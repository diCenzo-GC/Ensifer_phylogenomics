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

# Perform the HMMsearches
foreach $i (@HMMs) {
	system("hmmbuild Input_lists/HMM_files2/$i.hmm Input_lists/HMM_files2/$i.txt"); # build the HMM profiles
	system("hmmsearch Input_lists/HMM_files2/$i.hmm Sym_Gene_Phylogenies/combined_proteomes_HMM.faa > Sym_Gene_Phylogenies/HMMsearch/$i.txt"); # do the hmmsearch
	system("perl Scripts/parseHMMsearch.pl Sym_Gene_Phylogenies/HMMsearch/$i.txt > Sym_Gene_Phylogenies/HMMsearchParsed/$i.txt"); # parse the hmmsearch output
	system("perl Scripts/extractHMMsearchHits2.pl Sym_Gene_Phylogenies/HMMsearchParsed/$i.txt > Sym_Gene_Phylogenies/HMMsearchHits/$i.faa"); # extract the hmmsearch hits
}


