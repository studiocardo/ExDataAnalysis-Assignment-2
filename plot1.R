if(!file.exists("preproc.R"))
{
	stop("Can't find the helper file, preproc.R.  Make sure it's in working directory")
}

source("preproc.R")

particles <- group_by(NEI, year) %>%
	summarize(emission=sum(Emissions))

par("mar"=c(5.1, 4.5, 4.1, 2.1))


minyr = min(particles$year)
maxyr = max(particles$year)
title <- paste ("Emissions in US (", minyr, "-", maxyr,")", sep=" ")

plot(particles, 
	type = "l", 
	xlab = "Year", 
     ylab = expression('Total PM'[2.5]*" Emission (ton)"),
     main = paste("Total Emissions in US (", minyr, "-", maxyr,")"))

dev.copy(png, file="plot1.png", width=480, height=480)

dev.off()

cat("Done! plot1.png has been saved to", getwd())