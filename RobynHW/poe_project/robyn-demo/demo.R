# Cargar librería
library(Robyn)

# # Verificar última versión
# packageVersion("Robyn")

# Usar ambiente virtual donde esta la libreria de python nevergrad
library(reticulate)
# use_virtualenv("/Users/santiagolondono/Documents/Proyectos/Rutilities/RobynHW/poe_project/venv", required = TRUE)
# use_virtualenv("/Users/santiagolondono/Documents/Proyectos/Rutilities/RobynHW/poe_project/robyn-demo/venv", required = TRUE)
# use_virtualenv("/Users/santlond/Library/Caches/pypoetry/virtualenvs/robyn-demo-VLVXTbaO-py3.9", required = TRUE)
use_virtualenv("/Users/santlond/Documents/Per/Rutilities/RobynHW/poe_project/robyn-demo/venv", required = TRUE)

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
robyn_object <- "/Users/santlond/Documents"

# ################################################################
# #### Step 2a: For first time user: Model specification in 4 steps

# #### 2a-1: First, specify input variables

# ## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
# ## All sign control are now automatically provided: "positive" for media & organic variables
# ## and "default" for all others. User can still customise signs if necessary. Documentation
# ## is available in ?robyn_inputs
# ## ------------------------------------------------------------------------------------------ ##
# InputCollect <- robyn_inputs(
#   dt_input = dt_simulated_weekly,
#   dt_holidays = dt_prophet_holidays,
#   date_var = "DATE", # date format must be "2020-01-01"
#   dep_var = "revenue", # there should be only one dependent variable
#   dep_var_type = "revenue", # "revenue" (ROI) or "conversion" (CPA)
#   prophet_vars = c("trend", "season", "holiday"), # "trend","season", "weekday" & "holiday"
#   prophet_country = "DE", # input one country. dt_prophet_holidays includes 59 countries by default
#   context_vars = c("competitor_sales_B", "events"), # e.g. competitors, discount, unemployment etc
#   paid_media_spends = c("tv_S", "ooh_S", "print_S", "facebook_S", "search_S"), # mandatory input
#   paid_media_vars = c("tv_S", "ooh_S", "print_S", "facebook_I", "search_clicks_P"), # mandatory.
#   # paid_media_vars must have same order as paid_media_spends. Use media exposure metrics like
#   # impressions, GRP etc. If not applicable, use spend instead.
#   organic_vars = c("newsletter"), # marketing activity without media spend
#   factor_vars = c("events"), # specify which variables in context_vars or organic_vars are factorial
#   window_start = "2016-11-23",
#   window_end = "2018-08-22",
#   adstock = "geometric" # geometric, weibull_cdf or weibull_pdf.
# )
# print(InputCollect)

# #### 2a-2: Second, define and add hyperparameters

# ## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
# ## Default media variable for modelling has changed from paid_media_vars to paid_media_spends.
# ## hyperparameter names needs to be base on paid_media_spends names. Run:
# hyper_names(adstock = InputCollect$adstock, all_media = InputCollect$all_media)
# ## to see correct hyperparameter names. Check GitHub homepage for background of change.
# ## Also calibration_input are required to be spend names.
# ## ------------------------------------------------------------------------------------------ ##

# ## Guide to setup & understand hyperparameters

# ## 1. IMPORTANT: set plot = TRUE to see helper plots of hyperparameter's effect in transformation
# plot_adstock(plot = FALSE)
# plot_saturation(plot = FALSE)

# ## 2. Get correct hyperparameter names:
# # All variables in paid_media_spends and organic_vars require hyperparameter and will be
# # transformed by adstock & saturation.
# # Run hyper_names() as above to get correct media hyperparameter names. All names in
# # hyperparameters must equal names from hyper_names(), case sensitive.
# # Run ?hyper_names to check parameter definition.

# ## 3. Hyperparameter interpretation & recommendation:

# ## Geometric adstock: Theta is the only parameter and means fixed decay rate. Assuming TV
# # spend on day 1 is 100€ and theta = 0.7, then day 2 has 100*0.7=70€ worth of effect
# # carried-over from day 1, day 3 has 70*0.7=49€ from day 2 etc. Rule-of-thumb for common
# # media genre: TV c(0.3, 0.8), OOH/Print/Radio c(0.1, 0.4), digital c(0, 0.3)

# ## Weibull CDF adstock: The Cumulative Distribution Function of Weibull has two parameters
# # , shape & scale, and has flexible decay rate, compared to Geometric adstock with fixed
# # decay rate. The shape parameter controls the shape of the decay curve. Recommended
# # bound is c(0.0001, 2). The larger the shape, the more S-shape. The smaller, the more
# # L-shape. Scale controls the inflexion point of the decay curve. We recommend very
# # conservative bounce of c(0, 0.1), because scale increases the adstock half-life greatly.

# ## Weibull PDF adstock: The Probability Density Function of the Weibull also has two
# # parameters, shape & scale, and also has flexible decay rate as Weibull CDF. The
# # difference is that Weibull PDF offers lagged effect. When shape > 2, the curve peaks
# # after x = 0 and has NULL slope at x = 0, enabling lagged effect and sharper increase and
# # decrease of adstock, while the scale parameter indicates the limit of the relative
# # position of the peak at x axis; when 1 < shape < 2, the curve peaks after x = 0 and has
# # infinite positive slope at x = 0, enabling lagged effect and slower increase and decrease
# # of adstock, while scale has the same effect as above; when shape = 1, the curve peaks at
# # x = 0 and reduces to exponential decay, while scale controls the inflexion point; when
# # 0 < shape < 1, the curve peaks at x = 0 and has increasing decay, while scale controls
# # the inflexion point. When all possible shapes are relevant, we recommend c(0.0001, 10)
# # as bounds for shape; when only strong lagged effect is of interest, we recommend
# # c(2.0001, 10) as bound for shape. In all cases, we recommend conservative bound of
# # c(0, 0.1) for scale. Due to the great flexibility of Weibull PDF, meaning more freedom
# # in hyperparameter spaces for Nevergrad to explore, it also requires larger iterations
# # to converge.

# ## Hill function for saturation: Hill function is a two-parametric function in Robyn with
# # alpha and gamma. Alpha controls the shape of the curve between exponential and s-shape.
# # Recommended bound is c(0.5, 3). The larger the alpha, the more S-shape. The smaller, the
# # more C-shape. Gamma controls the inflexion point. Recommended bounce is c(0.3, 1). The
# # larger the gamma, the later the inflection point in the response curve.

# ## 4. Set individual hyperparameter bounds. They either contain two values e.g. c(0, 0.5),
# # or only one value, in which case you'd "fix" that hyperparameter.

# # Run hyper_limits() to check maximum upper and lower bounds by range
# # Example hyperparameters ranges for Geometric adstock
# hyperparameters <- list(
#   facebook_S_alphas = c(0.5, 3),
#   facebook_S_gammas = c(0.3, 1),
#   facebook_S_thetas = c(0, 0.3),
#   print_S_alphas = c(0.5, 3),
#   print_S_gammas = c(0.3, 1),
#   print_S_thetas = c(0.1, 0.4),
#   tv_S_alphas = c(0.5, 3),
#   tv_S_gammas = c(0.3, 1),
#   tv_S_thetas = c(0.3, 0.8),
#   search_S_alphas = c(0.5, 3),
#   search_S_gammas = c(0.3, 1),
#   search_S_thetas = c(0, 0.3),
#   ooh_S_alphas = c(0.5, 3),
#   ooh_S_gammas = c(0.3, 1),
#   ooh_S_thetas = c(0.1, 0.4),
#   newsletter_alphas = c(0.5, 3),
#   newsletter_gammas = c(0.3, 1),
#   newsletter_thetas = c(0.1, 0.4)
# )

# # Example hyperparameters ranges for Weibull CDF adstock
# # facebook_S_alphas = c(0.5, 3)
# # facebook_S_gammas = c(0.3, 1)
# # facebook_S_shapes = c(0.0001, 2)
# # facebook_S_scales = c(0, 0.1)

# # Example hyperparameters ranges for Weibull PDF adstock
# # facebook_S_alphas = c(0.5, 3
# # facebook_S_gammas = c(0.3, 1)
# # facebook_S_shapes = c(0.0001, 10)
# # facebook_S_scales = c(0, 0.1)

# #### 2a-3: Third, add hyperparameters into robyn_inputs()

# InputCollect <- robyn_inputs(InputCollect = InputCollect, hyperparameters = hyperparameters)
# print(InputCollect)

# # #### Check spend exposure fit if available
# # if (length(InputCollect$exposure_vars) > 0) {
# #   InputCollect$modNLS$plots$facebook_I
# #   InputCollect$modNLS$plots$search_clicks_P
# # }

# ################################################################
# #### Step 3: Build initial model

# ## Run all trials and iterations. Use ?robyn_run to check parameter definition
# OutputModels <- robyn_run(
#   InputCollect = InputCollect, # feed in all model specification
#   # cores = 5, # default to max available
#   # add_penalty_factor = FALSE, # Untested feature. Use with caution.
#   iterations = 2000, # recommended for the dummy dataset
#   trials = 1, # recommended for the dummy dataset
#   outputs = FALSE # outputs = FALSE disables direct model output - robyn_outputs()
# )
# print(OutputModels)

# # ## Check MOO (multi-objective optimization) convergence plots
# # print('Check MOO (multi-objective optimization) convergence plots ..............')
# # OutputModels$convergence$moo_distrb_plot
# # OutputModels$convergence$moo_cloud_plot
# # # check convergence rules ?robyn_converge

# ## Calculate Pareto optimality, cluster and export results and plots. See ?robyn_outputs
# print('Calculate Pareto optimality, cluster and export results and plots. See ?robyn_outputs ..............')
# OutputCollect <- robyn_outputs(
#   InputCollect, OutputModels,
#   pareto_fronts = 3,
#   # calibration_constraint = 0.1, # range c(0.01, 0.1) & default at 0.1
#   csv_out = "pareto", # "pareto" or "all"
#   clusters = TRUE, # Set to TRUE to cluster similar models by ROAS. See ?robyn_clusters
#   plot_pareto = TRUE, # Set to FALSE to deactivate plotting and saving model one-pagers
#   plot_folder = robyn_object # path for plots export
# )
# print(OutputCollect)

# ## 4 csv files are exported into the folder for further usage. Check schema here:
# ## https://github.com/facebookexperimental/Robyn/blob/main/demo/schema.R
# # pareto_hyperparameters.csv, hyperparameters per Pareto output model
# # pareto_aggregated.csv, aggregated decomposition per independent variable of all Pareto output
# # pareto_media_transform_matrix.csv, all media transformation vectors
# # pareto_alldecomp_matrix.csv, all decomposition vectors of independent variables

# ################################################################
# #### Step 4: Select and save the any model

# ## Compare all model one-pagers and select one that mostly reflects your business reality
# print('Printing OutputCollect Object!!!!!!!!!!!!!!!!!!!!')
# print(OutputCollect)
# select_model <- "1_161_2" # Pick one of the models from OutputCollect to proceed

# #### Since 3.7.1: JSON export and import (faster and lighter than RDS files)
# ExportedModel <- robyn_write(InputCollect, OutputCollect, select_model)
# print(ExportedModel)

# ###### DEPRECATED (<3.7.1) (might work)
# # ExportedModelOld <- robyn_save(
# #   robyn_object = robyn_object, # model object location and name
# #   select_model = select_model, # selected model ID
# #   InputCollect = InputCollect,
# #   OutputCollect = OutputCollect
# # )
# # print(ExportedModelOld)
# # # plot(ExportedModelOld)

# ################################################################
# #### Step 5: Get budget allocation based on the selected model above
# print("Step 5 ........................................................")

# ## Budget allocation result requires further validation. Please use this recommendation with caution.
# ## Don't interpret budget allocation result if selected model above doesn't meet business expectation.

# # Check media summary for selected model
# print(ExportedModel)

# # Run ?robyn_allocator to check parameter definition
# # Run the "max_historical_response" scenario: "What's the revenue lift potential with the
# # same historical spend level and what is the spend mix?"
# AllocatorCollect1 <- robyn_allocator(
#   InputCollect = InputCollect,
#   OutputCollect = OutputCollect,
#   select_model = select_model,
#   scenario = "max_historical_response",
#   channel_constr_low = 0.7,
#   channel_constr_up = c(1.2, 1.5, 1.5, 1.5, 1.5),
#   export = TRUE,
#   date_min = "2016-11-21",
#   date_max = "2018-08-20"
# )
# print("AllocatorCollect1 ..............................................")
# print(AllocatorCollect1)
# # plot(AllocatorCollect1)

# # Run the "max_response_expected_spend" scenario: "What's the maximum response for a given
# # total spend based on historical saturation and what is the spend mix?" "optmSpendShareUnit"
# # is the optimum spend share.
# AllocatorCollect2 <- robyn_allocator(
#   InputCollect = InputCollect,
#   OutputCollect = OutputCollect,
#   select_model = select_model,
#   scenario = "max_response_expected_spend",
#   channel_constr_low = c(0.7, 0.7, 0.7, 0.7, 0.7),
#   channel_constr_up = c(1.2, 1.5, 1.5, 1.5, 1.5),
#   expected_spend = 1000000, # Total spend to be simulated
#   expected_spend_days = 7, # Duration of expected_spend in days
#   export = TRUE
# )
# print("Printing AllocatorCollect2 ...................")
# print(AllocatorCollect2)
# AllocatorCollect2$dt_optimOut
# # plot(AllocatorCollect2)

# ## A csv is exported into the folder for further usage. Check schema here:
# ## https://github.com/facebookexperimental/Robyn/blob/main/demo/schema.R

# ## QA optimal response
# print("QA optimal response ..................................")
# # Pick any media variable: InputCollect$all_media
# # select_media <- "search_S"
# select_media <- "tv_S"

# print('Printing metric_value')
# # For paid_media_spends set metric_value as your optimal spend
# metric_value <- AllocatorCollect1$dt_optimOut$optmSpendUnit[
#   AllocatorCollect1$dt_optimOut$channels == select_media
# ]; metric_value
# # For paid_media_vars and organic_vars, manually pick a value
# # metric_value <- 10000

# if (TRUE) {
#   print('Getting optimal_response_allocator .........................')
#   optimal_response_allocator <- AllocatorCollect1$dt_optimOut$optmResponseUnit[
#     AllocatorCollect1$dt_optimOut$channels == select_media
#   ]
#   print('Getting optimal_response ...........................')
#   optimal_response <- robyn_response(
#     InputCollect = InputCollect,
#     OutputCollect = OutputCollect,
#     select_model = select_model,
#     select_build = 0,
#     media_metric = select_media,
#     metric_value = metric_value
#   )
#   # print('ploting optimal_response$plot')
#   # plot(optimal_response$plot)
#   print('Is length optimal_response_allocator greater than 0?')
#   print(length(optimal_response_allocator))
#   if (length(optimal_response_allocator) > 0) {
#     cat("QA if results from robyn_allocator and robyn_response agree: ")
#     cat(round(optimal_response_allocator) == round(optimal_response$response), "( ")
#     cat(optimal_response$response, "==", optimal_response_allocator, ")\n")
#   }
# }

################################################################
#### Step 6: Model refresh based on selected model and saved results "Alpha" [v3.7.1]

## Must run robyn_write() (manually or automatically) to export any model first, before refreshing.
## The robyn_refresh() function is suitable for updating within "reasonable periods".
## Two situations are considered better to rebuild model:
## 1. most data is new. If initial model has 100 weeks and 80 weeks new data is added in refresh,
## it might be better to rebuild the model. Rule of thumb: 50% of data or less can be new.
## 2. new variables are added.

# Provide JSON file with your InputCollect and ExportedModel specifications
# It can be any model, initial or a refresh model
json_file <- "/Users/santlond/Documents/Robyn_202209060918_init/RobynModel-1_161_2.json"
RobynRefresh <- robyn_refresh(
  json_file = json_file,
  dt_input = dt_simulated_weekly,
  dt_holidays = dt_prophet_holidays,
  refresh_steps = 13,
  refresh_iters = 1000, # 1k is an estimation
  refresh_trials = 1
)

InputCollect <- RobynRefresh$listRefresh1$InputCollect
OutputCollect <- RobynRefresh$listRefresh1$OutputCollect
select_model <- RobynRefresh$listRefresh1$OutputCollect$selectID

################################################################
#### Step 7: Get budget allocation recommendation based on selected refresh runs

# Run ?robyn_allocator to check parameter definition
print('Step 7 ...................')
AllocatorCollect <- robyn_allocator(
  InputCollect = InputCollect,
  OutputCollect = OutputCollect,
  select_model = select_model,
  scenario = "max_response_expected_spend",
  channel_constr_low = c(0.7, 0.7, 0.7, 0.7, 0.7),
  channel_constr_up = c(1.2, 1.5, 1.5, 1.5, 1.5),
  expected_spend = 2000000, # Total spend to be simulated
  expected_spend_days = 14 # Duration of expected_spend in days
)
print(AllocatorCollect)

################################################################
#### Step 8: get marginal returns

## Example of how to get marginal ROI of next 1000$ from the 80k spend level for search channel

# Run ?robyn_response to check parameter definition

## -------------------------------- NOTE v3.6.0 CHANGE !!! ---------------------------------- ##
## The robyn_response() function can now output response for both spends and exposures (imps,
## GRP, newsletter sendings etc.) as well as plotting individual saturation curves. New
## argument names "media_metric" and "metric_value" instead of "paid_media_var" and "spend"
## are now used to accommodate this change. Also the returned output is a list now and
## contains also the plot.
## ------------------------------------------------------------------------------------------ ##

# Get response for 80k from result saved in robyn_object
Spend1 <- 60000
Response1 <- robyn_response(
  InputCollect = InputCollect,
  OutputCollect = OutputCollect,
  select_model = select_model,
  media_metric = "search_S",
  metric_value = Spend1
)
print('ROI for search 60k')
Response1$response / Spend1 # ROI for search 80k
# Response1$plot

# Get response for +10%
Spend2 <- Spend1 * 1.1
Response2 <- robyn_response(
  InputCollect = InputCollect,
  OutputCollect = OutputCollect,
  select_model = select_model,
  media_metric = "search_S",
  metric_value = Spend2
)
print('ROI for search 61k')
Response2$response / Spend2 # ROI for search 81k

print('Marginal ROI of next 1000$ from 80k spend level for search')
# Marginal ROI of next 1000$ from 80k spend level for search
(Response2$response - Response1$response) / (Spend2 - Spend1)

## Example of getting paid media exposure response curves
print('facebook_S')
imps <- 50000000
response_imps <- robyn_response(
  InputCollect = InputCollect,
  OutputCollect = OutputCollect,
  select_model = select_model,
  media_metric = "facebook_S",
  metric_value = imps
)

print('ROI media exposure facebook_I')
response_imps$response / imps * 1000
# response_imps$plot

print('print_S')
## Example of getting organic media exposure response curves
sendings <- 30000
response_sending <- robyn_response(
  InputCollect = InputCollect,
  OutputCollect = OutputCollect,
  select_model = select_model,
  media_metric = "print_S",
  metric_value = sendings
)
print('ROI print_S')
response_sending$response / sendings * 1000


jpeg('/Users/santlond/Documents/rplot.jpg')
response_sending$plot
dev.off()