# Mencoba rword2vec
# Source: http://www.rpubs.com/mukul13/rword2vec

#--------------------------Installing-----------------------------------------
library(devtools)
library(rword2vec)

# melihat list fungsi word2vec di R
ls("package:rword2vec")

#-------------------------Training word2vec model------------------------------ 
# To train text data to get word vectors:
setwd("/Volumes/mydata/RStudio/belajaR/Word2vec in R")

model <- word2vec(train_file = "text8", output_file = "vec.bin", binary=1)

#-------------------------Distance-------------------------------------------- 
# To get closest words:

