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