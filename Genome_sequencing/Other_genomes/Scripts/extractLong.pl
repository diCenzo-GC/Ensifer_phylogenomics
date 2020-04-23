#!usr/bin/perl

# File designations
$medusa = 'medusa_scaffolding/scaffolds_medusa_phage.fasta';
$tempFile = 'medusa_scaffolding/contigLengths.txt';
$tempFile2 = 'medusa_scaffolding/contigLengths_sorted.txt';
$finalFile = 'medusa_scaffolding/scaffolds_medusa_reduced.fasta';

# Calculate and record scaffold lengths
$count = 0;
open($in, '<', $medusa);
open($out, '>', $tempFile);
while(<$in>) {
    chomp;
    if(/>/) {
        if($count > 0) {
            print $out ("\t$count\n");
            print $out ("$_");
            $count = 0;
        }
        else {
            print $out ("$_");
        }
    }
    else {
        $count = $count + length($_);
    }
}
print $out ("\t$count\n");
close($in);
close($out);
system("sort -n -r -k2,2 medusa_scaffolding/contigLengths.txt > medusa_scaffolding/contigLengths_sorted.txt");

# Store contig lengths
open($in, '<', $tempFile2);
$x = 0;
while(<$in>) {
    chomp;
    @line = split("\t", $_);
    push(@contigName, @line[0]);
    push(@contigLength, @line[1]);
    $x++;
}
close($in);

# Extract and sort long contigs
$i = 0;
open($out, '>', $finalFile);
for($n = 0; $n < $x; $n++) {
    if(@contigLength[$n] >= 1000) {
        open($in, '<', $medusa);
        while(<$in>) {
            if(/>/) {
                $testName = $_;
                $testName =~ s/\n//;
                if(@contigName[$n] eq $testName) {
                    $test = 1;
                    $i++;
                    print $out (">Scaffold_$i\n");
                }
                else {
                    $test = 0;
                }
            }
            else {
                if($test == 1) {
                    print $out ("$_");
                }
            }
        }
        close($in);
    }
}
close($out);

