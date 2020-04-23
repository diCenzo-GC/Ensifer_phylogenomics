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

# Perform the HMMsearches
foreach $i (@HMMs) {
	system("hmmbuild Input_lists/HMM_files/$i.hmm Input_lists/HMM_files/$i.txt"); # build the HMM profiles
	system("hmmsearch Input_lists/HMM_files/$i.hmm Symbiotic_gene_presence/combined_proteomes_HMM.faa > Symbiotic_gene_presence/HMMsearch/$i.txt"); # do the hmmsearch
	system("perl Scripts/parseHMMsearch.pl Symbiotic_gene_presence/HMMsearch/$i.txt > Symbiotic_gene_presence/HMMsearchParsed/$i.txt"); # parse the hmmsearch output
	system("perl Scripts/extractHMMsearchHits.pl Symbiotic_gene_presence/HMMsearchParsed/$i.txt > Symbiotic_gene_presence/HMMsearchHits/$i.faa"); # extract the hmmsearch hits
}


