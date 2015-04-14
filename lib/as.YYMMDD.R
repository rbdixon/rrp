as.YYYMMDD = function(t) {
  paste(year(t), sprintf("%02d", month(t)), mday(t), sep="")
}