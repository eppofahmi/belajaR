library(httr)
library(jsonlite)
library(tidyverse)
library(rtweet)

nama = "latihanupn"
apikey = "UETze3Ilnn2hpfX0asxYDXDDu"
apikeysecret = "D1L0KPhrAACMWb39rT5pQdmpef0Me0pwQy5616r2tDISL1Crqw"
accestoken = "73705532-6clVbclYFQsC2FjxhuLdSJOpKJNg2d7L38EbNlorX"
accestokensecret = "zlM6w4TWA3O3RRH6dyR1bbeSaJJyDOvHkLm1HkQPs2LgR"

# tes 1: random sample ----
stream_tweets(
  timeout = (60 * 5),
  parse = FALSE,
  file_name = "tweets1"
)

hasil_strimng1 = parse_stream("tweets1.json")
ts_plot(hasil_strimng1, "secs")


# tes 2: stream a query for 90 sec----
stream_tweets("#percumalaporpolisi", 
              timeout = 90, 
              file_name = "tweets2.json")

hasil_strimng2 = parse_stream("tweets.json")
ts_plot(hasil_strimng2, "secs")


# tes 3 ----

