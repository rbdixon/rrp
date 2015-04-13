geocode_cities = function(c) {
  c = unique(c)
  CITIES = data.frame(
    city = c,
    full_city = paste(c, "Turkey", sep=", "),
    stringsAsFactors = FALSE
  ) %>%
    tbl_df %>%
    group_by(city, full_city) %>%
    do({
      suppressMessages(geocode(.$full_city, output="latlon"))
    })
  return(CITIES)
}

# This may be disallowed: https://www.kaggle.com/c/restaurant-revenue-prediction/forums/t/13018/city-names/68645
# Also: All the cities in train and test are in Turkey, except for "Tanımsız" which means undefined in Turkish.

CITIES = geocode_cities(c(TEST$City, TRAIN$City))
cache("CITIES")