library(httr)
library(purrr)
library(glue)
library(plyr)
library(ggplot2)
library(reshape)
library(tidyverse)

#Create a function to search movie by name using OMDbAPI
Search_by_name <- function(name, page = 1){
    query_string <- list(s = name, page = page, type = "movie", apikey="YOURAPIKEY")
    #query_string <- glue("http://www.omdbapi.com/?s={name}&apikey=YOURAPIKEY&page={page}")
    movie <- GET("http://www.omdbapi.com/", query = query_string)
    
    if(movie$status_code != 200){
        stop("Response goes wrong!")
    }
    
    tmp <- content(movie,as = "parsed")
    
    if(page > ceiling(as.integer(tmp$totalResults)/10)){
        stop("No result.\n
             Please enter a smaller page.")
    }
    #return a dataframe
    Output <- tmp$Search %>% 
        map_df(`[`, c("Title", "imdbID","Year","Type"))
    #return(tmp$totalResults)
    return(Output)
}

#Create a function to get ratings when giving IMDb IDs as input.
Get_Ratings <- function(ID){
    
    query_string <- glue("http://www.omdbapi.com/?i={ID}&apikey=YOURAPIKEY")
    movie <- GET(query_string)
    
    if(movie$status_code != 200){
        stop("Response goes wrong!")
    }
    
    tmp <- content(movie,as = "parsed")
    
    Title <- data.frame(Title = tmp$Title)
    Year <- data.frame(Year = tmp$Year)
    Ratings <- tmp$Ratings %>% 
        map_df(`[`, c("Source", "Value"))
    
    #Switch rows and columns
    Ratings2 <- data.frame(t(Ratings[-1]))
    colnames(Ratings2) <- Ratings[ , 1]
    Ratings2 <- cbind(rownames(Ratings2), Ratings2)
    rownames(Ratings2) <- NULL
    
    if(nrow(Ratings) == 3){
        colnames(Ratings2) <- c("Value","IMDb","RottenTomatoes","Metacritic")
    } else{
        if(nrow(Ratings) == 2)
            colnames(Ratings2) <- c("Value","IMDb","RottenTomatoes")
        else{
            if(nrow(Ratings) == 1){
                colnames(Ratings2) <- c("Value","IMDb")
            }
        }
    }
    
    #merge all the outputs
    Output <- merge(merge(Title,Year),Ratings2)
    Output = subset(Output, select = -c(Value) )
    
    return(Output)
}

#Create a function to get the ratings by giving search name and page number
Get_Ratings_By_name <- function(name, page = 1){
    result <- Search_by_name(name, page)
    Output <- lapply(result$imdbID[1:nrow(result)],Get_Ratings)
    Output <- merge_recurse(Output)
    return(Output)
}

#Get some data as examples
Batman <- Search_by_name("Batman",2)
Batman_rating <- Get_Ratings_By_name("Batman",2)

#save to local
write_csv(Batman,"./Batman_page2.csv")
write_csv(Batman_rating,"./Batman_Rating_page2.csv")

#Search movies about Resident Evil
Search_by_name("Resident+Evil",1)
Resident_Evil1 <- Get_Ratings_By_name("Resident+Evil",1)
Resident_Evil2 <- Get_Ratings_By_name("Resident+Evil",2)
Resident_Evil3 <- Get_Ratings_By_name("Resident+Evil",3)
#Resident_Evil4 <- Get_Ratings_By_name("Resident+Evil",4)
Resident_Evil <- rbind.fill(Resident_Evil1,Resident_Evil2,Resident_Evil3)
write_csv(Resident_Evil,"./Resident_Evil.csv")