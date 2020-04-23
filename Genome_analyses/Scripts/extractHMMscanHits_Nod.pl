#!usr/bin/perl
use 5.010;

# List of files 
$genePresence = 'Sym_Gene_Phylogenies/Symbiotic_gene_distribution.txt';
$nodA_file = 'Sym_Gene_Phylogenies/HMMscanTop/NodA.csv';
$nodB_file = 'Sym_Gene_Phylogenies/HMMscanTop/NodB.csv';
$nodC_file = 'Sym_Gene_Phylogenies/HMMscanTop/NodC.csv';
$nodA_out_file = 'Sym_Gene_Phylogenies/HMMscanTopLists/NodA.txt';
$nodB_out_file = 'Sym_Gene_Phylogenies/HMMscanTopLists/NodB.txt';
$nodC_out_file = 'Sym_Gene_Phylogenies/HMMscanTopLists/NodC.txt';

# Find strains with all Nod proteins
open($presence, '<', $genePresence);
while(<$presence>) {
	$_ =~ s/___/__/;
	@line = split("\t", $_);
	if(@line[7] == 1) {
		push(@species, @line[0]);
	}
}
close($presence);

# Get NodA proteins
open($nodA,'<',$nodA_file);
open($nodA_out,'>',$nodA_out_file);
while(<$nodA>) {
	@line = split(',',$_);
	if(@line[9] eq 'TIGR04245') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nodA_out (@line[0]);
			}
		}
	}
	elsif(@line[9] eq 'NodA') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nodA_out (@line[0]);
			}
		}
	}
}
close($nodA);
close($nodA_out);
system("grep -f 'Sym_Gene_Phylogenies/HMMscanTopLists/NodA.txt' Sym_Gene_Phylogenies/combined_proteomes_HMM_modified.faa > Sym_Gene_Phylogenies/SymbioticProteins/NodA_all.faa");

# Get NodB proteins
open($nodB,'<',$nodB_file);
open($nodB_out,'>',$nodB_out_file);
while(<$nodB>) {
	@line = split(',',$_);
	if(@line[9] eq 'TIGR04243') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nodB_out (@line[0]);
			}
		}
	}
}
close($nodB);
close($nodB_out);
system("grep -f 'Sym_Gene_Phylogenies/HMMscanTopLists/NodB.txt' Sym_Gene_Phylogenies/combined_proteomes_HMM_modified.faa > Sym_Gene_Phylogenies/SymbioticProteins/NodB_all.faa");

# Get NodC proteins
open($nodC,'<',$nodC_file);
open($nodC_out,'>',$nodC_out_file);
while(<$nodC>) {
	@line = split(',',$_);
	if(@line[9] eq 'TIGR04242') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $nodC_out (@line[0]);
			}
		}
	}
}
close($nodC);
close($nodC_out);
system("grep -f 'Sym_Gene_Phylogenies/HMMscanTopLists/NodC.txt' Sym_Gene_Phylogenies/combined_proteomes_HMM_modified.faa > Sym_Gene_Phylogenies/SymbioticProteins/NodC_all.faa");
