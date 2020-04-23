# Download genomes
sh Pipelines/download_genomes.sh

# Prepare an unrooted phylogeny
sh Pipelines/unrooted_phylogeny.sh

# Prepare a rooted phylogeny
sh Pipelines/rooted_phylogeny.sh

# Prepare ANI matrix
sh Pipelines/ani_matrix.sh

# Prepare AAI matrix
sh Pipelines/aai_matrix.sh

# Identify symbiotic strains
sh Pipelines/identify_symbiotic.sh

# Determine genome sizes and assembly level
sh Pipelines/genome_properties.sh
sed -i '1s/^/Strain\tNodA\tNodB\tNodC\tNifH\tNifD\tNifK\tNodABC\tNifHDK\tAll\tRepA\tRepB\tRepAB\n/' Output_files/unrootedPhylogenyAnnotation.txt # Add the missing header

# Compress unused genome files
gzip -r Unrooted_phylogeny/Reannotate_genomes/* # Compress unused files
gzip -r Rooted_phylogeny/Reannotate_genomes/* # Compress unused files

# Get symbiotic and non-symbiotic clade lists
awk '$4 == "1" {print $1}' Output_files/genomeProperties.txt > Output_files/symbioticClade.txt # Get symbiotic clade
awk '$4 == "0" {print $1}' Output_files/genomeProperties.txt > Output_files/nonSymbioticClade.txt # Get non-symbiotic clade

# Calculate pangenome
sh Pipelines/calculate_pangenome.sh

# Run pangenome summary analyses
sh Pipelines/pangenome_summary.sh

# Look for recent HGT between groups
sh Pipelines/examine_hgt.sh

# Examine relationships of the symbiotic genes
sh Pipelines/sym_gene_phylogenies.sh

# Pangenome functional annotation
sh Pipelines/functional_analysis.sh
