# Load the Songs Features Data
load('SongsData.RData')

# Clustering
# Preprocessing before kmeans (Normalization)
feature_data <- data[, c(6,7,9,11:17)]
feature_data <- data.frame(scale(feature_data, center = TRUE, scale = TRUE))

# NbClust, provides ref to decide how many clusters to divide
library('factoextra')
library('NbClust')
set.seed(123)
opt_km <- NbClust(data = feature_data, distance = "manhattan",
                  min.nc = 2, max.nc = 15, method = "ward.D", index = "all")
opt_km$Best.nc    
opt_km$Best.partition
fviz_nbclust(opt_km) + theme_minimal()
## It shows that 2 clusters is optimal number 

km_clus <- kmeans(feature_data, 2, iter.max = 10, nstart = 15)
fviz_cluster(km_clus, data = feature_data, geom = "point",
             stand = FALSE, main = "Kmeans - 2 Clusters", frame.type = "norm")
km_clus <- km_clus$cluster

