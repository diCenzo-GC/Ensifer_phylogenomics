#!usr/bin/perl
use 5.010;

# Files
$input = 'ANI_matrix/fastani_output_twoWay.txt';
$strains = 'ANI_matrix/genomePaths.txt';

# Get the strains
open($inStrains, '<', $strains);
while(<$inStrains>) {
    chomp;
    push(@strains, $_);
}
close($inStrains);

# Prepare the first row
print('Strains');
foreach $i (@strains) {
    $i =~ s/Genomes\///;
    $i =~ s/.fna//;
    print("\t$i");
}

# Make the matrix
foreach $i (@strains) {
    print("\n$i");
    foreach $j (@strains) {
        $test = 0;
        if($i eq $j) {
            print("\t100");
        }
        else {
            $i =~ $i . '.fna';
            $j =~ $j . '.fna';
            open($in, '<', $input);
            while(<$in>) {
                $_ =~ s/.fna//g;
                @line = split(" ", $_);
                if(@line[0] eq $i) {
                    if(@line[1] eq $j) {
                        @line = split(' ', $_);
                        $ani = (@line[2] + @line[3]) / 2;
                        print("\t$ani");
                        $test = 1;
                        last;
                    }
                }
                elsif(@line[1] eq $i) {
                    if(@line[0] eq $j) {
                        @line = split(' ', $_);
                        $ani = (@line[2] + @line[3]) / 2;
                        print("\t$ani");
                        $test = 1;
                        last;
                    }
                }            }
            close($in);
            if($test == 0) {
                print("\t78");
            }
        }
    }
}

