# Cargar librería
library(Robyn)

# # Verificar última versión
# packageVersion("Robyn")

# Usar ambiente virtual donde esta la libreria de python nevergrad
library(reticulate)
use_virtualenv("/Users/santiagolondono/Documents/Proyectos/Rutilities/RobynHW/poe_project/venv", required = TRUE)

#### Step 1: Load data
## Check simulated dataset or load your own dataset
data("dt_simulated_weekly")
head(dt_simulated_weekly)
str(dt_simulated_weekly)
