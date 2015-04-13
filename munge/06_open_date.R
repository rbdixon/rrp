DATA %<>%
  mutate(
    date = mdy(Open.Date)
  )