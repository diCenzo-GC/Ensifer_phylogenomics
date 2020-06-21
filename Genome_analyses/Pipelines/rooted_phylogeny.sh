# Make directories
mkdir Rooted_phylogeny/ # Make directory
mkdir Rooted_phylogeny/Reannotate_genomes/ # Make directory
mkdir Genome_files/Rhizobium_reannotated/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/Proteomes/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/MarkerScannerOutput/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/MarkerScannerSingle/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/MarkerScannerCounted/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/MarkerScannerGood/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/Mafft/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/Trimal/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/TrimalModified/ # Make directory
mkdir Rooted_phylogeny/MLSA_phylogeny/Phylogeny/ # Make directory

# Reannotate the genomes
perl Scripts/runProkka_rhizo.pl Input_lists/genomeList_rhizo.txt # Run prokka to annotate the genomes
perl Scripts/moveGenomes_rhizo.pl Input_lists/genomeList_rhizo.txt # Collect important reannotated genome files

# Get the marker proteins
perl Scripts/switchNames2.pl # Switch protein names
cat Rooted_phylogeny/MLSA_phylogeny/Proteomes/*.faa > Rooted_phylogeny/MLSA_phylogeny/combined_proteomes.faa # Combine the faa files into one file
rm Rooted_phylogeny/MLSA_phylogeny/Proteomes/*.faa # Remove unneeded files
perl Scripts/updateNumber.pl ~/AMPHORA/MarkerScanner.pl # updates the number of sequences in the MarkerScanner.pl script
perl Scripts/MarkerScanner.pl -Bacteria Rooted_phylogeny/MLSA_phylogeny/combined_proteomes.faa # perform the MarkerScanner analysis
mv *.pep Rooted_phylogeny/MLSA_phylogeny/MarkerScannerOutput/ # Move output of MarkerScanner output directory
perl Scripts/extractSingle.pl # Extract proteins that are single copy
perl Scripts/countProteins.pl # Check that the proteins are found in enough genomes
perl Scripts/checkSpecies.pl # Check that in those genomes, the protein is found in single copy (probably redundant since the addition of extractSingle.pl)

# Run alignments and prepare concatenated alignment
perl Scripts/align_trim.pl # Run mafft on all individual sets of proteins
perl Scripts/modifyTrimAl.pl # Modify the trimAl output to prepare it for combining the alignments
perl Scripts/sortProteins.pl # Sort each of the trimAl output files that will be used for further analysis
perl Scripts/combineAlignments.pl > Rooted_phylogeny/MLSA_phylogeny/Phylogeny/MLSA_final_alignment.fasta # Concatenate the alignment files

# Prepare phylogeny
cd Rooted_phylogeny/MLSA_phylogeny/Phylogeny/ # Change directory
mpiexec -bynode -np 8 raxmlHPC-HYBRID-SSE3 -T 4 -s MLSA_final_alignment.fasta -N autoMRE -n Rooted_Phylogeny -f a -p 12345 -x 12345 -m PROTGAMMAJTTDCMUT # Run raxml
cd ../../ # Change directory
cp /datadisk1/georged/Projects/Sinorhizobium_Ensifer/Rooted_phylogeny/MLSA_phylogeny/Phylogeny/RAxML_bipartitions.Rooted_Phylogeny Output_files/rootedPhylogeny.tre # Move the file
