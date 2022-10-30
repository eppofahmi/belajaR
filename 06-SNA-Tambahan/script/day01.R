# https://github.com/eppofahmi/belajaR/tree/master/upn-surabaya/data
# Menulis skrip di R 
# Tanda pagar == komen/tidak dibaca sebagai perintah

# tidak menggunakan spasi untuk nama objek

jumlah_peserta = 15
jumlah_peserta <- 15

jumlah peserta = 15 # salah - karena ada spasi di nama objek

# tidak menggunakan angka di depan/sebagai awalan nama
1jumlah_peserta = 15 # salah - karena ada angka di depan 
jumlah_peserta1 = 15 # benar

# library (perpustakaan) <- packages (buku) <- kumpulan fungsi (Rumus)

# install hanya dilakukan sekali -> koneksi internet
install.packages("tsna")

install.packages("tidyverse")
install.packages("tidytext")
install.packages("igraph")

# Memanggil package 
library(tidyverse)
library(tidytext)
library(igraph)

# bentuk umum fungsi di r
# nama_fungsi(arg1, arg2, ...)
# fungsi yang digunakan utk menginstall pacakge -> 
# install.packages()

nama_fungsi(arg1, arg2, ...)

# tipe data 
## Vector
nama = c("ujang", "fahmi", "sadasa")
usia = c("12", "15", "8")
nama[c(1, 3)]

## Data Frame -> data flat/rata
# 3 baris, masing2 baris memiliki 5 kolom
# 5 kolom masing-masing kolom memiliki lima baris
# df -> kumpuluan Vector (1 atau lebih) yang memiliki panjangan yang sama
length(nama) == length(usia)

df_peserta = tibble(nama_depan = nama, 
                    umur = usia)

df_peserta2 = tibble(nama_depan = nama, 
                    umur = usia)

# shortcut comment = ctr/cmd+shift+c
# mengkases data frame
df_peserta$umur
df_peserta$umur[2]
df_peserta$umur[c(1,3)]

# df_peserta2[baris,kolom]
df_peserta2[2,1]
df_peserta2[2:3,1]

## List
nama1 = c("ujang", "fahmi", "sadasa", "ahmad")
usia1 = c("12", "15", "8")

datalist1 = list(nama_depan = nama1, umur = usia1)
datalist2 = list(nama1, usia1)

datalist1[["nama_depan"]]
datalist1[["umur"]]

datalist2[[1]]
datalist2[[2]]

datalist1[[1]]
datalist2[[1]][c(1, 2)]

a = 18
hasil = a * jumlah_peserta
hasil = f * jumlah_peserta

# ekspor dan impor
library(tidyverse)
library(readxl) # untuk membaca file excel 
?readxl

?read_csv()
df1 = read_csv(file = "namafolder/namafile.csv")
df2 = read_csv(file = "https://raw.githubusercontent.com/eppofahmi/belajaR/master/upn-surabaya/data/tweet_save_monas.csv")

write_csv(x = df2, file = "data/mentah/raw_twit.csv")

library(readr)
twitMentah <- read_csv("data/mentah/raw_twit.csv")
View(twitMentah)

library(xlsx) # untuk menyimpan data excel

# menyimpan list
# rds = r data files
lis3 = list(datalist1, datalist2, df_peserta2)

write_rds(x = lis3, file = "data/mentah/raw_data.rds")
objek3 = read_rds("data/mentah/raw_data.rds")

