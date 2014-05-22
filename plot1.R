## Read serialized objects
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Convert into data.table and cleanup for memory savings
library(data.table)
NEI.DT = data.table(NEI)
rm(NEI)

## Aggregate Emissions by year
total.emissions = NEI.DT[, sum(Emissions), by="year"]

# Open the PNG device
png(filename="plot1.png", width=480, height=480, units="px")

## Plot emissions per year using basic package
plot(total.emissions, type = "b", pch = 19, col = "blue", ylab = "Emissions", xlab = "Year", main = "Annual Emissions")

# Close the PNG device
dev.off()
