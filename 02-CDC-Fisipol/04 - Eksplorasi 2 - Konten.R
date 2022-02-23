# Eksplorasi 2: Konten ----
# Pelatihan Big Data Analysis
# Mining and Exploration of Twitter data
# Sumber data: di ambil dari API dengan package twitteR 
# pada tanggal 16 April 2018, jam 11:01 
# untuk latihan data bisa diunduh di https://bit.ly/2qz4D8b
# sumber twit:
# 1. yang memention akun @jokowi
# 2. yang memention akun @prabowo


# D. Explorasi user ----
## D.1. Siapa paling banyak kirim twit
usercount <- as.data.frame(table(raw_data$screenName)) %>%
  arrange(desc(Freq)) %>%
  head(n=10)
ggplot(usercount,aes(x=reorder(Var1,Freq),y=Freq)) +
  geom_col() +
  coord_flip() +
  labs(title='10 user dengan twit terbanyak',x='jumlah twit',y='nama')
## D.2. Jam berapa orang ngetwit ----
ggplot(prabowo_data,aes(prabowo_data$created)) +
  geom_histogram() +
  labs(title='Histogram waktu twit',x='Waktu',y='Frekuensi')
ggplot(jokowi_data,aes(jokowi_data$created)) +
  geom_histogram() +
  labs(title='Histogram waktu twit mention jokowi',x='Waktu',y='Frekuensi') +
  xlim(ymd_hms('2018-04-15 00:00:00'),ymd_hms('2018-04-16 06:00:00'))
## D.3. Twit paling banyak di RT ----
maxRTdata <- raw_data %>%
  filter(isRetweet==FALSE) %>%
  dplyr::select(retweetCount,screenName,text) %>%
  dplyr::arrange(desc(retweetCount)) %>%
  head(n=10)
ggplot(maxRTdata,aes(x=reorder(screenName,retweetCount),y=retweetCount)) +
  geom_col() +
  coord_flip() +
  labs(title='10 user dengan RT terbanyak',x='jumlah RT',y='nama')
## D.4. Twit paling banyak di favorite ----
maxFavdata <- raw_data %>% 
  dplyr::select(favoriteCount,screenName,text) %>%
  dplyr::arrange(desc(favoriteCount)) %>%
  head(n=10) 
ggplot(maxFavdata,aes(x=reorder(screenName,favoriteCount),y=favoriteCount)) +
  geom_col() +
  coord_flip() +
  labs(title='10 user dengan favorit terbanyak',x='jumlah favorit',y='nama')


# E. Explorasi teks twit ----
library(stringr)
## E.1. Tagar ----
# Fungsi untuk memgambil tagar
get_hashtag <- function(col_text){
  hashtag <- str_extract_all(col_text, "#\\w+")
  hashtag <- unlist(hashtag)
  hashtag <- tolower(hashtag)
  hashtag = table(hashtag)
  hashtag = as.data.frame(hashtag)
  return(hashtag)
}
# Tagar dengan frekuensi terbanyak
# Total
hashtag <- get_hashtag(raw_data$text) %>%
  arrange(desc(Freq)) %>%
  head(n=10)
ggplot(hashtag,aes(x=reorder(hashtag,Freq),y=Freq)) +
  geom_col() +
  coord_flip() +
  labs(title='10 tagar terbanyak',x='jumlah',y='tagar')
# Jokowi
hashtag_jkw <- get_hashtag(jokowi_data$text) %>%
  arrange(desc(Freq)) %>%
  head(n=10)
ggplot(hashtag_jkw,aes(x=reorder(hashtag,Freq),y=Freq)) +
  geom_col() +
  coord_flip() +
  labs(title='10 tagar terbanyak dan mention jokowi',x='jumlah',y='tagar')
# Prabowo
hashtag_pbw <- get_hashtag(prabowo_data$text) %>%
  arrange(desc(Freq)) %>%
  head(n=10)
ggplot(hashtag_pbw,aes(x=reorder(hashtag,Freq),y=Freq)) +
  geom_col() +
  coord_flip() +
  labs(title='10 tagar terbanyak dan mention prabowo',x='jumlah',y='tagar')
## E.2. Kata paling sering muncul ----
library(tidytext)
# Cleaning text
replace_reg <- "http://[A-Za-z]+|&amp;|&lt;|&gt;|RT|https|[@|#|pic]['_A-Za-z|[:punct:]|\\d]+"
unnest_reg <- "([^A-Za-z])+"
stopwords <- read.csv("stopwords_indo.csv", header = FALSE)
cltext <- raw_data %>%
  filter(isRetweet == FALSE) %>%
  select(text) %>%
  mutate(text = str_replace_all(text,replace_reg,"")) %>%
  unnest_tokens(word,text,token="regex",pattern=unnest_reg) %>%
  filter(!word %in% stopwords$V1,str_detect(word,"[a-z]")) %>%
  filter(nchar(word)>1) %>%
  filter(!word %in% c('ed','co','bd','ri'))
# Get frequncy
cltext <- as.data.frame(table(cltext$word)) %>%
  arrange(desc(Freq)) %>%
  head(n=10)
ggplot(cltext,aes(x=reorder(Var1,Freq),y=Freq)) +
  geom_col() +
  coord_flip() +
  labs(title='10 kata terbanyak',x='jumlah',y='kata')
