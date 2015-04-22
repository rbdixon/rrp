cut_revenue = function(r) {
  cut(r, 5, labels=c(LETTERS[1:5]), ordered_result=TRUE)
}

CITY_TO_REVCUT = DATA %>%
  group_by(City) %>%
  summarize(
    sdrevenue = sd(revenue, na.rm=TRUE),
    revenue = median( revenue, na.rm=TRUE )
  ) %>%
  mutate(
    revcut = cut_revenue(revenue),
    revcut = replace(revcut, is.na(revcut), "C"),
    sdrevenue = cut(sdrevenue, 5, labels=c(LETTERS[1:5]), ordered=TRUE)
  ) %>%
  select(-revenue)
  identity