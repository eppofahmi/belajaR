devtools::install_github("mkearney/tweetbotornot")

library(tweetbotornot)

## select users
users <- c("realdonaldtrump", "netflix_bot",
           "kearneymw", "dataandme", "hadleywickham",
           "ma_salmon", "juliasilge", "tidyversetweets", 
           "American__Voter", "mothgenerator", "hrbrmstr")

## get botornot estimates
data <- tweetbotornot(users)
