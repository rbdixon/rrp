# Crank up MC
registerDoMC(cores = 4)

# Nuke the models. Comment to load cached copies.
# rm(list=ls(pattern="model.*"))
rm(model.mars)

tc = trainControl(
  method = "repeatedcv",
  repeats = 10
  )

if (!exists("model.mars")) {
  set.seed(1)
  model.mars = train( 
    form = revenue ~ .,
    data = TRAIN_CLEAN,
    method = "earth",
    trControl = tc,
    tuneGrid = data.frame(.degree=c(1:4), .nprune=c(100))
  )
  cache("model.mars")
  print(summary(model.mars$finalModel))
}

if (!exists("model.rf")) {
  set.seed(1)
  # Useful! http://www.bios.unc.edu/~dzeng/BIOS740/randomforest.pdf
  model.rf = train( 
    form = revenue ~ .,
    data = TRAIN_CLEAN,
    method = "rf",
    importance = TRUE,
    trControl = tc,
    # See http://stackoverflow.com/questions/10498477/carettrain-specify-model-generation-parameters
    tuneGrid = data.frame(.mtry=c(2:8))
  )
  cache("model.rf")
  
  # Variable importance
  IMP = model.rf$finalModel %>%
    importance %>%
    as.data.frame %>%
    add_rownames %>%
    rename(
      variable = rowname,
      PctIncMSE = `%IncMSE`
      ) %>%
    arrange(desc(abs(PctIncMSE)))
  
  print(model.rf$finalModel)
  print.data.frame(IMP)
}

if (!exists("model.lm")) {
  set.seed(1)
  model.lm = train(
    form = revenue ~.,
    data = TRAIN_CLEAN,
    method = "lm",
    trControl = tc
  )
  cache("model.lm")
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

print(summary(models.compare))
