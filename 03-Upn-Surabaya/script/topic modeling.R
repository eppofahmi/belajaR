library(tidyverse)
library(tidytext)
library(topicmodels)


# ambil data ------
raw_data = read_csv("data/tweet_save_monas.csv")

raw_data = raw_data %>%
  select(id, full_text_clean) %>%
  group_by(id) %>%
  unnest_tokens(word, full_text_clean, token = "words")

raw_data = raw_data %>%
  filter(!is.na(word))

glimpse(raw_data)

# membuat DTM
tweet_dtm = raw_data %>%
  count(word, id) %>%
  cast_dtm(id, word, n) %>%
  as.matrix()

# menjalan LDA
?LDA

lda_topics <- tweet_dtm %>%
  LDA(k = 2,
      method = "Gibbs",
      control = list(seed = 123)
      ) %>%
  tidy(matrix = 'beta') # Tidy hasil

lda_topics %>%
  arrange(desc(beta))

word_prob <- lda_topics %>%
  group_by(topic) %>%
  top_n(15, beta) %>%
  ungroup() %>%
  mutate(term2 = fct_reorder(term, beta))
word_prob


# Interpretasi
word_prob %>%
  ggplot(aes(term2, beta, fill = as.factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~topic, scales = "free") +
  coord_flip()


## filter data based on topik mahoni dan pohon 
raw_data2 = read_csv("data/tweet_save_monas.csv")

# close reading -----
mahonidanpohon = raw_data2 %>% 
  filter(str_detect(full_text_clean, "mahoni|pohon"))
