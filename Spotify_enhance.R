# http://rcharlie.com/2017-02-16-fitteR-happieR/
# https://developer.spotify.com/web-api/get-playlists-tracks/
# https://github.com/tiagomendesdantas/Rspotify
# https://medium.com/towards-data-science/is-my-spotify-music-boring-an-analysis-involving-music-data-and-machine-learning-47550ae931de
# https://github.com/hlilje/songmood
rm(list = ls())

library('Rspotify')

# 函式：取得完整歌單歌曲 （針對超過 100 首的歌單，但受限為 600 首）
getAllSongs <- function(user, playlist, token) {
  idx <- 0
  songs <- getPlaylistSongs(user, playlist, idx, token)
  while(TRUE){
    idx <- idx + 1
    songs_tmp <- getPlaylistSongs(user, playlist, idx * 100, token)
    songs <- rbind(songs, songs_tmp)
    if(dim(songs_tmp)[1]  != 100 | dim(songs)[1] > 500){ break }
  }
  return(songs)
}


# 函式：取得歌曲的歌手、專輯名、圖片
getTrack<-function(id, token){
  req <- httr::GET(paste0("https://api.spotify.com/v1/tracks/",id), httr::config(token = token))
  json <- httr::content(req)
  
  artists <- json$artists[[1]]$name
  album <- json$album$name
  image_url <- json$album$images[[2]]$url
  listen <- json$external_urls$spotify
  
  print(c(id))
  track <- data.frame(id = id,artists = artists, album = album, image_url = image_url, listen_url = listen, stringsAsFactors = F)

  return(track)
}

# 函式：調整 getFeatures 內 json1 輸出格式，以便高維處理
getFeatures_own <- function(spotify_ID,token){
  req <- httr::GET(paste0("https://api.spotify.com/v1/audio-features/",spotify_ID), httr::config(token = token))
  json1<-data.frame(httr::content(req))
  print(class(json1))
  dados=data.frame(id=json1$id,
                   danceability=json1$danceability,
                   energy=json1$energy,
                   key=json1$key,
                   loudness=json1$loudness,
                   mode=json1$mode,
                   speechiness=json1$speechiness,
                   acousticness=json1$acousticness,
                   instrumentalness=json1$instrumentalness,
                   liveness=json1$liveness,
                   valence=json1$valence,
                   tempo=json1$tempo,
                   duration_ms=json1$duration_ms,
                   time_signature=json1$time_signature,
                   uri=json1$uri,
                   analysis_url=json1$analysis_url,stringsAsFactors = F)
  return(dados)
}

# 取得 Spotify 憑證
keys <- spotifyOAuth("Spotify Data Analysis","6ea6156a265e413a93ae7c5272e6b155","6db9315501b34f5e9c951b32aab81dee")

# 個人資訊
user <- getUser("1266145897", token = keys)

# 取得歌單
playlist <- getPlaylist(user$id, token = keys)

# 取得特定歌單內全部歌曲:songs
playlist_id <- playlist[which(playlist$name == "Singles"), "id"]
songs <- getAllSongs(user$id, playlist_id, keys) # 耗時

# 取得歌曲詳細資料:songs_feature # 卡住？？？
songs_pl_id <- songs$id

feature <- as.data.frame(do.call(rbind, Map(function(x){
  getFeatures1(songs_pl_id[x], keys)
}, 1:length(songs_pl_id))))

## 待處理 Jul 9
feature <- sapply(songs_pl_id, function(x) getFeatures1(x, keys))
feature <- as.data.frame(feature)
feature$id <- as.character(feature$id)
rownames(feature) <- seq(1, dim(feature)[1], by = 1)









####################################

# 合併歌單歌曲與歌曲詳細資料
library(dplyr)
songs <- left_join(songs, feature, by = "id", copy = F)
songs <- unique(songs)


# 刪除不必要的欄位，得到分析的資料:songs_analysis
songs_pl_name <- songs$tracks
songs_analysis <- subset(songs, select = -c(id, tracks, artist, artistId, album, uri, analysis_url))
songs_analysis[] <- lapply(songs_analysis, as.numeric)
songs_analysis$tracks <- songs_pl_name
songs_analysis <- songs_analysis[,c(15, 1:14)]

# 觀察資料
library(ggplot2)
str(songs_analysis)
summary(songs_analysis)

## Example(numeric):danceability
ggplot(songs_analysis, aes(x=danceability)) + geom_histogram(binwidth = 0.1, fill = "#17B3B7")
filter(songs_analysis, danceability > 0.8) %>% select(tracks, danceability)

## Example(factor): key
songs_analysis$key <- as.factor(songs_analysis$key)
ggplot(songs_analysis, aes(key)) + geom_bar(fill = "#17B3B7")

# 只取歌曲變數欄位:songs_features
songs_feature <- subset(songs_analysis, select = c('danceability', 'energy', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence'))

## 計算各變數平均值並繪出圖
playlist_mean <- data.frame(features = colnames(songs_feature), means = colMeans(songs_feature), row.names = NULL)
ggplot(data = playlist_mean, aes(x = reorder(features, -means), y = means)) + geom_bar(stat = 'identity', fill = "#17B3B7") + 
  ggtitle("Mean of Features") + xlab('features')

## 計算各變數標準差並繪出圖
library(matrixStats)
playlist_std <- data.frame(features = colnames(songs_feature), std = colSds(as.matrix(songs_feature)))
ggplot(data = playlist_std, aes(x = reorder(features, -std), y = std)) + geom_bar(stat = 'identity', fill = "#17B3B7") + 
  ggtitle("Std of Features") + xlab('features')
mean(playlist_std$std)

# Cluserting
## Kmeans : 直接找出最佳分群，結果為分兩群，分三群次之
library('factoextra')
library('NbClust')
set.seed(123)
opt_km <- NbClust(data = songs_feature, distance = "euclidean",
        min.nc = 2, max.nc = 15, method = "ward.D", index = "all")
opt_km$Best.nc    
opt_km$Best.partition
              
fviz_nbclust(opt_km) + theme_minimal()

### 觀察分兩群和分三群圖形:決定分兩群效果較好
model_km2 <- kmeans(songs_feature, 2, nstart = 15)
model_km3 <- kmeans(songs_feature, 3, nstart = 15)
fviz_cluster(model_km2, data = songs_feature, geom = "point",
             stand = FALSE, frame.type = "norm")
fviz_cluster(model_km3, data = songs_feature, geom = "point",
             stand = FALSE, frame.type = "norm")
km_cluster <- model_km2$cluster

## Hierarchical Clustering : Agglomerative:一樣決定分兩群
par(mfrow=c(1,1))
hier_distance <- dist(songs_feature, method = "euclidean")
model_hc <- hclust(hier_distance, method = "complete")
plot(model_hc, labels = F, hang = -1)
rect.hclust(model_hc, k = 2, border = 2:4)
hr_cluster <- cutree(model_hc, k = 2)

## 觀察 Kmeans 和 Hierarachy 分類差別，結果分群結果完全一樣
km_cluster %in% hr_cluster
songs_analysis$cluster <- km_cluster

## 試著將分群結果定標籤，畫出各欄位差異，cl_1 = Energy, cl_2 = Acoustic
library(reshape2)
model_km2$center
result_1 <- as.data.frame(model_km2$center)
result_1$cl <- factor(c("cl_1", "cl_2"), levels = c("cl_1", "cl_2"))
plot <- melt(result_1, id.vars="cl")
ggplot(plot, aes(variable, value, fill = cl)) + geom_bar(stat = 'identity', position = 'dodge')

filter(songs_analysis, cluster == 1) %>% select(tracks, acousticness, energy) %>% head()
filter(songs_analysis, cluster == 2) %>% select(tracks, acousticness, energy) %>% head()

songs_analysis$cluster <- ifelse(songs_analysis$cluster == '1', "Energy", "Acoustic")
table_cl <- table(songs_analysis$cluster)


# 亂畫圖
library(rAmCharts)
amPie(data.frame(label=names(table_cl), value=as.vector(table_cl)),
      inner_radius=50, depth=10, show_values=TRUE, legend=TRUE)

library(highcharter)
hchart(songs_show, "scatter", hcaes(x = energy, y = acousticness, group = cluster, tracks, artist, album, image_url)) %>%
  hc_add_theme(hc_theme_smpl()) %>%
  hc_title(text = "Kenny's Spotify Distribution") %>% 
  hc_colors(hex_to_rgba(c('#03BB4F','#4285D9'), alpha = 0.70)) %>%
  hc_legend(floating=T,align='left',verticalAlign='bottom') %>%
  hc_tooltip(headerFormat = "",valueDecimals=2,borderWidth=2,
             hideDelay=100,useHTML=T,padding=7,
             pointFormat="<img src='{point.image_url}', height = '100'>
                          <center>{point.tracks}<center>{point.artist}<br>{point.album}")

# 加入聆聽連結, 歌手名，專輯圖片
# 將歌曲分佈在四象限: 快慢，開心傷心
songs_pl_id <- songs$id[1:100]
tracks <- sapply(songs_pl_id, function(x) getTrack(x, keys))
tracks <- as.data.frame(t(tracks))
tracks$id <- as.character(tracks$id)
rownames(tracks) <- seq(1, dim(tracks)[1], by = 1)
songs_show <- left_join(songs, tracks, by = "id", copy = F)
songs_show$cluster <- songs_analysis$cluster

# save.image("SpotifyJun15_v2.Rdata")
