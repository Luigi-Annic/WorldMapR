# WorldMapr 1.3.0

* dplyr is no longer an import for this package
* Corrected a bug which caused the function to fail when an object named map_df0 was present in
  the local environment
* dataset regions_ITBIH added
* empty_editable_map function added

# WorldMap 1.2.0

* map_df0 is now saved as one of the dataset, meaning that it is not built from scratch every time
  a function is called. Because of this, rnaturalearth and rnaturalearthdata packages are not required to be imported anymore
* Adjusted some label positions
* Added the shadows option, to choose whether to print a shadow around country
  labels or not
* Improved the UK_as_GB option in countrycoord_data


# WorldMapR 1.1.0

* Added the internal function countrycoord_data, which substitutes geometries_data and incorporates
  modifications of the crs.
* Because of the above, geometries_data is now deprecated, and might be removed in later releases.
  It is not used anymore in worldplot and worldplotCat
* Added legend.position option to move or remove the legend
* Added label.color option to change color of the country labels
* Added label.size option to change the size of the country labels


# WorldMapR 1.0.1

* Corrected a bug which caused the figures to be plotted twice
* Default option for range value added
* Possibility to specify a user-defined gradient continuous variables added
* Option to modify the color for missing countries added
* Option to automatically update coordinates limits when using different crs added

# WorldMapR 0.1.3

* Added option to modify the coordinate reference system (crs argument)
* Created vignette
* Removed save functionality within the functions, as the plot object can be saved with various external methods now

# WorldMapR 0.1.1

* Label's position has been improved for some countries in geometries_data
* For categorical variables, the color palette can now be customized manually 
* Improved labels' aesthetics


# WorldMapR 0.1.0

* Initial CRAN submission.
