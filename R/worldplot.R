#' @title worldplot
#'
#' @description Plot a world heat map based on a continuous variable.
#'
#' @param data Data set containing the list of nations and the variable that we want to plot.
#' @param ColName Character variable with the name of the variable of interest.
#' @param CountryName Character variable with the name of the country names column.
#' @param CountryNameType Character variable with the coding for \code{CountryName}. One of \code{isoa2} (default, standing for ISO 3166-1 alpha-2 code), \code{isoa3}, or \code{name}.
#' @param rangeVal Limit values (minimum and maximum) that are to be defined for the map. If not specified, the minimum and maximum are taken, and a message is displayed.
#' @param longitude Longitude limits. Default is \code{c(-180, 180)} (whole world with crs as EPSG::4326).
#' @param latitude Latitude limits. Default is \code{c(-90, 90)} (whole world with crs as EPSG::4326).
#' @param crs Coordinate reference system (EPSG). By default the value is 4326, which corresponds to EPSG::4326 (WGS84)
#' @param title Title of the plot. Default is no title.
#' @param legendTitle Title of the legend. Default is the name of the filling variable.
#' @param legend.position Position of the legend. If set to "none", no legend is displayed
#' @param annote Do you want to plot country labels (ISO 3166-1 alpha-2 code) on the map? Default is set to \code{FALSE}.
#' @param div Parameter for modifying the elements dimensions in the map. Usually, it does not need to be modified. Default value is 1.
#' @param palette_option Character string indicating the palette to be used. Available options range between "A" and "H".
#' @param label.color Color of the labels if annote = TRUE. Default is white
#' @param label.size Size of the labels if annote = TRUE
#' @param na_colour The colour to be used for countries with missing information. Default is grey80
#' @param transform_limits Only if crs is specified and different from 4326. If TRUE (the default) the program expects to receive values of longitude and latitude as in EPSG 4326,
#'                          (i.e., within -180, +180 for longitude and within -90, +90 for latitude) and automatically updates to the new crs.
#'                          Set to FALSE if you want to define longitude and latitude limits based on the new crs
#' @param shadows If TRUE, add shadows to the country labels (only if annote = TRUE)
#'
#' @return a map
#' @export
#'
#' @examples
#' data(testdata1b)
#' worldplot(data = testdata1b,
#'           div = 1,
#'           ColName = "VNum",
#'           CountryName = "Cshort",
#'           CountryNameType = "isoa2",
#'           rangeVal = c(0,50),
#'           annote = FALSE)
#'
worldplot <- function(data,
                      ColName, CountryName, CountryNameType = "isoa2", rangeVal,
                      longitude = c(-180, 180) ,latitude = c(-90, 90), crs = 4326,
                      title = "", legendTitle = as.character(ColName), legend.position = "right",
                      annote = FALSE, div = 1, palette_option = "D", label.color = "white", label.size = 2,
                      na_colour = "grey80", transform_limits = TRUE, shadows = TRUE) {


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

  map_df <- left_join(map_df0, simdata, by = "iso_a2")
  

  if (missing(rangeVal)) {
    rangeVal = c(range(map_df$MapFiller, na.rm = TRUE))
  }
  
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
          legend.title = element_text(size= 8/div),
          legend.position = legend.position,
          plot.title = element_text(size=8/div),
          panel.grid = element_blank(),
          panel.background = element_rect(fill = 'grey95'))+
    labs(fill= legendTitle)+
    coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW', crs = st_crs(crs)) +
    xlab('') + ylab('')+
    ggtitle(title)
  
  if (length(palette_option) == 1) {
    
    wplot <- wplot +
      scale_fill_viridis_c(option= palette_option, na.value = na_colour, direction=1,begin=0.3, limits= rangeVal)
    
  } else {
    
    wplot <- wplot +
      scale_fill_gradientn(colours = palette_option, na.value = na_colour, limits = rangeVal)
  }
  

  if (annote == TRUE) {

    world_points <- countrycoord_data(countries.list = simdata$iso_a2[!is.na(simdata$MapFiller)],
                                      crs = crs, UK_as_GB = TRUE, exclude.iso.na = TRUE)
    
    if (shadows == TRUE) {
      wplot <- wplot +
        with_shadow(geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2), size= label.size/div, 
                              color= label.color, fontface= 'bold'),
                    x_offset = 2, y_offset = 2, sigma = 1)
      
    } else {
      
      wplot <- wplot +
       geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2), size= label.size/div, 
                              color= label.color, fontface= 'bold')
    }


  }

  return(wplot)

  }
