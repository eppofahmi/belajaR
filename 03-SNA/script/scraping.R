# https://onlinelibrary.wiley.com/action/doSearch?AllField=children+media+habit&Ppub=%5B20210915+TO+20211015%5D&PubType=journal&startPage=0&pageSize=20
# https://onlinelibrary.wiley.com/action/doSearch?AllField=children+media+habit&Ppub=%5B20210915+TO+20211015%5D&PubType=journal&startPage=1&pageSize=20

0:8

link = "https://onlinelibrary.wiley.com/action/doSearch?AllField=children+media+habit&Ppub=%5B20210915+TO+20211015%5D&PubType=journal&startPage=6&pageSize=20%22"

# data yang ambil 

# judul = .meta__title__margin
# penulis = .publication_contrib_author span
# jurnal = .meta__book , .publication_meta_serial
# edisi = .meta__info a:nth-child(2)
# tgl_terbit = .meta__epubDate
# abstrak = #section-1-en p -> tidak sukses diambil 
# doi = hlFld-Title

library(tidyverse)
library(rvest)
# ?rvest

page1 <- read_html(link)

# judul ------
judul <- data_frame(judul = page1 %>%
                      html_nodes('.hlFld-Title a') %>%
                      html_text(trim = TRUE))

View(judul)

# penulis ------
page1 %>% 
  html_nodes(".comma") %>% 
  html_text(trim = TRUE)

penulis <- data_frame(penulis = page1 %>%
                        html_nodes('.comma') %>%
                        html_text(trim = FALSE))

# View(penulis)

# jurnal -----
page1 %>% 
  html_nodes(".meta__book , .publication_meta_serial") %>% 
  html_text(trim = TRUE)

tryCatch(html_text(html_nodes(page1, ".meta__book , .publication_meta_serial")),
         error = function(e){NA})



jurnal = data_frame(jurnal = page1 %>% 
                      html_nodes(".meta__book , .publication_meta_serial") %>% 
                      html_text(trim = TRUE))

# View(jurnal)

# edisi ----
page1 %>% 
  html_nodes(".publication_meta_volume_issue") %>% 
  html_text()

edisi = data_frame(edisi = page1 %>% 
                     html_nodes(".publication_meta_volume_issue") %>% 
                     html_text()
)

glimpse(edisi)

# tgl_terbit -------
page1 %>% 
  html_nodes(".meta__epubDate") %>% 
  html_text(trim = TRUE)

tgl_terbit = data_frame(tgl_terbit = page1 %>% 
                          html_nodes(".meta__epubDate") %>% 
                          html_text(trim = TRUE))
tgl_terbit

# abstrak -----
page1 %>% 
  html_nodes("article-section__content en main") %>% 
  html_text()

# doi ----- 
page1 %>% 
  html_nodes(".meta__title__margin") %>% 
  html_attr("href")

page1 %>%
  html_nodes(".hlFld-Title a") %>% # tambah tag a 
  html_attr("href")

doi = data_frame(doi = page1 %>%
                   html_nodes(".hlFld-Title a") %>% # tambah tag a 
                   html_attr("href"))

# ?html_attr
# ?html_attrs

doi$doi = paste0("https://asistdl.onlinelibrary.wiley.com", doi$doi)

# Melengkapi link doi 
# https://asistdl.onlinelibrary.wiley.com/doi/10.1002/pra2.437

# gabung data hasil scrap
hasil_ch = bind_cols(judul, penulis, jurnal, edisi, tgl_terbit, doi)

glimpse(hasil_ch)
View(hasil_ch)


## Buat mesin scraper dengan loop -----
hasil_full = data_frame()

for (i in seq_along(0:8)) {
  print(i)
  url1 = "https://onlinelibrary.wiley.com/action/doSearch?AllField=children+media+habit&Ppub=%5B20210915+TO+20211015%5D&PubType=journal&startPage="
  url2 = "&pageSize=20"
  url_full = paste0(url1, i-1, url2)
  print(url_full)
  
  # download html file 
  page1 <- read_html(url_full)
  
  # judul ------
  judul <- data_frame(judul = page1 %>%
                        html_nodes('.hlFld-Title a') %>%
                        html_text(trim = TRUE))
  
  # penulis ------
  penulis <- data_frame(penulis = page1 %>%
                          html_nodes('.comma') %>%
                          html_text(trim = FALSE))
  # jurnal
  jurnal = data_frame(jurnal = page1 %>% 
                        html_nodes(".meta__book , .publication_meta_serial") %>% 
                        html_text(trim = TRUE))

  # edisi ----
  edisi = data_frame(edisi = page1 %>% 
                       html_nodes(".publication_meta_volume_issue") %>% 
                       html_text()
  )
  
  # tgl_terbit -------
  tgl_terbit = data_frame(tgl_terbit = page1 %>% 
                            html_nodes(".meta__epubDate") %>% 
                            html_text(trim = TRUE))
  
  # doi ----- 
  doi = data_frame(doi = page1 %>%
                     html_nodes(".hlFld-Title a") %>% # tambah tag a 
                     html_attr("href"))
  
  doi$doi = paste0("https://asistdl.onlinelibrary.wiley.com", doi$doi)
  
  # Melengkapi link doi 
  # https://asistdl.onlinelibrary.wiley.com/doi/10.1002/pra2.437
  
  # gabung data hasil scrap
  hasil_perpage = bind_cols(judul, penulis, jurnal, edisi, tgl_terbit, doi)
  hasil_full = bind_rows(hasil_full, hasil_perpage)
}


## Buat mesin scraper dengan loop -----
hasil_full2 = data_frame()

for (i in seq_along(6:8)) {
  print(i)
  url1 = "https://onlinelibrary.wiley.com/action/doSearch?AllField=children+media+habit&Ppub=%5B20210915+TO+20211015%5D&PubType=journal&startPage="
  url2 = "&pageSize=20"
  url_full = paste0(url1, i-1, url2)
  print(url_full)
  
  # download html file 
  page1 <- read_html(url_full)
  
  # judul ------
  hasil <- data_frame(judul = tryCatch(html_text(html_nodes(page1, ".hlFld-Title a")),
                               error = function(e){NA}
                               ),
                      penulis = page1 %>%
                        html_nodes('.comma') %>%
                        html_text(trim = FALSE), 
                      jurnal = tryCatch(html_text(html_nodes(page1, ".meta__book , .publication_meta_serial")),
                                       error = function(e){NA}
                                       ),
                      edisi = page1 %>% 
                        html_nodes(".publication_meta_volume_issue") %>% 
                        html_text(), 
                      tgl_terbit = page1 %>% 
                        html_nodes(".meta__epubDate") %>% 
                        html_text(trim = TRUE), 
                      doi = page1 %>%
                        html_nodes(".hlFld-Title a") %>% # tambah tag a 
                        html_attr("href")
                      )
  
  doi$doi = paste0("https://asistdl.onlinelibrary.wiley.com", doi$doi)
  hasil_full2 = bind_rows(hasil_full2, hasil)
}
