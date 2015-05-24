#
### plot6.R
#

cat ("Compare emissions from motor vehicle sources in Baltimore City with emissions to that from Los Angeles County, California (fips == 06037). \n")

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
# Define some session constants
#
fn = "plot6.png"
Baltimore = "24510"
LA = "06037"

#
# Reducing NEI
#
NEI <- filter(NEI, (fips==Baltimore | fips == LA)) %>%
		select(year, SCC, Emissions, fips) %>%
		mutate (fips = ifelse(fips=="24510", "Baltimore", ifelse(fips=="06037", "LA", "NA")))

#
# Reducing SCC
# 
SCC <- filter(SCC, grepl("vehicle", EI.Sector, ignore.case=T)) %>%
		select(SCC, EI.Sector)


#
# Beauty of using dplyr, create subgroup by the value of the variable "year"
#
orioles<-inner_join(NEI, SCC, by="SCC") %>%
			group_by(year, fips) %>%
			summarize(emission=sum(Emissions))


# Summarize, in this case, find the sum of the Emissions of the subgroup by_year
# particles is a df w/ 2 variables (year and total)

minyr = min(orioles$year)
maxyr = max(orioles$year)

ploto<-ggplot(orioles, aes(x=year, y=emission, color=fips, fill=fips)) +
    	geom_point(shape=16, size=4) + 
    	geom_line() +
    	ylab(expression("Total PM[2.5] (ton)")) + 
    	xlab("Year") + 
    	ggtitle(expression('Total PM'[2.5]*' Emissions from Motor Vehicles'))

ploto+geom_point()

ggsave(filename=fn, plot=ploto, h=7, w=7, dpi=100)

cat("Done! ", fn, "has been saved to: \n", getwd(), "\n")