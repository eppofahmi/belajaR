# library
library(tidyverse)

# error umum ----
## objek nout found ----
a + 198

## solusi -> membuat objek a terlebih dahulu
a = 10
a + 198

## could not find function ----
df1 = mtcars
df1 %>% 
  select(1:3)

# Impor data ----
# read*
# data
# #savejakarta.csv

twit = read_csv("data/#savejakarta.csv")

library(readxl)
impor_migas <- read_excel("data/Nilai Impor Migas-NonMigas.xlsx", 
                          sheet = "Sheet1", col_names = TRUE)

leksikon <- read.table(file = "data/sentiwords_id.txt", 
                       header = FALSE, sep = ":")

colnames(x = leksikon) = c("kata", "nilai")
head(leksikon)

library(jsonlite)

mt_car1 = read_json("data/sample.json")
?fromJSON
mt_car2 = fromJSON("data/sample.json", flatten = TRUE)
