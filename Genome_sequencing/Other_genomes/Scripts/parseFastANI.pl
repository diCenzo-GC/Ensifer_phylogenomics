#!usr/bin/perl
use 5.010;

while(<>) {
	chomp;
	$total++;
	if($total <= 2) {
		@line = split(' ', $_);
		@name = split('/', @line[1]);
		system("cp @line[1] referenceGenomes/@name[4]");
	}
}
