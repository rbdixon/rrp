if (!exists("model.lm")) {
  set.seed(1)
  model.lm = train(
    form = train_formula,
    data = TRAIN_CLEAN,
    method = "lm",
    trControl = tc
  )
  cache("model.lm")
}