#
### plot4.R
#

cat ("How have emissions from coal combustion-related sources changed from 1999–2008 in the US? \n")


if(!file.exists("preproc.R"))
{
	stop("Can't find the helper file, preproc.R.  Make sure it's in working directory \n")
}

source("preproc.R")

#
#
#
if(!file.exists("Source_Classification_Code.rds"))
{
	stop("Can't find the Source_Classification_Code.R file.  Make sure it's in working directory")
}
SCCdf <- readRDS("Source_Classification_Code.rds")
SCC <- tbl_df(SCCdf)
rm(SCCdf)

SCC <- select (SCC, SCC, EI.Sector) %>%
		filter(grepl("coal", EI.Sector, ignore.case=T))

SCC <- distinct (SCC)

#
# Define some session specific constants
#
fn = "plot4.png"
Baltimore = "24510"

#
# Beauty of using dplyr, create subgroup by the value of the variable "year"
#
# grepl is used instead of grep because R complains about filter condition dos not evaluate a logical vector
#
# I know exactly which columns I need so I am only going to keep those
#

NEI <- select (NEI, year, SCC, Emissions)

orioles<-inner_join(NEI, SCC, by="SCC") %>%
			group_by(year) %>%
			summarize(emission=sum(Emissions))


# Summarize, in this case, find the sum of the Emissions of the subgroup by_year
# particles is a df w/ 2 variables (year and total)

minyr = min(orioles$year)
maxyr = max(orioles$year)

ploto<-ggplot(orioles, aes(x=year, y=emission)) +
    	geom_point(shape=16, size=4) + 
    	geom_line() +
    	ylab(expression("Total PM"[2.5]*" (ton)")) + 
    	xlab("Year") + 
    	ggtitle(expression('Total PM'[2.5]*' Emissions from Coal'))

ploto+geom_point()

ggsave(filename=fn, plot=ploto, h=7, w=7, dpi=100)

cat("Done! ", fn, " has been saved to \n", getwd(), "\n")