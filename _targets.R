# === Targets -------------------------------------------------------------
# Framework by Alec L. Robitaille & Isabella Richmond



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
    init_model,
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
        backend = 'rstan')
    ),
  
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

