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
# print(colnames(dt_simulated_weekly))


## Check holidays from Prophet
# 59 countries included. If your country is not included, please manually add it.
# Tipp: any events can be added into this table, school break, events etc.
data("dt_prophet_holidays")
head(dt_prophet_holidays)
str(dt_prophet_holidays)

# # Unique countries
# unique(dt_prophet_holidays$country)

# Exploring CO country
# dt_prophet_holidays %>% filter(country == "CO")

# tail(dt_prophet_holidays[dt_prophet_holidays$country == "CO",])
# dt_p_h_co <- dt_prophet_holidays[dt_prophet_holidays$country == "CO",]
# unique(dt_simulated_weekly$events)


# # Directory where you want to export results to (will create new folders)
# robyn_object <- "~/Desktop"

