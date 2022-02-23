library(tidyverse)

# https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/tweet_save_monas.csv

tweet = read_csv("https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/tweet_save_monas.csv")

glimpse(tweet)

# memilih kolom
# shortcut -> pipe = ctr/cmd+shift+m
selected_tweet = tweet %>%
  select(created_at, user_name, full_text)
rm(selected_tweet)

selected_tweet = tweet[,c(4, 8, 11)]
glimpse(selected_tweet)

selected_tweet = tweet %>%
  select(created_at:full_text)
selected_tweet = tweet[,c(4:11)]

# memilih baris
economics = economics
glimpse(economics)

# ymd = year month day
filtered_economics = economics %>%
  filter(date >= "1969-01-01")

filtered_economics = economics %>%
  filter(date >= "1969-01-01" & date <= "1970-12-31")

# membuat kolom baru
?mutate()

filtered_economics = filtered_economics %>% 
  mutate(jumlah = psavert + uempmed)

selected_tweet = selected_tweet %>% 
  mutate(sentimen_username = paste(user_name, "->", text_sentiment))

mostactive_username = tweet %>% 
  count(user_name, sort = TRUE)

# tokenisasi 
library(tidytext)

tokened_tweet = tweet %>% 
  filter(!is.na(full_text_clean)) %>% 
  select(id, user_name, full_text, full_text_clean) %>% 
  unnest_tokens(output = kata, input = full_text_clean, 
                token = "ngrams", n = 1)

# == sama dengan
# != tidak sama dengan

tokened_tweet %>% 
  count(kata, sort = TRUE)

stopwords_id = read_csv("https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/stopwords_id.csv", col_names = FALSE)

stopwords_id = stopwords_id %>% 
  rename(words = X1)

wordCount = tokened_tweet %>% 
  filter(!kata %in% stopwords_id$words) %>% 
  count(kata, sort = TRUE)

wordCount %>% 
  head(20) %>% 
  ggplot(aes(x = reorder(kata, n), y = n)) + 
  geom_col() + 
  coord_flip() +
  labs(title = "Kata paling banyak digunakan dalam twit", 
       subtitle = "Twit dengan kata kunci Monas", 
       x = "Kata", y = "Jumlah")

ggsave(filename = "plot/jumlahkata.png", width = 18, height = 9, 
       units = "cm", dpi = 600)

# regex
?gsub()
tokened_tweet$kata = gsub(pattern = "yg", replacement = "yang", 
                          x = tokened_tweet$kata)
tokened_tweet$kata = gsub(pattern = "gak", replacement = "tidak", 
                          x = tokened_tweet$kata)
tokened_tweet$kata = gsub(pattern = "tdk", replacement = "tidak", 
                          x = tokened_tweet$kata)
tokened_tweet$kata = gsub(pattern = "jg", replacement = "juga", 
                          x = tokened_tweet$kata)
tokened_tweet$kata = gsub(pattern = "jga", replacement = "juga", 
                          x = tokened_tweet$kata)
tokened_tweet$kata = gsub(pattern = "jgn", replacement = "jangan", 
                          x = tokened_tweet$kata)

wordCount = tokened_tweet %>% 
  filter(!kata %in% c("indonesia", "dki", "untuk", 'nya', "jadi")) %>% 
  filter(!kata %in% stopwords_id$words) %>% 
  count(kata, sort = TRUE)

?str_count()

wordCount %>% 
  filter(str_count(kata) >= 4) %>% 
  head(20) %>% 
  ggplot(aes(x = reorder(kata, n), y = n)) + 
  geom_col() + 
  coord_flip() +
  labs(title = "Kata paling banyak digunakan dalam twit", 
       subtitle = "Twit dengan kata kunci Monas", 
       x = "Kata", y = "Jumlah")

# cleansing
?tolower()
?toupper()

tweet$full_text_norm = toupper(tweet$full_text_norm)
tweet$full_text_norm = tolower(tweet$full_text_norm)
glimpse(tweet)

data_mentah = tweet %>% 
  select(user_name, full_text)
glimpse(data_mentah)

library(textclean)

data_mentah$text_bersih = textclean::replace_html(data_mentah$full_text)
data_mentah$text_bersih <- gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "",
                                data_mentah$full_text)

data_mentah$text_bersih <- gsub("(^|[^@\\w])@(\\w{1,15})\\b", "",
                                data_mentah$text_bersih)
data_mentah$text_bersih <- gsub("#\\S+", "",
                                data_mentah$text_bersih)
data_mentah$text_bersih <- gsub("@\\S+", "",
                                data_mentah$text_bersih)
data_mentah$text_bersih <- gsub("[[:punct:]]", "",
                                data_mentah$text_bersih)

data_mentah = data_mentah %>% 
  filter(!duplicated(text_bersih))

data_mentah$text_bersih = tolower(data_mentah$text_bersih)
data_mentah$text_bersih = textclean::replace_white(data_mentah$text_bersih)
data_mentah$text_bersih = str_trim(string = data_mentah$text_bersih, 
                                   side = "both")

data_mentah$text_bersih = gsub("gak", "tidak", data_mentah$text_bersih)

data_mentah_token = data_mentah %>% 
  filter(!is.na(text_bersih)) %>% 
  select(user_name, text_bersih) %>% 
  unnest_tokens(output = kata, input = text_bersih, 
                token = "ngrams", n = 2, drop = TRUE)

data_mentah_token = data_mentah_token %>% 
  count(kata, sort = TRUE) %>% 
  filter(n >= 7)

data_mentah_token = data_mentah_token %>% 
  separate(col = kata, into = c("kata1", "kata2"), sep = " ") %>% 
  filter(!is.na(kata1))

library(igraph)
network_kata = data_mentah_token %>% 
  graph_from_data_frame()

class(network_kata)
plot(network_kata)

library(ggraph)
?ggraph()
ggraph(graph = network_kata, layout = "fr") + 
  geom_edge_link() + 
  geom_node_point() + 
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)
