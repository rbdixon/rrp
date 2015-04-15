TEST_CLEAN = clean_data(TEST)
if (any(is.na(TEST_CLEAN))) warning("NA's in TEST_CLEAN")

# Create predictions
predictions = plyr::llply(models, function(m) {
  predict(m, TEST_CLEAN)
})

# Save predictions
plyr::llply( names(predictions), function(name) {
  D = data.frame(
    Id = 0:(length(predictions[[name]])-1),
    Prediction = predictions[[name]]
  )
  if (nrow(D)<100000) warning(sprintf("Model %s has only %d rows in prediction", name, nrow(D)))
  fn = paste("reports/submission_", as.YYYYMMDD(now()), "_", name, ".csv", sep="")
  write.table(D, fn, row.names=FALSE, quote=FALSE, sep=",")
})