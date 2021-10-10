library(httr)
library(jsonlite)
library(tidyverse)

# fungsi untuk membuat url api github
github_api <- function(path) { 
  url <- modify_url("https://api.github.com",
  path = path)
GET(url)
}

what = "commits"
paste0("https://api.github.com", "/repos/eppofahmi/belajaR/", what)

resp <- github_api(paste0("/repos/eppofahmi/belajaR/", what))
data = fromJSON(rawToChar(resp$content))

# https://api.github.com/ -> url utama
# param 1: eppofahmi/belajaR
# param 2: commits

data_resp = fromJSON("https://api.github.com/repos/eppofahmi/belajaR/commits")
glimpse(data_resp)

# Twitter api ----
library(rtweet)
vignette("auth") # tutorial mendapatkan api twitter

# setup token
nama = "latihanupn"
apikey = "UETze3Ilnn2hpfX0asxYDXDDu"
apikeysecret = "D1L0KPhrAACMWb39rT5pQdmpef0Me0pwQy5616r2tDISL1Crqw"
accestoken = "73705532-6clVbclYFQsC2FjxhuLdSJOpKJNg2d7L38EbNlorX"
accestokensecret = "zlM6w4TWA3O3RRH6dyR1bbeSaJJyDOvHkLm1HkQPs2LgR"

token <- create_token(
  app = nama,
  consumer_key = UETze3Ilnn2hpfX0asxYDXDDu,
  consumer_secret = apikeysecret,
  access_token = accestoken,
  access_secret = accestokensecret)

# 2978 total di twitter
# 1,468 = tanpa rt
# 1,569 = dengan rt

tweets = rtweet::search_tweets(q = "#TolakKampusAsing", 
                               n = 20000, 
                               type = "recent", 
                               include_rts = TRUE, 
                               retryonratelimit = TRUE)
glimpse(tweets)

# akun paling banyak mendapatkan retweet?
tweets %>% 
  group_by(screen_name) %>% 
  summarise(total_reweet = sum(retweet_count)) %>% 
  arrange(desc(total_reweet)) %>% 
  head(10) %>% 
  ggplot(aes(x = reorder(screen_name, total_reweet), y = total_reweet)) + 
  geom_col() +
  coord_flip()


stream_tweets("#percumalaporpolisi", 
              timeout = 20000, 
              file_name = "tweets.json")


## Not run: 
data_twit = list()
for (i in seq_along(1:5)) {
  df <- stream_tweets("#percumalaporpolisi", timeout = 30)
  ## stream tweets mentioning "election" for 90 seconds
  if(nrow(df) == 0){
    df <- stream_tweets("#percumalaporpolisi", timeout = 30)
  } else {
    data_twit[[i]] = e
    rm(df)
    }
  }


# net data 
## search for #rstats tweets
# rstats <- search_tweets("#rstats", n = 200)

## create from-to data frame representing retweet/mention/reply connections
rstats_net <- network_data(rstats, "retweet,mention,reply")

## view edge data frame
rstats_net

## view user_id->screen_name index
attr(rstats_net, "idsn")

## if igraph is installed...
if (requireNamespace("igraph", quietly = TRUE)) {
  
  ## (1) convert directly to graph object representing semantic network
  rstats_net <- network_graph(rstats)
  
  ## (2) plot graph via igraph.plotting
  plot(rstats_net)
}


