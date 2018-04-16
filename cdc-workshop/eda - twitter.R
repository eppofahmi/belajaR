# Pelatihan Big Data Analysis
# Mining and Exploration of Twitter data
# Sumber data: di ambil dari API dengan package twitteR 
# pada tanggal 16 April 2018, jam 11:01 
# untuk latihan data bisa diunduh di https://bit.ly/2qz4D8b
# sumber twit:
# 1. yang memention akun @jokowi
# 2. yang memention akun @prabowo


#--------------- Memasukkan data ---------------------
raw_data <- read.csv("latihan cdc.csv", 
                     header = TRUE, sep = ",", stringsAsFactors = FALSE)

#--------------- Rangkuman data --------------------------------------------------
library(skimr)
skim(raw_data)

#--------------- Ekplorasi 1 - Aktivitas -----------------------------------------
# Jenis aktivitas di Twitter
# 1. twit - berapa jumlah twit per hari/jam?
# 2. retweet - berapa jumlah retweet per hari/jam?
# 3. reply - berapa jumlah reply per hari/jam?
# 4. favorite - berapa jumlah favorite per hari/jam?

#--------------- Pre-processing --------------------------------------------------

str(raw_data)

library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)

# mengubah format tanggal dari character ke date
raw_data$created <- ymd_hms(raw_data$created)
str(raw_data)

# 1. twit - berapa jumlah twit per hari/jam? -------------------------------------
ggplot(raw_data, aes(x = created, fill = person)) +
  geom_histogram(position = "identity", bins = 20, show.legend = FALSE) +
  facet_wrap(~person, ncol = 1)

# 2. retweet - berapa jumlah retweet per hari/jam? -------------------------------


# 3. reply - berapa jumlah reply per hari/jam? -----------------------------------


# 4. favorite - berapa jumlah favorite per hari/jam? -----------------------------


#--------------- Ekplorasi 1 - Teks/Konten ---------------------------------------
# 1. Frekuensi tagar - tagar apa yang paling sering digunakan?
# 2. Frekuensi kata/term - kata apa yang paling sering digunakan?
# 3. Jumlah akun yang terlibat - akun siapa yang peling sering muncul?
# 4. Kata apa yang paling penting dalam dua sumber twit? (tf-idf)
# 5. Bagaimana hubungan antar kata di dalam dokumen?


