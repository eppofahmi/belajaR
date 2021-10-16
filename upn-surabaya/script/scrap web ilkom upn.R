# http://ilkom.upnjatim.ac.id/blog/page/1/
# http://ilkom.upnjatim.ac.id/blog/page/2/
# http://ilkom.upnjatim.ac.id/blog/page/3/
# http://ilkom.upnjatim.ac.id/blog/page/21/
  
url = "http://ilkom.upnjatim.ac.id/blog/page/2/"
page = read_html(url)


judul = data_frame(judul = page %>% 
                     html_nodes(".blog-title a") %>% 
                     html_text())

tanggal = data_frame(tanggal = page %>% 
                       html_nodes(".span12") %>% 
                       html_text())

tautan = data_frame(tautan = page %>%
                      html_nodes(".blog-title a") %>%
                      html_attr("href"))

hasil_blog = bind_cols(judul, tanggal, tautan)


hasil_blog2 = data_frame()
for (i in seq_along(1:21)) {
  print(i)
  
  url = paste0("http://ilkom.upnjatim.ac.id/blog/page/", i, "/")
  page = read_html(url)
  
  
  judul = data_frame(judul = page %>% 
                       html_nodes(".blog-title a") %>% 
                       html_text())
  
  tanggal = data_frame(tanggal = page %>% 
                         html_nodes(".span12") %>% 
                         html_text())
  
  tautan = data_frame(tautan = page %>%
                        html_nodes(".blog-title a") %>%
                        html_attr("href"))
  
  result = bind_cols(judul, tanggal, tautan)
  
  hasil_blog2 = bind_rows(hasil_blog2, result)
}

library(textclean)
hasil_blog2$judul = replace_white(hasil_blog2$judul)
hasil_blog2$judul = str_trim(hasil_blog2$judul, "both")
hasil_blog2$tanggal = gsub("[[:punct:]]", "", hasil_blog2$tanggal)
hasil_blog2$tanggal = replace_white(hasil_blog2$tanggal)
hasil_blog2$tanggal2 = as.Date(hasil_blog2$tanggal, format = "%B %d %Y")

hasil_blog2 %>% 
  count(tanggal2) %>% 
  ggplot(aes(x = tanggal2, y = n)) + 
  geom_col()

glimpse(hasil_blog2)
View(hasil_blog2)
