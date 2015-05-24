###  preproc.R
#

if(!file.exists("summarySCC_PM25.rds"))
{
	stop("Can't find the data input file, summarySCC_PM25.rds.  Make sure it's in working directory")
}

cat("My solution utilizes dplyr...  So it is loading it from the library \n")
library(dplyr)

NEIdf <- readRDS("summarySCC_PM25.rds")
NEI <- tbl_df(NEIdf)
rm(NEIdf)

#
# Source the ggplotss graphics library, always, just because
#
library(ggplot2)
