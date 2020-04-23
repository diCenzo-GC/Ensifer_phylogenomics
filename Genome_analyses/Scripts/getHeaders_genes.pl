#!/usr/bin/perl
use 5.010;

# Input files
$genomeList = 'Output_files/genomeProperties.txt';

# Output files
$output = 'Horizontal_transfer/geneHeaders_genes.txt';

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
open($out, '>', $output);
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
                @oldName = split(' ', $_);
                $oldName = @oldName[0];
                $oldName =~ s/>//;
                say $out ("$oldName\t$protein$total2");
            }
        }
    }
    else {
        while(<$in>) {
            if(/>/) {
                $total++;
                $total2 = "__$total";
                @oldName = split(' ', $_);
                $oldName = @oldName[0];
                $oldName =~ s/>//;
                say $out ("$oldName\t$protein$total2");
            }
        }
    }
    close($in);
}
close($out);


