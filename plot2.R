###  plot2.R
#

if(!file.exists("preproc.R"))
{
	stop("Can't find the helper file, preproc.R.  Make sure it's in working directory")
}

source("preproc.R")

fn = "plot2.png"

# Beauty of using dplyr, create subgroup by the value of the variable "year"
orioles<-filter(NEI, fips == "24510") %>% 
		group_by(year) %>%
		summarize(emission=sum(Emissions))


# Summarize, in this case, find the sum of the Emissions of the subgroup by_year
# particles is a df w/ 2 variables (year and total)

par("mar"=c(5.1, 4.5, 4.1, 2.1))

minyr = min(orioles$year)
maxyr = max(orioles$year)

plot(orioles, 
	type = "b", 
	pch = 8,
	xlab = "Year", 
    ylab = expression("Total PM"[2.5]* " (ton)"),
    main = paste("Emissions in Baltimore (", minyr, "-", maxyr, ")")
    )

dev.copy(png, file=fn, width=480, height=480)

dev.off()

cat("Done! ", fn, " has been saved to", getwd())