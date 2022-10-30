library(tidyverse)

node_network <- read_csv("06-SNA/data/hasil/NodesTes1.csv")
glimpse(node_network)

node_network %>% 
  count(modularity_class, sort = TRUE) %>% 
  ggplot(aes(x = reorder(modularity_class, n), y = n)) + 
  geom_col() + 
  coord_flip()

username_kel16 = node_network %>% 
  filter(modularity_class == 16)

# username_kel16$Label = paste0("@", username_kel16$Label)

data_kel16 = dataMentah %>% 
  filter(user_name %in% username_kel16$Label)
