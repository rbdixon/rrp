TEST = mutate(TEST, dataset="TEST")
TRAIN = mutate(TRAIN, dataset="TRAIN")
DATA = bind_rows(TEST, TRAIN)