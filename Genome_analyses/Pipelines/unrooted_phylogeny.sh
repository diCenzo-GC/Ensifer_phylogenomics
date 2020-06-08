# Reannotate the genomes
mkdir Unrooted_phylogeny/ # Make directory
mkdir Unrooted_phylogeny/Reannotate_genomes/ # Make directory
mkdir Unrooted_phylogeny/Reannotate_genomes/Output/ # Make directory
mkdir Genome_files/Sinorhizobium_reannotated/ # Make directory
perl Scripts/runProkka_sino.pl Input_lists/genomeList_sino.txt # Run prokka to annotate the genomes
perl Scripts/moveGenomes_sino.pl Input_lists/genomeList_sino.txt # Collect important reannotated genome files

# Find core genes and make phylogeny
mkdir Unrooted_phylogeny/Core_gene_phylogeny/ # Make directory
roary -p 20 -f Unrooted_phylogeny/Core_gene_phylogeny/ -e -i 70 -g 150000 Genome_files/Sinorhizobium_reannotated/*.gff # Run roary
cd Unrooted_phylogeny/Core_gene_phylogeny/ # Change directory
cp */core_gene_alignment.aln . # Copy file
trimal -in core_gene_alignment.aln -out core_gene_alignment_trimmed.aln -automated1 -fasta # Trim alignment
raxmlHPC-HYBRID-SSE3 -T 32 -s core_gene_alignment_trimmed.aln -N autoMRE -n Unrooted_Phylogeny -f a -p 12345 -x 12345 -m GTRCAT # Run raxml
cd ../../ # Change directory
mkdir Output_files/ # Make directory
cp Unrooted_phylogeny/Core_gene_phylogeny/RAxML_bipartitions.Unrooted_Phylogeny Output_files/unrootedPhylogeny.tre # Move file
