library(tidyverse)
library(tidytext)

tweet = read_csv("https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/tweet_save_monas.csv")
tweet$id = seq_along(1:nrow(tweet))
glimpse(tweet)

# kolom yang akan analisis -> full_text_clean 
leks_sentimen <- read.csv("https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/sentiwords_id.txt", sep = ":", header = FALSE)

colnames(leks_sentimen) = c("kata", "nilai")

# 1. Pre-processing
tweet_token = tweet %>% 
  select(id, full_text_clean) %>% 
  unnest_tokens(kata, full_text_clean, token = "ngrams", n = 1, drop = FALSE)

glimpse(tweet_token)
glimpse(leks_sentimen)

result = tweet_token %>% 
  left_join(leks_sentimen)

result$nilai[is.na(result$nilai)] = 0

result2 = result %>% 
  group_by(id, full_text_clean) %>% 
  summarise(nilai_sentimen_total = sum(nilai)) %>% 
  ungroup()

glimpse(result2)
summary(result2)

# jika kolom nilai == 0 ~ Netral
# jika kolom nilai > 0 ~ Positif
# jika kolom nilai < 0 negatif Positif

for (i in seq_along(1:nrow(result2))) {
  print(paste0("Baris ke-", i))
  if(result2$nilai_sentimen_total[i] == 0){
    result2$sentimen[i] = "Netral"
  } else if(result2$nilai_sentimen_total[i] > 0){
    result2$sentimen[i] = "Positif"
  } else{
    result2$sentimen[i] = "Negatif"
  }
}

result2 %>% 
  ungroup() %>% 
  count(sentimen)

library(echarts4r)

result2 %>% 
  ungroup() %>% 
  count(sentimen) %>% 
  e_charts(sentimen) %>% 
  e_pie(n) %>% 
  e_tooltip(trigger = "item")
