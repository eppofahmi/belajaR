library(echarts4r)

les <- jsonlite::fromJSON("https://gist.githubusercontent.com/tyluRp/0d7a53f2a1f55cb3c6ffe22c67618267/raw/0684a839c3e49dac1157721ddd906eff8f9491d4/les-miserables.json")

e_charts() %>% 
  e_graph(
    layout = "circular", 
    circular = list(
      rotateLabel = TRUE
    ),
    roam = TRUE,
    lineStyle = list(
      color = "source",
      curveness = 0.3
    ),
    label = list(
      position = "right",
      formatter = "{b}"
    )
  ) %>%
  e_graph_nodes(
    nodes = les$nodes, 
    names = name, 
    value = value, 
    size = size, 
    category = grp
  ) %>% 
  e_graph_edges(
    edges = les$edges, 
    source = from,
    target = to
  ) %>%
  e_tooltip()


flights <- read.csv(
  paste0("https://raw.githubusercontent.com/plotly/datasets/",
         "master/2011_february_aa_flight_paths.csv")
) %>% 
  dplyr::select(airport1, airport2)

airports <- read.csv(
  paste0("https://raw.githubusercontent.com/plotly/datasets/",
         "master/2011_february_us_airport_traffic.csv")
) %>% 
  dplyr::select(iata, cnt)

# remove airports with no flights
airp <- unique(c(as.character(flights$airport1), as.character(flights$airport2)))
airports <- airports %>% 
  dplyr::filter(iata %in% airp)

e_charts() %>% 
  e_graph_gl() %>% 
  e_graph_nodes(airports, iata, cnt) %>% 
  e_graph_edges(flights, airport1, airport2) %>% 
  e_modularity() %>% 
  e_tooltip()
