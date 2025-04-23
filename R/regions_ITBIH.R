#' Some potentially useful regions for more granular maps
#'
#' This data set contains information about name, iso_a2 code and geometry for Italian and BIH regions.
#'
#' @docType data
#'
#' @usage data(regions_ITBIH)
#'
#' @format An object of class \code{data.frame}
#' @keywords datasets
#'
#' @examples
#' data(regions_ITBIH)
#' head(regions_ITBIH)
"regions_ITBIH"

# The following is the code which is used to create the dataset regions_ITBIH
# Note that the packages rnaturalearth and rnaturalearthdata are needed to create the dataset,
# but they are not imported in WorldMapR anymore
#

#require(rnaturalearth)
#require(rnaturalearthdata)
#library(dplyr)
#library(ggplot2)

#Bosnia <- ne_states(country = "Bosnia and Herzegovina", returnclass = "sf")

# Keep only information regarding regions (no province level)
#BA_entities<- Bosnia %>%
#  group_by(region) %>%
#  summarise()

# This way, Brcko district is considered as being part of Republika Sprska

#BA_entities$region
#colnames(BA_entities) <- c("name", "geometry")
#BA_entities$iso_a2 <- c("BA-BIH", "BA-SRP ") # isoa2 codes do not exist for republic srpska and federation of Bosnia

#ggplot(data = BA_entities)+
#  geom_sf()+
#  coord_sf(label_axes = "SW")                # remove coordinates 

# Now you can just remove the row world$sovereignt == "Bosnia and Herzegovina"
# and substitute it

# here we are

## Disentangle brcko district from rep sprska

#brcko <- Bosnia %>%
#  filter(type == "Condominium") %>%
#  select(c(name, geometry)) %>%
#  mutate(iso_a2 = "BA-BRC") 

#BA_entities2 <- rbind(BA_entities, brcko)

#ggplot(data = BA_entities2)+
#  geom_sf()+
#  coord_sf(label_axes = "SW")

### Ita

#Italy <- ne_states(country = "Italy", returnclass = "sf")

# Keep only information regarding regions (no province level)
#Ita_regions<- Italy %>%
#  group_by(region) %>%
#  summarise() %>%
#  mutate(iso_a2 = "IT") %>%
#  rename(name = region)

#ggplot(data = Ita_regions)+
#  geom_sf()+
#  coord_sf(label_axes = "SW")

#regions_ITBIH <- rbind(BA_entities2, Ita_regions)
#class(regions_ITBIH) <- c("sf", "data.frame")

### save
#save(regions_ITBIH, file = "regions_ITBIH.RData", compress = "xz")
