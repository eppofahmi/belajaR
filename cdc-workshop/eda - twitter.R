# Pelatihan Big Data Analysis
# Mining and Exploration of Twitter data
# Sumber data: di ambil dari API dengan package twitteR 
# pada tanggal 16 April 2018, jam 11:01 
# untuk latihan data bisa diunduh di https://bit.ly/2qz4D8b
# sumber twit:
# 1. yang memention akun @jokowi
# 2. yang memention akun @prabowo


#--------------- Memasukkan data -------------------------------------------------
dirwd <- paste(getwd(),"/cdc-workshop/",sep='')
raw_data <- read.csv(paste(dirwd,"latihan-cdc.csv",sep=''), 
                     header = TRUE, sep = ",", stringsAsFactors = FALSE)

#--------------- Rangkuman data --------------------------------------------------
library(skimr)
skimdata <- skim(raw_data)

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
  geom_histogram(position = "identity", show.legend = FALSE, binwidth = 1800) +
  facet_wrap(~person, ncol = 1)

# pada jam berapa orang biasanya memention dua akun ini?
median(raw_data$created) # 2018-04-16 00:36:15
mean(raw_data$created) # 2018-04-15 21:40:13

# dengan memisahkan satu kolom datetime menjadi dua kolom (date dan time) 
# bisa dilakukan dengan fungsi `separate()` dari tidyr
library(tidyr)
a <- raw_data %>%
  select(created) %>%
  separate(created, into = c("date", "time"), sep = " ")

str(a)

# mean dari kolom time saja 
format(mean(strptime(a$time, "%H:%M:%S")), "%H:%M:%S") # 07:43:00

# lubridate way
seconds_to_period(mean(period_to_seconds(hms(a$time))))

# modus or mode of time 
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# atau dengan package `tadaatoolbox` yang memiliki fungsi `modus()`
# devtools::install_github("tadaadata/tadaatoolbox")

library(tadaatoolbox)


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


# twit tentang apa yang paling diretweet? (ekplorasi 2)

#--------------- Ekplorasi 2 - Teks/Konten ---------------------------------------
library(stringr)
library(tidytext)


# 1. Frekuensi tagar - tagar apa yang paling sering digunakan?
# tagar dalam twitter selalu didahului oleh tanda '#' dalam data terletak pada
# kolom `text`

# Fungsi untuk mengabil tagar
tag_detect <- function(input_col) {
  hashtag <- str_extract_all(input_col, "#\\w+")
  # put tags in vector
  hashtag <- unlist(hashtag)
  # removing pic etc chr in the vector
  hashtag <- gsub("pic$", "", hashtag)
  hashtag <- gsub("http$", "", hashtag)
  hashtag <- gsub("https$", "", hashtag)
  hashtag <- tolower(hashtag)
  # calculate hashtag frequencies
  hashtag = table(hashtag)
  hashtag = as.data.frame(hashtag)
}

# pengambilan tagar step by step
f_1 <- raw_data %>%
  filter(person == "Jokowi")

f_2 <- tag_detect(f_1$text) %>%
  arrange(desc(Freq)) %>%
  head(n=10)

f_3 <- raw_data %>%
  filter(person == "Prabowo") 

f_4 <- tag_detect(f_3$text) %>%
  arrange(desc(Freq)) %>%
  head(n=10)

# visualiasi tagar
bind_rows(f_2 %>% 
            mutate(person = "Jokowi"),
          f_4 %>% 
            mutate(person = "Prabowo")) %>%
  ggplot(aes(reorder(hashtag, Freq), Freq, fill = person)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~person, scales = "free_y") +
  labs(y = "Jumlah retweet",
       x = NULL) +
  ggtitle("10 Tagar paling banyak digunakan") +
  coord_flip()

# 2. siapa yang paling sering mengirim twit?

raw_data$screenName <- paste("@", raw_data$screenName, sep="")

raw_data %>%
  group_by(person) %>%
  count(screenName, sort = TRUE) %>%
  filter(n >= 15) %>%
  ggplot(aes(reorder(screenName, n), n, fill = person)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~person, scales = "free_y") +
  labs(y = "Jumlah retweet",
       x = NULL) +
  ggtitle("Username minimal 15 unggahan twit dengan mention 2 akun") +
  coord_flip()
  
# 3. Frekuensi kata/term - kata apa yang paling sering digunakan?
library(stringi)

# checking character on text 
all(stri_enc_isutf8(raw_data$text))

clean_text <- raw_data %>%
  filter(isRetweet == FALSE) %>%
  select(created, text, person)

clean_text$text <- iconv(clean_text$text, from = "UTF-8", to="latin1")

# cleaning function
library(tm)

tweet_cleaner <- function(input_text) # nama kolom yang akan dibersihkan
{    
  # create a corpus (type of object expected by tm) and document term matrix
  corpusku <- Corpus(VectorSource(input_text)) # make a corpus object
  # remove urls1
  removeURL1 <- function(x) gsub("http[^[:space:]]*", "", x) 
  corpusku <- tm_map(corpusku, content_transformer(removeURL1))
  #remove urls3
  removeURL2 <- function(x) gsub("pic[^[:space:]]*", "", x) 
  corpusku <- tm_map(corpusku, content_transformer(removeURL2))
  # remove username
  TrimUsers <- function(x) {
    str_replace_all(x, '(@[[:alnum:]_]*)', '')
  }
  corpusku <- tm_map(corpusku, TrimUsers)
  #remove hashtags
  removehashtag <- function(x) gsub("#\\w+", "", x)
  corpusku <- tm_map(corpusku, content_transformer(removehashtag))
  #remove puntuation
  removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
  corpusku <- tm_map(corpusku, content_transformer(removeNumPunct))
  corpusku <- tm_map(corpusku, stripWhitespace)
  # tranform text to lower case
  corpusku <- tm_map(corpusku, content_transformer(tolower))
  #stopwords bahasa indonesia
  stopwords <- read.csv(paste(dirwd,"stopwords_indo.csv",sep=''), header = FALSE)
  stopwords <- as.character(stopwords$V1)
  stopwords <- c(stopwords, stopwords())
  corpusku <- tm_map(corpusku, removeWords, stopwords)
  #kata khusus yang dihapus
  corpusku <- tm_map(corpusku, removeWords, c("rt", "cc", "via", "r", "n", "dlm", "bang", "tau", "mas",
                                              "u", "zonkeduaubdedububf", "eduaubdedubu","mu","dah","gw",
                                              "zonkeduaubdedubu", "yu", "yth", "kau", "tuh","p","d","du",
                                              "yoo", "yoi", "yoiiik", "yng", "yesss", "eduaubdedubueduaubdedubu",
                                              "akueduaubdedubuc", "lu", "sih", "gue", "eduaubdedubueduaubdedubueduaubdedubu",
                                              "yaeduaubdedubueduaubdedubueduaubdedubueduaubdedubueduaubdedubutp", 
                                              "yaaeduaubdedubuceduaubdedubuc","ha","loh","yaa","bs","h",
                                              "yaaaakeduaubdedubueduaubdedubueduaubdedubueduaubdedubueduaubdedubueduaubdedubueduaubdedubueduaubdedubueduaubdedubu", 
                                              "y", "xxxbuat", "x", "xxiud", "xexx", "wuahahahhaeduaubdedubu","wowww", 
                                              "woow", "woiii", "wowww", "yaaau","eduaubdedubud","eh","oh",
                                              "eduaubdedubueduaubdedubueduaubdedubueduaubdedubu","iya",
                                              "ajaeduaubeedubua", "bro", "hahaha","g", "lg", "deh","ni", 
                                              "sm", "wkwmkwmw", "wkwkwkwkwkwkwkwkwkwkwk", "wkwkwk","w",
                                              "wkwkwkwkwkwkwkkkkkk", "eduaubeedubua", "vs", "wkwkwkwk"))
  corpusku <- tm_map(corpusku, stripWhitespace)
  #removing white space in the begining
  rem_spc_front <- function(x) gsub("^[[:space:]]+", "", x)
  corpusku <- tm_map(corpusku, content_transformer(rem_spc_front))
  #removing white space at the end
  rem_spc_back <- function(x) gsub("[[:space:]]+$", "", x)
  corpusku <- tm_map(corpusku, content_transformer(rem_spc_back))
  
  data <- data.frame(text=sapply(corpusku, identity),stringsAsFactors=F)
}

cleaned_text <- tweet_cleaner(clean_text$text)

# cek kata-kata setelah celaning
g <- cleaned_text %>%
  unnest_tokens(word, text) %>%
  count(word) %>%
  ungroup()
#View(g)

# jika dirasa udah bersih maka hasilnya bisa digabungkan

clean_text <- bind_cols(clean_text, clean = cleaned_text)
#View(clean_text)

clean_text <- clean_text %>%
  unnest_tokens(word, text1) %>%
  ungroup()

clean_text %>%
  group_by(person) %>%
  count(word, sort = TRUE) %>%
  arrange(desc(n)) %>%
  filter(n >= 15) %>%
  ggplot(aes(reorder(word, n), n, fill = person)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~person, scales = "free_y") +
  labs(y = "Jumlah retweet",
       x = NULL) +
  ggtitle("Username minimal 15 unggahan twit dengan mention 2 akun") +
  coord_flip()

# 4. Kata apa yang paling penting dalam dua sumber twit? (tf-idf)


# 5. Bagaimana hubungan antar kata di dalam dokumen? (semantic network)

