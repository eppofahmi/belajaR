# pelajari cara membuat fungsi di R
nama_fungsi(arg1, arg2)

# mengalikan angka berapupun yang diinput oleh user dengan angka 50
kali136 <- function(angka){
 x <- 50 * angka
 # y = x %% 2
 # z = list(x=x, y = y)
 return(x)
}

kali136(angka = 11)

# fungsi memili dua argumen. Argumen 1 berupa string, argumen 2 berupa angka. Hasilanya harus string angka

# nama = "Ujang"
# nilai = 80
# output = Nilai Ujang adalah 80

library(tidyverse)

df1 = economics
glimpse(df1)

df1$uempmed
df1[,5]

# Looping 
vec1 = 1:10000

df1$hasil_fungsi = 1
glimpse(df1)

df1$unemploy[1]
df1$unemploy[500]

for (i in seq_along(1:nrow(df1))) {
  print(paste0("Angka ke-", i))
  df1$hasil_fungsi[i] = kali136(angka = df1$uempmed[i])
}

glimpse(df1)

# if dan else 

timA = 10
timB = 8

# jika nilai tim A lebih besar dari nilai tim B, maka Tim A yang Menang

if(timA > timB){
  print("Tim A yang menang")
} else if(timA == timB){
  print("Tim A dan Tim B seri")
} else {
  print("Tim B yang menang")
}

