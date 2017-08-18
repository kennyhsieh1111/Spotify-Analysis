# 函式：調整 getFeatures 內 json1 輸出格式，以便高維處理
getFeatures_own <- function(spotify_ID,token){
  print(spotify_ID)
  req <- httr::GET(paste0("https://api.spotify.com/v1/audio-features/",spotify_ID), httr::config(token = token))
  json1<-data.frame(httr::content(req))
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
  Sys.sleep(0.1)
  return(dados)
}
