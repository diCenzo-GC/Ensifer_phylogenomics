# Split file into clade specific files
mkdir Pangenome_calculation/Pangenome_overlap/ # Make directory
./Scripts/transposePangenome.R # Transpose the pangenome table
head -1 Pangenome_calculation/Pangenome_overlap/Transposed_right.txt > Pangenome_calculation/Pangenome_overlap/Symbiotic_transposed.txt # Print cluster names
grep -f 'Output_files/symbioticClade.txt' Pangenome_calculation/Pangenome_overlap/Transposed_right.txt | sort -u >> Pangenome_calculation/Pangenome_overlap/Symbiotic_transposed.txt # Get strains of interest
head -1 Pangenome_calculation/Pangenome_overlap/Transposed_right.txt > Pangenome_calculation/Pangenome_overlap/Non_symbiotic_transposed.txt # Print cluster names
grep -f 'Output_files/nonSymbioticClade.txt' Pangenome_calculation/Pangenome_overlap/Transposed_right.txt | sort -u >> Pangenome_calculation/Pangenome_overlap/Non_symbiotic_transposed.txt # Get strains of interest

# Determine core and accessory genome overlap
./Scripts/pangenomeOverlap.R # Determine overlaps

# Prepare gene accumulation curves, distance matrix, and PCA
./Scripts/pangenomeSummaryFigures.R # Make these figures

# Move output
cp Pangenome_calculation/Pangenome_overlap/core_genome_overlap.svg Output_files/coreGenomeOverlap.svg # Move file
cp Pangenome_calculation/Pangenome_overlap/accessory_genome_overlap_2.svg Output_files/accessryGenomeOverlap1.svg # Move file
cp Pangenome_calculation/Pangenome_overlap/accessory_genome_overlap_10.svg Output_files/accessoryGenomeOverlap2.svg # Move file
cp Pangenome_calculation/Pangenome_overlap/gene_accumulation_plots.svg Output_files/geneAccumulationPlots.svg # Move file
cp Pangenome_calculation/Pangenome_overlap/accessory_genome_tree.tre Output_files/pangenomeTree.tre # Move file
cp Pangenome_calculation/Pangenome_overlap/pca_plot.svg Output_files/pangenomePca1.svg # Move file
cp Pangenome_calculation/Pangenome_overlap/pca_plot_2.svg Output_files/pangenomePca2.svg # Move file
