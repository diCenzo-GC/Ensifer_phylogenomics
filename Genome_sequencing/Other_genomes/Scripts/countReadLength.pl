#!usr/bin/perl
use 5.010;

while(<>) {
	if(/>/) {
		say($length);
		$length = 0;
	}
	else {
		chomp;
		$n = length($_);
		$length = $length + $n;
	}
}
