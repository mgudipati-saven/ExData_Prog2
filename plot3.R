## Read serialized objects
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Convert into data.table and cleanup for memory savings
library(data.table)
NEI.DT = data.table(NEI)
rm(NEI)

## Aggregate Emissions by year, county and source type
total.emissions.baltimore.type = NEI.DT[, sum(Emissions), by=c("year", "fips", "type")][fips == "24510"]

# Open the PNG device
png(filename="plot3.png", width=480, height=480, units="px")

## Plot emissions per year grouped by source type using ggplot2 plotting system
## NON-ROAD, NONPOINT, ON-ROAD type sources have seen decreases in emissions.
## POINT type has seen increased emissions until year 2005 and then decreased.
library(ggplot2)
g = ggplot(total.emissions.baltimore.type, aes(year, V1))
g + geom_point() + 
  geom_line(aes(color = type)) + 
  labs(x = "Year") + labs(y = "Emissions") +
  labs(title = "Baltimore City Emissions")


# Close the PNG device
dev.off()
