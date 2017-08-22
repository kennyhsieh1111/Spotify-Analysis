setwd('~/Documents/Spotify')
load('SongsData.RData')

library(highcharter)
library(dplyr)

#quick produce mess
fq_data <- data[, c(2,7,15)]

hchart(fq_data, "scatter", hcaes(x = valence, y = energy)) %>%
  hc_xAxis(title = list(text = 'Valence'),
           plotLines = list(list(value = 0.5, color = 'grey', width = 2, zIndex = 5)),
           max = 1) %>%
  hc_yAxis(title = list(text = 'Energy'),
           plotLines = list(list(value = 0.5, color = 'grey', width = 2, zIndex = 5)), 
           max = 1) %>%
  hc_tooltip(headerFormat = "", valueDecimals=2, borderWidth=2,
             hideDelay=100, useHTML=T, padding=10,
             pointFormat="<b>{point.tracks}</b><br><b>Valence :</b> {point.valence}<br><b>Energy :</b> {point.energy}") %>%
  hc_title(text = "Track Sentiment Quadrant") %>%
  hc_add_theme(hc_theme_db())

