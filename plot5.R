cat ("How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City? \n")

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
	stop("Can't find the Source_Classification_Code.R file.  Make sure it's in working directory \n")
}
SCCdf <- readRDS("Source_Classification_Code.rds")
SCC <- tbl_df(SCCdf)
rm(SCCdf)

#
# Define some session specific constants
#
fn = "plot5.png"
Baltimore = "24510"

#
# Reducing NEI to make it run faster with the join function
#
NEI <- filter(NEI, fips==Baltimore) %>%
		select(year, SCC, Emissions)

#
# Reducing SCC to make it run faster w/ the join function
# 
SCC <- filter(SCC, grepl("vehicle", EI.Sector, ignore.case=T)) %>%
		select(SCC, EI.Sector)

#
# Gotta love dplyr
#
orioles<-inner_join(NEI, SCC, by="SCC") %>%
			group_by(year) %>%
			summarize(emission=sum(Emissions))

#
# Summarize, in this case, find the sum of the Emissions of the subgroup by_year
# particles is a df w/ 2 variables (year and total)
#

minyr = min(orioles$year)
maxyr = max(orioles$year)

ploto<-ggplot(orioles, aes(x=year, y=emission)) +
    	geom_point(shape=16, size=4) + 
    	geom_line() +
    	ylab(expression("Total PM"[2.5]*" (ton)")) + 
    	xlab("Year") + 
    	ggtitle(expression('Baltimore PM'[2.5]*' Emissions from Motor Vehicles'))

ploto+geom_point()

ggsave(filename=fn, plot=ploto, h=7, w=7, dpi=100)

#
# It's a wrap
#
cat("Done! ", fn, "has been saved to: \n", getwd(), "\n")