table1 <- countrycoord_data()
table2 <- countrycoord_data(exclude.iso.na = FALSE)
table3 <- countrycoord_data(countries.list = c("IT", "FR", "US"))
table3b <- countrycoord_data(countries.list = c("IT", "FR", "US"), crs = 3035)

# Verifying that a warning is issued if one of the elements in the list
# does not have a match in the data base
table4 <- countrycoord_data(countries.list = c("IT", "FR", "US", "OSS"))

countrycoord_data(countries.list = c("GB"), UK_as_GB = T)
countrycoord_data(countries.list = c("GB"), UK_as_GB = F)
countrycoord_data(countries.list = c("UK"), UK_as_GB = T)
countrycoord_data(countries.list = c("UK"), UK_as_GB = F) 

# if you want to use GB, then give GB in the list! This is already enforced in worldmap functions
