as.YYYYMMDD = function(t) {
  sprintf("%d%02d%02d", year(t), month(t), mday(t))
}
