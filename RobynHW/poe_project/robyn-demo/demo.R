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


# Directory where you want to export results to (will create new folders)
robyn_object <- "~/Desktop"

################################################################
#### Step 2a: For first time user: Model specification in 4 steps

#### 2a-1: First, specify input variables

## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
## All sign control are now automatically provided: "positive" for media & organic variables
## and "default" for all others. User can still customise signs if necessary. Documentation
## is available in ?robyn_inputs
## ------------------------------------------------------------------------------------------ ##
InputCollect <- robyn_inputs(
  dt_input = dt_simulated_weekly,
  dt_holidays = dt_prophet_holidays,
  date_var = "DATE", # date format must be "2020-01-01"
  dep_var = "revenue", # there should be only one dependent variable
  dep_var_type = "revenue", # "revenue" (ROI) or "conversion" (CPA)
  prophet_vars = c("trend", "season", "holiday"), # "trend","season", "weekday" & "holiday"
  prophet_country = "DE", # input one country. dt_prophet_holidays includes 59 countries by default
  context_vars = c("competitor_sales_B", "events"), # e.g. competitors, discount, unemployment etc
  paid_media_spends = c("tv_S", "ooh_S", "print_S", "facebook_S", "search_S"), # mandatory input
  paid_media_vars = c("tv_S", "ooh_S", "print_S", "facebook_I", "search_clicks_P"), # mandatory.
  # paid_media_vars must have same order as paid_media_spends. Use media exposure metrics like
  # impressions, GRP etc. If not applicable, use spend instead.
  organic_vars = c("newsletter"), # marketing activity without media spend
  factor_vars = c("events"), # specify which variables in context_vars or organic_vars are factorial
  window_start = "2016-11-23",
  window_end = "2018-08-22",
  adstock = "geometric" # geometric, weibull_cdf or weibull_pdf.
)
print(InputCollect)

?robyn_inputs