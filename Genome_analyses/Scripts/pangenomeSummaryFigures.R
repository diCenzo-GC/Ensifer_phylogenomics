#!/usr/bin/env Rscript

# Code adapted from: http://gogarten.uconn.edu/mcb5472_2018/Laboratories/R_pangenome/updated.nb.html

setwd('Pangenome_calculation/Pangenome_overlap/')

# Load libraries
library("ape")
library("vegan")
library("philentropy")
library("ggplot2")
library("ggfortify")

# Load the data for gene accumulation curves
pan_matrix_nonSymbiotic <- read.table(file = "Non_symbiotic_transposed.txt", 
                                      stringsAsFactors = TRUE, header = TRUE, row.names = 1)
pan_matrix_symbiotic <- read.table(file = "Symbiotic_transposed.txt", 
                                   stringsAsFactors = TRUE, header = TRUE, row.names = 1)

# Make the gene accumulation curves
sp_nonSymbiotic <- specaccum(pan_matrix_nonSymbiotic, method="random", permutations=500)
sp_symbiotic <- specaccum(pan_matrix_symbiotic, method="random", permutations=500)

# Plot the data
svg(filename = 'gene_accumulation_plots2.svg')
par(mfrow=c(1,2))
plot(sp_nonSymbiotic, ci.type="poly", col="blue", lwd=2, ci.lty=0, ci.col="lightblue", 
     xlab="Genomes", ylab="Proteins", main="Gene accumulation plot", 
     ylim = c(0,100000), xlim = c(0,120))
plot(sp_symbiotic, ci.type="poly", col="blue", lwd=2, ci.lty=0, ci.col="lightblue", 
     xlab="Genomes", ylab="Proteins", main="Gene accumulation plot", 
     ylim = c(0,100000), xlim = c(0,120))
dev.off()

# Prepare the data for distance plots
pan_matrix_full <- rbind(pan_matrix_nonSymbiotic, pan_matrix_symbiotic)

# Prepare distance tree based on the pangenome
r_names <- row.names(pan_matrix_full)
matrix_dist <- distance(pan_matrix_full, method = "jaccard")
row.names(matrix_dist) <- r_names
tree_bionj <- bionj(matrix_dist)
write.tree(tree_bionj, file = "accessory_genome_tree.tre")

# Prepare a PCA plot based on the pangenome with extra groupings
pan_matrix_nonSymbiotic$Sym_Cluster <- c(rep("Non-symbiotic"))
pan_matrix_symbiotic$Sym_Cluster <- c(rep("Symbiotic"))
pan_matrix_full <- rbind(pan_matrix_nonSymbiotic, pan_matrix_symbiotic)
pan_matrix.pca <- prcomp(pan_matrix_full[,1:ncol(pan_matrix_full)-1]) 
par(mfrow=c(1,1))
test <- autoplot(pan_matrix.pca, data = pan_matrix_full, colour = 'Sym_Cluster', 
                 xlim = c(-0.15,0.15), ylim = c(-0.25, 0.25), frame = TRUE, frame.type = 'norm')
svg(filename = 'pca_plot.svg')
autoplot(pan_matrix.pca, data = pan_matrix_full, colour = 'Sym_Cluster', 
         xlim = c(-0.15,0.15), ylim = c(-0.25, 0.25), frame = TRUE, frame.type = 'norm')
dev.off()

# Prepare a PCA plot based on the pangenome with extra groupings
pan_matrix_full2 <- pan_matrix_full
pan_matrix_full2[82:150,ncol(pan_matrix_full2)] <- "Symbiotic2"
pan_matrix_full2[58:60,ncol(pan_matrix_full2)] <- "Symbiotic2"
pan_matrix_full2[155,ncol(pan_matrix_full2)] <- "Symbiotic2"
pan_matrix_full2[67,ncol(pan_matrix_full2)] <- "Symbiotic2"
pan_matrix2.pca <- prcomp(pan_matrix_full2[,1:ncol(pan_matrix_full2)-1]) 
par(mfrow=c(1,1))
test <- autoplot(pan_matrix2.pca, data = pan_matrix_full2, colour = 'Sym_Cluster', 
         xlim = c(-0.15,0.15), ylim = c(-0.25, 0.25), frame = TRUE, frame.type = 'norm')
svg(filename = 'pca_plot_2.svg')
autoplot(pan_matrix2.pca, data = pan_matrix_full2, colour = 'Sym_Cluster', 
         xlim = c(-0.15,0.15), ylim = c(-0.25, 0.25), frame = TRUE, frame.type = 'norm')
dev.off()

# Prepare a PCA plot based on the pangenome with extra groupings again
pan_matrix_full3 <- pan_matrix_full
pan_matrix_full3[68:81,ncol(pan_matrix_full3)] <- "Symbiotic2"
pan_matrix_full3[52,ncol(pan_matrix_full3)] <- "Symbiotic2"
pan_matrix_full3[152:154,ncol(pan_matrix_full3)] <- "Symbiotic2"
pan_matrix_full3[54:57,ncol(pan_matrix_full3)] <- "Symbiotic2"
pan_matrix_full3[62:66,ncol(pan_matrix_full3)] <- "Symbiotic2"
pan_matrix_full3[156,ncol(pan_matrix_full3)] <- "Symbiotic2"
pan_matrix_full3[45,ncol(pan_matrix_full3)] <- "Symbiotic2"
pan_matrix_full3[53,ncol(pan_matrix_full3)] <- "Symbiotic3"
pan_matrix_full3[46:51,ncol(pan_matrix_full3)] <- "Symbiotic4"
pan_matrix_full3[157,ncol(pan_matrix_full3)] <- "Symbiotic4"
pan_matrix_full3[61,ncol(pan_matrix_full3)] <- "Symbiotic4"
pan_matrix_full3[151,ncol(pan_matrix_full3)] <- "Symbiotic4"
pan_matrix3.pca <- prcomp(pan_matrix_full3[,1:ncol(pan_matrix_full3)-1]) 
par(mfrow=c(1,1))
test <- autoplot(pan_matrix3.pca, data = pan_matrix_full3, colour = 'Sym_Cluster', 
                 xlim = c(-0.15,0.15), ylim = c(-0.25, 0.25), frame = TRUE, frame.type = 'norm')
svg(filename = 'pca_plot_3.svg')
autoplot(pan_matrix3.pca, data = pan_matrix_full3, colour = 'Sym_Cluster', 
         xlim = c(-0.15,0.15), ylim = c(-0.25, 0.25), frame = TRUE, frame.type = 'norm')
dev.off()

# Save
save.image("pangenome_summary_figures")

# Quit
quit("no")
