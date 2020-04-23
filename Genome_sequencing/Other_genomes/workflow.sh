## Prepare necessary directories
mkdir Rhizobium_sp_Lc18/
mkdir Ensifer_morelense_Lc04/
mkdir Ensifer_psoraleae_CCBAU_65732/
mkdir Rhizobium_sp_Lc18/spades_assembly/
mkdir Ensifer_morelense_Lc04/spades_assembly/
mkdir Ensifer_psoraleae_CCBAU_65732/spades_assembly/
mkdir Rhizobium_sp_Lc18/medusa_scaffolding/
mkdir Ensifer_morelense_Lc04/medusa_scaffolding/
mkdir Ensifer_psoraleae_CCBAU_65732/medusa_scaffolding/
mkdir Rhizobium_sp_Lc18/referenceGenomes/
mkdir Ensifer_morelense_Lc04/referenceGenomes/
mkdir Ensifer_psoraleae_CCBAU_65732/referenceGenomes/

## Perform workflow for Rhizobium_sp_Lc18

# Assemble the genome with Spades
cd Rhizobium_sp_Lc18/
spades.py -o spades_assembly --pe1-1 ../fastq_files/3575_ID887_M1_S7_L003_R1_001.fastq.gz --pe1-2 ../fastq_files/3575_ID887_M1_S7_L003_R2_001.fastq.gz -t 40 # Assemble the reads
perl ../Scripts/removeShort.pl spades_assembly/scaffolds.fasta > spades_assembly/scaffolds_shortRemoved.fasta # Remove scaffolds below 200 bp
sed -i 's/XXX)/20)/' ../Scripts/removeLowCov.pl # Adjust coverage threshold
perl ../Scripts/removeLowCov.pl spades_assembly/scaffolds_shortRemoved.fasta > spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta # Remove scaffolds below 50x coverage
sed -i 's/20)/XXX)/' ../Scripts/removeLowCov.pl # Adjust coverage threshold

# Scaffold the assembly with MeDuSa
fastANI -q spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta --rl ../genomePaths.txt -o medusa_scaffolding/scaffolds_fastANI_output.txt # Run fastANI to find most related genomes
perl ../Scripts/parseFastANI.pl medusa_scaffolding/scaffolds_fastANI_output.txt # Collect 2 most related genomes
java -jar /home/medusa/medusa/medusa.jar -scriptPath /home/medusa/medusa/medusa_scripts/ -v -o medusa_scaffolding/scaffolds_medusa.fasta -i spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta -f referenceGenomes/ # Run MeDuSa to try and combine scaffolds
perl ../Scripts/removePhage.pl # Remove the phage contig
perl ../Scripts/extractLong.pl # Keep only contigs greater than 1 kb

# Annotate the genome
prokka --outdir annotated_genome --cpus 40 --addgenes --prefix Rhizobium_sp_Lc18 --genus Rhizobium --species sp --strain Lc18 medusa_scaffolding/scaffolds_medusa_reduced.fasta
cd ..

## Perform workflow for Ensifer_morelense_Lc04

# Assemble the genome with Spades
cd Ensifer_morelense_Lc04/
spades.py -o spades_assembly --pe1-1 ../fastq_files/3577_ID887_M3_S9_L003_R1_001.fastq.gz --pe1-2 ../fastq_files/3577_ID887_M3_S9_L003_R2_001.fastq.gz -t 40 # Assemble the reads
perl ../Scripts/removeShort.pl spades_assembly/scaffolds.fasta > spades_assembly/scaffolds_shortRemoved.fasta # Remove scaffolds below 200 bp
sed -i 's/XXX)/20)/' ../Scripts/removeLowCov.pl # Adjust coverage threshold
perl ../Scripts/removeLowCov.pl spades_assembly/scaffolds_shortRemoved.fasta > spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta # Remove scaffolds below 50x coverage
sed -i 's/20)/XXX)/' ../Scripts/removeLowCov.pl # Adjust coverage threshold

# Scaffold the assembly with MeDuSa
fastANI -q spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta --rl ../genomePaths.txt -o medusa_scaffolding/scaffolds_fastANI_output.txt # Run fastANI to find most related genomes
perl ../Scripts/parseFastANI.pl medusa_scaffolding/scaffolds_fastANI_output.txt # Collect 2 most related genomes
java -jar /home/medusa/medusa/medusa.jar -scriptPath /home/medusa/medusa/medusa_scripts/ -v -o medusa_scaffolding/scaffolds_medusa.fasta -i spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta -f referenceGenomes/ # Run MeDuSa to try and combine scaffolds
perl ../Scripts/removePhage.pl # Remove the phage contig
perl ../Scripts/extractLong.pl # Keep only contigs greater than 1 kb

# Annotate the genome
prokka --outdir annotated_genome --cpus 40 --addgenes --prefix Ensifer_morelense_Lc04 --genus Ensifer --species morelense --strain Lc04 medusa_scaffolding/scaffolds_medusa_reduced.fasta
cd ..

## Perform workflow for Ensifer_psoraleae_CCBAU_65732

# Assemble the genome with Spades
cd Ensifer_psoraleae_CCBAU_65732/
spades.py -o spades_assembly --pe1-1 ../fastq_files/3579_ID887_M5_S11_L003_R1_001.fastq.gz --pe1-2 ../fastq_files/3579_ID887_M5_S11_L003_R2_001.fastq.gz --pe2-1 ../fastq_files/3579_ID887_M5_S11_L005_R1_001.fastq.gz --pe2-2 ../fastq_files/3579_ID887_M5_S11_L005_R2_001.fastq.gz -t 40 # Assemble the reads
perl ../Scripts/removeShort.pl spades_assembly/scaffolds.fasta > spades_assembly/scaffolds_shortRemoved.fasta # Remove scaffolds below 200 bp
sed -i 's/XXX)/20)/' ../Scripts/removeLowCov.pl # Adjust coverage threshold
perl ../Scripts/removeLowCov.pl spades_assembly/scaffolds_shortRemoved.fasta > spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta # Remove scaffolds below 50x coverage
sed -i 's/20)/XXX)/' ../Scripts/removeLowCov.pl # Adjust coverage threshold

# Scaffold the assembly with MeDuSa
fastANI -q spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta --rl ../genomePaths.txt -o medusa_scaffolding/scaffolds_fastANI_output.txt # Run fastANI to find most related genomes
sed -i '/Sinorhizobium_fredii_USDA_257/d' medusa_scaffolding/scaffolds_fastANI_output.txt # Remove USDA 257 from the list
perl ../Scripts/parseFastANI.pl medusa_scaffolding/scaffolds_fastANI_output.txt # Collect 2 most related genomes
java -jar /home/medusa/medusa/medusa.jar -scriptPath /home/medusa/medusa/medusa_scripts/ -v -o medusa_scaffolding/scaffolds_medusa.fasta -i spades_assembly/scaffolds_shortRemoved_lowRemoved.fasta -f referenceGenomes/ # Run MeDuSa to try and combine scaffolds
perl ../Scripts/removePhage.pl # Remove the phage contig
perl ../Scripts/extractLong.pl # Keep only contigs greater than 1 kb

# Annotate the genome
prokka --outdir annotated_genome --cpus 40 --addgenes --prefix Ensifer_psoraleae_CCBAU_65732 --genus Ensifer --species psoraleae --strain CCBAU_65732 medusa_scaffolding/scaffolds_medusa_reduced.fasta
cd ..

