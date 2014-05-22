## Read serialized objects
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Convert into data.table and cleanup for memory savings
library(data.table)
NEI.DT = data.table(NEI)
rm(NEI)

## Aggregate Emissions by year and county and filter "24510"
total.emissions.baltimore = NEI.DT[, sum(Emissions), by=c("year", "fips")][fips == "24510"]

# Open the PNG device
png(filename="plot2.png", width=480, height=480, units="px")

## Plot emissions per year using basic package
plot(total.emissions.baltimore$year, total.emissions.baltimore$V1, type = "b", pch = 19, col = "blue", ylab = "Emissions", xlab = "Year", main = "Baltimore Emissions")

# Close the PNG device
dev.off()
