# Crank up MC
registerDoMC(cores = 4)

# Nuke the models. Comment to load cached copies.
rm(list=ls(pattern="model.*"))

# Set training control defaults
tc = trainControl(
  method = "repeatedcv",
  repeats = 10
  )

# Training formula
train_formula = revenue ~ .^2