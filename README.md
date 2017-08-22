# Spotify Analysis
## Data Preprocessing
- _Aug 19_
- Retrieving songs' features through Spotify Developer API
- Solving the issue about maximum request (limit 100 per time) to API
- Prepare clean dataset for further usage 


## Exploratary Data Analysis
- _Aug 20_
- Choose own Spotify playlist - Singles, to implement analysis
- Observe the Mean & Std Value of tracks' features
- Create an equation to measure the boringness of playlist
> Boring Scores = Loudness + Tempo + (Danceability + Energy)*100
- Confirm there is no Linear Relation between Energy & Danceability

## Cluster & PCA
- _Aug 20_
- **Nbclust**, provides reference to decide how many Ccusters to divide (Opt : 2 clusters in this case)
- **PCA**, to reduce the dimensionality for plotting result
- Seems useless now, remain explained :(

## Sentiment Quandrant
- _Aug 21_
- xAxis = Valence, yAxis = Energy


## Next Step
- R Shiny Interface

## Reference
### Develop Package
-  [Spotify Developer API](https://developer.spotify.com/web-api/get-playlists-tracks/)
- [Rspotify](https://github.com/tiagomendesdantas/Rspotify)
- [SongMood: Lyric Sentiment Anaylsis](https://github.com/hlilje/songmood)
### Article
- [RCharlie : fitteR happieR](http://rcharlie.com/2017-02-16-fitteR-happieR/)
- [RCharlie : CoachellaR](http://rcharlie.com/2017-04-13-Coachella/)
- [An analysis involving music, data, and machine learning](https://medium.com/towards-data-science/is-my-spotify-music-boring-an-analysis-involving-music-data-and-machine-learning-47550ae931de)
