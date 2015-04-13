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

CITIES = geocode_cities(c(TEST$City, TRAIN$City))
cache("CITIES")