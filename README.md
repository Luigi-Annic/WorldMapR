WorldMapR (v 0.1.3) is an R package for creating world heat maps, based on continuous or categorical variables.

The attached vignette provides further information about how to use this package.

WorldMapR is currently on CRAN - DOI:	10.32614/CRAN.package.WorldMapR

Future updates will address the following:

- improve documentation for EPSG coordinates
- find better solutions for dealing with coordinates when different EPGS are provided
- update vignette by switching eval in chunk-10 from FALSE to TRUE, and improve readability
- add possibility to use user-defined palette for continuous data
- add possibility to obtain different EPSG to geometries_data() (now, only WGS84 is available)
- Improve code readability by deleting the rows containing saving arguments and chunk (now they are commented, thus practically removed from the functions, they can be deleted)