# Eksplorasi 1: User activity ----
# Pelatihan Big Data Analysis
# Mining and Exploration of Twitter data
# Sumber data: di ambil dari API dengan package twitteR 
# pada tanggal 16 April 2018, jam 11:01 
# untuk latihan data bisa diunduh di https://bit.ly/2qz4D8b
# sumber twit:
# 1. yang memention akun @jokowi
# 2. yang memention akun @prabowo


# A. Memasukkan data ----
setwd(paste(getwd(),"/cdc-workshop/",sep=''))
raw_data <- read.csv("latihan-cdc.csv", 
                     header = TRUE, sep = ",", stringsAsFactors = FALSE)
# A.1. Preprocess ----
library(lubridate)
raw_data$created <- ymd_hms(raw_data$created)


# B. Eksplorasi umum ----
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


# C. Explorasi visual ----
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
  labs(title='Boxplot RT',x='Subjek',y='log jumlah RT')