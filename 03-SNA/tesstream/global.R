library(ggplot2)
library(dplyr)
# data("diamonds")

# while(TRUE){
#   temp=sample_frac(diamonds,0.1)
#   write.csv(temp, paste0("sampled", gsub("[^0-9]","",Sys.time()),".csv"),
#             row.names = FALSE)
#   Sys.sleep(2) # Suspend execution of R expressions. The time interval to suspend execution for, in seconds.
# }


# stream_tweets(
#   timeout = (60 * 5),
#   parse = FALSE,
#   file_name = "tweets1"
# )