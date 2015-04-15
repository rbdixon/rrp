# Crank up MC
registerDoMC(cores = 4)

# Remove models under dev
if (exists("model.rf")) { rm( "model.rf" ) }

tc = trainControl(
  method = "repeatedcv",
  repeats = 10
  )

if (!exists("model.mars")) {
  set.seed(1)
  model.mars = train( 
    form = revenue ~ .,
    data = filter(TRAIN_CLEAN, !holdout) %>% select(-holdout), 
    method = "earth",
    trControl = tc
  )
}

if (!exists("model.rf")) {
  set.seed(1)
  # Useful! http://www.bios.unc.edu/~dzeng/BIOS740/randomforest.pdf
  model.rf = train( 
    form = revenue ~ .,
    data = filter(TRAIN_CLEAN, !holdout) %>% select(-holdout), 
    method = "rf",
    importance = TRUE,
    trControl = tc,
    # See http://stackoverflow.com/questions/10498477/carettrain-specify-model-generation-parameters
    tuneGrid = data.frame(.mtry=c(2:8))
  )
}

if (!exists("model.lm")) {
  set.seed(1)
  model.lm = train(
    form = revenue ~.,
    data = filter(TRAIN_CLEAN, !holdout) %>% select(-holdout), 
    method = "lm",
    trControl = tc
  )
}

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

print(model.rf$finalModel)
print(summary(models.compare))
