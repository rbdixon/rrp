TEST_CLEAN = clean_data(TEST)

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
  fn = paste("reports/submission_", year(now()), month(now()), day(now()), "_", name, ".csv", sep="")
  write.table(D, fn, row.names=FALSE, quote=FALSE, sep=",")
})