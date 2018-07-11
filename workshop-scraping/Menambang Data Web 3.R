# Menambang Data Web 2
# script ini digunakan untuk menambang data dari Twitter dengan menggunakan API basci


# Mendapatkan twit ----
library(twitteR) # mengambil data dari twitter
library(dplyr) # memanipulasi data
library(ggplot2) # visualisasi data
library(skimr) # melihat rangkuman data 
library(stringr) # text handling
library(tm) # text mining 
library(textclean) # cleaning

# Setting API ----
# yang dibutuhkan adalah: (1) Access Token; (2) Access Token Secret

options(httr_oauth_cache=T)
# ganti dengan kode dari Consumer Key (API Key)
api_key <- "pAFA3zX08uixfVtP4PMpcHas0"

# ganti dengan kode dari Consumer Secret (API Secret)
api_secret <- "FZfuzn055vuJgRFraq8KNAAWipsa0ugUEpIjWxuhOFH9Kd5HAm"

# ganti dengan kode Access Token
token <- "73705532-JApWQavtY5kkKbpRUGpDByEhHdLxb2HcKzAgtDZ7T"

# ganti dengan Access Token Secret
token_secret <- "2p2xuhlsMHVlbqDx8Swb7IkCAstwmCEMoINYreNmWxoCN"

# connecting to Twitter API
setup_twitter_oauth(api_key, api_secret, token, token_secret)

# Collecting tweets ----
raw_tweets <- searchTwitter("#2019gantipresiden", since = "2018-07-03", until = "2018-07-10", n = 1000)

# Transform tweets list into a data frame
raw_tweets <- twListToDF(raw_tweets)

summary(raw_tweets)
skim(raw_tweets)
