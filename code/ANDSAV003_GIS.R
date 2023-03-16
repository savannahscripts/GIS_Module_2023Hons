
#Install necassary packages
library(rosm)
library(ggspatial)
library(leaflet)
library(htmltools)
library(rinat)
library(sf)
library(magrittr)
library(tidyverse)
library(ctv)
install.packages("here")
library(here)
library(dplyr)
library(viridis)
library(ggplot2)
install.packages("rnaturalearth")
library(rnaturalearth)
install.packages("ggrepel")
library(ggrepel)
install.packages("cowplot")
library(cowplot)



#Call the occurrence data directly from iNat for fish
bronzebream <- get_inat_obs(taxon_name = "Pachymetopon grande",
                            bounds = c(-35, 18, -20, 35),
                            maxresults = 1000)

redstump <- get_inat_obs(taxon_name = "Chrysoblephus gibbiceps",
                         bounds = c(-35, 18, -20, 35),
                         maxresults = 1000)
redsteen <- get_inat_obs(taxon_name = "Petrus rupestris",
                         bounds = c(-35, 18, -20, 35),
                         maxresults = 1000)
knifejaw <- get_inat_obs(taxon_name = "Oplegnathus conwayi",
                         bounds = c(-35, 18, -20, 35),
                         maxresults = 1000)
capestump <- get_inat_obs(taxon_name = "Rhabdosargus holubi",
                          bounds = c(-35, 18, -20, 35),
                          maxresults = 1000)
#Filter returned observations by a range of column attribute criteria
bronzebream <- bronzebream %>% filter(positional_accuracy<46 & 
                                        latitude<0 &
                                        !is.na(latitude) &
                                        quality_grade == "research")
redstump<- redstump %>% filter(positional_accuracy<46 & 
                                 latitude<0 &
                                 !is.na(latitude) &
                                 quality_grade == "research")
redsteen <- redsteen %>% filter(positional_accuracy<46 & 
                                  latitude<0 &
                                  !is.na(latitude) &
                                  quality_grade == "research")
knifejaw <- knifejaw %>% filter(positional_accuracy<46 & 
                                  latitude<0 &
                                  !is.na(latitude) &
                                  quality_grade == "research")
capestump <- capestump %>% filter(positional_accuracy<46 & 
                                    latitude<0 &
                                    !is.na(latitude) &
                                    quality_grade == "research")


#Make the data frame a spatial object of class = "sf"
bronzebream <- st_as_sf(bronzebream, coords = c("longitude", "latitude"), crs = 4326)
redstump<- st_as_sf(redstump, coords = c("longitude", "latitude"), crs = 4326)
redsteen<- st_as_sf(redsteen, coords = c("longitude", "latitude"), crs = 4326)
knifejaw<- st_as_sf(knifejaw, coords = c("longitude", "latitude"), crs = 4326)
capestump<- st_as_sf(capestump, coords = c("longitude", "latitude"), crs = 4326)

#return class 
class(capestump)
class(knifejaw)
class(redsteen)
class(redstump)
class(bronzebream)

#join data frames
#bind rows --> multiple species from iNat in tut
?bind_rows()
fishdat = bind_rows(bronzebream, redstump, redsteen, knifejaw, capestump)


#Plot
ggplot() + geom_sf(data=fishdat)

#adding base layer



#reading in MPA data
MPA<- st_read("/Users/savannahanderson/Desktop/stats directories/WCBSP_MPA_2017-2")

ggplot() + annotation_map_tile(type = "thunderforestlandscape", progress = "none") + 
  geom_sf(data=fishdat, aes(colour = common_name)) +
  geom_sf(data=MPA, colour = 'blue', cex = 0.08)







#interactive

#Creating colour palette and interactive leaflet
palPwr <- leaflet::colorFactor(palette = c("Bronze Seabream" = "red", 
                                           "Red Stumpnose" = "orange", 
                                           "Red Steenbras" = "green", "Cape knifejaw" = "pink", "Cape Stumpnose" = "purple"), 
                               domain = fishcrop$common_name)

leaflet() %>%
  addTiles(group = "Default") %>%  
  #add fish occurence points
  addCircleMarkers(data = fishcrop, radius = 3, fillOpacity = 5, color = palPwr(fishcrop$common_name)) %>% 
  # Add legend
  addLegend("bottomright",
            pal = palPwr, 
            values = fishcrop$common_name,
            title = "Species",
            opacity = 1) %>% 
## Add MPA polygons  
addPolygons(data = MPA, weight = 5, fill = FALSE, label = MPA$Name)

#Bounding box:  xmin: 17.92102 ymin: -34.62667 xmax: 24.19405 ymax: -33.04178

ext = c(17.92102, -34.62667, 24.19405, -33.04178)
names(ext) = c("xmin", "ymin", "xmax", "ymax")

#crop fishdat variable
fishcrop = st_crop(fishdat, ext)

#Overlay with MPA data

overlay = st_intersection(MPA, fishdat)
getwd()
setwd("/Users/savannahanderson/Desktop/stats directories/GIS_resident_MPA_Wc")

ggplot() + annotation_map_tile(type = "osm", progress = "none")  +  geom_sf(data=MPA, colour = 'blue', cex = 0.08)