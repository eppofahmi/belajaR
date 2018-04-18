# Pelatihan Big Data Analysis
# Mining and Exploration of Twitter data
# Sumber data: di ambil dari API dengan package twitteR 
# pada tanggal 16 April 2018, jam 11:01 
# untuk latihan data bisa diunduh di https://bit.ly/2qz4D8b
# sumber twit:
# 1. yang memention akun @jokowi
# 2. yang memention akun @prabowo


# A. Memasukkan data ----
dirwd <- paste(getwd(),"/cdc-workshop/",sep='')
raw_data <- read.csv(paste(dirwd,"latihan-cdc.csv",sep=''), 
                     header = TRUE, sep = ",", stringsAsFactors = FALSE)
# A.1. Preprocess ----
library(lubridate)
raw_data$created <- ymd_hms(raw_data$created)


# B. Eksplorasi data ----
library(skimr)
library(dplyr)
## B.1. Total data ----
skimdata <- skim(raw_data)
skimdata %>% dplyr::filter(variable=="favoriteCount")
skimdata %>% dplyr::filter(stat=="mean")
## B.2. Dibagi per subjek ----
jokowi_data <- raw_data[raw_data$person == 'Jokowi',]
prabowo_data <- raw_data[raw_data$person == 'Prabowo',]

skim(jokowi_data) %>% dplyr::filter(variable=="retweetCount")
skim(prabowo_data) %>% dplyr::filter(stat=="mean")


# C. Explorasi data visual ----
library(ggplot2)
## C.1. Histogram ----
ggplot(jokowi_data,aes(jokowi_data$retweetCount)) + 
  geom_histogram(breaks=seq(0, 5000, by=500)) +
  labs(title='Histogram jokowi',x='jumlah RT',y='frekuensi') +
  theme_minimal()
## C.2. Scatter plot ----
ggplot(prabowo_data,aes(x = log(prabowo_data$retweetCount), y = log(prabowo_data$favoriteCount))) +
  geom_point() +
  labs(title='Scatter plot prabowo',x='log jumlah RT',y='log jumlah favorit')
## C.3. Box plot ----
ggplot(raw_data,aes(x=raw_data$person,y=log(raw_data$retweetCount))) +
  geom_boxplot() +
  labs(title='Boxplot RT',x='Subjek',y='log jumlah RT') +
  ylim(0,10)


# D. Explorasi twit ----
## D.1. Jam berapa orang ngetwit ----
ggplot(raw_data,aes(raw_data$created)) +
  geom_histogram() +
  labs(title='Histogram waktu twit',x='Waktu',y='Frekuensi')
ggplot(jokowi_data,aes(jokowi_data$created)) +
  geom_histogram() +
  labs(title='Histogram waktu twit mention jokowi',x='Waktu',y='Frekuensi')
## D.2. Twit paling banyak di RT ----
# Agak beda karena konsep RT count berdasarkan twit asal
maxRTdata <- prabowo_data %>% 
  dplyr::select(retweetCount,screenName,text) %>%
  dplyr::arrange(desc(retweetCount)) %>%
  head(n=1)
## D.3. Twit paling banyak di favorite ----
maxFavdata <- raw_data %>% 
  dplyr::select(favoriteCount,screenName,text) %>%
  dplyr::arrange(desc(favoriteCount)) %>%
  head(n=10) 
ggplot(maxFavdata,aes(x=reorder(screenName,favoriteCount),y=favoriteCount)) +
  geom_col() +
  coord_flip() +
  labs(title='10 user dengan favorit terbanyak',x='jumlah favorit',y='nama')


# E. Explorasi teks twit ----
## E.1. Tagar ----
