# Run and parse the analysis
mkdir AAI_matrix/ # Make directory
mkdir AAI_matrix/tmp/ # Make directory
comparem aai_wf -e 1e-12 -p 40.0 -a 70.0 --sensitive -x fna --tmp_dir AAI_matrix/tmp/ -c 20 Genome_files/Sinorhizobium/ AAI_matrix/ # Run comparem
perl Scripts/prepareAAImatrix.pl > AAI_matrix/AAI_matrix.txt # Make a two-way AAI matrix from the comparem output
cp AAI_matrix/AAI_matrix.txt Output_files/aaiMatrix.txt # Move file
