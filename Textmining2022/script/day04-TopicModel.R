library(tidyverse)
library(topicmodels)
library(tidytext)

tweet = read_csv("https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/tweet_save_monas.csv")
tweet$id = seq_along(1:nrow(tweet))
glimpse(tweet)

# 1. Pre-processing
tweet_token = tweet %>% 
  select(id, full_text_clean) %>% 
  unnest_tokens(kata, full_text_clean, token = "ngrams", n = 1, drop = FALSE)

tweet_token = tweet_token %>% 
  filter(!is.na(full_text_clean))

# document term matrix
tweet_dtm = tweet_token %>% 
  count(id, kata) %>% 
  cast_dtm(id, kata, n) %>% 
  as.matrix()

class(tweet_dtm)

?LDA

data_topik = LDA(x = tweet_dtm, k = 3, method = "VEM") %>% 
  tidy(matrix = "beta")
glimpse(data_topik)

data_topik %>% 
  group_by(topic) %>% 
  top_n(10, beta) %>% 
  ungroup() %>% 
  ggplot(aes(x = term, y = beta, fill = as.factor(topic))) +
  geom_col() +
  facet_grid(~topic, scales = "free_x") + 
  coord_flip()
