library(tidyverse)
library(rjson)
library(jsonlite)
library(lubridate)

json_file <- "/Users/laurence/Projects/analyze-spec-benchmarks/charts/scatter-data.json"
json <- fromJSON(json_file, flatten=TRUE)

# Subset for ease of plotting
# json <- head(json, 100)

# Add 01 day value to each month so it can be read as date
json$date <- paste(json$date,"-01",sep="")
# Convert to date
json$date <- as_date(json$date)

p <- json %>%
  ggplot(aes(date, speed)) + geom_point(colour = "sky blue", alpha = 0.5, fill = "transparent") + 
  geom_smooth(formula=y ~ poly(x, 2, raw=TRUE)) + 
  labs(title='CPU Speed Over 25 Years', x='Date', y='Speed (GHz)') +
  theme_minimal() +
  theme(plot.title = element_text(size=24), 
        axis.text.x = element_text(size=16),
        axis.text.y = element_text(size=16),
        axis.title = element_text(size=18),
        rect = element_rect(fill = "transparent"), # all rectangles
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        panel.grid.major = element_blank(), # get rid of major grid
        panel.grid.minor = element_blank(), # get rid of minor grid
        legend.background = element_rect(fill = "transparent"), # get rid of legend bg
        legend.box.background = element_rect(fill = "transparent") # get rid of legend panel bg
        ) + 
  scale_y_continuous(limits=c(0, 5))

ggsave(p, filename = "cpu_speed.png",  bg = "transparent")
