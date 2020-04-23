# Get sizes and gene counts
perl Scripts/getSizes.pl # Get desired information
sort -k4,4 genomeProperties.txt > Output_files/genomeProperties.txt # Sort output by cluster
rm genomeProperties.txt # remove file

# Determine assembly level
perl Scripts/determineAssembly.pl > unrootedPhylogenyAnnotation.txt # Add assembly level to annotation file
mv unrootedPhylogenyAnnotation.txt Output_files/ # Move file
