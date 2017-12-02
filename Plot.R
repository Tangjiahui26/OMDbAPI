library(httr)
library(purrr)
library(glue)
library(plyr)
library(ggplot2)
library(reshape)
library(stringr)
library(tidyverse)

#Read data
Resident_Evil <- read_csv("./Resident_Evil.csv")

IMDb <- Resident_Evil$IMDb %>% 
    str_replace_all("/10","")
Resident_Evil$IMDb = IMDb

#Inserts newlines into strings every N interval
new_lines_adder = function(test.string, interval){
    #length of str
    string.length = nchar(test.string)
    #split by N char intervals
    split.starts = seq(1,string.length,interval)
    split.ends = c(split.starts[-1]-1,nchar(test.string))
    #split it
    test.string = substring(test.string, split.starts, split.ends)
    #put it back together with newlines
    test.string = paste0(test.string,collapse = "\n")
    return(test.string)
}

#a user-level wrapper that also works on character vectors, data.frames, matrices and factors
add_newlines = function(x, interval) {
    if (class(x) == "data.frame" | class(x) == "matrix" | class(x) == "factor") {
        x = as.vector(x)
    }
    
    if (length(x) == 1) {
        return(new_lines_adder(x, interval))
    } else {
        t = sapply(x, FUN = new_lines_adder, interval = interval) #apply splitter to each
        names(t) = NULL #remove names
        return(t)
    }
}

#Make some plots
plot1 <- Resident_Evil %>% 
    filter(!is.na(RottenTomatoes)) %>% 
    arrange(Year) %>% 
    ggplot(aes(x = Title, y = IMDb, color = IMDb))+
    geom_point()+
    theme_bw()+
    labs(title = "IMDb Ratings of Resident Evil Series") +
    scale_x_discrete("Movie Title")+
    scale_y_discrete("IMDb Rating")+
    scale_color_discrete("IMDb Rating") +
    theme(axis.text.x = element_text(angle = 8),
          plot.title = element_text(hjust = 0.5))

#Save to local
ggsave("./IMDb Ratings of Resident Evil Series.png",plot1,device = "png", width = 10, 
       height = 7,dpi = 500)

#Filter data
Resident_Evil2 <- Resident_Evil %>% 
    filter(IMDb >=7.0) %>% 
    arrange(Year) 

#Plot2: IMDb Ratings of Movies about Resident Evil
plot2 <- Resident_Evil2 %>% 
    ggplot()+
    geom_point(aes(x = Title, y = IMDb, color = IMDb))+
    theme_bw()+
    scale_x_discrete("Movie Title",labels = add_newlines(Resident_Evil2$Title, 9)) +
    labs(title = "IMDb Ratings of Movies about Resident Evil") +
    scale_y_discrete("IMDb Rating")+
    scale_color_discrete("IMDb Rating") +
    theme(axis.text.x = element_text(size = 8),
          plot.title = element_text(hjust = 0.5))

#Save to local
ggsave("./IMDb Ratings of Movies about Resident Evil.png",plot2,device = "png", width = 10, 
       height = 7,dpi = 500)