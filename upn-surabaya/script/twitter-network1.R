# install.packages("vosonSML")

library(magrittr)
library(vosonSML)

# twitter authentication creates an access token as part of the auth object
twitter_auth <- Authenticate("twitter", 
                             appName = "teachingSadasa",
                             apiKey = "BGbvhjfImdSCy7qt2rDw2Ublx",
                             apiSecret = "ohPewlfEX1H2jNQDxyhav6ZyBGKvi1bpbkSP7Ee7RpXI2Ro50v",
                             accessToken = "73705532-g7fuTPis2Ee02fPUd0BmZz9vckiATXF7lBdYiPAXz",
                             accessTokenSecret = "ERLtRKX6eRuKdwEWBlr4UArjgOeKrqOBSAf5i6hm4hUfw")

# save the object to file after authenticate
saveRDS(twitter_auth, file = "Data/twitter_oauth1.0a")
twitter_auth <- readRDS("Data/twitter_oauth1.0a")

# collect 100 recent tweets for the hashtag #covid19
twitter_data <- twitter_auth %>%
  Collect(searchTerm = "#covid19",
          searchType = "recent",
          numTweets = 100,
          includeRetweets = TRUE,
          retryOnRateLimit = TRUE,
          writeToFile = FALSE,
          verbose = TRUE)

# activity network
activity_network <- twitter_data %>% 
  Create("activity")
class(activity_network)

# write to file 
g <- activity_network %>% Graph(writeToFile = TRUE)

# create SNA
actor_network <- twitter_data %>%
  Create("actor", inclMentions = TRUE)

actor_network

g <- actor_network %>% Graph(writeToFile = TRUE)
g

# Semantic network
semantic_network <- twitter_data %>% 
  Create("semantic",
         removeTermsOrHashtags = c("#auspol"),
         termFreq = 10,
         hashtagFreq = 20)

# dashboard 
# install.packages("VOSONDash")
library(VOSONDash)

runVOSONDash()
