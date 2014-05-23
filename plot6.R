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

## Aggregate Emissions for the above SCC by year and county
motor.vehicle.emissions = NEI.DT[SCC %in% motor.vehicle.scc, sum(Emissions), by=c("year", "fips")]

## Subset Baltimore City emissions
motor.vehicle.emissions.baltimore = motor.vehicle.emissions[fips == "24510"]

## Subset Los Angeles County emissions
motor.vehicle.emissions.la = motor.vehicle.emissions[fips == "06037"]

# Open the PNG device
png(filename="plot6.png", width=480, height=480, units="px")

## Plot emissions per year grouped by fips using ggplot2 plotting system
## Use log scale to plot rate of change.
## Observe steeper slopes for Baltimore City, indicating it has seen greater changes.
library(ggplot2)
g = ggplot(motor.vehicle.emissions[fips == "24510" | fips == "06037"], aes(year, log(V1)))
g + geom_point() + 
  geom_line(aes(color = fips)) +
  scale_color_discrete(name = "County", breaks = c("06037", "24510"), labels = c("Los Angeles", "Baltimore")) +
  labs(x = "Year") + labs(y = "Emissions (Log Scale)") +
  labs(title = "Annual Motor Vehicle Emissions")

# Close the PNG device
dev.off()

