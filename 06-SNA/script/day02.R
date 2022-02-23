# skrip baru - sc = cmd+shift+n
?getwd()
getwd()

library(tidyverse)
library(tidytext)
library(igraph)

# 1. data 
dataMentah = read_csv(file = "https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/tweet_save_monas.csv")

# 2. Network (Butuh nodes dan hubungan abstrak antar nodes)
glimpse(dataMentah)

# NODES? username yang ada dikolom user_name dan full_text
# username? teks yang diawali oleh @
# EDGES (hubungan antar nodes) -> mention
# @suka011: "@WR_4AG226 #SaveMonasSaveJakarta ❤🇮🇩"

# pipe
dataMentahNetwork = dataMentah %>% 
  select(user_name, full_text) %>% 
  filter(!duplicated(full_text))

glimpse(dataMentahNetwork)

# cleansing
regex <- "(^|[^@\\w])@(\\w{1,15})\\b"
?grep

username_mention = str_extract_all(string = dataMentahNetwork$full_text, 
                pattern = regex, simplify = FALSE)

library(data.table)
username_mention = data.table::rbindlist(l = username_mention)
# paste0(username_mention[[2]], collapse = " ")

for (i in seq_along(1:length(username_mention))) {
  print(i)
  dataMentahNetwork$mention_username[i] = paste0(username_mention[[i]], collapse = " ")
}

# mempesiapkan data untuk network 
# adjacency
dataMentahNetwork = dataMentahNetwork %>% 
  tidytext::unnest_tokens(output = mention, 
                          input = mention_username, 
                          token = "ngrams", n = 1, 
                          to_lower = FALSE)

dataMentahNetwork = dataMentahNetwork %>% 
  select(-full_text) %>% 
  filter(!is.na(mention))

dataMentahNetwork$user_name = paste0("@", dataMentahNetwork$user_name)
dataMentahNetwork$mention = paste0("@", dataMentahNetwork$mention)
glimpse(dataMentahNetwork)
View(dataMentahNetwork)

# membuat network
sample_net = dataMentahNetwork %>% 
  count(user_name, mention)
glimpse(sample_net)
View(sample_net)

sample_net = sample_net %>% 
  filter(n >= 10)
glimpse(sample_net)
class(sample_net)

# membuat file/object graph
d_net = igraph::graph_from_data_frame(d = sample_net, 
                              directed = FALSE)

d_net
write_graph(graph = d_net, file = "data/hasil/sample_net.pajek", 
            format = "pajek")

plot(d_net)
