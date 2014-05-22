## Read serialized objects
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Convert into data.table and cleanup for memory savings
library(data.table)
NEI.DT = data.table(NEI)
SCC.DT = data.table(SCC)
rm(NEI)
rm(SCC)

## Obtain SCC codes for motor vehicle sources using EI.Sector variable
motor.vehicle.scc = SCC.DT[grep("[Mm]obile|[Vv]ehicles", EI.Sector), SCC]

## Aggregate Emissions for the above SCC by year and county and filter Baltimore City
motor.vehicle.emissions.baltimore = NEI.DT[SCC %in% motor.vehicle.scc, sum(Emissions), by=c("year", "fips")][fips == "24510"]

# Open the PNG device
png(filename="plot5.png", width=480, height=480, units="px")

## Plot emissions per year grouped by source type using ggplot2 plotting system
g = ggplot(motor.vehicle.emissions.baltimore, aes(year, V1))
g + geom_point() + 
  geom_line() +
  labs(x = "Year") + labs(y = "Emissions") +
  labs(title = "Baltimore City Motor Vehicle Emissions")


# Close the PNG device
dev.off()

