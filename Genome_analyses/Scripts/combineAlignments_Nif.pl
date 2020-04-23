#!usr/bin/perl
use File::Find;
use 5.010;
use Cwd;

# set variables
$pwd = cwd();
$parent = "$pwd/Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Nif/";
$species_list = "Sym_Gene_Phylogenies/SymbioticProteinsOperons_TrimAlmodified_Nif/NifH_trimal.fasta";
$temporaryFile = 'temporary.txt';
$test = 0;

# make an array of the species names
open($species,'<',$species_list);
while(<$species>) {
    if(/>/) {
        chomp;
        @line = split(',',$_);
        push(@genomes,@line[0]);
    }
}
close($species);

foreach $genome (@genomes) {
	open($temp,'>',$temporaryFile);
	find( \&search_all_folder, $parent );
	close($temp);
	open($temp2,'<',$temporaryFile);
    say("$genome");
	while(<$temp2>) {
		print($_);
	}
	print("\n");
}	
unlink($temporaryFile);

sub search_all_folder {
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

sub read_files {
	($filename) = @_;
	open $fh, '<', $filename;
	while(<$fh>) {
		chomp;
		@lineA = split(',',$_);
		if(@lineA[0] eq $genome) {
			$test++;
			print $temp (@lineA[2]);
		}
	}
	if($test == 0) {
		$characters = "-" x @lineA[1];
		print $temp ($characters);
	}
	$test = 0;
}

