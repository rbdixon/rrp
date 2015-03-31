unzip("raw/test.csv.zip", exdir="raw")
TEST = read.csv("raw/test.csv")
cache("TEST")