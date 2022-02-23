library(tidyverse)
library(tidytext)

# data impor ------
## data mentah
tweet = read_csv("data/tweet_save_monas.csv")
glimpse(tweet)

## leksikon 
leksikon_id = read.table("data/sentiwords_id.txt", header = FALSE, sep = ":")
colnames(leksikon_id) = c("kata", "nilai")
leksikon_id$kata = as.character(leksikon_id$kata)
glimpse(leksikon_id)

# preprocessing ------
# pilih kolom yang akan di analisis id 
tweet_analisis = tweet %>% 
  select(id, full_text_clean)
glimpse(tweet_analisis)

# tokenisasi ------
tweet_token = tweet_analisis %>% 
  unnest_tokens(kata, teks_bersih) %>% 
  count(id, kata, sort =TRUE)
glimpse(tweet_token)

# join data ------
# kita gabungan data tweet_token dengan data leksikon_id, berdasarkan kolom kata
hasil1 = tweet_token %>% 
  left_join(leksikon_id)

hasil1$nilai[is.na(hasil1$nilai)] = 0 

glimpse(hasil1)
View(hasil1)

# kalkulasi ------
hasil2 = hasil1 %>% 
  group_by(id) %>% 
  summarise(nilai_sentimen = sum(nilai))

hasil3 = tweet %>% 
  select(id, full_text)

hasil3$teks_bersih = teks_clean$clean_text
glimpse(hasil3)

hasil3 = hasil3 %>% 
  left_join(hasil2)

glimpse(hasil3)
View(hasil3)

# menambahkan label positif, negatif, dan netral 
# positif = nilai_sentimen > 0
# negatif = nilai_sentimen < 0
# netral = nilai_sentimen == 0

hasil3 = hasil3 %>% 
  mutate(label_sentimen = case_when(
    nilai_sentimen > 0 ~ "positif",
    nilai_sentimen < 0 ~ "negatif", 
    TRUE ~ "netral"
  ))

glimpse(hasil3)
View(hasil3)

# visualisasi ------
porsi = hasil3 %>% 
  count(label_sentimen)

porsi = porsi %>% 
  mutate(total = sum(n))

porsi = porsi %>% 
  mutate(persen = n/total * 100)

library(echarts4r)

porsi %>% 
  e_charts(label_sentimen) %>%  
  e_pie(persen) %>%
  e_tooltip(trigger = "item")
  # e_title("Porsi Sentimen Twit Save Monas")
