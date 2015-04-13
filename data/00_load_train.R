unzip("raw/train.csv.zip", exdir="raw")
TRAIN = read.csv("raw/train.csv", stringsAsFactors=FALSE)
cache("TRAIN")