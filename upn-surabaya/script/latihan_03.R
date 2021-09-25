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

# memilih kolom
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
