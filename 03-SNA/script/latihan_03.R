## ekspor data 
library(tidyverse)
library(readxl)

getwd() # digunakan untuk cek working directory

## Impor data frame -----
impor_migas <- read_excel("data/Nilai Impor Migas-NonMigas.xlsx", 
                          sheet = "Sheet1", col_names = TRUE)
class(impor_migas)

write_csv(x = impor_migas, path = "data/bersih/file_tersimpan.csv")

df1 = mtcars
class(df1)

df2 = economics
class(df2)

df3 = read_delim("data/share_phone.csv",
                 ";", escape_double = FALSE)

## Impor data list -----
obj1 = list(mtcars = df1, 
            ekonomi = df2, 
            phone = df3, 
            migas = impor_migas)

write_rds(x = impor_migas, path = "data/bersih/kumpulan_data2.rds")

library(jsonlite)
write_json(x = obj1, path = "data/bersih/kumpulan_data3.json")

## Observasi dan Sumamry
glimpse(df2)
summary(df2)

df4 = msleep
glimpse(df4)
summary(df4)
?glimpse()
plot(df2)

# menstandarkan nama kolom ----
library(janitor)
# impor data
df5 <- read_delim("data/sample.csv", ";", 
                  escape_double = FALSE)
df5$`Row Labels`
glimpse(df5)

# nama kolom standar
df6 = janitor::clean_names(df5)
glimpse(df5)
glimpse(df6)
df6$row_labels

# memilih kolom -----
?select
# pipe (%>%) shortcut cmd/ctr + shift + m

# match
df4 %>% 
  select(!starts_with(match = "Sleep"))

# indeks
df4 %>% 
  select(1:4, 10)

# nama
df4 %>% 
  select(name, vore)

# delet obj env
rm(impor_migas)

# pilih dengan filter() -----
?filter

df5 = msleep
glimpse(df5)

df6 = df5 %>% 
  filter(!is.na(brainwt))

df7 = df5 %>% 
  filter(vore == "herbi")

df8 = df5 %>% 
  filter(!is.na(brainwt) & vore == "herbi")

?economics
?mtcars

## buat filter dari data starwars, economics, mtcars, msleep dengan menggunakan 1 varibel, 2 variabel, dan memasukan operator ==, >, >=, dan &, |, !

glimpse(starwars)
glimpse(economics)
summary(economics)
df9 = economics %>% 
  filter(between(date, as.Date("1991-05-16"), as.Date("2003-04-23")))

df10 = economics %>%
  filter(date >= "1991-05-16" & date <= "2003-04-23")


## trnasformasi kolom -----
df11 = mtcars
glimpse(df11)

df11 = rownames_to_column(df11)
glimpse(df11)

### membuat kolom baru ----
?mutate
?row_number()

df11 = df11 %>% 
  mutate(id_baris = row_number())

df11$id_baris2 = paste0("baris ke-", row_number(df11$mpg))

df12 = data_frame(rnorm(32))
colnames(df12) = "distribusi"

?bind_cols()
df13 = bind_cols(df11, df12)
df11$distribusi = df12$distribusi

?left_join()

### join table ----
df14 = data_frame(id_baris = seq_along(1:100), distribusi = rnorm(100))

df15 = df11 %>% 
  right_join(df14)

df1 <- tibble(x = 1:3)
df2 <- tibble(x = c(1, 1, 2), y = c("first", "second", "third"))
df1 %>% left_join(df2)

### memisahkan nilai kolom 
data_tidur_fauna = msleep
glimpse(data_tidur_fauna)

data_tidur_fauna = data_tidur_fauna %>% 
  separate(col = 1, into = c("nama_depan", "nama_tengah", "nama_belakang"), 
           sep = " ", remove = FALSE, fill = "right")
glimpse(data_tidur_fauna)

?is.na()

data_tidur_fauna$nama_belakang[is.na(data_tidur_fauna$nama_belakang)] = ""
data_tidur_fauna$nama_tengah[is.na(data_tidur_fauna$nama_tengah)] = ""

film_star = starwars

## Menggabungkan nilai dari kolom 
data_tidur_fauna$tengah_belakng = paste0(data_tidur_fauna$nama_tengah, 
                                         "-", 
                                         data_tidur_fauna$nama_belakang)

glimpse(data_tidur_fauna)

df = data_tidur_fauna %>% 
  unite(col = "tengah_belakng2", nama_tengah:nama_belakang, 
        sep = " ", remove = FALSE)

# unlist column in a data frame ----
library(tidyr)
film_star2 = unnest(film_star, films)

film_star
glimpse(film_star)

# df1 <- sapply(film_star$films, length)
# unlist.col1 <- rep(film_star$films, df1)
# unlist.col1

# film_star$films = as.character(film_star$films)
# glimpse(film_star)
film_star$films = gsub("(?!')[[:punct:]]", "", film_star$films, perl=TRUE)

## Kolom baru dengan value rangkuman 
## membuat kolom baru berisi rerata waktu tidur (sleep_total) fauna berdasarkan kolom order
?group_by
?mean

data_tidur_fauna = data_tidur_fauna %>% 
  group_by(order) %>% 
  mutate(rerata_tidur = mean(sleep_rem))

rerarat_SC = mean(data_tidur_fauna$sleep_cycle, na.rm = TRUE)
rerarat_SC = round(rerarat_SC, 2)
data_tidur_fauna$sleep_cycle[is.na(data_tidur_fauna$sleep_cycle)] = rerarat_SC
summary(data_tidur_fauna)

# Mengisi nilai kosong
library(missForest)
?missForest

data_tes = iris
glimpse(data_tes)

# level factor
levels(data_tes$Species)
summary(data_tes)

# membuat data tes dengan value NA
# akan mulai dari memiliki data yang memiliki value NA 
data_tes_na = prodNA(x = data_tes, noNA = 0.7)
summary(data_tes_na)
glimpse(data_tes_na)

data_tes_na = data_tes_na %>% 
  mutate(Petal.Width_r = case_when(
    is.na(Petal.Width) ~ max(data_tes_na$Petal.Width, na.rm = TRUE), 
    TRUE ~ Petal.Width
  ))

summary(data_tes_na)

data_tes_na = data_tes_na %>% 
  select(-6)

## impute menggunakan missForrest
hasil_na <- missForest(data_tes_na, xtrue = data_tes, verbose = TRUE)
hasil_imputasi = hasil_na[[1]]

summary(data_tes_na)
summary(hasil_imputasi)

# tanpa xtrue
hasil_na2 <- missForest(data_tes_na, verbose = TRUE)
hasil_imputasi2 = hasil_na2[[1]]

summary(data_tes_na)
summary(hasil_imputasi2)

# Noise remmove -----
teks = "Bpbd... http://sadas.id
        https://instagram.com/p/CT5xmXMP_xq/?utm_medium=twitter,
        www.dodoremi.com,
        pic.twitter..."

?gsub()
gsub(pattern = "?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", replacement = "", teks)
