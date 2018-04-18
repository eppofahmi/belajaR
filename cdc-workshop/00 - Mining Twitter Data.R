# Skrip ini digunakan untuk mendapatkan data dari twitter melalui API 
# Syarat: 
# 1. Memiliki akun twitter yang aktif
# 2. Membuat aplikasi API Twitter


# library ------ 
library(twitteR) # mengambil data dari twitter

# setup twitter api------

# ganti dengan kode dari Consumer Key (API Key)
api_key <- "pAFA3zX08uixfVtP4PMpcHas0"

# ganti dengan kode dari Consumer Secret (API Secret)
api_secret <- "FZfuzn055vuJgRFraq8KNAAWipsa0ugUEpIjWxuhOFH9Kd5HAm"

# ganti dengan kode Access Token
token <- "73705532-JApWQavtY5kkKbpRUGpDByEhHdLxb2HcKzAgtDZ7T"

# ganti dengan Access Token Secret
token_secret <- "2p2xuhlsMHVlbqDx8Swb7IkCAstwmCEMoINYreNmWxoCN"

setup_twitter_oauth(api_key, api_secret, token, token_secret)

# collect tweets 1 ------
raw_jkw <- searchTwitter("@jokowi", n=5000, lang="id")

# mengubah format data menjadi data frame
raw_jkw <- twListToDF(raw_jkw)

# Melihat hasil 
View(raw_jkw)

# Save data
write.csv(raw_jkw, "raw_jkw.csv")

# cek di folder apakah sudah ada file dengan nama raw_jokowi.csv


# Your Turn 
# collect tweets 2 -----
raw_prb <- searchTwitter("@prabowo", n=5000, lang="id")
raw_prb <- twListToDF(raw_prb)
View(raw_prb)
write.csv(raw_jkw, "raw_prb.csv")

