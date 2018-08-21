
library(rvest)

url<-read_html("https://www.tripadvisor.com/Airline_Review-d8729111-Reviews-Lion-Air")

#menemukan page terakhir pada review

npages<-url%>%
  html_nodes(" .pageNum")%>%
  html_attr(name="data-page-number")%>%
  tail(.,1)%>%
  as.numeric()

npages

#find index page
a<-0:(npages-1)
b<-10
res<-numeric(length=length(a))
for (i in seq_along(a)) {
  res[i]<-a[i]*b
}

tableout <- data.frame()

for(i in res){
  cat(".")
  
  #Change URL address here depending on attraction for review
  url <- paste ("https://www.tripadvisor.com/Airline_Review-d8729111-Reviews-or",i,"-Lion-Air#REVIEWS",sep="")
  
  
  reviews <- url %>%
    html() %>%
    html_nodes("#REVIEWS .innerBubble")
  
  id <- reviews %>%
    html_node(".quote a") %>%
    html_attr("id")
  
  quote <- reviews %>%
    html_node(".quote span") %>%
    html_text()
  
  rating <- reviews %>%
    html_node(".rating .ui_bubble_rating") %>%
    html_attrs() %>% 
    gsub("ui_bubble_rating bubble_", "", .) %>%
    as.integer() / 10
  
  date <- reviews %>%
    
    html_node(".innerBubble, .ratingDate") %>%
    html_text() 
  
  
  review <- reviews %>%
    html_node(".entry .partial_entry") %>%
    html_text()
  
  #get rid of \n in reviews as this stands for 'enter' and is confusing dataframe layout
  reviewnospace <- gsub("\n", "", review)
  
  temp.tableout <- data.frame(id, quote, rating, date, reviewnospace) 
  
  tableout <- rbind(tableout,temp.tableout)
  
}


#simpan review dalam file excel
write.csv(tableout, "F:/DOC/lionGithub/datalion.csv")
