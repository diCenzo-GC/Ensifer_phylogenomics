#!usr/bin/perl
use 5.010;

# List of files 
$genePresence = 'Sym_Gene_Phylogenies/Symbiotic_gene_distribution.txt';
$nifH_file = 'Sym_Gene_Phylogenies/HMMscanTop/RepA.csv';
$nifD_file = 'Sym_Gene_Phylogenies/HMMscanTop/RepB.csv';
$nifH_out_file = 'Sym_Gene_Phylogenies/HMMscanTopLists/RepA.txt';
$nifD_out_file = 'Sym_Gene_Phylogenies/HMMscanTopLists/RepB.txt';

# Find strains with all Rep proteins
open($presence, '<', $genePresence);
while(<$presence>) {
	$_ =~ s/___/__/;
	@line = split("\t", $_);
	if(@line[12] == 1) {
		push(@species, @line[0]);
	}
}
close($presence);

# Get RepA proteins
open($nifH,'<',$nifH_file);
open($nifH_out,'>',$nifH_out_file);
while(<$nifH>) {
	@line = split(',',$_);
	if(@line[9] eq 'TIGR03453') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nifH_out (@line[0]);
			}
		}
	}
}
close($nifH);
close($nifH_out);
system("grep -f 'Sym_Gene_Phylogenies/HMMscanTopLists/RepA.txt' Sym_Gene_Phylogenies/combined_proteomes_HMM_modified.faa > Sym_Gene_Phylogenies/SymbioticProteins/RepA_all.faa");

# Get RepB proteins
open($nifD,'<',$nifD_file);
open($nifD_out,'>',$nifD_out_file);
while(<$nifD>) {
	@line = split(',',$_);
	if(@line[9] eq 'TIGR03454') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nifD_out (@line[0]);
			}
		}
	}
	elsif(@line[9] eq 'TIGR00180') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nifD_out (@line[0]);
			}
		}
	}
	elsif(@line[9] eq 'RepB') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nifD_out (@line[0]);
			}
		}
	}
	elsif(@line[9] eq 'TIGR03734') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nifD_out (@line[0]);
			}
		}
	}
}
close($nifD);
close($nifD_out);
system("grep -f 'Sym_Gene_Phylogenies/HMMscanTopLists/RepB.txt' Sym_Gene_Phylogenies/combined_proteomes_HMM_modified.faa > Sym_Gene_Phylogenies/SymbioticProteins/RepB_all.faa");
