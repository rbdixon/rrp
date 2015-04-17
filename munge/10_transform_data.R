transform_dependent = function(D) {
  D %>%
    # Not useful for modeling
    select(-Id, -dataset) %>%
    # Not needed: https://www.kaggle.com/c/restaurant-revenue-prediction/forums/t/13018/city-names/70115
    # left_join(CITIES, by=c("City"="city")) %>%
    mutate(
      # Parse date
      Open.Date = mdy(Open.Date),
      recent = year(Open.Date)>=2011,
      
      # dummy Type
      typeFC = Type=="FC",
      typeIL = Type=="IL",
      typeDT = Type=="DT"
    ) %>%
    # Factorize
    mutate_each(funs(factor), City, City.Group) %>%
    
    # For now drop all but the mystery vars
    select(
      -Open.Date,
      -City,
      -Type
    ) %>%
    identity
}

transform_independent = function(D) {
  sdclip = 2
  D %>%
    mutate(
      # Cap revenue outliers
      revenue = ifelse(revenue >= mean(revenue)+sdclip*sd(revenue), sdclip*sd(revenue), revenue)
    )
}

TRAIN_CLEAN = TRAIN %>% 
  transform_independent %>%
  transform_dependent

if (any(is.na(TRAIN_CLEAN))) warning("NA's in TRAIN_CLEAN")