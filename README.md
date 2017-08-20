# Spotify Analysis
## Data Preprocessing
- _Aug 19_
- Retrieving Songs' Features through Spotify Developer API
- Solving the Issue about Maximum Request (limit 100 per time) to API
- Prepare Clean Dataset for further Usage 


## Exploratary Data Analysis
- _Aug 20_
- Choose Own Spotify Playlist - Singles, to Implement Analysis
- Observe the Mean & Std Value of Tracks' Features
- Create an Equation to Measure the boringness of playlist
> Boring Scores = Lsoudness + Tempo + (Danceability + Energy)*100
- Confirm there is no Linear Relation between Energy & Danceability

## Cluster & PCA
- _Aug 20_
- **Nbclust**, provides Ref to Decide how many Clusters to Divide (Opt : 2 clusters in this case)
- **PCA**, to reduce the dimensionality for plotting result
- Seems useless now, remain explained :(

## Sentiment Quandrant
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
