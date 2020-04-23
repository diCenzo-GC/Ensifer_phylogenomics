# Prepare directories
mkdir Genome_files/SymGeneGenomes/ # Make directory
mkdir Sym_Gene_Phylogenies/ # Make directory
mkdir Sym_Gene_Phylogenies/HMMsearch/ # Make directory
mkdir Sym_Gene_Phylogenies/HMMsearchParsed/ # Make directory
mkdir Sym_Gene_Phylogenies/HMMsearchHits/ # Make directory
mkdir Sym_Gene_Phylogenies/HMMscan/ # Make directory
mkdir Sym_Gene_Phylogenies/HMMscanParsed/ # Make directory
mkdir Sym_Gene_Phylogenies/HMMscanTop/ # Make directory
mkdir Sym_Gene_Phylogenies/HMMscanTopLists/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteins/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteinsOperons/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteinsOperons_Mafft/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAl/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Nod/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Nif/ # Make directory
mkdir Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Rep/ # Make directory
mkdir Sym_Gene_Phylogenies/Alignments/ # Make directory
mkdir Sym_Gene_Phylogenies/Phylogenies/ # Make directory

# Download the GenBank files
perl Scripts/parseGenomeList_symGenes.pl Input_lists/SymGeneGenomes.csv # Parse the NCBI genome table to get info to download genomes
sed -i 's/sp\._/sp_/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/Agrobacterium_sp_H13-3/Agrobacterium_sp_H13_3/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/Rhizobium_sp_NT-26/Rhizobium_sp_NT_26/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/Rhizobium_sp_ACO-34A/Rhizobium_sp_ACO_34A/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/Rhizobium_etli_8C-3/Rhizobium_etli_8C_3/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/Rhizobium_leguminosarum_Vaf-108/Rhizobium_leguminosarum_Vaf_108/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/\.F\.Ca\.ET\./_F_Ca_ET_/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/043\.01\.1\.1/043_01_1_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/046\.03\.2\.1/046_03_2_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/002\.03\.1\.2/002_03_1_2/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/043\.05\.1\.1/043_05_1_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/045\.04\.1\.1/045_04_1_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/045\.02\.1\.1/045_02_1_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/058\.02\.1\.1/058_02_1_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/M7D\.F\.Ca\.US\.005\.01\.1\.1/M7D_F_Ca_US_005_01_1_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/M6A\.T\.Cr\.TU\.016\.01\.1\.1/M6A_T_Cr_TU_016_01_1_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/M7A\.F\.Ce\.TU\.012\.03\.2\.1/M7A_F_Ce_TU_012_03_2_1/g' Input_lists/genomeList_symGenes.txt # Fix formatting
sed -i 's/Agrobacterium_tumefaciens_LBA4213_(Ach5)/Agrobacterium_tumefaciens_LBA4213_Ach5/g' Input_lists/genomeList_symGenes.txt # Fix formatting
cat Input_lists/genomeList_symGenes.txt Input_lists/genomeList_sino.txt > Input_lists/genomeList_symGenesFull.txt # Add Sinorhizobium to the list
perl Scripts/downloadGenomes_symGenes.pl Input_lists/genomeList_symGenesFull.txt # download the genomes of interest
cp New_genomes/*.gbff Genome_files/SymGeneGenomes/ # Move new genomes in genomes directory
cat New_genomes/newGenomeList.txt Input_lists/genomeList_symGenesFull.txt > temp_1.txt # Concatenated new list with old one
sort -u -k1,1 temp_1.txt > temp_2.txt # Remove duplicates
mv temp_2.txt Input_lists/genomeList_symGenesFull.txt  # Rename file
rm temp_1.txt # Remove file

# Extract protein sequences
perl Scripts/extractFaaFromGff.pl # Make faa files from the GenBank files
perl Scripts/modifyFasta.pl Sym_Gene_Phylogenies/combined_proteomes_HMM.faa > Sym_Gene_Phylogenies/combined_proteomes_HMM_modified.faa # Modify the fasta file for easy extraction

# Perform the HMMsearch screens
perl Scripts/performHMMsearch2.pl # A short script to repeat for all HMM files, the build, hmmsearch, parsing, and hit extraction

# Perform the HMM scan screens
gunzip -r Symbiotic_gene_presence/hmmDatabaseFiles/ # Uncompress files
perl Scripts/performHMMscan2.pl # A short script to repeat for all the HMM search output files, to perform hmmscan, parse, and hit extraction
gzip -r Symbiotic_gene_presence/hmmDatabaseFiles/ # Compress files

# Determine strains with each protein
perl Scripts/determineProteinPresence2.pl > Sym_Gene_Phylogenies/Symbiotic_gene_distribution.txt # determine which of the six proteins are in each of the strains

# Extract proteins
perl Scripts/extractHMMscanHits_Nod.pl # extract all the Nod proteins
perl Scripts/extractHMMscanHits_Nif.pl # extract all the Nif proteins
perl Scripts/extractHMMscanHits_Rep.pl # extract all the Rep proteins

# Associate proteins to operons
perl Scripts/linkGenes_Nod.pl # Group genes into operons
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/NodA.faa # make two lines
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/NodB.faa # make two lines
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/NodC.faa # make two lines
perl Scripts/linkGenes_Nif.pl # Group genes into operons
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/NifH.faa # make two lines
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/NifD.faa # make two lines
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/NifK.faa # make two lines
perl Scripts/linkGenes_Rep.pl # Group genes into operons
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/RepA.faa # make two lines
sed -i 's/\t/\n/' Sym_Gene_Phylogenies/SymbioticProteinsOperons/RepB.faa # make two lines

# Prepare the alignments
perl Scripts/align_trim2.pl # Align and trim all proteins
perl Scripts/modifyTrimAl2.pl # Modify output
mv Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified/Nod*.fasta Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Nod/ # Move files
mv Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified/Nif*.fasta Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Nif/ # Move files
mv Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified/Rep*.fasta Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Rep/ # Move files
perl Scripts/combineAlignments_Nod.pl > Sym_Gene_Phylogenies/Alignments/Nod_protein_alignment.fasta # Concatenate the alignments
perl Scripts/combineAlignments_Nif.pl > Sym_Gene_Phylogenies/Alignments/Nif_protein_alignment.fasta # Concatenate the alignments
perl Scripts/combineAlignments_Rep.pl > Sym_Gene_Phylogenies/Alignments/Rep_protein_alignment.fasta # Concatenate the alignments

# Make the phylogenies
cd Sym_Gene_Phylogenies/Phylogenies/ # Change directory
mpiexec -bynode -np 10 raxmlHPC-HYBRID-SSE3 -T 2 -s ../Alignments/Nod_protein_alignment.fasta -N autoMRE -n NodABC_Phylogeny -f a -p 12345 -x 12345 -m PROTGAMMALG # Run raxml
mpiexec -bynode -np 10 raxmlHPC-HYBRID-SSE3 -T 2 -s ../Alignments/Nif_protein_alignment.fasta -N autoMRE -n NifHDK_Phylogeny -f a -p 12345 -x 12345 -m PROTGAMMALG # Run raxml
mpiexec -bynode -np 10 raxmlHPC-HYBRID-SSE3 -T 2 -s ../Alignments/Rep_protein_alignment.fasta -N autoMRE -n RepAB_Phylogeny -f a -p 12345 -x 12345 -m PROTGAMMALG # Run raxml
cd ../../ # Change directory

# Move output files
cp Sym_Gene_Phylogenies/Phylogenies/RAxML_bipartitions.NodABC_Phylogeny Output_files/nodPhylogeny.tre # Move file
cp Sym_Gene_Phylogenies/Phylogenies/RAxML_bipartitions.NifHDK_Phylogeny Output_files/nifPhylogeny.tre # Move file
cp Sym_Gene_Phylogenies/Phylogenies/RAxML_bipartitions.RepAB_Phylogeny Output_files/repPhylogeny.tre # Move file


