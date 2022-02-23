library(rvest)
library(tidyverse)

# 1. Unduh HTML
page_raw = read_html(x = "https://onlinelibrary.wiley.com/action/doSearch?AllField=disaster+risk+management&Ppub=%5B20220208+TO+20220215%5D&startPage=&PubType=journal")

# html tag
# .visitable

df1 = page_raw %>% 
  html_nodes(".visitable") %>% 
  html_text()

df1 = tibble(judul = df1)

# .comma

df2 = page_raw %>% 
  html_nodes(".comma") %>% 
  html_text()

df2 = tibble(penulis = df2)
df0 = bind_cols(df1, df2)

page1 = read_html("https://search.kompas.com/search?q=kompas.com")


df3 = page_raw %>% 
  html_nodes(".visitable") %>% 
  html_attr("href")
df3 = tibble(link = df3)

df3$link = paste0("https://onlinelibrary.wiley.com", df3$link)

df0 = bind_cols(df0, df3)
write_csv(x = df0, "datamentah/jurnal.csv")
