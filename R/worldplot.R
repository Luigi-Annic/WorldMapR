#' @title worldplot
#'
#' @description Plot a world map for continuous data
#'
#' @param simdata Data set containing the list of nations and the variable that we want to plot
#' @param div Controlling image quality (and image size). Default value is 1
#' @param ColName character variable with the name of the variable of interest
#' @param CountryName character variable with the name of the country names column (iso_a2 is the only format accepted atm)
#' @param CountryNameType character variable with the coding for CountryName. It can be "isoa2", "isoa3", or "name"
#' @param rangeVal limit values that are to be defined for the map
#' @param longitude longitude limits. Default is c(-180, 180) (whole world)
#' @param latitude latitude limits. Default is c(-90, 90) (whole world)
#' @param title title of the plot. Default is no title
#' @param legendTitle title of the legend. Default is the name of the filling variable
#'
#' @return a map
#' @export
#' @importFrom rnaturalearth ne_countries
#' @importFrom countrycode countrycode
#' @importFrom dplyr "%>%" left_join select
#' @importFrom ggplot2 ggplot geom_sf theme labs scale_fill_viridis_c coord_sf xlab ylab ggtitle aes
#'
worldplot <- function(simdata, div = 1, ColName, CountryName, CountryNameType, rangeVal,
                      longitude = c(-180, 180) ,latitude = c(-90, 90),
                      title = "", legendTitle = as.character(ColName)) {

  world <- ne_countries(scale = "medium", continent = NULL, returnclass = "sf")

  map_df0<- world %>%
    select(name, iso_a2, iso_a3, geometry)

  simdata$MapFiller <- simdata[, which(colnames(simdata) == ColName)]

  if (CountryNameType == "isoa2") {
    simdata$iso_a2 <- simdata[, which(colnames(simdata) == CountryName)]
  } else if (CountryNameType == "name") {
    simdata$iso_a2 <- countrycode(sourcevar = simdata[, which(colnames(simdata) == CountryName)],
                                  origin = "country.name", destination = "iso2c")
  } else if (CountryNameType == "isoa3") {
    simdata$iso_a2 <- countrycode(sourcevar = simdata[, which(colnames(simdata) == CountryName)],
                                  origin = "iso3c", destination = "iso2c")
  } else {
    simdata$iso_a2 <- NULL
  }


  map_df <- left_join(map_df0, simdata, by = "iso_a2")

  wplot <- ggplot(data= map_df) +
    geom_sf(color= 'black', aes(fill= MapFiller)) +
    theme(legend.key.size = unit(1, 'lines'),
          legend.text = element_text(size= 8),
          legend.title = element_text(size= 8),
          plot.title = element_text(size=8),
          panel.grid = element_blank(),
          panel.background = element_rect(fill = 'grey95'))+
    labs(fill= legendTitle)+
    scale_fill_viridis_c(option='viridis', na.value = 'grey80',direction=1,begin=0.3, limits= rangeVal)+
    coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW') +
    xlab('') + ylab('')+
    ggtitle(title)

  wplot
}
