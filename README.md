# OMDbAPI
Homework10 for STAT547M

## About this project

***This project is one homework for [STAT547](http://stat545.com/index.html)***
***I did not push my APIKEY to Github because of security, so Remember to change`YOURAPIKEY`if you want to build this project!!!***

I used [OMDb API](http://www.omdbapi.com) to get some simple information about movies. Three functions were created to simplify the process:

`Search_by_name()`: Search movie by name and page. We can only request for one page results every time and the`page`paramter was set as 1 by default.

`Get_Ratings()`: Get the ratings of movie when giving IMDb ID as the input. The ratings include: `IMDb`,`RottenTomatoes`and`Metacritic`.

`Get_Ratings_By_name()`: Combine the functions above to get the ratings by giving search name and page number.

If you want to know more about the project, you can see [OMDbAPI.md](https://github.com/Tangjiahui26/OMDbAPI/blob/master/OMDbAPI.md)