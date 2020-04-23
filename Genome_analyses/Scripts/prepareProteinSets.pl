#!/usr/bin/perl
use 5.010;

# Input files
$genomeList = 'Output_files/genomeProperties.txt';

# Output files
$symClade = 'Horizontal_transfer/symbioticCladeProteins.ffn';
$nonSymClade = 'Horizontal_transfer/nonSymbioticCladeProteins.ffn';

# Make lists of strains and clade
open($in, '<', $genomeList);
while(<$in>) {
    chomp;
    @line = split("\t", $_);
    push(@strains, @line[0]);
    push(@clade, @line[3]);
}
close($in);

# Switch names and combine
open($out_sym, '>', $symClade);
open($out_non, '>', $nonSymClade);
$arrayLength = scalar @strains;
$arrayLength = $arrayLength - 1;
for($n = 0; $n <= $arrayLength; $n++) {
    $species = @strains[$n];
    $protein = $species;
    $species .= '.ffn';
    $species2 = 'Genome_files/Sinorhizobium_reannotated/';
    $species2 .= $species;
    open($in, '<', $species2);
    if(@clade[$n] == 1) {
        while(<$in>) {
            if(/>/) {
                $total++;
                $total2 = "__$total";
                say $out_sym (">$protein$total2");
            }
            else {
                print $out_sym ("$_");
            }
        }
    }
    else {
        while(<$in>) {
            if(/>/) {
                $total++;
                $total2 = "__$total";
                say $out_non (">$protein$total2");
            }
            else {
                print $out_non ("$_");
            }
        }
    }
    close($in);
}
close($out_sym);
close($out_non);
