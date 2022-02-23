1objek = 1 + 19 # salah
objek 1 = 1 + 19 # salah
objek_1 = 1 + 19 # benar
# obj1 = 89 * 5

# Membuat objek R ----
objek_1 = 1 + 19 # benar
objek_2 <- 0.16 / 0.75

data1 = "10"
data1 + 10

data2 = 19 + 17

data1 == data2

# Operator di R ----
teks1 = "farikha"
teks2 = "hanna"

teks1 == teks2

teks3 = TRUE
isTRUE(teks3)

teks1 != teks2
is.na(teks1)
!is.na(teks1)

# Membuat fungsi R
fungsi_bmi = function(bb, tb){
  bmi = bb / tb ^ 2 
  return(bmi)
  }

# menggunakan ----
fungsi_bmi(bb = 65, tb = 1.7)
hasil_bmi1 = fungsi_bmi(bb = 65, tb = 1.7)
hasil_bmi1

# Kemudian (%>%)
library(tidyverse)

?mtcars
df1 = mtcars
# cmd/ctr + shit + m 

df2 = df1 %>% 
  select(1:4) %>% # pilih kolom
  filter(mpg >= 21) # pilih baris

# pilih kolom 1 sampai 6, yang nilai di kolom drat nya kurang dari atau sama dengan 3

# df3 = df1 %>% 
#   # pilih kolom 1 sampai 6 
#   # filter drat <= 3

# fungsi paste -----
kalimat_1 = "andi pergi ke pasar" 
kalimat_1

kalimat_2 = "bersama ayah dan ibu"
kalimat_2

kalimat_3a = paste(kalimat_1, kalimat_2, sep = "%%%%")
kalimat_3a

kalimat_3b = paste0(kalimat_1, " ", kalimat_2)
kalimat_3b

# fungsi if else 
# template if else 
if(kondisi1) {
  # perintah 1
} else if(kondisi2){
  # perintah 2
} else {
  # perintah 3
}

NilaitimA = 20
NilaitimB = 10

# NilaitimA == NilaitimB -> seri
# NilaitimA > NilaitimB -> menang a
# NilaitimA < NilaitimB -> menang b

if(NilaitimA == NilaitimB) {
  # perintah 1
  print("Tim a dan tim b seri")
} else if(NilaitimA > NilaitimB){
  # perintah 2
  print("Tim a menang")
} else {
  # perintah 3
  print("Tim b menang")
}


# Data A=6 dan B=187,jikaA=genap,danB=Ganjil,makacetak“GanjilGenap”,jika A dan B genap, maka cetak “Genap”, JIKA A dan B ganjil semua maka cetak Ganjil, JIKA A ganjil dan B genap, maka cetak “Ganjil genap”, JIKA tidak memenuhi kondisi sebelumnya, maka cetak “genap”.

A = "genap"
B = "ganjil"

# jika A = genap, dan B = Ganjil -> genap ganjil
# jika A dan B genap, -> “Genap”
# JIKA A dan B ganjil -> Ganjil
# JIKA A ganjil dan B genap, -> “Ganjil Genap”,
# JIKA tidak memenuhi kondisi sebelumnya, -> “Genap”

A %% 2 == 0
B %% 2 != 0

if(A %% 2 == 0 & B %% 2 != 0) {
  # perintah 1
  print("Genap Ganjil")
} else if(A %% 2 == 0 & B %% 2 == 0){
  # perintah 2
  print("Genap")
} else if(A %% 2 != 0 & B %% 2 != 0) {
  # perintah 3
  print("Ganjil")
} else {
  # perintah 4
  print("Ganjil Genap")
}

# for loop 
nomor_antrian = 1:10000
for (i in seq_along(1:10000)) {
  if(i %% 2 == 0) {
    print(paste0("Antrian nomor ", i, " = genap"))
  }
}

# Fungsi str, class, summary
library(tidyverse)

data_fauna = msleep

# melihat struktur
str(object = data_fauna)
class(x = data_fauna)
summary(object = data_fauna)

library(skimr)
?skim
skim(data = data_fauna)

# mengganti NA dengan value tertentu
data_fauna$sleep_rem[is.na(data_fauna$sleep_rem)] = 0
skim(data = data_fauna)

# jenis data ----
## Vectors ------
vektor_1 = c(1:4,10)
length(vektor_1)
class(vektor_1)

vektor_2 = c("andi", "susi", "rosi", "ahmad", "jaldi")
length(vektor_1)
class(vektor_2)

vektor_2[3]

## data frame -----
penduduk_rt05 = data_frame(vektor_1, vektor_2)

penduduk_rt05$vektor_1
penduduk_rt05$vektor_2
penduduk_rt05$vektor_2[3]
penduduk_rt05$vektor_1[3]

penduduk_rt05[2,2]

## List ----
vektor_1 = c(1:4, 10)
vektor_2 = c("andi", "susi", "rosi", "ahmad", "jaldi")
vektor_3 = sample(10:20, 7)

penduduk_rt06 = list(vektor_1, vektor_2, vektor_3)
data_penduduk = list(penduduk_rt05, penduduk_rt06)

penduduk_rt06[[2]]
penduduk_rt06[[2]][3]
penduduk_rt06[[2]][1:3]
penduduk_rt06[[2]][c(3,5)]
