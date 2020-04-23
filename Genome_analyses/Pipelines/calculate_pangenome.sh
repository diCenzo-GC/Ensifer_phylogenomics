# Make directories
mkdir Pangenome_calculation/ # Make directory
mkdir Pangenome_calculation/ProteomesNewNames/ # Make directory
mkdir Pangenome_calculation/cdhit_clustering/ # Make directory

# Calculate orthologous groups and prepare a table
perl Scripts/switchNames3.pl # Switch the names of the proteins
cat Pangenome_calculation/ProteomesNewNames/* > Pangenome_calculation/cdhit_clustering/combinedProteome.faa # Concatenate the proteomes as one file
cdhit -i Pangenome_calculation/cdhit_clustering/combinedProteome.faa -o Pangenome_calculation/cdhit_clustering/output -c 0.7 -G 0 -M 50000 -T 20 -n 4 -d 0 -aL 0.8 # run cdhit
perl Scripts/modifyCdhitOutput.pl Pangenome_calculation/cdhit_clustering/output.clstr > Pangenome_calculation/cdhit_clustering/modifiedOutput.txt # modify the cdhit output to be one liners
perl Scripts/makePangenomeTable.pl > Pangenome_calculation/cdhit_clustering/outputTable.txt # make a table from the cdhit output

# Remove intermediate files
rm Pangenome_calculation/ProteomesNewNames/* # Remove files

# Move output
cp Pangenome_calculation/cdhit_clustering/outputTable.txt Output_files/pangenomeSummaryTable.txt # Move file
