transform_dependent = function(D, corlim=0.9) {
  
  D %>%
    # Not useful for modeling
    select(-Id, -dataset) %>%
    # Not needed: https://www.kaggle.com/c/restaurant-revenue-prediction/forums/t/13018/city-names/70115
    # left_join(CITIES, by=c("City"="city")) %>%
    mutate(
      # Parse date
      Open.Date = mdy(Open.Date),
      recent = year(Open.Date)>=2010,
#       year = year(Open.Date),
#       days_since_open = as.integer( ymd("2015-04-01") - Open.Date ),
      
      # dummy Type
      typeFC = Type=="FC",
      typeIL = Type=="IL",
      typeDT = Type=="DT"
    ) %>%
  
    # Factorize
    mutate_each(funs(factor), City.Group) %>%
  
    # Mark the NA City Name
    # mutate(City = replace(City, City=="Tanımsız", NA)) %>%
    
    # Test converting some variables to be a boolean with 0==FALSe
    #mutate_each(funs(not(.==0)), P14:P18, P24:P27, P30:P37) %>%
    
    # Scale and sum correlating variables
    # mutate_each( "scale", P31, P11, P21, P5, P4) %>%
    # mutate( cmv = sum(P31, P11, P21, P5, P4) ) %>%
    # 95% cor: P31, P11, P21, P5, P4
    select( -P11, -P21, -P5, -P4 ) %>% 

    # Test Damon's suggestion to cut revenue and assign a level
    left_join(CITY_TO_REVCUT, by="City") %>%
    mutate(
      revcut = replace(revcut, is.na(revcut), "C"),
      sdrevenue = replace(sdrevenue, is.na(sdrevenue), "E")
    ) %>%
  
    # Mark 
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