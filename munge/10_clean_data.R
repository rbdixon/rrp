clean_data = function(D) {
  D %>%
    # Not useful for modeling
    select(-Id, -dataset) %>%
    left_join(CITIES, by=c("City"="city")) %>%
    mutate(
      # Holdout
      holdout = ifelse(sample(c(TRUE, FALSE), n(), replace=TRUE, prob=c(.2, .8)), TRUE, FALSE),

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
    
    # Cut
    mutate_each(funs( cut(., 4, labels=1:4) ), lat, lon) %>%
#     # Scale the integer columns with differing levels
#     mutate_each(funs(scale), P1, P5, P7, P9, P15, P17, P18, P21, P25, P30, P33:P36) %>%
#     # Scale the non-integer columns
#     mutate_each(funs(scale), P2:P4, P13, P26:P29)
    # For now drop all but the mystery vars
    select(
      -Open.Date,
      -City,
      -full_city,
      -Type
    ) %>%
    identity
}

set.seed(1)
TRAIN_CLEAN = clean_data(TRAIN)