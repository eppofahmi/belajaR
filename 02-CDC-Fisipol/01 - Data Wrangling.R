# Skrip ini digunakan untuk menyiapkan data yang sudah didapat sebelumnya 
# untuk diproses lebih lanjut

# Ketentuan:
# 1. Tempatkan file .R ini dalam folder yang sama dengan data yang akan diolah
# 2. Cobalah untuk menulis ulang (script) bukan mengkopi paste untuk membiasakan


# Impor data ----------------------
# data 1
raw_jkw <- read.csv("raw_jkw.csv", stringsAsFactors = FALSE, header = TRUE, 
                    sep = ",")

# Your turn!!! --------------------
# cobalah impor data ke 2 
# data 2
raw_prb <- 


# Membuat kolom identitas ---------
# menambah satu kolom baru pada data dengan fungsi mutate() dari package dplyr

library(dplyr)

raw_jkw <- raw_jkw %>%
  mutate(person = "Jokowi")

# Fungsi di atas membuat satu kolom baru dengan nama `person` pada data `raw_jkw`, di mana string "Jokowi" adalah isi dari kolom tersebut
# Your turn!!! --------------------
# tambahkan kolom yang sama untuk data kedua 

raw_prb <- 
  
# Menggabungkan data --------------
# untuk menggabungkan data perlu dipastikan akan digabungkan ke samping (kolom)
# atau ke bawah (baris/rows)
# di sini kita akan menggabungkan rows dengan menggunakan bind_rows()

raw_data <- bind_rows(raw_jkw, raw_prb)

# Mengecek structure data ----------
# gunakan fungsi str(nama_data)

str(raw_data)

# Seharusnya di console sekarang ada deskripsi tentang data
# perhatikan kolom `created` 
# kolom tersebut seharusnya berisi tanggal, namun saat ini masih terbaca 
# sebagai chr (character) oleh karena itu kolom tersebut perlu di konversi 

# Konversi -------------------------

library(lubridate)

raw_data$created <- as.Date(raw_data$created)

# Coba cek apakah kolom tersebut saat ini sudah beruah atau belum dengan str(...)