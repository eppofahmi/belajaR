pack <- c("tidyverse", "tidytext", "textclean", "janitor", "igraph")
pack

# install.packages("tidyverse")
# install.packages(pack)

# Memanggil package 
library(tidyverse)
library(tidytext)
library(textclean)
library(janitor)

# install package dari github
# install.packages("devtools")
# devtools::install_github("mjskay/ggdist")

library(ggdist)
?geom_dotsinterval()

library(dplyr)
library(ggplot2)

data(RankCorr_u_tau, package = "ggdist")
RankCorr_u_tau %>%
  ggplot(aes(x = u_tau)) +
  geom_dots()

RankCorr_u_tau %>%
  ggplot(aes(x = u_tau, y = factor(i), fill = stat(x > 6))) +
  stat_dotsinterval(quantiles = 100)

# anatomi fungsi
nama_fungsi(arg1, arg2, ...) 

# menulis skrip di R
1data = 1 + 1 # salah
data1 = 1 + 1 # benar

data 1 = 1 + 1 # salah
data_1 = 1 + 1 # benar

data3 = data1 * data_1
data4 = "6"
data3 + data4

# TIPE DATA
# 1. VECTOR
nama = c("budi", "fauzi", "rizka", "erwin")
asal_daerah = c("jak", "malang", "jogja", "jogja")
kekuatan = c(8, 6, 7, 9.7)
nama[4]
nama[1]
nama[c(1, 4)]

# 2. Data frame
df1 = tibble(nama, asal_daerah)
df2 = tibble(nama, asal_daerah, kekuatan)
df3 = tibble(nama = c("ujang", "fahmi"), 
             hobi = c("baca", "maen game"))

# akses baris ke 2, dari kolom ke 2 
df2[2,2]
df2$asal_daerah[3]

df2$asal_daerah
df2[2,]

# 3. List
nama = c("budi", "fauzi", "erwin")
asal_daerah = c("jak", "malang", "jogja", "jogja")
kekuatan = c(8, 6, 7, 9.7, 6)

data_peserta = list(nama = nama, 
                    asal_daerah = asal_daerah, 
                    kekuatan = kekuatan)
data_peserta[[2]][c(1,4)]

# ekspor dan impor data
library(xlsx) # untuk simpal excel file

write_csv(x = df2, file = "databersih/exported_data.csv")
write_csv(x = data_peserta, file = "databersih/exported_data2.csv") # tidak bisa

# rds
write_rds(x = data_peserta, file = "databersih/exported_lis.rds")

# json = javascript object notation 
library(jsonlite)
?jsonlite

toJSON(data_peserta)

jsonlite::write_json(x = data_peserta, path = "databersih/exported_lis.json")
jsonlite::write_json(x = df2, path = "databersih/exported_df.json")

# membaca file data
data_peserta1 = read_csv("databersih/exported_data.csv")

# baca xlsx
readxl::read_xlsx(path = "", sheet = "")

# baca rds
data_peserta_rds = read_rds(file = "databersih/exported_lis.rds")

# baca json
data_peserta_json = read_json(path = "databersih/exported_lis.json")
data_peserta_df = read_json(path = "databersih/exported_df.json")
data_peserta_df = jsonlite::fromJSON("databersih/exported_df.json")
data_peserta_list_to_df = jsonlite::fromJSON("databersih/exported_lis.json")

# anatomi fungsi
write_csv(x = data_peserta_df, 
          file = "databersih/exported_data.csv", 
          progress = TRUE)

nama_fungsi(arg1, arg2, ...) 

nama_depan = "ujang"
nama_belakang = "fahmi"
obj1 = 3
obj2 = 2

paste(nama_depan, nama_belakang)
paste0(nama_depan, " ", nama_belakang, " ", obj)

paste0(obj1, obj2)
as.double(paste0(obj1, obj2))
as.integer()
as.numeric()

glimpse(data_peserta_df)

df_economic = economics
plot(df_economic)

# pelajari cara membuat fungsi di R
nama_fungsi(arg1, arg2)