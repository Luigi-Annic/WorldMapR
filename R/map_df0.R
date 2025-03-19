#' Initial dataset with geometries for each country
#'
#' This data set contains information about name, iso_a2 code and geometry for 242 countries.
#'
#' @docType data
#'
#' @usage data(map_df0)
#'
#' @format An object of class \code{data.frame}
#' @keywords datasets
#'
#' @examples
#' data(map_df0)
#' head(map_df0)
"map_df0"

# The following is the code which is used to create the dataset map_df0
# Note that the packages rnaturalearth and rnaturalearthdata are needed to create the dataset,
# but they are not imported in WorldMapR anymore
#

#### Bringing Crimea to Ukraine
#crimea <- ne_download(
#  type = "admin_0_breakaway_disputed_areas",
#  category = "cultural",
#  scale = 50,
#  returnclass = "sf"
#) %>%
#  filter(NAME == "Crimea")

#world <- ne_countries(scale = "medium", returnclass = "sf")
#ukraine <- world %>% filter(name == "Ukraine")

#ukraine$geometry <- st_union(ukraine$geometry, st_geometry(crimea))

#world <- world %>%
#  filter(name != "Ukraine") %>%
#  bind_rows(ukraine)

### map_df with limited number of variables
#map_df<- world %>%
#  select(name, iso_a2_eh, geometry) %>%
#  mutate(iso_a2 = ifelse(name %in% c("Indian Ocean Ter." , "Ashmore and Cartier Is."), -99, iso_a2_eh)) %>%
#  select(name, iso_a2, geometry)

###Cyprus adjustment 
#cyp <- subset(map_df, name %in% c("Cyprus", "N. Cyprus"))
#cyp2 <- st_union(cyp[1, "geometry"], cyp[2,"geometry"])
#map_df[map_df$iso_a2 == "CY", "geometry"] <- cyp2

### save
# save(map_df0, file = "map_df0.RData", compress = "xz")
