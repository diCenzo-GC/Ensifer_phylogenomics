#!usr/bin/perl
use File::Find;
use 5.010;
use Cwd;

$pwd = cwd();
$parent = "$pwd/Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAl";
$output = "$pwd/Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified/";

find( \&search_all_folder, $parent );		

sub search_all_folder {
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

sub read_files {
	($filename) = @_;
	open $fh, '<', $filename;
	$output2 = $output . $filename;
	open($out,'>',$output2);
	while(<$fh>) {
		if(/>/) {
			chomp;
			@line = split("\ ",$_);
			@line2 = split('__',$_);
			print $out ("\n@line2[0]__@line2[2],@line[1],");
		}
		else {
			chomp;
			print $out ($_);
		}
	}
	close($fh);
	close($out);
}

