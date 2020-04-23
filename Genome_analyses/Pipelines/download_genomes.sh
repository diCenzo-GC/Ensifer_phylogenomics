# Download the Sinorhizobium and Ensifer genomes
grep -v 'RAC02' Input_lists/Sinorhizobium.csv > temp.txt # Remove the one odd strain
mv temp.txt Input_lists/Sinorhizobium.csv # Rename the file
grep -v 'RP12G' Input_lists/Sinorhizobium.csv > temp.txt # Remove the second odd strain
mv temp.txt Input_lists/Sinorhizobium.csv # Rename the file
grep -v 'JGI' Input_lists/Sinorhizobium.csv > temp.txt # Remove the second odd strain
mv temp.txt Input_lists/Sinorhizobium.csv # Rename the file
perl Scripts/parseGenomeList_sino.pl Input_lists/Sinorhizobium.csv # Parse the NCBI genome table to get info to download genomes
sed -i 's/__/_/g' Input_lists/genomeList_sino.txt # Fix the double __
sort -u -k1,1 Input_lists/genomeList_sino.txt > temp.txt # Remove duplicates
mv temp.txt Input_lists/genomeList_sino.txt # Rename the file
sed -i 's/_(FSM-MA)/_FSM_MA/g' Input_lists/genomeList_sino.txt # Fix formatting
sed -i 's/RU11\/001/RU11_011/' Input_lists/genomeList_sino.txt # Fix formatting
sed -i 's/sp\._/sp_/g' Input_lists/genomeList_sino.txt # Fix formatting
sed -i 's/-/_/g' Input_lists/genomeList_sino.txt # Fix formatting
sed -i 's/IMG_taxon/IMG-taxon/g' Input_lists/genomeList_sino.txt # Fix formatting
sed -i 's/SfreGR64_1/SfreGR64-1/g' Input_lists/genomeList_sino.txt # Fix formatting
mkdir Genome_files/ # Make directory
mkdir Genome_files/Sinorhizobium/ # Make directory
perl Scripts/downloadGenomes_sino.pl Input_lists/genomeList_sino.txt # download the genomes of interest
cp New_genomes/*.fna Genome_files/Sinorhizobium/ # Move new genomes in genomes directory
cat New_genomes/newGenomeList.txt Input_lists/genomeList_sino.txt > temp_1.txt # Concatenated new list with old one
sort -u -k1,1 temp_1.txt > temp_2.txt # Remove duplicates
mv temp_2.txt Input_lists/genomeList_sino.txt  # Rename file
rm temp_1.txt # Remove file

# Download the Rhizobium genomes
perl Scripts/parseGenomeList_rhizo.pl Input_lists/Rhizobium.csv # Parse the NCBI genome table to get info to download genomes
sort -u -k1,1 Input_lists/genomeList_rhizo.txt > temp.txt # Remove duplicates
mv temp.txt Input_lists/genomeList_rhizo.txt # Rename the file
sed -i 's/Rhizobium_etli_8C-3/Rhizobium_etli_8C_3/g' Input_lists/genomeList_rhizo.txt # Fix formatting
mkdir Genome_files/Rhizobium/ # Make directory
perl Scripts/downloadGenomes_rhizo.pl Input_lists/genomeList_rhizo.txt # download the genomes of interest
cat Input_lists/genomeList_sino.txt Input_lists/genomeList_rhizo.txt > Input_lists/genomeList_combined.txt # Combine the genome lists
