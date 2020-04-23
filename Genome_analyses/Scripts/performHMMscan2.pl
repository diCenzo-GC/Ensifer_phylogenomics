#!usr/bin/perl
use 5.010;

# set variables
$HMM_list = 'Input_lists/HMM_files2/hmm_list.txt';

# make an array of the HMM names
open($HMM,'<',$HMM_list);
while(<$HMM>) {
	chomp;
	push(@HMMs,$_);
}
close($HMM);

# Perform the HMMscans
foreach $i (@HMMs) {
	system("hmmscan Symbiotic_gene_presence/hmmDatabaseFiles/converted_combined.hmm Sym_Gene_Phylogenies/HMMsearchHits/$i.faa > Sym_Gene_Phylogenies/HMMscan/$i.txt");
	system("perl Scripts/parseHMMscan.pl Sym_Gene_Phylogenies/HMMscan/$i.txt > Sym_Gene_Phylogenies/HMMscanParsed/$i.csv");
	system("perl Scripts/HMMscanTopHit.pl Sym_Gene_Phylogenies/HMMscanParsed/$i.csv > Sym_Gene_Phylogenies/HMMscanTop/$i.csv");
}
