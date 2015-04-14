if (!exists("model.mars")) {
  set.seed(1)
  model.mars = train( 
    form = revenue ~ .,
    data = TRAIN_CLEAN, 
    method = "earth"
  )
}

if (!exists("model.lm")) {
  set.seed(1)
  model.lm = train(
    form = revenue ~.,
    data = TRAIN_CLEAN,
    method = "lm"
  )
}

models = list(
  LM = model.lm,
  MARS = model.mars
)

models.compare = resamples( models )

print(summary(models.compare))