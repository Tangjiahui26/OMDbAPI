OMDbAPI
================
Jiahui Tang
2017-12-01

``` r
library(httr)
library(purrr)
```

    ## Warning: package 'purrr' was built under R version 3.4.2

``` r
library(glue)
```

    ## Warning: package 'glue' was built under R version 3.4.2

``` r
library(plyr)
```

    ## 
    ## Attaching package: 'plyr'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     compact

``` r
library(ggplot2)
library(reshape)
```

    ## 
    ## Attaching package: 'reshape'

    ## The following objects are masked from 'package:plyr':
    ## 
    ##     rename, round_any

``` r
library(tidyverse)
```

    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: dplyr

    ## Warning: package 'dplyr' was built under R version 3.4.2

    ## Conflicts with tidy packages ----------------------------------------------

    ## arrange():   dplyr, plyr
    ## collapse():  dplyr, glue
    ## compact():   purrr, plyr
    ## count():     dplyr, plyr
    ## expand():    tidyr, reshape
    ## failwith():  dplyr, plyr
    ## filter():    dplyr, stats
    ## id():        dplyr, plyr
    ## lag():       dplyr, stats
    ## mutate():    dplyr, plyr
    ## rename():    dplyr, reshape, plyr
    ## summarise(): dplyr, plyr
    ## summarize(): dplyr, plyr

Make API queries “by hand” using`httr`.
---------------------------------------

Create a dataset with multiple records by requesting data from an API using the`httr`package.

`GET()`data from the API and convert it into a clean and tidy data frame. Store that as a file ready for (hypothetical!) downstream analysis. Do just enough basic exploration of the resulting data, possibly including some plots, that you and a reader are convinced you’ve successfully downloaded and cleaned it.

About this project
------------------

***This project is one homework for [STAT547](http://stat545.com/index.html)***

I used [OMDb API](http://www.omdbapi.com) to get some simple information about movies. Three functions were created to simplify the process:

`Search_by_name()`: Search movie by name and page. We can only request for one page results every time and the`page`paramter was set as 1 by default.

`Get_Ratings()`: Get the ratings of movie when giving IMDb ID as the input. The ratings include: "IMDb","RottenTomatoes","Metacritic".

`Get_Ratings_By_name()`: Combine the functions above to get the ratings by giving search name and page number.

Display data and plots
----------------------

``` r
Batman <- read_csv("./Batman_page2.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   Title = col_character(),
    ##   imdbID = col_character(),
    ##   Year = col_integer(),
    ##   Type = col_character()
    ## )

``` r
Batman_ratings <- read_csv("./Batman_Rating_page2.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   Title = col_character(),
    ##   Year = col_integer(),
    ##   IMDb = col_character(),
    ##   RottenTomatoes = col_character()
    ## )

``` r
Resident_Evil <- read_csv("./Resident_Evil.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   Title = col_character(),
    ##   Year = col_integer(),
    ##   IMDb = col_character(),
    ##   RottenTomatoes = col_character(),
    ##   Metacritic = col_character()
    ## )

``` r
knitr::kable(Batman)
```

| Title                                   | imdbID    |  Year| Type  |
|:----------------------------------------|:----------|-----:|:------|
| Batman: The Killing Joke                | tt4853102 |  2016| movie |
| Batman: The Dark Knight Returns, Part 2 | tt2166834 |  2013| movie |
| Batman: Mask of the Phantasm            | tt0106364 |  1993| movie |
| Batman: The Movie                       | tt0060153 |  1966| movie |
| Batman: Year One                        | tt1672723 |  2011| movie |
| Batman: Assault on Arkham               | tt3139086 |  2014| movie |
| Batman: Gotham Knight                   | tt1117563 |  2008| movie |
| Superman/Batman: Apocalypse             | tt1673430 |  2010| movie |
| Batman Beyond: Return of the Joker      | tt0233298 |  2000| movie |
| Superman/Batman: Public Enemies         | tt1398941 |  2009| movie |

``` r
knitr::kable(Batman_ratings)
```

| Title                                   |  Year| IMDb   | RottenTomatoes |
|:----------------------------------------|-----:|:-------|:---------------|
| Batman: The Killing Joke                |  2016| 6.5/10 | 45%            |
| Batman: The Dark Knight Returns, Part 2 |  2013| 8.4/10 | NA             |
| Batman: Mask of the Phantasm            |  1993| 7.9/10 | 82%            |
| Batman: The Movie                       |  1966| 6.5/10 | 80%            |
| Batman: Year One                        |  2011| 7.4/10 | 88%            |
| Batman: Assault on Arkham               |  2014| 7.5/10 | NA             |
| Batman: Gotham Knight                   |  2008| 6.8/10 | 83%            |
| Superman/Batman: Apocalypse             |  2010| 7.2/10 | NA             |
| Batman Beyond: Return of the Joker      |  2000| 7.8/10 | 88%            |
| Superman/Batman: Public Enemies         |  2009| 7.2/10 | NA             |

``` r
knitr::kable(Resident_Evil)
```

| Title                                                           |  Year| IMDb   | RottenTomatoes | Metacritic |
|:----------------------------------------------------------------|-----:|:-------|:---------------|:-----------|
| Resident Evil                                                   |  2002| 6.7/10 | 34%            | 33/100     |
| Resident Evil: Apocalypse                                       |  2004| 6.2/10 | 21%            | 35/100     |
| Resident Evil: Extinction                                       |  2007| 6.3/10 | 23%            | 41/100     |
| Resident Evil: Afterlife                                        |  2010| 5.9/10 | 23%            | 37/100     |
| Resident Evil: Retribution                                      |  2012| 5.4/10 | 31%            | 39/100     |
| Resident Evil: The Final Chapter                                |  2016| 5.6/10 | 36%            | 49/100     |
| Resident Evil: Degeneration                                     |  2008| 6.6/10 | NA             | NA         |
| Resident Evil: Damnation                                        |  2012| 6.5/10 | NA             | NA         |
| Resident Evil: Vendetta                                         |  2017| 6.3/10 | NA             | NA         |
| Resident Evil: Red Falls                                        |  2013| 5.7/10 | NA             | NA         |
| Playing Dead: 'Resident Evil' from Game to Screen               |  2002| 6.0/10 | NA             | NA         |
| Resident Evil: The Nightmare of Dante                           |  2013| 6.7/10 | NA             | NA         |
| Scoring Resident Evil                                           |  2002| 6.2/10 | NA             | NA         |
| The Evolution of 'Resident Evil': Bridge to Extinction          |  2007| 8.5/10 | NA             | NA         |
| Game Over: 'Resident Evil' Reanimated                           |  2004| 6.5/10 | NA             | NA         |
| Resident Evil: Underground                                      |  2012| 5.7/10 | NA             | NA         |
| Resident Evil: Wesker's Report                                  |  2001| 7.5/10 | NA             | NA         |
| Resident Evil: Down with the Sickness                           |  2012| 6.8/10 | NA             | NA         |
| Beyond Raccoon City: Unearthing 'Resident Evil: Extinction'     |  2008| 7.6/10 | NA             | NA         |
| Resident Evil 1.5: Fan Trailer                                  |  2010| 6.1/10 | NA             | NA         |
| Resident Evil Damnation: Las Plagas - Organisms of War          |  2012| 6.3/10 | NA             | NA         |
| Resident Evil: Vengeance                                        |  2013| 6.5/10 | NA             | NA         |
| Resident Evil: Diary of an Apocalypse                           |  2007| 7.0/10 | NA             | NA         |
| Resident Evil: Operation Raccoon City - Live Action Fan Trailer |  2012| 7.9/10 | NA             | NA         |
| Resident Evil: Hunted                                           |  2010| 7.9/10 | NA             | NA         |
| Undead Evolution: Making 'Resident Evil: Afterlife'             |  2011| 8.9/10 | NA             | NA         |
| Resident Evil: Resurrection                                     |  2012| 7.2/10 | NA             | NA         |
| Back from the Afterlife: Making 'Resident Evil: Retribution'    |  2012| 7.3/10 | NA             | NA         |
| Resident Evil Revelations 2                                     |  2015| 5.9/10 | NA             | NA         |
| Resident Evil Damnation: The DNA of Damnation                   |  2012| 8.0/10 | NA             | NA         |

### Plot1: IMDb Ratings of Resident Evil Series

![](IMDb%20Ratings%20of%20Resident%20Evil%20Series.png)

### Plot2: IMDb Ratings of Movies about Resident Evil

![](IMDb%20Ratings%20of%20Movies%20about%20Resident%20Evil.png)
