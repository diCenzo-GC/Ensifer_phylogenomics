#!/usr/bin/env Rscript

setwd('Pangenome_calculation/Pangenome_overlap/')
library(data.table)
library(VennDiagram)
library(polyclip)

# Take the Symbiotic and Non Symbiotic list
Symbiont_list <- read.table('Symbiotic_transposed.txt', header = T, sep = '\t')
Non_symbiotic_list <- read.table('Non_symbiotic_transposed.txt', header = T, sep = '\t')

# Transpose function
tdt <- function(inpdt){
  transposed <- t(inpdt[,-1]);
  colnames(transposed) <- inpdt[[1]];
  transposed <- data.table(transposed, keep.rownames=T);
  setnames(transposed, 1, names(inpdt)[1]);
  return(transposed);
}

# Transpose the lists
Symbiont_list_original <- tdt(Symbiont_list)
Non_symbiotic_list_original <- tdt(Non_symbiotic_list)

# Take the clusters present in 90% of symbiotic strains
Clusters_Symbiotic_90 <- matrix(,1,1)
for (j in 1:nrow(Symbiont_list_original)) {
  if (sum(as.numeric(Symbiont_list_original[j,2:ncol(Symbiont_list_original)])) >= 0.90 * (ncol(Symbiont_list_original)-1)) {
    rowCluster <- Symbiont_list_original[j,1]
    Clusters_Symbiotic_90 <- rbind(Clusters_Symbiotic_90, as.matrix(rowCluster))
  }
}
Clusters_Symbiotic_90 <- Clusters_Symbiotic_90[2:nrow(Clusters_Symbiotic_90),1]

# Take the clusters present in 90% of non-symbiotic strains
Clusters_Non_symbiotic_90 <- matrix(,1,1)
for (j in 1:nrow(Non_symbiotic_list_original)) {
  if (sum(as.numeric(Non_symbiotic_list_original[j,2:ncol(Non_symbiotic_list_original)])) >= 0.90 * (ncol(Non_symbiotic_list_original)-1)) {
    rowCluster <- Non_symbiotic_list_original[j,1]
    Clusters_Non_symbiotic_90 <- rbind(Clusters_Non_symbiotic_90, as.matrix(rowCluster))
  }
}
Clusters_Non_symbiotic_90 <- Clusters_Non_symbiotic_90[2:nrow(Clusters_Non_symbiotic_90),1]

# Take the clusters present in at least 2 strain of symbiotic strains
Clusters_Symbiotic_001 <- matrix(,1,1)
for (j in 1:nrow(Symbiont_list_original)) {
  if (sum(as.numeric(Symbiont_list_original[j,2:ncol(Symbiont_list_original)])) >= 2) {
      rowCluster <- Symbiont_list_original[j,1]
      Clusters_Symbiotic_001 <- rbind(Clusters_Symbiotic_001, as.matrix(rowCluster))
    }
  }
Clusters_Symbiotic_001 <- Clusters_Symbiotic_001[2:nrow(Clusters_Symbiotic_001),1]

# Take the clusters present in at least 2 strains of non-symbiotic strains
Clusters_Non_symbiotic_001 <- matrix(,1,1)
for (j in 1:nrow(Non_symbiotic_list_original)) {
  if (sum(as.numeric(Non_symbiotic_list_original[j,2:ncol(Non_symbiotic_list_original)])) >= 2) {
      rowCluster <- Non_symbiotic_list_original[j,1]
      Clusters_Non_symbiotic_001 <- rbind(Clusters_Non_symbiotic_001, as.matrix(rowCluster))
    }
  }
Clusters_Non_symbiotic_001 <- Clusters_Non_symbiotic_001[2:nrow(Clusters_Non_symbiotic_001),1]

# Take the clusters present in at least 10% of strains of symbiotic strains
Clusters_Symbiotic_10 <- matrix(,1,1)
for (j in 1:nrow(Symbiont_list_original)) {
  if (sum(as.numeric(Symbiont_list_original[j,2:ncol(Symbiont_list_original)])) >= 0.10 * (ncol(Symbiont_list_original)-1)) {
      rowCluster <- Symbiont_list_original[j,1]
      Clusters_Symbiotic_10 <- rbind(Clusters_Symbiotic_10, as.matrix(rowCluster))
    }
  }
Clusters_Symbiotic_10 <- Clusters_Symbiotic_10[2:nrow(Clusters_Symbiotic_10),1]

# Take the clusters present in at least 10% of strains of non-symbiotic strains
Clusters_Non_symbiotic_10 <- matrix(,1,1)
for (j in 1:nrow(Non_symbiotic_list_original)) {
  if (sum(as.numeric(Non_symbiotic_list_original[j,2:ncol(Non_symbiotic_list_original)])) >= 0.10 * (ncol(Non_symbiotic_list_original)-1)) {
      rowCluster <- Non_symbiotic_list_original[j,1]
      Clusters_Non_symbiotic_10 <- rbind(Clusters_Non_symbiotic_10, as.matrix(rowCluster))
    }
  }
Clusters_Non_symbiotic_10 <- Clusters_Non_symbiotic_10[2:nrow(Clusters_Non_symbiotic_10),1]

# Get values for the Venn Diagrams
Core_genome_overlap <- length(intersect(Clusters_Symbiotic_90, Clusters_Non_symbiotic_90))
Core_genome_symbiotic <- length(Clusters_Symbiotic_90)
Core_genome_nonsymbiotic <- length(Clusters_Non_symbiotic_90)
Accessory_genome_overlap <- length(intersect(Clusters_Symbiotic_001, Clusters_Non_symbiotic_001))
Accessory_genome_symbiotic <- length(Clusters_Symbiotic_001)
Accessory_genome_nonsymbiotic <- length(Clusters_Non_symbiotic_001)
Accessory2_genome_overlap <- length(intersect(Clusters_Symbiotic_10, Clusters_Non_symbiotic_10))
Accessory2_genome_symbiotic <- length(Clusters_Symbiotic_10)
Accessory2_genome_nonsymbiotic <- length(Clusters_Non_symbiotic_10)

# Make the core genome plot
grid.newpage()
vp <- draw.pairwise.venn(area1 = Core_genome_symbiotic, area2 = Core_genome_nonsymbiotic, 
                         cross.area = Core_genome_overlap, category = c('Symbiotic', 'Non-symbiotic'), 
                         fill = c("red", "white"))
A <- list(list(x = as.vector(vp[[3]][[1]]), y = as.vector(vp[[3]][[2]])))
B <- list(list(x = as.vector(vp[[4]][[1]]), y = as.vector(vp[[4]][[2]])))
AintB <- polyclip(A, B)
ix <- sapply(vp, function(x) grepl("text", x$name, fixed = TRUE))
labs <- do.call(rbind.data.frame, lapply(vp[ix], `[`, c("x", "y", "label")))
svg(filename = "core_genome_overlap.svg")
plot(c(0, 1), c(0, 1), type = "n", axes = FALSE, xlab = "", ylab = "")
polygon(A[[1]], col="light blue")
polygon(B[[1]], col="pink")
polygon(AintB[[1]], col = "light yellow")
text(x = labs$x, y = labs$y, labels = labs$label)
dev.off()

# Make the full acessory genome plot
grid.newpage()
vp <- draw.pairwise.venn(area1 = Accessory_genome_symbiotic, area2 = Accessory_genome_nonsymbiotic, 
                         cross.area = Accessory_genome_overlap, category = c('Symbiotic', 'Non-symbiotic'), 
                         fill = c("red", "white"))
A <- list(list(x = as.vector(vp[[3]][[1]]), y = as.vector(vp[[3]][[2]])))
B <- list(list(x = as.vector(vp[[4]][[1]]), y = as.vector(vp[[4]][[2]])))
AintB <- polyclip(A, B)
ix <- sapply(vp, function(x) grepl("text", x$name, fixed = TRUE))
labs <- do.call(rbind.data.frame, lapply(vp[ix], `[`, c("x", "y", "label")))
svg(filename = "accessory_genome_overlap_2.svg")
plot(c(0, 1), c(0, 1), type = "n", axes = FALSE, xlab = "", ylab = "")
polygon(A[[1]], col="light blue")
polygon(B[[1]], col="pink")
polygon(AintB[[1]], col = "light yellow")
text(x = labs$x, y = labs$y, labels = labs$label)
dev.off()

# Make the sub acessory genome plot
grid.newpage()
vp <- draw.pairwise.venn(area1 = Accessory2_genome_symbiotic-2130, area2 = Accessory2_genome_nonsymbiotic-2130, 
                         cross.area = Accessory2_genome_overlap-2130, category = c('Symbiotic', 'Non-symbiotic'), 
                         fill = c("red", "white"))
A <- list(list(x = as.vector(vp[[3]][[1]]), y = as.vector(vp[[3]][[2]])))
B <- list(list(x = as.vector(vp[[4]][[1]]), y = as.vector(vp[[4]][[2]])))
AintB <- polyclip(A, B)
ix <- sapply(vp, function(x) grepl("text", x$name, fixed = TRUE))
labs <- do.call(rbind.data.frame, lapply(vp[ix], `[`, c("x", "y", "label")))
svg(filename = "accessory_genome_overlap_10.svg")
plot(c(0, 1), c(0, 1), type = "n", axes = FALSE, xlab = "", ylab = "")
polygon(A[[1]], col="light blue")
polygon(B[[1]], col="pink")
polygon(AintB[[1]], col = "light yellow")
text(x = labs$x, y = labs$y, labels = labs$label)
dev.off()

# Save
save.image("pangenomeOverlapLists.RData")

# Quit
quit("no")

