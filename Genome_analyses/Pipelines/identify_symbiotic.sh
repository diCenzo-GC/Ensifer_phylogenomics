# Prepare directories
mkdir Symbiotic_gene_presence/ # Make directory
mkdir Symbiotic_gene_presence/ProteomesHMM/ # Make directory
mkdir Symbiotic_gene_presence/HMMsearch/ # Make directory
mkdir Symbiotic_gene_presence/HMMsearchParsed/ # Make directory
mkdir Symbiotic_gene_presence/HMMsearchHits/ # Make directory
mkdir Symbiotic_gene_presence/hmmDatabaseFiles/ # Make directory
mkdir Symbiotic_gene_presence/HMMscan/ # Make directory
mkdir Symbiotic_gene_presence/HMMscanParsed/ # Make directory
mkdir Symbiotic_gene_presence/HMMscanTop/ # Make directory

# Prepare protein files
perl Scripts/switchNames.pl # Switch the names of the proteins in the faa files
cat Symbiotic_gene_presence/ProteomesHMM/*.faa > Symbiotic_gene_presence/combined_proteomes_HMM.faa # Combine the faa files into one file
rm Symbiotic_gene_presence/ProteomesHMM/* # Remove unrequired intermediate files
perl Scripts/modifyFasta.pl Symbiotic_gene_presence/combined_proteomes_HMM.faa > Symbiotic_gene_presence/combined_proteomes_HMM_modified.faa # Modify the fasta file for easy extraction

# Perform the HMMsearch screens
perl Scripts/performHMMsearch.pl # A short script to repeat for all HMM files, the build, hmmsearch, parsing, and hit extraction

# Perform the HMM scan screens
wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz # get the Pfam HMM files
wget ftp://ftp.jcvi.org/pub/data/TIGRFAMs//TIGRFAMs_15.0_HMM.LIB.gz # get the TIGRFAM HMM files
gunzip Pfam-A.hmm.gz # unzip the Pfam files
gunzip TIGRFAMs_15.0_HMM.LIB.gz # unzip the TIGRFAM files
mv Pfam-A.hmm Symbiotic_gene_presence/hmmDatabaseFiles/Pfam-A.hmm # move the Pfam files
mv TIGRFAMs_15.0_HMM.LIB Symbiotic_gene_presence/hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB # move the TIGRFAM files
hmmconvert Symbiotic_gene_presence/hmmDatabaseFiles/Pfam-A.hmm > Symbiotic_gene_presence/hmmDatabaseFiles/Pfam-A_converted.hmm # convert the database to the necessary format
hmmconvert Symbiotic_gene_presence/hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB > Symbiotic_gene_presence/hmmDatabaseFiles/TIGRFAM_converted.hmm # convert the database to the necessary format
cat Symbiotic_gene_presence/hmmDatabaseFiles/Pfam-A_converted.hmm Symbiotic_gene_presence/hmmDatabaseFiles/TIGRFAM_converted.hmm > Symbiotic_gene_presence/hmmDatabaseFiles/converted_combined.hmm # combined all hidden Markov models into a single file
hmmpress Symbiotic_gene_presence/hmmDatabaseFiles/converted_combined.hmm # prepare files for hmmscan searches
perl Scripts/performHMMscan.pl # a short script to repeat for all the HMM search output files, to perform hmmscan, parse, and hit extraction

# Determine strains with each protein
perl Scripts/determineProteinPresence.pl > Symbiotic_gene_presence/Symbiotic_gene_distribution.txt # determine which of the six proteins are in each of the strains

# Compress HMM files
gzip -r Symbiotic_gene_presence/hmmDatabaseFiles/ # Compress files

# Remove intermediate files
rm Symbiotic_gene_presence/combined_proteomes_HMM.faa # Remove file
rm Symbiotic_gene_presence/combined_proteomes_HMM_modified.faa # Remove file


