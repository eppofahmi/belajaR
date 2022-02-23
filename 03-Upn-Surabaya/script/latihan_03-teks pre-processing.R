# text prep + visualisasi 

library(textclean)
library(stringr)

teks = " jagalah 3m, Menjaga Jarak, yang yang, tadi itu apa,
         kebersihan, dan menjaga hatii !!!......."
teks

# extra sapce
teks = textclean::replace_white(teks)
teks

# white space di depan/belakang
?str_trim
teks = str_trim(string = teks, side = "both")

# remove non ascii
teks = textclean::replace_non_ascii(x = teks)
teks

# remove punctuation
# !? etc.
?gsub()

teks = gsub(pattern = "[[:punct:]]", replacement = "", x = teks)
teks = str_trim(string = teks, side = "both")
teks

# kamus normalisasi 
kamus = data.frame(pat = c("hatii", "3m"), rep = c("hati", "3 meter"))
kamus

teks = gsub(pattern = "[[:punct:]]", replacement = "", x = teks)
teks

teks = gsub(pattern = kamus$pat[1], replacement = kamus$rep[1], x = teks)
teks = gsub(pattern = kamus$pat[2], replacement = kamus$rep[2], x = teks)
teks

# lower upper case
teks = toupper(x = teks)
teks
teks = tolower(x = teks)
teks

# stopwords
kamus_stopw = read.delim("https://raw.githubusercontent.com/datascienceid/stopwords-bahasa-indonesia/master/stopwords_id_satya.txt", col.names = FALSE)
class(kamus_stopw)
colnames(kamus_stopw) = "pat"

library(tidyverse)

kamus_stopw$pat = as.character(kamus_stopw$pat)
glimpse(kamus_stopw)

kamus_stopw$pat <- paste0("\\b", kamus_stopw$pat, "\\b")
kamus_stopw$rep <- ""

kamus_stopw %>% 
  head(10)

pattern <- as.character(kamus_stopw$pat)
class(pattern)

replacement <- as.character(kamus_stopw$rep)
replacement

teks
textclean::mgsub_regex(teks, pattern = pattern, replacement = replacement,
            fixed = FALSE)

# Tugas: Membersihkan kolom full teks dari kata sambung/stop words

data_twit = readr::read_csv("data/tweet_save_monas.csv")
glimpse(data_twit)
View(data_twit)

data_twit_sample = sample_n(tbl = data_twit, 100)
glimpse(data_twit_sample)

library(tidytext)

# "yang aku bawa adalah buku pelajaran dan makanan buat siang nanti"

# 1 token
# yang
# aku
# bawa 
# ....

# 2 token: bigram
# yang aku
# aku bawa
# bawa adalah
# adalah buku

# 3 token: trigram
# yang aku bawa
# aku bawa adalah
# bawa adalah buku

?unnest_tokens()
data_twit_sample = data_twit_sample %>% #persen lebih dari persen = kemudian
  select(full_text_clean) %>% 
  group_by(full_text_clean) %>% 
  unnest_tokens(output = "hasil_token", input = full_text_clean, token = "ngrams", n = 1) 

# View(data_twit_sample)
glimpse(data_twit_sample)

data_twit_sample %>% 
  ungroup() %>% 
  count(hasil_token, sort = TRUE)

monas = data_twit_sample %>% 
  ungroup() %>% 
  filter(str_detect(hasil_token, "monas")) %>% 
  filter(!duplicated(full_text_clean))
glimpse(monas)

# menunjukkan perbandingan dengan diagram balok
data_twit_sample %>% 
  ungroup() %>% 
  count(hasil_token, sort = TRUE) %>% 
  head(n = 15) %>% 
  ggplot(aes(x = reorder(hasil_token, n), y = n)) + # sumbu x dan y
  geom_col() + # jenis plot
  coord_flip() + # tambahan
  labs(y = "Jumlah kata diketik", x = "kata") # tambahan


## Membuat plot
## 1. Data yang akan diplot kan (x, y, z)
datap1 = data_twit_sample %>% 
  ungroup() %>% 
  count(hasil_token, sort = TRUE) %>% 
  head(n = 15)
glimpse(datap1)

datap1 %>% 
  ggplot(aes(x = hasil_token, y = n))

## 2. Pesan - data menujukkan apa? perbandingan 
## 3. Jenis plot (scatter, pie, balok, line)? balok
### balok = geom_col() - ini akan digunakan 
### line = geom_line()
### scatter = geom_point()

datap1 %>% 
  ggplot(aes(x = hasil_token, y = n)) + 
  geom_col()

## 4. Kustomisasi X, Y, JUDUL 
datap1 %>% 
  ggplot(aes(x = reorder(hasil_token, n), y = n)) + 
  geom_col() + 
  coord_flip() + 
  labs(y = "Jumlah kata diketik", x = "kata") # tambahan


## Distribusi 
data_dist = data_twit %>% 
  select(created_at) %>% 
  separate(created_at, into = c("tanggal", "jam"), sep = " ") 

data_dist$tanggal = as.Date(data_dist$tanggal)
glimpse(data_dist)

data_dist %>% 
  count(tanggal) %>%
  ggplot(aes(x = tanggal, y = n, group = 1)) +
  geom_line()

# buat distribusi reply_count, like_count, dan retweet_count dalam 1 plot line

# plot hubungan 
data_twit %>% 
  select(retweet_count, like_count) %>% 
  ggplot(aes(x = retweet_count, y = like_count)) + 
  geom_point() + 
  geom_smooth()


# plot pie 
library(echarts4r)

mtcars  %>%  
  head() %>% 
  tibble::rownames_to_column("model") %>% 
  e_charts(model) %>% 
  e_pie(cyl)

mtcars %>% 
  head() %>% 
  tibble::rownames_to_column("model") %>% 
  e_charts(model) %>% 
  e_pie(carb, radius = c("50%", "70%")) %>% 
  e_title("Donut chart")


# buat komposisi sentimen text_sentiment