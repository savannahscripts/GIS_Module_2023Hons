library(readxl)
library(rosm)
library(ggspatial)
library(sf)
library(magrittr)
library(tidyverse)

#read in MPA data

MPA<- st_read("/Users/savannahanderson/Desktop/stats directories/WCBSP_MPA_2017-2")
getwd()

setwd("/Users/savannahanderson/Desktop/stats directories")

  
  library(ggplot2)
ggplot() +
  geom_sf(data=MPA, aes(colour = Name))

#adding base layer
library(rosm)
library(ggspatial)

rosm::osm.types()
#plotting MPAs
ggplot() + annotation_map_tile(type = "osm", progress = "none")  +  geom_sf(data=MPA, colour = 'blue', cex = 0.08)

class(MPA)


st_is_within_distance(MPA, fishcrop, 1000) %>% unlist() %>% unique()



leaflet() %>%
  addTiles(group = "Default") %>%  
  addCircleMarkers(data = MPA, radius = 3, fillOpacity = 5, color = palPwr(fishdat$common_name)) %>% 
  # Add legend
  addLegend("bottomright",
            pal = palPwr, 
            values = fishdat$common_name,
            title = "Species",
            opacity = 1)


