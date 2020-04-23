# Make directories
mkdir Horizontal_transfer/ # Make directory

# Combine the proteomes
perl Scripts/prepareProteinSets.pl # Prepare gene sets for each clade

# Perform the blast search
makeblastdb -in Horizontal_transfer/symbioticCladeProteins.ffn -out Horizontal_transfer/symbioticBlastDB -title symbioticBlastDB -dbtype 'nucl' # Make blast database
blastn -query Horizontal_transfer/nonSymbioticCladeProteins.ffn -db Horizontal_transfer/symbioticBlastDB -out Horizontal_transfer/blast_output.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -num_threads 20 # Perform the blast search

# Extract similar hits
awk '$3 >= "95" {print}' Horizontal_transfer/blast_output.txt > Horizontal_transfer/blast_output_95.txt # Get hits with atleast 95% identity
awk '$3 >= "98" {print}' Horizontal_transfer/blast_output.txt > Horizontal_transfer/blast_output_98.txt # Get hits with atleast 98% identity
awk '$3 >= "99" {print}' Horizontal_transfer/blast_output.txt > Horizontal_transfer/blast_output_99.txt # Get hits with atleast 99% identity
gzip Horizontal_transfer/blast_output.txt # Compress the file
awk '$4 / $7 >= "0.95" {print}' Horizontal_transfer/blast_output_95.txt | awk '$4 / $10 >= "0.95" {print}' > Horizontal_transfer/blast_output_95_95.txt # Get hits with at least 95% protein alignment
awk '$4 / $7 >= "0.98" {print}' Horizontal_transfer/blast_output_98.txt | awk '$4 / $10 >= "0.98" {print}' > Horizontal_transfer/blast_output_98_98.txt # Get hits with at least 98% protein alignment
awk '$4 / $7 >= "0.99" {print}' Horizontal_transfer/blast_output_99.txt | awk '$4 / $10 >= "0.99" {print}' > Horizontal_transfer/blast_output_99_99.txt # Get hits with at least 99% protein alignment

# Determine recently transferred clusters
matlab --nodesktop --nosplash -r Scripts/linkHeaders.m # Convert gene names
grep -f 'Horizontal_transfer/genes_99.txt' Pangenome_calculation/cdhit_clustering/modifiedOutput.txt > Horizontal_transfer/clusters_99.txt # Get transferred clusters
grep -f 'Horizontal_transfer/genes_98.txt' Pangenome_calculation/cdhit_clustering/modifiedOutput.txt > Horizontal_transfer/clusters_98.txt # Get transferred clusters
grep -f 'Horizontal_transfer/genes_95.txt' Pangenome_calculation/cdhit_clustering/modifiedOutput.txt > Horizontal_transfer/clusters_95.txt # Get transferred clusters
sed -i 's/aa\,/\t/' Horizontal_transfer/clusters_99.txt # Modify formatting
sed -i 's/aa\,/\t/' Horizontal_transfer/clusters_98.txt # Modify formatting
sed -i 's/aa\,/\t/' Horizontal_transfer/clusters_95.txt # Modify formatting
awk '$4 >= "100" {print}' Horizontal_transfer/clusters_99.txt | cut -f1,1 > Horizontal_transfer/clusters_99_100aa.txt # Get hits with atleast 95% identity
awk '$4 >= "100" {print}' Horizontal_transfer/clusters_98.txt | cut -f1,1 > Horizontal_transfer/clusters_98_100aa.txt # Get hits with atleast 95% identity
awk '$4 >= "100" {print}' Horizontal_transfer/clusters_95.txt | cut -f1,1 > Horizontal_transfer/clusters_95_100aa.txt # Get hits with atleast 95% identity

# Count transferred clusters
wc -l Horizontal_transfer/clusters_99_100aa.txt > Horizontal_transfer/shared_cluster_count.txt # Count recently transferred clusters
wc -l Horizontal_transfer/clusters_98_100aa.txt >> Horizontal_transfer/shared_cluster_count.txt # Count recently transferred clusters
wc -l Horizontal_transfer/clusters_95_100aa.txt >> Horizontal_transfer/shared_cluster_count.txt # Count recently transferred clusters
cp Horizontal_transfer/shared_cluster_count.txt Output_files/transferredClusters.txt # Move file

