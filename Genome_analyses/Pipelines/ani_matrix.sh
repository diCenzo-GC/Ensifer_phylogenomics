# Run fastANI
mkdir ANI_matrix/ # Make directory
find Genome_files/Sinorhizobium/*.fna > ANI_matrix/genomePaths.txt # Get the genome paths
./Scripts/splitDatabase.sh ANI_matrix/genomePaths.txt 20 ANI_matrix/ # Run fastani in parallel
cat ANI_matrix/*.output > ANI_matrix/fastani_output.txt # Combine the output files
rm ANI_matrix/*.output # Remove unwanted files
rm ANI_matrix/BATCH_OUTPUT_* # Remove unwanted files
rm ANI_matrix/partition.* # Remove unwanted files

# Parse fastANI output
sort -k1,1 -k2,2 ANI_matrix/fastani_output.txt > ANI_matrix/fastani_output_sorted_1.txt # Sort the file by first column then by second column
sort -k2,2 -k1,1 ANI_matrix/fastani_output.txt > ANI_matrix/fastani_output_sorted_2.txt # Sort the file by second column then by first column
cut -d ' ' -f 1,2,3 ANI_matrix/fastani_output_sorted_1.txt > ANI_matrix/temp.txt # Get the relevant columns of the first sorted file
cut -d ' ' -f 3 ANI_matrix/fastani_output_sorted_2.txt > ANI_matrix/temp2.txt # Get the relevant columns of the second sorted file
paste -d ' ' ANI_matrix/temp.txt ANI_matrix/temp2.txt > ANI_matrix/fastani_output_twoWay.txt # Combine the relevant columns
rm ANI_matrix/temp* # remove the temporary files
perl Scripts/prepareANImatrix.pl > ANI_matrix/ANI_matrix.txt # make a two-way ANI matrix from the fastANI output
cp ANI_matrix/ANI_matrix.txt Output_files/aniMatrix.txt # Move file
