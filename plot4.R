## Read serialized objects
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Convert into data.table and cleanup for memory savings
library(data.table)
NEI.DT = data.table(NEI)
SCC.DT = data.table(SCC)
rm(NEI)
rm(SCC)

## Obtain SCC codes for coal combustion related surces using SCC.Level.Three variable
coal.scc = SCC.DT[grep("Coal", SCC.Level.Three), SCC]

## Aggregate Emissions for the above SCC by year
coal.emissions = NEI.DT[SCC %in% coal.scc, sum(Emissions), by = "year"]

# Open the PNG device
png(filename="plot4.png", width=480, height=480, units="px")

## Plot emissions per year using ggplot2 plotting system
## Emissions from coal combustion related sources decreased significantly from 1999-2008.
g = ggplot(coal.emissions, aes(year, V1))
g + geom_point() + 
  geom_line() +
  labs(x = "Year") + labs(y = "Emissions") +
  labs(title = "Emissions from Coal Combustion")

# Close the PNG device
dev.off()

