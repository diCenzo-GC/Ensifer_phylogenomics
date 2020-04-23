#!usr/bin/perl
use 5.010;

# Input files
$strainList = 'Input_lists/genomeList_sino.txt';
$cdhitOutput = 'Pangenome_calculation/cdhit_clustering/modifiedOutput.txt';

# Get list of strains
open($strainsIn, '<', $strainList);
while(<$strainsIn>) {
	chomp;
        @line = split('\t', $_);
	push(@strains, @line[0]);
}
close($strainsIn);

# Print the header row
foreach $i (@strains) {
	print("\t$i");
}

# Make the count table
open($cdhit, '<', $cdhitOutput);
while(<$cdhit>) {
	if(/>Cluster/) {
		@line = split("\t", $_);
		@line[0] =~ s/>//;
		@line[0] =~ s/\ /_/;
		print("\n@line[0]");
		foreach $i (@strains) {
                        $j = $i . '__';
			if(/$j/) {
				print("\t1");
			}
			else {
				print("\t0");
			}
		}
	}
}
