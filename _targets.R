# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille & Isabella Richmond

# MEETING W AM
# TODO
# change sampler starting values w init to try and help convergence
# use 1000 iterations w 8 chains 
# take out question_category, can calculate post hoc if needed 
# use subset of data and test w that 
# change exponential prior to normal(0, 0,2)
# do predictions with prior only model - is the variation in question and individual representative of the dataset
# - we want a plausible range that is close to real data 
# make homogenous subset of data in different ways and see if that is creating the biomodal dist 
# bottom line: find out if problem is the model or the data
# adjustment for direct effect of language includes city type, ethnicity, immigration

# Source ------------------------------------------------------------------
library(targets)
tar_source('R')



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')



# Renv --------------------------------------------------------------------
activate()
snapshot()
restore()



# Targets -----------------------------------------------------------------
c(
  
  # DAG,
  tar_target(
    dag,
    create_dag()
  ),
  
  # load survey data
  tar_file_read(mtl_raw,
           "input/survey/Montreal_cleaned.csv", # raw survey data from Qualtrics cleaned by Camilo & Kuan
           read.csv(file = !!.x)),
  
  # clean for analysis
  tar_target(
    mtl_clean,
    clean_mtl(mtl_raw)
  ),
  
  # make long for initial model
  tar_target(
    mtl_long,
    mtl_clean %>%
      pivot_longer(cols = starts_with(c('uf_vals', 'beliefs'))) %>%
      mutate(question = name,
             score = value,
             question_category = case_when(startsWith(question, 'uf_vals') ~ 'values',
                                           startsWith(question, 'beliefs_negative') ~ 'negative_beliefs',
                                           startsWith(question, 'beliefs_extra_negative') ~ 'extra_negative_beliefs',
                                           startsWith(question, 'beliefs_positive') ~ 'positive_beliefs',
                                           startsWith(question, 'beliefs_extra_positive') ~ 'extra_positive_beliefs'))
    
  ),
  
  # explore variance using random effects model 
  # note: models are misspecified 
  # TODO: add zarg
  
  tar_target(
    init_model_prior,
    brm(bf(score ~ 1 + (1|id) + (1|question) + (1|question_category)),
        data = mtl_long,
        family = cumulative(),
        prior = c(prior(normal(-2.5, 0.4),  class = "Intercept", coef = "1"),
                  prior(normal(-1.5, 0.4),  class = "Intercept", coef = "2"),
                  prior(normal(-0.5, 0.2),   class = "Intercept", coef = "3"),
                  prior(normal(0.5, 0.4),   class = "Intercept", coef = "4"),
                  prior(exponential(4), class = "sd")),
        sample_prior = "only",
        cores = getOption("mc.cores", 8),
        chains = 4,
        backend = 'cmdstanr')
  ),
  
  tar_target(
    init_model_cmdstanr,
    brm(bf(score ~ 1 + (1|id) + (1|question) + (1|question_category)),
        data = mtl_long,
        family = cumulative(), 
        prior = c(prior(normal(-2.5, 0.4),  class = "Intercept", coef = "1"),
                  prior(normal(-1.5, 0.4),  class = "Intercept", coef = "2"),
                  prior(normal(-0.5, 0.2),   class = "Intercept", coef = "3"),
                  prior(normal(0.5, 0.4),   class = "Intercept", coef = "4"),
                  prior(exponential(4), class = "sd")),
        cores = getOption("mc.cores", 8),
        chains = 4,
        backend = 'cmdstanr')
  )
  

  
)

