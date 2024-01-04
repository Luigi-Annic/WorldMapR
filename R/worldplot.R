#' @title worldplot
#'
#' @description Plot a world map for continuous data
#'
#' @param data Data set containing the list of nations and the variable that we want to plot.
#' @param ColName Character variable with the name of the variable of interest.
#' @param CountryName Character variable with the name of the country names column.
#' @param CountryNameType Character variable with the coding for `CountryName.` It can be "isoa2" (default), "isoa3", or "name".
#' @param rangeVal Limit values that are to be defined for the map.
#' @param longitude Longitude limits. Default is `c(-180, 180)` (whole world).
#' @param latitude Latitude limits. Default is `c(-90, 90)` (whole world).
#' @param title Title of the plot. Default is no title.
#' @param legendTitle Title of the legend. Default is the name of the filling variable.
#' @param annote Do you want to plot country labels (iso2 code) on the map? Default is set to `FALSE`.
#' @param div Controlling image quality (and image size). Default value is 1.
#' @param save Save the plot in a jpg file?
#' @param filename Only if is save set to TRUE. Name of the file.
#' @param path Only if save is set to TRUE. Path of the directory where the file is to be saved.
#' @param width Only if save is set to TRUE. Width of the file.
#' @param height Only if save is set to TRUE. Height of the file.
#' @param units Only if save is set to TRUE. Units for width and height. Can be "cm", "mm", "in", or "px".
#' @param scale Only if save is set to TRUE. Scaling factor for adjusting image dimensions
#'
#' @return a map
#' @export
#' @importFrom rnaturalearth ne_countries
#' @importFrom countrycode countrycode
#' @importFrom dplyr "%>%" left_join select filter mutate relocate
#' @importFrom ggplot2 ggplot geom_sf theme labs scale_fill_viridis_c coord_sf xlab ylab ggtitle aes unit element_text element_blank element_rect geom_text ggsave
#' @importFrom sf st_centroid st_coordinates
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
                      longitude = c(-180, 180) ,latitude = c(-90, 90),
                      title = "", legendTitle = as.character(ColName),
                      annote = FALSE, div = 1,
                      save = FALSE, filename = "worldplot.jpg", path = getwd(),
                      width = 20, height = 10, units = "cm", scale = 1) {

  world <- ne_countries(scale = 50, continent = NULL, returnclass = "sf")

  map_df0<- world %>%
    select(name, iso_a2_eh, iso_a3_eh, geometry) %>%
    mutate(iso_a2 = ifelse(name %in% c("Indian Ocean Ter." , "Ashmore and Cartier Is."), -99, iso_a2_eh),
           iso_a3 = ifelse(name %in% c("Indian Ocean Ter." , "Ashmore and Cartier Is."), -99, iso_a3_eh)) %>%
    select(name, iso_a2, iso_a3, geometry)

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

  if (annote == TRUE) {

    world_points <- geometries_data(exclude.iso.na = T,
                                    countries.list = simdata$iso_a2[!is.na(simdata$MapFiller)])

    wplot <- wplot +
      geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2), size= 2, color= 'black', fontface= 'bold')
  }

  print(wplot)

  if (save == TRUE) {
    ggplot2::ggsave(filename = filename,
                   path = path,
                   width = width,
                   height = height,
                   units = units,
                   dpi = "retina",
                   scale = scale)
  }

  }
