# Menambang Data Web 1

# Skrip ini digunakan untuk mendapatkan data dari jurnal public policy yang dicari dengan kata kunci "public policy" sebanyak 13 halaman. 

# library yang digunakan 
library(tidyverse) # general
library(rvest) # html parser
library(textclean) # text cleaning
library(lubridate) # transform date 
library(purrr) # mapping lists

# Tahap 1

## halaman pertama ----
url1 <- read_html("https://onlinelibrary.wiley.com/action/doSearch?AllField=public+policy&PubType=journal&SeriesKey=19442866&content=articlesChapters&countTerms=true&target=default&AfterYear=2009&BeforeYear=2018")

## judul ----
# kode target: .hlFld-Title a, elemen = text
judul <- data_frame(judul = url1 %>% 
  html_nodes('.hlFld-Title a') %>% 
  html_text(trim = TRUE))

## cleaning judul
judul <- replace_non_ascii(judul$judul)
judul <- replace_white(judul)
judul <- data.frame(judul)

## Penulis ----
penulis <- data_frame(penulis = url1 %>% 
  html_nodes('.comma') %>% 
  html_text(trim = FALSE))

## cleaning penulis
penulis <- replace_non_ascii(penulis$penulis)
penulis <- replace_white(penulis)
penulis <- data.frame(penulis)

# Tahun Terbit ----
tahun_terbit <- data_frame(tahun = url1 %>% 
  html_nodes('.meta__epubDate') %>% 
  html_text(trim = FALSE))

# menghilangkan term di awal - "First published: "
tahun_terbit$tahun <- gsub("\\bFirst published: \\b", "", tahun_terbit$tahun)

# Doi ---- 
doi <- url1 %>%
  html_nodes(".hlFld-Title a") %>% # sama dengan mengambil judul tapi atribut yang diambil berupa link 
  html_attrs()

doi <- data_frame(doi)

# url doi aslinya adalah # https://onlinelibrary.wiley.com/doi/10.1002/poi3.165 tapi data hanya memiliki angka saja dan setelah dicek tidak bisa dibuka. Untuk itu kita tambahkan elemen di depannya. 
doi$doi <- paste("https://onlinelibrary.wiley.com", sep = '', doi$doi)

# menggabungkan data
data_all <- bind_cols(judul, tahun_terbit, penulis, doi)

# Sampai di sini kita sudah memiliki data dari web yang berisi empat kolom dan 20 baris

# Kita juga ingin mengambil abstrak dengan pertimbangan abstrak bisa diambil secara gratis. Namun jika di cek di web nya tidak semua judul memiliki abstrak, untuk itu proses di sini lebih kompleks. Kita akan coba terlebih dahulu dengan menggunakan selector gadget  

# Abstrak 1 ----
abstrak1 <- url1 %>%
  html_nodes("p") %>%
  html_text()

abstrak1 <- data_frame(abstrak1)

# Dengan menggunkan kode `p` yang didapat dengan selector gadget, kita mendapatkan 26 observasi. Padahal jumlah artikel dalam halam tersebut hanya 20. Jika dicek isinya, ada elemen lain yang ternyata menggunakan kode yang sama. Dalam konteks ini selector gadget tidak dapat memberikan kode spesifik. Untuk itu, kita perlu melakukan observasi langsung html-nya. 

# Caranya: Buka web yang akan di scrap -> klik kanan -> pilih "inspect"

# Abstrak 2 ---- 
# kita ambil dari tingkat/struktur yang lebih tinggi agar bisa membandingkan. Di sini tidak semua judul ada abstraknya maka kita butuh kode yang mencakup judul dan abstrak. ketika kode abstak tidak ada = NA
abstrak2 <- url1 %>% 
  html_nodes('.item__body') %>% # select enclosing nodes
  # iterate over each, pulling out desired parts and coerce to data.frame
  map_df(~list(judul = html_nodes(.x, '.hlFld-Title a') %>% 
                 html_text() %>% 
                 {if(length(.) == 0) NA else .}, # replace length-0 elements with NA
               abstrak = html_nodes(.x, 'p') %>% # isi abstrak
                 html_text() %>% 
                 {if(length(.) == 0) NA else .}))

abstrak2

# Hasil akhir ----
# Melalui observasi langsung kita bisa membuat skenario untuk mengambil seluruh data yang ingin didapat. 

hasil_akhir <- url1 %>% 
  html_nodes('.item__body') %>% # select enclosing nodes
  # iterate over each, pulling out desired parts and coerce to data.frame
  map_df(~list(judul = html_nodes(.x, '.hlFld-Title a') %>% 
                 html_text() %>% 
                 {if(length(.) == 0) NA else .}, # replace length-0 elements with NA
               penulis = html_nodes(.x, '.comma') %>% 
                 html_text() %>% 
                 {if(length(.) == 0) NA else .},
               tahun = html_nodes(.x, '.meta__epubDate') %>% 
                 html_text() %>% 
                 {if(length(.) == 0) NA else .},
               doi = html_nodes(.x, '.hlFld-Title a') %>% 
                 html_attrs() %>% 
                 {if(length(.) == 0) NA else .},
               abstrak = html_nodes(.x, 'p') %>% # isi abstrak
                 html_text() %>% 
                 {if(length(.) == 0) NA else .}))

hasil_akhir


# Multiple pages ----
# hasil pencarian kita terdiri dari 7 halaman, sementara kita sudah mencoba untuk halaman satu dan berhasil. Dengan dasar yang sudah diaplikasikan di halaman 1 kita bisa mengetesnya untuk semua halaman. Karena dengan menggunakan bahasa ini juga memungkinkan kita untuk melakukan scrapping multi pages. 

multipages <- lapply(paste0('https://onlinelibrary.wiley.com/action/doSearch?AllField=public%20policy&PubType=journal&SeriesKey=19442866&content=articlesChapters&countTerms=true&target=default&AfterYear=2009&BeforeYear=2018&startPage=', 0:12),
                function(url){
                  url %>% read_html() %>% 
                    html_nodes(".item__body") %>% 
                    map_df(~list(judul = html_nodes(.x, '.hlFld-Title a') %>% 
                                   html_text() %>% 
                                   {if(length(.) == 0) NA else .}, # replace length-0 elements with NA
                                 penulis = html_nodes(.x, '.comma') %>% 
                                   html_text() %>% 
                                   {if(length(.) == 0) NA else .},
                                 tahun = html_nodes(.x, '.meta__epubDate') %>% 
                                   html_text() %>% 
                                   {if(length(.) == 0) NA else .},
                                 doi = html_nodes(.x, '.hlFld-Title a') %>% 
                                   html_attrs() %>% 
                                   {if(length(.) == 0) NA else .},
                                 abstrak = html_nodes(.x, 'p') %>% # isi abstrak
                                   html_text() %>% 
                                   {if(length(.) == 0) NA else .}))
                })

# cek daftar

page1 <- multipages[[1]]
page2 <- multipages[[2]]
page3 <- multipages[[3]]
page4 <- multipages[[4]]
page5 <- multipages[[5]]
page6 <- multipages[[6]]
page7 <- multipages[[7]]
page8 <- multipages[[8]]
page9 <- multipages[[9]]
page10 <- multipages[[10]]
page11 <- multipages[[11]]
page12 <- multipages[[12]]
page13 <- multipages[[13]]


# gabungan
hasil_akhir <- bind_rows(page1, page2, page3, page4, page5, page6, page7, page8, page9, page10, page11, page12, page13)

rm(page1, page2, page3, page4, page5, page6, page7, page8, page9, page10, page11, page12, page13)

glimpse(hasil_akhir)
a <- hasil_akhir$doi
b <- unlist(a, recursive = FALSE)
b <- data_frame(b)
glimpse(b)

hasil_akhir1 <- hasil_akhir[,-4]
hasil_akhir1 <- bind_cols(hasil_akhir1,b)  
glimpse(hasil_akhir1)
class(hasil_akhir1)

# Cleaning hasil ---- 
hasil_akhir1$judul <- replace_non_ascii(hasil_akhir1$judul)
hasil_akhir1$judul <- replace_white(hasil_akhir1$judul)
hasil_akhir1$penulis <- replace_non_ascii(hasil_akhir1$penulis)
hasil_akhir1$abstrak <- replace_non_ascii(hasil_akhir1$abstrak)
hasil_akhir1$abstrak <- replace_white(hasil_akhir1$abstrak)
hasil_akhir1$tahun <- gsub("\\bFirst published: \\b", '', hasil_akhir1$tahun)

colnames(hasil_akhir1) <- c("judul", "penulis", "tahun", "abstrak", "doi")
hasil_akhir1$doi <- paste("https://onlinelibrary.wiley.com", sep = '', hasil_akhir1$doi)

# menimpan hasil dalam memory internal
write_tsv(hasil_akhir1, path = "workshop-scraping/hasil-akhir1.tsv")

# Penutup
# Dengan scrapping yang dilakukan didapatkan 244 judul artikel dan asbtraknya. Namun di dalamnya juga masih ada tulisan yang bukan jurnal, seperti Editorial dan Issue Information. Beruntunya format tersebut digunakan secara konsisten oleh jurnal. Sehingga term tersebut dapat dijadikan parameter untu memfilter. 

hasil_akhir2 <- hasil_akhir1 %>%
  filter(!str_detect(judul, "\\bEditorial\\b")) %>% # drop judul Editorial
  filter(!str_detect(judul, "\\bIssue Information\\b")) %>% # drop "Issue Information"
  filter(!str_detect(judul, "\\bErratum\\b")) %>% # bErratum
  drop_na(abstrak) # drop empty abstrak

# Menyimpan hasil akhir ----
write_tsv(hasil_akhir2, path = "hasil-akhir2.tsv")

# Melalui skrip di atas saya menyimpan data hasil scraping dengan menggunakan format tsv.


# Simple Analysis
