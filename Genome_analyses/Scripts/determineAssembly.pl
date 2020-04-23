#!usr/bin/perl
use 5.010;

# Files
$assemblyFileIn = 'Symbiotic_gene_presence/Symbiotic_gene_distribution.txt';
$genomeList = 'Input_lists/Sinorhizobium.csv';
$accessionList = 'Input_lists/genomeList_sino.txt';

# Determine genome assembly level
open($in, '<', $assemblyFileIn);
while(<$in>) {
	chomp;
	$annotation = $_;
	@line = split("\t", $_);
	open($in2, '<', $accessionList);
	while(<$in2>) {
		if(/@line[0]/) {
			chomp;
			@line2 = split("\t", $_);
			open($in3, '<', $genomeList);
			while(<$in3>) {
				if(/@line2[1]/) {
					@line3 = split(",", $_);
					@line3[6] =~ s/\"//g;
					if(@line3[6] eq 'Complete') {
						say("$annotation\t1");
					}
					elsif(@line3[6] eq ' Chromosome') {
						say("$annotation\t1");
					}
					elsif(@line3[6] eq 'Chromosome') {
						say("$annotation\t1");
					}
					else {
						say("$annotation\t0");
					}
				}
			}
		}
	}
}

