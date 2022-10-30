library(tidyverse)
library(tidytext)
library(igraph)

# 1. data ----
dataMentah = read_csv(file = "https://raw.githubusercontent.com/eppofahmi/belajaR/master/99-BankData/tweet_save_monas.csv")

# 2. data username dengan username ----
dataMentahNetwork1 = dataMentah %>% 
  select(user_name, full_text) %>% 
  filter(!duplicated(full_text))

glimpse(dataMentahNetwork1)

# mengekstrak username dari full_text
regex <- "@\\S+"
username_mention = str_extract_all(string = dataMentahNetwork1$full_text, 
                                pattern = regex, simplify = FALSE)
str(username_mention)

paste0(username_mention[[2]], collapse = " ")

for (i in seq_along(1:length(username_mention))) {
  print(i)
  dataMentahNetwork1$mention[i] = paste0(username_mention[[i]], collapse = " ")
}

# tokenisasi ----
dataMentahNetwork1 = dataMentahNetwork1 %>% 
  tidytext::unnest_tokens(output = mention, 
                          input = mention, 
                          token = "ngrams", n = 1, 
                          to_lower = FALSE)
glimpse(dataMentahNetwork1)

# dataMentahNetwork$mention = tolower(dataMentahNetwork$mention)

dataMentahNetwork1 = dataMentahNetwork1 %>% 
  select(-full_text) %>% 
  filter(!is.na(mention))

mentiondiri_sendiri = dataMentahNetwork1 %>% 
  filter(user_name == mention)
  
glimpse(dataMentahNetwork1)

write_csv(dataMentahNetwork1, 
          "06-SNA/data/hasil/tes_network1.csv")
