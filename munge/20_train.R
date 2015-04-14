if (!exists("model.mars")) {
  set.seed(1)
  model.mars = train( 
    form = revenue ~ .,
    data = filter(TRAIN_CLEAN, !holdout), 
    method = "earth"
  )
}

if (!exists("model.lm")) {
  set.seed(1)
  model.lm = train(
    form = revenue ~.,
    data = filter(TRAIN_CLEAN, !holdout), 
    method = "lm"
  )
}

models = list(
  LM = model.lm,
  MARS = model.mars
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