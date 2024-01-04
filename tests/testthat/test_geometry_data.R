table1 <- geometries_data()
table2 <- geometries_data(exclude.iso.na = FALSE)
table3 <- geometries_data(countries.list = c("IT", "FR", "US"))

# Verifying that a warning is issued if one of the elements in the list
# does not have a match in the data base
table4 <- geometries_data(countries.list = c("IT", "FR", "US", "OSS"))
