all: OMDbAPI.html

clean:
	rm -f *.csv
	rm -f *.png
	rm -f OMDbAPI.md
	rm -f *.html

Resident_Evil.csv Batman_page2.csv Batman_Rating_page2.csv:
	Rscript GetDataFromAPI.R
	
Plot: Plot.R Resident_Evil.csv
	Rscript $<
	rm -f Rplots.pdf
	
OMDbAPI.html: OMDbAPI.Rmd Plot Resident_Evil.csv Batman_page2.csv Batman_Rating_page2.csv
	Rscript -e 'rmarkdown::render("$<")'

