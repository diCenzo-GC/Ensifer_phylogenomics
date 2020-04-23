#!usr/bin/perl
use 5.010;

while(<>) {
	@line = split("\t", $_);
	system("cp Unrooted_phylogeny/Reannotate_genomes/@line[0]/@line[0].gff Genome_files/Sinorhizobium_reannotated/");
	system("cp Unrooted_phylogeny/Reannotate_genomes/@line[0]/@line[0].faa Genome_files/Sinorhizobium_reannotated/");
	system("cp Unrooted_phylogeny/Reannotate_genomes/@line[0]/@line[0].ffn Genome_files/Sinorhizobium_reannotated/");
}
