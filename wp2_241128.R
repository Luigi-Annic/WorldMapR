# worldplot improvement: coord_sf is now present only once, with no change message in case crs different from 4326

w2 <- function (data, ColName, CountryName, CountryNameType = "isoa2", 
          rangeVal, longitude = c(-180, 180), latitude = c(-90, 90), 
          crs = 4326, title = "", legendTitle = as.character(ColName), 
          annote = FALSE, div = 1, palette_option = "D", na_colour = "grey80", 
          transform_limits = TRUE) 
{
  world <- ne_countries(scale = 50, continent = NULL, returnclass = "sf")
  map_df0 <- world %>% select(name, iso_a2_eh, iso_a3_eh, geometry) %>% 
    mutate(iso_a2 = ifelse(name %in% c("Indian Ocean Ter.", 
                                       "Ashmore and Cartier Is."), -99, iso_a2_eh), iso_a3 = ifelse(name %in% 
                                                                                                      c("Indian Ocean Ter.", "Ashmore and Cartier Is."), 
                                                                                                    -99, iso_a3_eh)) %>% select(name, iso_a2, iso_a3, 
                                                                                                                                geometry)
  cyp <- subset(map_df0, name %in% c("Cyprus", "N. Cyprus"))
  cyp2 <- st_union(cyp[1, "geometry"], cyp[2, "geometry"])
  map_df0[map_df0$iso_a2 == "CY", "geometry"] <- cyp2
  simdata <- c()
  simdata$MapFiller <- data[, which(colnames(data) == ColName)]
  if (CountryNameType == "isoa2") {
    simdata$iso_a2 <- data[, which(colnames(data) == CountryName)]
  }
  else if (CountryNameType == "name") {
    simdata$iso_a2 <- countrycode(sourcevar = data[, which(colnames(data) == 
                                                             CountryName)], origin = "country.name", destination = "iso2c")
  }
  else if (CountryNameType == "isoa3") {
    simdata$iso_a2 <- countrycode(sourcevar = data[, which(colnames(data) == 
                                                             CountryName)], origin = "iso3c", destination = "iso2c")
  }
  else {
    simdata$iso_a2 <- NULL
  }
  simdata <- as.data.frame(simdata)
  map_df <- left_join(map_df0, simdata, by = "iso_a2")
  if (missing(rangeVal)) {
    rangeVal = c(range(map_df$MapFiller, na.rm = TRUE))
  }
  
  if (crs != 4326 & transform_limits == TRUE) {
      lim1 <- data.frame(X = longitude, Y = latitude)
      lim2 <- st_as_sf(lim1, coords = c("X", "Y"), crs = "EPSG:4326")
      lim3 <- st_transform(lim2, crs = st_crs(crs))
      longitude <- c(st_bbox(lim3)$xmin, st_bbox(lim3)$xmax)
      latitude <- c(st_bbox(lim3)$ymin, st_bbox(lim3)$ymax)
    }
    
  
  
  
  wplot <- ggplot(data = map_df) +
    geom_sf(color = "black", aes(fill = MapFiller)) +
    theme(legend.key.size = unit(1/div,  "lines"), legend.text = element_text(size = 8/div),
          legend.title = element_text(size = 8/div), plot.title = element_text(size = 8/div),
          panel.grid = element_blank(), panel.background = element_rect(fill = "grey95")) + 
    labs(fill = legendTitle) + 
    coord_sf(xlim = longitude, ylim = latitude, expand = FALSE, 
             label_axes = "SW", crs = st_crs(crs)) +
    xlab("") + ylab("") + ggtitle(title)
  
  if (length(palette_option) == 1) {
    wplot <- wplot + scale_fill_viridis_c(option = palette_option, 
                                          na.value = na_colour, direction = 1, begin = 0.3, 
                                          limits = rangeVal)
  }
  else {
    wplot <- wplot + scale_fill_gradientn(colours = palette_option, 
                                          na.value = na_colour, limits = rangeVal)
  }
  
  if (annote == TRUE) {
    world_points <- geometries_data(exclude.iso.na = T, countries.list = simdata$iso_a2[!is.na(simdata$MapFiller)])
    if (crs != 4326) {
      d <- data.frame(iso_a2 = world_points$iso_a2, X = world_points$X, 
                      Y = world_points$Y)
      d2 <- st_as_sf(d, coords = c("X", "Y"), crs = "EPSG:4326")
      d3 <- st_transform(d2, crs = st_crs(crs))
      d4 <- data.frame(iso_a2 = d3$iso_a2, X = rep(NA, 
                                                   nrow(d3)), Y = rep(NA, nrow(d3)))
      for (i in 1:nrow(d3)) {
        d4[i, c("X", "Y")] <- d3$geometry[[i]]
      }
      world_points <- d4
    }
    wplot <- wplot + with_shadow(geom_text(data = world_points, 
                                           aes(x = X, y = Y, label = iso_a2), size = 2/div, 
                                           color = "white", fontface = "bold"), x_offset = 2, 
                                 y_offset = 2, sigma = 1)
  }
  return(wplot)
}
