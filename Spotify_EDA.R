# Load the Songs Features Data
load('SongsData.RData')

# Exploratary Data Analysis
summary(data)

# Observe the features of songs
# Average
features <- data[, c(6,7,11:15)]
features_mean <- data.frame(features = colnames(features), means = colMeans(features), row.names = NULL)
ggplot(data = features_mean, aes(x = reorder(features, -means), y = means)) + geom_bar(stat = 'identity', fill = "#17B3B7") + 
  ggtitle("Mean value of the song features of Singles") + xlab('features')

# Variety
features_std <- data.frame(features = colnames(features), std = sapply(features, sd), row.names = NULL)
ggplot(data = features_std, aes(x = reorder(features, -std), y = std)) + geom_bar(stat = 'identity', fill = "#17B3B7") + 
  ggtitle("Std value of the song features of Singles") + xlab('features')
mean(features_std[,2]); sum(features_std[,2])

# Boring Equation = loudness + tempo + (energy*100) + (danceability*100)
## The lowest the score is, the more boring the song is.
boring <- data[, c(6,7,9,16)]
boring['score'] <- (boring[1] + boring[2])*100 + boring[3] + boring[4]
ggplot(data = boring, aes(score)) + geom_histogram(fill = "#17B3B7")
mean(boring[, 5])
