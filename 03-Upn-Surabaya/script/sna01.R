# SNA 1

# library -------
library(tidyverse)
library(tidytext)
library(igraph)

# Impor Data -------
tweet_save_monas <- read_csv("data/tweet_save_monas.csv")
glimpse(tweet_save_monas)

# Mendefinisikan nodes dan edges -------
# nodes = Username (diawali dengan @)
# nodes ini ada kolom: user_name dan full_text
# edges = mention (mention network)

raw_net = tweet_save_monas %>% 
  select(user_name, full_text)
glimpse(raw_net)

# target 1
# username      mention
# username1     username1a, username2a
# username2     username3

## Ekstrak nodes -------
user_inv <- as.character(raw_net$full_text)
user_inv <- sapply(str_extract_all(user_inv, "(@[[:alnum:]_]*)", simplify = FALSE), paste, collapse=", ")

user_inv <- tibble(user_inv)
View(user_inv)

raw_net$mention = user_inv$user_inv
glimpse(raw_net)
View(raw_net)

raw_net = raw_net %>% 
  mutate(strMention = str_count(mention))

glimpse(raw_net)
raw_net = raw_net %>% 
  filter(strMention != 0)
glimpse(raw_net)

## Adjacency List -------
raw_net = raw_net %>% 
  unnest_tokens(target, mention)

glimpse(raw_net)
View(raw_net)

raw_net = raw_net %>% 
  select(pengirimPost = user_name, termention = target)
glimpse(raw_net)
class(raw_net)

write_csv(raw_net, "file SNA/raw_sna.csv")

# hanya menggunakan 500 baris sebagai contoh
raw_net = sample_n(raw_net, 500)

# Membuat graph -------
## Membuat objek network 
# data_net = igraph::graph_from_data_frame(d = raw_net, directed = TRUE) # directed network
data_net = igraph::graph_from_data_frame(d = raw_net, directed = FALSE) # undirected network
class(data_net)

write_graph(graph = data_net, file = "file SNA/hasil_network.graphml", format = "graphml")

# Menambahkan atribut per nodes

## Menambahakn degree centr thd objek graph
V(data_net)$degree <- degree(data_net)

## Menambahkan eigen pada objek graph 
eigen_centrality = 
  eigen_centrality(data_net)
eigen_centrality = 
  data_frame(eigen_centrality = eigen_centrality[["vector"]])
eigen_centrality$eigen_centrality = 
  round(eigen_centrality$eigen_centrality, 2)

V(data_net)$eigen_centrality <- eigen_centrality$eigen_centrality

## Modularity class
wtc <- cluster_walktrap(data_net)
modularity(wtc)
modularity(data_net, membership(wtc))
member = data_frame(modularity_class = wtc$membership)

V(data_net)$modularity_class <- member$modularity_class

write_graph(graph = data_net, file = "file SNA/hasil_network.graphml", format = "graphml")


## Graph Ke Data Frame 
df_from_graph = as_long_data_frame(data_net)
glimpse(df_from_graph)

# Visualisasi -------