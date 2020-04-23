# Make directories
mkdir Pangenome_calculation/Functional_analysis/ # Make directory
mkdir Pangenome_calculation/Functional_analysis/Proteomes/ # Make directory
mkdir Pangenome_calculation/Functional_analysis/Eggnog_output/ # Make directory
mkdir Pangenome_calculation/Functional_analysis/COG_categories/ # Make directory

# Extract the protein lists
./Scripts/getGeneLists.R # Determine overlaps
perl Scripts/modifyFasta.pl Pangenome_calculation/cdhit_clustering/output > Pangenome_calculation/Functional_analysis/proteome_modified.faa # Modify protein fasta
cd Pangenome_calculation/Functional_analysis # Change directory
sed -i 's/\"//' common_core.txt # Modify format
sed -i 's/\"/\t/' common_core.txt # Modify format
sed -i 's/\"//' ensifer_core.txt # Modify format
sed -i 's/\"/\t/' ensifer_core.txt # Modify format
sed -i 's/\"//' sinorhizobium_core.txt # Modify format
sed -i 's/\"/\t/' sinorhizobium_core.txt # Modify format
sed -i 's/\"//' common_accessory.txt # Modify format
sed -i 's/\"/\t/' common_accessory.txt # Modify format
sed -i 's/\"//' sinorhizobium_accessory.txt # Modify format
sed -i 's/\"/\t/' sinorhizobium_accessory.txt # Modify format
sed -i 's/\"//' ensifer_accessory.txt # Modify format
sed -i 's/\"/\t/' ensifer_accessory.txt # Modify format
sed -i 's/\"//' sinorhizobium_uniq_core.txt # Modify format
sed -i 's/\"/\t/' sinorhizobium_uniq_core.txt # Modify format
sed -i 's/\"//' ensifer_uniq_core.txt # Modify format
sed -i 's/\"/\t/' ensifer_uniq_core.txt # Modify format
cd ../.. # Change directory

# Modify names of the starting protein file
cp Pangenome_calculation/Functional_analysis/proteome_modified.faa Pangenome_calculation/Functional_analysis/proteome_modified.txt # Make a version with a different extension
cp Pangenome_calculation/cdhit_clustering/modifiedOutput.txt Pangenome_calculation/Functional_analysis/modifiedOutput.txt # Copy the file
sed -i 's/Cluster /Cluster_/' Pangenome_calculation/Functional_analysis/modifiedOutput.txt # Change cluster naming
sed -i 's/\t/ /g' Pangenome_calculation/Functional_analysis/modifiedOutput.txt # Change cluster naming
sed -i 's/ 0 /\t0\t/g' Pangenome_calculation/Functional_analysis/modifiedOutput.txt # Change cluster naming
cd Scripts/ # Change directory
matlab -nodesktop -nosplash -r renameClusters # switch gene name with cluster name
cd ../ # Change directory

# Extract proteomes
cd Pangenome_calculation/Functional_analysis # Change directory
grep -f common_core.txt proteome_modified_renamed.fasta > common_core.fasta # Extract proteins
grep -f sinorhizobium_core.txt proteome_modified_renamed.fasta > sinorhizobium_core.fasta # Extract proteins
grep -f ensifer_core.txt proteome_modified_renamed.fasta > ensifer_core.fasta # Extract proteins
grep -f common_accessory.txt proteome_modified_renamed.fasta > common_accessory.fasta # Extract proteins
grep -f sinorhizobium_accessory.txt proteome_modified_renamed.fasta > sinorhizobium_accessory.fasta # Extract proteins
grep -f ensifer_accessory.txt proteome_modified_renamed.fasta > ensifer_accessory.fasta # Extract proteins
grep -f sinorhizobium_uniq_core.txt proteome_modified_renamed.fasta > sinorhizobium_uniq_core.fasta # Extract proteins
grep -f ensifer_uniq_core.txt proteome_modified_renamed.fasta > ensifer_uniq_core.fasta # Extract proteins
sed -i 's/\t/\n/' common_core.fasta # Reformat file
sed -i 's/\t/\n/' sinorhizobium_core.fasta # Reformat file
sed -i 's/\t/\n/' ensifer_core.fasta # Reformat file
sed -i 's/\t/\n/' common_accessory.fasta # Reformat file
sed -i 's/\t/\n/' sinorhizobium_accessory.fasta # Reformat file
sed -i 's/\t/\n/' ensifer_accessory.fasta # Reformat file
sed -i 's/\t/\n/' sinorhizobium_uniq_core.fasta # Reformat file
sed -i 's/\t/\n/' ensifer_uniq_core.fasta # Reformat file
mv common_core.fasta Proteomes/common_core.fasta # Move file
mv sinorhizobium_core.fasta Proteomes/sinorhizobium_core.fasta # Move file
mv ensifer_core.fasta Proteomes/ensifer_core.txt # Move file
mv common_accessory.fasta Proteomes/common_accessory.fasta # Move file
mv sinorhizobium_accessory.fasta Proteomes/sinorhizobium_accessory.fasta # Move file
mv ensifer_accessory.fasta Proteomes/ensifer_accessory.fasta # Move file
mv sinorhizobium_uniq_core.fasta Proteomes/sinorhizobium_uniq_core.fasta # Move file
mv ensifer_uniq_core.fasta Proteomes/ensifer_uniq_core.fasta # Move file
cd ../.. # Change directory

# Functional annotation
cd Pangenome_calculation/Functional_analysis # Change directory
emapper.py -i Proteomes/common_core.fasta --output Eggnog_output/common_core -d bact --usemem --cpu 40 # Run eggnog-mapper
emapper.py -i Proteomes/sinorhizobium_core.fasta --output Eggnog_output/sinorhizobium_core -d bact --usemem --cpu 40 # Run eggnog-mapper
emapper.py -i Proteomes/ensifer_core.fasta --output Eggnog_output/ensifer_core -d bact --usemem --cpu 40 # Run eggnog-mapper
emapper.py -i Proteomes/common_accessory.fasta --output Eggnog_output/common_accessory -d bact --usemem --cpu 40 # Run eggnog-mapper
emapper.py -i Proteomes/sinorhizobium_accessory.fasta --output Eggnog_output/sinorhizobium_accessory -d bact --usemem --cpu 40 # Run eggnog-mapper
emapper.py -i Proteomes/ensifer_accessory.fasta --output Eggnog_output/ensifer_accessory -d bact --usemem --cpu 40 # Run eggnog-mapper
emapper.py -i Proteomes/sinorhizobium_uniq_core.fasta --output Eggnog_output/sinorhizobium_uniq_core -d bact --usemem --cpu 40 # Run eggnog-mapper
emapper.py -i Proteomes/ensifer_uniq_core.fasta --output Eggnog_output/ensifer_uniq_core -d bact --usemem --cpu 40 # Run eggnog-mapper
perl ../../Scripts/COGanalysis.pl # Analyse COG categories
cd ../.. # Change directory
