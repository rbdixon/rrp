unzip("raw/test.csv.zip", exdir="raw")
TEST = read.csv("raw/test.csv", stringsAsFactors=FALSE)
cache("TEST")