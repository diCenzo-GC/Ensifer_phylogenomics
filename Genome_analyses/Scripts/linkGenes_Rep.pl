#!usr/bin/perl
use 5.010;

# Input files
$nifH_file = 'Sym_Gene_Phylogenies/SymbioticProteins/RepA_all.faa';
$nifD_file = 'Sym_Gene_Phylogenies/SymbioticProteins/RepB_all.faa';

# Output files
$nifH_out_file = 'Sym_Gene_Phylogenies/SymbioticProteinsOperons/RepA.faa';
$nifD_out_file = 'Sym_Gene_Phylogenies/SymbioticProteinsOperons/RepB.faa';

# Collect all RepA proteins
open($in, '<', $nifH_file);
while(<$in>) {
    chomp;
    @line = split("\t", $_);
    @line2 = split('__', @line[0]);
    push(@nifH_strain, @line2[0]);
    push(@nifH_locus, @line2[1]);
    push(@nifH_replicon, @line2[2]);
    push(@nifH_number, @line2[3]);
    push(@nifH_sequence, @line[1]);
}
close($in);

# Collect all RepB proteins
open($in, '<', $nifD_file);
while(<$in>) {
    chomp;
    @line = split("\t", $_);
    @line2 = split('__', @line[0]);
    push(@nifD_strain, @line2[0]);
    push(@nifD_locus, @line2[1]);
    push(@nifD_replicon, @line2[2]);
    push(@nifD_number, @line2[3]);
    push(@nifD_sequence, @line[1]);
}
close($in);

# Get array lengths
$nifH_length = scalar @nifH_strain;
$nifH_length = $nifH_length - 1;
$nifD_length = scalar @nifD_strain;
$nifD_length = $nifD_length - 1;

# Group into operons
$A_old = 'XXX';
open($nifH_out, '>', $nifH_out_file);
open($nifD_out, '>', $nifD_out_file);
for($n = 0; $n <= $nifH_length; $n++) {
    for($i = 0; $i <= $nifD_length; $i++) {
        if(abs( @nifD_number[$i] - @nifH_number[$n]) <= 2 ) {
            @A = split("__", @nifD_strain[$i]);
            if(@A[0] eq $A_old) {
                $total++;
                $total2 = "_$total";
                $locus = "__$nifH_locus[$n]";
                $replicon = "__$nifH_replicon[$n]";
                $number = "__$nifH_number[$n]";
                say $nifH_out ("@nifH_strain[$n]$total2$locus$replicon$number\t@nifH_sequence[$n]");
                $locus = "__$nifD_locus[$i]";
                $replicon = "__$nifD_replicon[$i]";
                $number = "__$nifD_number[$i]";
                say $nifD_out ("@nifD_strain[$i]$total2$locus$replicon$number\t@nifD_sequence[$i]");
            }
            else {
                $total = 1;
                $locus = "__$nifH_locus[$n]";
                $replicon = "__$nifH_replicon[$n]";
                $number = "__$nifH_number[$n]";
                say $nifH_out ("@nifH_strain[$n]$locus$replicon$number\t@nifH_sequence[$n]");
                $locus = "__$nifD_locus[$i]";
                $replicon = "__$nifD_replicon[$i]";
                $number = "__$nifD_number[$i]";
                say $nifD_out ("@nifD_strain[$i]$locus$replicon$number\t@nifD_sequence[$i]");
            }
            $A_old = @A[0];
        }
    }
}
close($nifH_out);
close($nifD_out);

