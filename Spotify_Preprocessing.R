#install.packages('Rspotify')
library('Rspotify')
source('Expansion.R')

# Retrieve the Oauth from Spotify
keys <- spotifyOAuth("Spotify Data Analysis","6ea6156a265e413a93ae7c5272e6b155","6db9315501b34f5e9c951b32aab81dee")

# Retrieve the Personal Basic Information
user <- getUser("1266145897", keys)

# Retrieve the Personal Playlist
playlist <- getPlaylist(user$id, token=keys)
playlist_id <- playlist[which(playlist$name == "Singles"), "id"]
playlist_len <- playlist[which(playlist$name == "Singles"), "tracks"]
## choosing the Singles to analysis in this case, due to it contains most of my favorite songs since I start using Spotify. 

# Retrieve the Songs in Playlist
## still don't know why there is always something wrong when retreiving idx 600-700 songs
songs_part1 <- as.data.frame(do.call(rbind, Map(function(x){
  getPlaylistSongs(user$id, playlist_id, offset=100*x+1, token=keys)
}, 0:5)))

songs_part2 <- as.data.frame(do.call(rbind, Map(function(x){
  getPlaylistSongs(user$id, playlist_id, offset=100*x+1, token=keys)
}, 7:10)))

songs <- rbind(songs_part1, songs_part2)
rm(songs_part1, songs_part2)

# Retrieve the Features of Songs
features_id <- songs$id
features <- as.data.frame(do.call(rbind, Map(function(x){
  getFeatures_own(features_id[x], token=keys)
}, 1:length(features_id))))

# Binding Songs & Features with id, remove repeat songs & useless variable
# Final Preprocessing 892 obs 
data <- merge(songs, features, by = "id")
data <- unique(data)
data <- data[, !(colnames(data) %in% c("artistId", "uri", "analysis_url"))]

# Aug 20
save.image('SongsData.RData')
