#!/usr/bin/env Rscript

setwd('Pangenome_calculation/Functional_analysis/')
library(data.table)

# Load the existing data
load("../Pangenome_overlap/pangenomeOverlapLists.RData")

# Get the core gene sets
common_core <- data.table(intersect(Clusters_Symbiotic_90, Clusters_Non_symbiotic_90))
ensifer_core <- data.table(setdiff(Clusters_Non_symbiotic_90,
                                   intersect(Clusters_Symbiotic_90, Clusters_Non_symbiotic_90)))
sinorhizobium_core <- data.table(setdiff(Clusters_Symbiotic_90,
                                         intersect(Clusters_Symbiotic_90, Clusters_Non_symbiotic_90)))

# Get the accessory gene sets
common_accessory <- data.table(setdiff(intersect(Clusters_Symbiotic_10, Clusters_Non_symbiotic_10),
                                       intersect(Clusters_Symbiotic_90, Clusters_Non_symbiotic_90)))
ensifer_accessory <- data.table(setdiff(Clusters_Non_symbiotic_10,
                                        intersect(Clusters_Symbiotic_10, Clusters_Non_symbiotic_10)))
sinorhizobium_accessory <- data.table(setdiff(Clusters_Symbiotic_10,
                                              intersect(Clusters_Symbiotic_10, Clusters_Non_symbiotic_10)))

# Take the clusters present in at least 1 strain of symbiotic strains
Clusters_Symbiotic_001 <- matrix(,1,1)
for (j in 1:nrow(Symbiont_list_original)) {
  if (sum(as.numeric(Symbiont_list_original[j,2:ncol(Symbiont_list_original)])) >= 1) {
    rowCluster <- Symbiont_list_original[j,1]
    Clusters_Symbiotic_001 <- rbind(Clusters_Symbiotic_001, as.matrix(rowCluster))
  }
}
Clusters_Symbiotic_001 <- Clusters_Symbiotic_001[2:nrow(Clusters_Symbiotic_001),1]

# Take the clusters present in at least 1 strains of non-symbiotic strains
Clusters_Non_symbiotic_001 <- matrix(,1,1)
for (j in 1:nrow(Non_symbiotic_list_original)) {
  if (sum(as.numeric(Non_symbiotic_list_original[j,2:ncol(Non_symbiotic_list_original)])) >= 1) {
    rowCluster <- Non_symbiotic_list_original[j,1]
    Clusters_Non_symbiotic_001 <- rbind(Clusters_Non_symbiotic_001, as.matrix(rowCluster))
  }
}
Clusters_Non_symbiotic_001 <- Clusters_Non_symbiotic_001[2:nrow(Clusters_Non_symbiotic_001),1]

# Get the unique core gene sets
ensifer_uniq_core <- data.table(setdiff(setdiff(Clusters_Non_symbiotic_90,
                                                intersect(Clusters_Symbiotic_90, Clusters_Non_symbiotic_90)),
                                        Clusters_Symbiotic_001))
sinorhizobium_uniq_core <- data.table(setdiff(setdiff(Clusters_Symbiotic_90,
                                                      intersect(Clusters_Symbiotic_90, Clusters_Non_symbiotic_90)),
                                              Clusters_Non_symbiotic_001))

# Export the files
write.table(common_core, 'common_core.txt', sep = '\t', row.names = F, col.names = F)
write.table(ensifer_core, 'ensifer_core.txt', sep = '\t', row.names = F, col.names = F)
write.table(sinorhizobium_core, 'sinorhizobium_core.txt', sep = '\t', row.names = F, col.names = F)
write.table(common_accessory, 'common_accessory.txt', sep = '\t', row.names = F, col.names = F)
write.table(ensifer_accessory, 'ensifer_accessory.txt', sep = '\t', row.names = F, col.names = F)
write.table(sinorhizobium_accessory, 'sinorhizobium_accessory.txt', sep = '\t', row.names = F, col.names = F)
write.table(ensifer_uniq_core, 'ensifer_uniq_core.txt', sep = '\t', row.names = F, col.names = F)
write.table(sinorhizobium_uniq_core, 'sinorhizobium_uniq_core.txt', sep = '\t', row.names = F, col.names = F)

# Save
save.image("makeLists.RData")

# Quit
quit("no")



