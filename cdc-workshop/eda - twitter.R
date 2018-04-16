# Pelatihan Big Data Analysis
# Mining and Exploration of Twitter data
# Sumber data: di ambil dari API dengan package twitteR 
# pada tanggal 16 April 2018, jam 11:01 
# untuk latihan data bisa diunduh di https://bit.ly/2qz4D8b
# sumber twit:
# 1. yang memention akun @jokowi
# 2. yang memention akun @prabowo


#--------------- Memasukkan data -------------------------------------------------
raw_data <- read.csv("latihan cdc.csv", 
                     header = TRUE, sep = ",", stringsAsFactors = FALSE)

#--------------- Rangkuman data --------------------------------------------------
library(skimr)
skim(raw_data)

#--------------- Ekplorasi 1 - Aktivitas -----------------------------------------
# Jenis aktivitas di Twitter
# 1. twit - bagaimana distribusi twit?, pada jam berapa oran biasanya ngetwit?
# 2. retweet - twit siapa yang paling banyak di retweet?
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

# 1. twit - bagaimana distribusi twit? -------------------------------------------

ggplot(raw_data, aes(x = created, fill = person)) +
  geom_histogram(position = "identity", bins = 20, show.legend = FALSE) +
  facet_wrap(~person, ncol = 1)

# pada jam berapa orang biasanya memention dua akun ini?
median(raw_data$created) # 2018-04-16 00:36:15
mean(raw_data$created) # 2018-04-15 21:40:13

# dengan memisahkan satu kolom datetime menjadi dua kolom (date dan time) 
# bisa dilakukan dengan fungsi `separate()` dari tidyr

a <- raw_data %>%
  select(created) %>%
  separate(created, into = c("date", "time"), sep = " ")

str(a)

# mean dari kolom time saja 
format(mean(strptime(a$time, "%H:%M:%S")), "%H:%M:%S") # 07:43:00

# lubridate way
seconds_to_period(mean(period_to_seconds(hms(a$time))))

# 2. retweet - twit siapa yang paling banyak di retweet? --------------------------

# ke #jokowi
b <- raw_data %>%
  select(screenName, retweetCount, person, text) %>%
  filter(person == "Jokowi") %>%
  arrange(desc(retweetCount)) %>%
  head(n=10)

# ke @prabowo
c <- raw_data %>%
  select(screenName, retweetCount, person, text) %>%
  filter(person == "Prabowo") %>%
  arrange(desc(retweetCount)) %>%
  head(n=10)

# visualisasi
bind_rows(b, c) %>%
  ggplot(aes(reorder(screenName, retweetCount), retweetCount, fill = person)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~person, scales = "free_y") +
  labs(y = "Jumlah retweet",
       x = NULL) +
  ggtitle("10 username yang twitnya paling banyak retweet") +
  coord_flip()

# jika dilihat isi twitnya, twit yang paling banyak di RT adalah twit yang di unggah
# dua akun yang menjadi sampel dan kemudian RT lagi oleh username lain. Bandingkan 
# dengan hasil di bawah ini.

# ke #jokowi
d <- raw_data %>%
  filter(isRetweet == FALSE) %>%
  select(screenName, retweetCount, person, text) %>%
  filter(person == "Jokowi") %>%
  arrange(desc(retweetCount)) %>%
  head(n=10)

# ke @prabowo
e <- raw_data %>%
  filter(isRetweet == FALSE) %>%
  select(screenName, retweetCount, person, text) %>%
  filter(person == "Prabowo") %>%
  arrange(desc(retweetCount)) %>%
  head(n=10)

# visualisasi
bind_rows(d, e) %>%
  ggplot(aes(reorder(screenName, retweetCount), retweetCount, fill = person)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~person, scales = "free_y") +
  labs(y = "Jumlah retweet",
       x = NULL) +
  ggtitle("10 username yang twitnya paling banyak retweet") +
  coord_flip()


# twit tentang apa yang paling diretweet? 



#--------------- Ekplorasi 1 - Teks/Konten ---------------------------------------
# 1. Frekuensi tagar - tagar apa yang paling sering digunakan?
# 2. Frekuensi kata/term - kata apa yang paling sering digunakan?
# 3. Jumlah akun yang terlibat - akun siapa yang peling sering muncul?
# 4. Kata apa yang paling penting dalam dua sumber twit? (tf-idf)
# 5. Bagaimana hubungan antar kata di dalam dokumen?