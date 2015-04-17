models = list(
  LM = model.lm,
  MARS = model.mars,
  RF = model.rf
)

models.compare = resamples( models )

# Save comparison for the historical record
models.compare$values %>%
  select(-Resample) %>%
  gather(modelmetric, value, everything()) %>%
  separate(modelmetric, c("model", "metric")) %>%
  filter(metric=="RMSE") %>%
  group_by(model, metric) %>%
  summarize(rmse = mean(value)) %>%
  mutate(
    date = as.YYYYMMDD(now())
  ) %>%
  select(date, model, metric, value=rmse) %>%
  write.csv(paste("reports/metrics/metrics_", as.YYYYMMDD(now()), "_train.csv", sep=""), row.names=FALSE)

print(summary(models.compare))
