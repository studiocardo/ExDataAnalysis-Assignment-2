#
### plot3.R
#

if(!file.exists("preproc.R"))
{
	stop("Can't find the helper file, preproc.R.  Make sure it's in working directory \n")
}

source("preproc.R")

#
# Define some session specific constants
#
fn = "plot3.png"

# Beauty of using dplyr, create subgroup by the value of the variable "year"
orioles<-filter(NEI, fips == "24510") %>%
				group_by(year, type) %>%
				summarize(emission=sum(Emissions))

# Summarize, in this case, find the sum of the Emissions of the subgroup by_year
# particles is a df w/ 2 variables (year and total)

minyr = min(orioles$year)
maxyr = max(orioles$year)

ploto<-ggplot(orioles, aes(x=year, y=emission, color=type, fill=type)) +
    	geom_line() +
    	geom_point(shape=16, size=4) + 
    	ylab(expression("Total PM"[2.5]* "(ton)")) + 
    	xlab("Year") + 
    	ggtitle(expression('Baltimore PM'[2.5]*' Emissions For Each Type'))

ploto+geom_point()

ggsave(filename=fn, plot=ploto, h=7, w=7, dpi=100)

cat("Done! ", fn, " has been saved to: \n", getwd(), "\n")