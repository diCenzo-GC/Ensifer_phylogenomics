#!usr/bin/perl
use 5.010;

# Files
$genomeFile = 'Input_lists/genomeList_sino.txt';
$outFile = 'genomeProperties.txt';
$symFile = 'Symbiotic_gene_presence/Symbiotic_gene_distribution.txt';

# Make array of strain names
open($in, '<', $genomeFile);
while(<$in>) {
    @line = split("\t", $_);
    push(@strains, @line[0]);
}
close($in);

# Get the genome information
open($out, '>', $outFile);
foreach $i (@strains) {
    $file = "Unrooted_phylogeny/Reannotate_genomes/$i/$i.txt";
    open($in, '<', $file);
    while(<$in>) {
        if(/bases/) {
            chomp;
            @line = split(' ', $_);
            print $out ("$i\t@line[1]");
        }
        elsif(/CDS/) {
            @line = split(' ', $_);
            print $out ("\t@line[1]\t");
        }
    }
    close($in);
    $file = "Unrooted_phylogeny/Reannotate_genomes/$i/$i.fna";
    open($in, '<', $file);
    $GC = 0;
    $GCAT = 0;
    while(<$in>) {
        chomp;
        unless(/>/) {
            @line = split('', $_);
            foreach $j (@line) {
                $GCAT++;
                if($j eq 'G') {
                    $GC++;
                }
                elsif($j eq 'C') {
                    $GC++;
                }
            }
        }
    }
    $GCratio = 100 * $GC / $GCAT;
    print $out ("$GCratio\t");
    close($in);
    open($in, '<', $symFile);
    while(<$in>) {
        @line = split("\t", $_);
        if($i eq @line[0]) {
            if(@line[9] == 1) {
                if(/sesbaniae/) {
                    say $out ('0');
                }
                else {
                    say $out ('1');
                }
            }
            else {
                if(/05631/) {
                    say $out ('1');
                }
                elsif(/fredii/) {
                    say $out ('1');
                }
                elsif(/aridi/) {
                    say $out ('1');
                }
                elsif(/M4_45/) {
                    say $out ('1');
                }
                elsif(/6670/) {
                    say $out ('1');
                }
                elsif(/T2_8/) {
                    say $out ('1');
                }
                elsif(/meliloti/) {
                    say $out ('1');
                }
                else {
                    say $out ('0');
                }
            }
        }
    }
}
close($out)
