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
