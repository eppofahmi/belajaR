library(rtweet)
library(tidyverse)

apikey = "SyhQqa4VfjLjeByL7EKNDh6fm"
apikey_secret = "1U4dYQlSEwxG0mW6FPrhb9LekNxmBZRRIZ8jCWSR0CISzKu65S"
acces_token = "73705532-7jwT4Nds5lRDoekVI1LGriFmBoQAMbcgB41nsRYFL"
acces_secret_token = "fsvYQhCB3P1yIAE7lycn84UuuIOjpkzj2fTe2NWpSNl0g"

create_token(app = "latihanupn", 
             consumer_key = apikey, 
             consumer_secret = apikey_secret, 
             access_token = acces_token, 
             access_secret = acces_secret_token)


## search for 100 tweets containing the letter r
?rtweet
df_tweet <- search_tweets(q = "jogja", n = 1000, retryonratelimit = TRUE)
glimpse(df_tweet)

ts_plot(df_tweet, "hours")
stream_tweets(
  q = "omicron", 
  timeout = (6 * 10),
  parse = FALSE,
  file_name = "datamentah/tweets1"
)

df1 = jsonlite::read_json("datamentah/tweets1.json")
