#!usr/bin/perl
use 5.010;

# set variables
$HMM_list = 'Input_lists/HMM_files/hmm_list.txt';

# make an array of the HMM names
open($HMM,'<',$HMM_list);
while(<$HMM>) {
	chomp;
	push(@HMMs,$_);
}
close($HMM);

# Perform the HMMscans
foreach $i (@HMMs) {
	system("hmmscan Symbiotic_gene_presence/hmmDatabaseFiles/converted_combined.hmm Symbiotic_gene_presence/HMMsearchHits/$i.faa > Symbiotic_gene_presence/HMMscan/$i.txt");
	system("perl Scripts/parseHMMscan.pl Symbiotic_gene_presence/HMMscan/$i.txt > Symbiotic_gene_presence/HMMscanParsed/$i.csv");
	system("perl Scripts/HMMscanTopHit.pl Symbiotic_gene_presence/HMMscanParsed/$i.csv > Symbiotic_gene_presence/HMMscanTop/$i.csv");
}
