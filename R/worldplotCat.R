#' @title worldplotCat
#'
#' @description Plot a world heat map based on a categorical variable.
#'
#' @inheritParams worldplot
#' @param Categories categories labels to be plotted in the legend.
#' @param na.as.category Treat \code{NA} as a separate category? If `\code{TRUE}, NA will also appear in the legend as one of the categories.
#' @param palette_option Character string indicating the palette to be used. Available options range between "A" and "H". You can also enter a string with a colour for each category
#'
#' @return a map
#' @export
#'
#' @examples
#' data(testdata1b)
#' worldplotCat(data = testdata1b,
#'              div = 1,
#'              ColName = "VCat",
#'              CountryName = "Cshort",
#'              CountryNameType = "isoa2",
#'              annote = FALSE)
#'
worldplotCat <- function(data,
                         ColName, CountryName, CountryNameType = "isoa2",
                         longitude = c(-180, 180) ,latitude = c(-90, 90), crs = 4326,
                         title = "", legendTitle = as.character(ColName), legend.position = "right",
                         Categories = levels(factor(map_df$MapFiller)),
                         na.as.category = TRUE, label.color = "white", label.size = 2,
                         annote = FALSE, div = 1, palette_option = "D", 
                         na_colour = "grey80", transform_limits = TRUE, shadows = TRUE, UK_as_GB = TRUE) {


  simdata <- c()

  simdata$MapFiller <- data[, which(colnames(data) == ColName)]

  if (CountryNameType == "isoa2") {
    simdata$iso_a2 <- data[, which(colnames(data) == CountryName)]
  } else if (CountryNameType == "name") {
    simdata$iso_a2 <- countrycode(sourcevar = data[, which(colnames(data) == CountryName)],
                                  origin = "country.name", destination = "iso2c")
  } else if (CountryNameType == "isoa3") {
    simdata$iso_a2 <- countrycode(sourcevar = data[, which(colnames(data) == CountryName)],
                                  origin = "iso3c", destination = "iso2c")
  } else {
    simdata$iso_a2 <- NULL
  }

  simdata <- as.data.frame(simdata)
  
  simdata$iso_a2 <- replace(simdata$iso_a2, simdata$iso_a2 == "UK", "GB")

  #map_df <- left_join(map_df0, simdata, by = "iso_a2")
  map_df <- merge(WorldMapR::map_df0, simdata, by = "iso_a2", all.x = TRUE)
  
  if (crs != 4326 & transform_limits == TRUE) {
      #Correct longitude and latitude values
      lim1 <- data.frame(X = longitude, Y = latitude)
      lim2 <- st_as_sf(lim1, coords=c("X","Y"), crs="EPSG:4326" )
      lim3 <- st_transform(lim2, crs = st_crs(crs))
      
      longitude <- c(st_bbox(lim3)$xmin, st_bbox(lim3)$xmax)
      latitude <-  c(st_bbox(lim3)$ymin, st_bbox(lim3)$ymax)
      ##
    }


  wplot <- ggplot(data= map_df) +
    geom_sf(color= 'black', aes(fill= MapFiller)) +
    theme(legend.key.size = unit(1/div, 'lines'),
          legend.text = element_text(size= 8/div),
          legend.title = element_text(size = 8/div),
          legend.position = legend.position,
          plot.title = element_text(size= 8/div),
          panel.grid = element_blank(),
          panel.background = element_rect(fill = 'grey95'))+
    labs(fill= legendTitle)+
    coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW', crs = st_crs(crs)) +
    xlab('')+ ylab('')+
    ggtitle(title)

  if (length(palette_option) == 1) {
    wplot <- wplot +
      scale_fill_viridis_d(option = palette_option, begin= 0.3, na.value = na_colour, direction= 1,
                         labels= c(Categories, "NA"), na.translate = na.as.category)
  } else {
    wplot <- wplot +
      scale_fill_manual(values = palette_option, na.value= na_colour, drop= F,
                        labels = Categories, na.translate = na.as.category)
  }



  if (annote == TRUE) {

    world_points <- countrycoord_data(countries.list = simdata$iso_a2[!is.na(simdata$MapFiller)],
                                      crs = crs, UK_as_GB = UK_as_GB, exclude.iso.na = TRUE)
    
    if (shadows == TRUE) {
      
       wplot <- wplot +
      with_shadow(geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2), size= label.size/div, color= label.color, fontface= 'bold'),
                  x_offset = 2, y_offset = 2, sigma = 1)
    } else {
      
      wplot <- wplot +
        geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2), size= label.size/div, color= label.color, fontface= 'bold')
    }
  }

  return(wplot)

}
