#!usr/bin/perl
use 5.010;

while(<>) {
	@line = split("\t", $_);
	system("prokka --outdir Rooted_phylogeny/Reannotate_genomes/@line[0] --cpus 20 --prefix @line[0] Genome_files/Rhizobium/@line[0].fna");
}
