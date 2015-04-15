# Validate holdout
VALIDATE_CLEAN = TRAIN_CLEAN %>% 
  filter(holdout) %>%
  select(-holdout)

models.validate = plyr::llply(models, function(m) {
  obs  = VALIDATE_CLEAN$revenue
  pred = predict(m, select(VALIDATE_CLEAN, -revenue))
  RMSE(pred, obs)
})

plyr::ldply(models.validate) %>%
  tbl_df %>%
  rename(
    model = .id,
    value = V1
  ) %>%
  mutate(
    date = as.YYYYMMDD(now()),
    metric = "RMSE-HOLDOUT"
  ) %>%
  select(date, model, metric, value) %>%
  write.csv(paste("reports/metrics/metrics_", as.YYYYMMDD(now()), "_holdout.csv", sep=""), row.names=FALSE)
