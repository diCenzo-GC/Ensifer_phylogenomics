#!usr/bin/perl
use 5.010;

$test = 1;
while(<>) {
	if(/>/) {
		@line = split('_', $_);
		if(@line[5] >= XXX) {
			print($_);
			$test = 1;
		}
		else {
			$test = 0;
		}
	}
	else {
		if($test == 1) {
			print($_);
		}
	}
}
