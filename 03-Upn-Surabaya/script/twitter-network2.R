library(graphTweets)
library(igraph) # for plot
library(rtweet)

tweets <- search_tweets("#rstats", n = 1000, include_rts = FALSE, lang = "en")

net <- tweets %>% 
  gt_co_edges(hashtags) %>%
  gt_nodes() %>% 
  gt_collect()

c(edges, nodes) %<-% net

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

edges <- edges %>% 
  mutate(
    id = 1:n()
  ) %>% 
  filter(source != "#rstats") %>% 
  filter(target != "#rstats")

nodes <- nodes %>% 
  mutate(
    id = nodes,
    label = id,
    size = n
  ) %>% 
  filter(id != "#rstats") %>% 
  select(id, label, size)

library(sigmajs)
#> Welcome to sigmajs
#> 
#> Docs: sigmajs.john-coene.com

sigmajs() %>% 
  sg_nodes(nodes, id, label, size) %>% 
  sg_edges(edges, id, source, target) %>% 
  sg_cluster(
    colors = c(
      "#0084b4",
      "#00aced",
      "#1dcaff",
      "#c0deed"
    )
  ) %>% 
  sg_layout() %>% 
  sg_neighbours() %>% 
  sg_settings(
    defaultEdgeColor = "#a3a3a3",
    edgeColor = "default"
  )
