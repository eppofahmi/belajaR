# centrality dan visualisasi network di R

library(tidyverse)
library(tidytext)
library(igraph)

# 1. data 
dataMentah = read_csv(file = "https://raw.githubusercontent.com/eppofahmi/belajaR/master/99-BankData/tweet_save_monas.csv")

dataMentahNetwork = dataMentah %>% 
  select(user_name, full_text) %>% 
  filter(!duplicated(full_text))

glimpse(dataMentahNetwork)

# cleansing
regex <- "#\\S+"
tagar_mention = str_extract_all(string = dataMentahNetwork$full_text, 
                                   pattern = regex, simplify = FALSE)

paste0(tagar_mention[[2]], collapse = " ")

for (i in seq_along(1:length(tagar_mention))) {
  print(i)
  dataMentahNetwork$mention_tagar[i] = paste0(tagar_mention[[i]], collapse = " ")
}

# mempesiapkan data untuk network 
# adjacency
dataMentahNetwork = dataMentahNetwork %>% 
  tidytext::unnest_tokens(output = mention, 
                          input = mention_tagar, 
                          token = "ngrams", n = 1, 
                          to_lower = FALSE)

dataMentahNetwork$mention = tolower(dataMentahNetwork$mention)

dataMentahNetwork = dataMentahNetwork %>% 
  select(-full_text) %>% 
  filter(!is.na(mention))

dataMentahNetwork$user_name = paste0("@", dataMentahNetwork$user_name)
dataMentahNetwork$mention = paste0("#", dataMentahNetwork$mention)

glimpse(dataMentahNetwork)
View(dataMentahNetwork)

# membuat network ----
sample_net = dataMentahNetwork %>% 
  count(user_name, mention)
glimpse(sample_net)
# View(sample_net)

sample_net = sample_net %>% 
  sample_n(100)

glimpse(sample_net)
class(sample_net)

# membuat file/object graph
d_net = igraph::graph_from_data_frame(d = sample_net, 
                                      directed = FALSE)

d_net
# write_graph(graph = d_net, file = "data/hasil/sample_net.pajek", 
#             format = "pajek")

plot(d_net)

# degree centrality
V(d_net)$degree <- degree(d_net)
eigen_c = eigen_centrality(graph = d_net, directed = TRUE, weights = NA)$vector
plot(d_net, vertex.size = eigen_c * 100, layout = layout_with_fr)

nodes = tibble(nodes = V(d_net)$name)
# ec = tibble(eigen_c)

nodes$ec = eigen_c
nodes$dc = degree(graph = d_net)
nodes$bc = betweenness(graph = d_net, directed = FALSE)
# edge_betweenness()

library(ggraph)
?ggraph

d_net %>% 
  ggraph(layout = "fr") +
  geom_node_point(aes(size = nodes$bc)) + 
  geom_edge_link() + 
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_graph()

# modularity ----
?cluster_walktrap()

cw = cluster_walktrap(graph = d_net)
cw$modularity
cw$membership
cw$names

kelas_m = tibble(nodes = cw$names, kelas = cw$membership)
kelas_m %>% 
  count(kelas, sort = TRUE)


color = cw$modularity

d_net %>% 
  ggraph(layout = "fr") +
  geom_node_point(aes(size = nodes$bc, color = as.factor(color)), 
                  show.legend = FALSE) + 
  geom_edge_link() + 
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_graph()

close_reading = dataMentah %>% 
  filter(str_detect(tolower(full_text), "chinavirussesungguhnya"))
