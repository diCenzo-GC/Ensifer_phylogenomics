#!usr/bin/perl
use 5.010;

while(<>) {
	@line = split("\t", $_);
	system("cp Rooted_phylogeny/Reannotate_genomes/@line[0]/@line[0].faa Genome_files/Rhizobium_reannotated/");
}
