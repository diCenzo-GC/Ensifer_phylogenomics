#!/usr/bin/perl
use 5.010;

$genomes = 'Input_lists/genomeList_sino.txt'; # file to get the information of the files
$output = 'Horizontal_transfer/geneHeaders_proteins.txt';

open($gen,'<',$genomes);
while(<$gen>) {
	chomp;
	@line = split("\t",$_); # split the input line into an array based on commas
	push(@species,@line[0]); # make an array of the species names
	push(@unique,@line[1]); # make an array of if it is the representative genome or not
}
close($gen);

open($out, '>', $output);
foreach $species (@species) {
		$protein = $species;
		$species .= '.faa';
		$species2 = 'Genome_files/Sinorhizobium_reannotated/';
		$species2 .= $species;
		$output = 'Symbiotic_gene_presence/ProteomesHMM/';
		$output .= $species;
		open($in, '<', $species2);
		while(<$in>) {
			if(/>/) {
				$total++;
				$total2 = "__$total";
                		@oldName = split(' ', $_);
                		$oldName = @oldName[0];
                		$oldName =~ s/>//;
				print $out ("$oldName\t$protein$total2\n");
			}
		}
		close($in);
		print("$species\n");
}
close($out);
