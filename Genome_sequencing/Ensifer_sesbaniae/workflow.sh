# Prepare necessary directories
mkdir dot_plots/
mkdir medusa_scaffolding/
mkdir pacbio_reads_prep/
mkdir referenceGenomes/
mkdir spades_assembly/

# Correct the PacBio reads with Canu
canu -correct -p Ensifer_sesbaniae_pacbio -d pacbio_reads_prep genomeSize=6.9m -pacbio-raw input/pacbio_reads.fasta # Attempt to correct the PacBio reads with Canu
mv /home/georged/Ensifer_sesbaniae/pacbio_reads_prep/Ensifer_sesbaniae_pacbio.gkpStore.BUILDING /home/georged/Ensifer_sesbaniae/pacbio_reads_prep/Ensifer_sesbaniae_pacbio.gkpStore.ACCEPTED # Allow Canu to proceed even though there are lots of short reads that will be discarded
canu -correct -p Ensifer_sesbaniae_pacbio -d pacbio_reads_prep genomeSize=6.9m -pacbio-raw input/pacbio_reads.fasta # Run Canu again

# Trim the corrected PacBio reads with Canu
canu -trim -p Ensifer_sesbaniae_pacbio -d pacbio_reads_prep genomeSize=6.9m -pacbio-corrected pacbio_reads_prep/Ensifer_sesbaniae_pacbio.correctedReads.fasta.gz

# Assemble the genome with Spades
spades.py -o spades_assembly/ --pe1-1 input/3578_ID887_M4_S10_L003_R1_001.fastq.gz --pe1-2 input/3578_ID887_M4_S10_L003_R2_001.fastq.gz --pe2-1 input/3578_ID887_M4_S10_L005_R1_001.fastq.gz --pe2-2 input/3578_ID887_M4_S10_L005_R2_001.fastq.gz --pacbio pacbio_reads_prep/Ensifer_sesbaniae_pacbio.trimmedReads.fasta.gz -t 40 # Run the assembly
perl Scripts/removeShort.pl spades_assembly/scaffolds.fasta > spades_assembly/scaffolds_shortRemoved.fasta # Remove scaffolds below 200 bp
perl Scripts/removeLowCov.pl spades_assembly/scaffolds_shortRemoved.fasta > spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta # Remove scaffolds below 10x coverage

# Scaffold the assembly with MeDuSa
fastANI -q spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta --rl genomePaths.txt -o medusa_scaffolding/scaffolds_fastANI_output.txt # Run fastANI to find most related genomes
perl Scripts/parseFastANI.pl medusa_scaffolding/scaffolds_fastANI_output.txt # Collect 2 most related genomes
java -jar /home/medusa/medusa/medusa.jar -scriptPath /home/medusa/medusa/medusa_scripts/ -v -o medusa_scaffolding/scaffolds_medusa.fasta -i spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta -f referenceGenomes/ # Run MeDuSa to try and combine scaffolds
perl Scripts/extractLong.pl # Keep only contigs greater than 10 kb

# Annotate the genome
prokka --outdir annotated_genome --cpus 40 --addgenes --prefix Ensifer_sesbaniae_CCBAU_65729 --genus Ensifer --species sesbaniae --strain CCBAU_65729 medusa_scaffolding/scaffolds_medusa_reduced.fasta

# Make dot plots against OV14
nucmer -p dot_plots/OV14 annotated_genome/Ensifer_sesbaniae_CCBAU_65729.fna referenceGenomes/Ensifer_adhaerens_OV14.fna
mummerplot -f -l --small --postscript -p dot_plots/OV14 dot_plots/OV14.delta
ps2pdf dot_plots/OV14.ps dot_plots/OV14.pdf

# Make dot plots against Casida A
nucmer -p dot_plots/CasidaA annotated_genome/Ensifer_sesbaniae_CCBAU_65729.fna referenceGenomes/Ensifer_adhaerens_Casida_A.fna
mummerplot -f -l --small --postscript -p dot_plots/CasidaA dot_plots/CasidaA.delta
ps2pdf dot_plots/CasidaA.ps dot_plots/CasidaA.pdf

# Make dot plots against NGR234
nucmer -p dot_plots/NGR234 annotated_genome/Ensifer_sesbaniae_CCBAU_65729.fna dot_plots/Sinorhizobium_fredii_NGR234.fna
mummerplot -f -l --small --postscript -p dot_plots/NGR234 dot_plots/NGR234.delta
ps2pdf dot_plots/NGR234.ps dot_plots/NGR234.pdf
