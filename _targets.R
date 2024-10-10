# === Targets -------------------------------------------------------------

# Source ------------------------------------------------------------------
library(targets)
tar_source('R')



# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')
options(timeout=100)


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
      pivot_longer(cols = starts_with(c('uf_vals', 'beliefs', 'tree_satisfaction'))) %>%
      mutate(question = name,
             score = value,
             question_category = case_when(startsWith(question, 'uf_vals') ~ 'values',
                                           startsWith(question, 'beliefs_negative') ~ 'negative_beliefs',
                                           startsWith(question, 'beliefs_extra_negative') ~ 'extra_negative_beliefs',
                                           startsWith(question, 'beliefs_positive') ~ 'positive_beliefs',
                                           startsWith(question, 'beliefs_extra_positive') ~ 'extra_positive_beliefs',
                                           startsWith(question, 'tree_satisfaction') ~ 'tree_satisfaction'))
    
  ),
  
  # explore variance using random effects model 
  # note: models are misspecified 
  # change exponential prior to normal(0, 0.2)
  
  zar_brms(
    language_de,
    #bf(score ~ 1 + firstlanguage + city_type + ethncode + decade_num + (1|id) + (1|question)),
    bf(score ~ 1),
    family = cumulative(probit),
    prior = c(#prior(normal(0, 0.5), class = "b"),
              prior(normal(-1, 0.5), class = "Intercept", coef = "1"),
              prior(normal(-0.5, 0.5),  class = "Intercept", coef = "2"),
              prior(normal(0, 0.5),   class = "Intercept", coef = "3"),
              prior(normal(0.5, 0.5),   class = "Intercept", coef = "4")),
              #prior(normal(1, 0.5), class = "sd")),
    backend = 'cmdstanr',
    data = mtl_long,
    chains = 4,
    iter = 1000,
    cores = 4,
    init = 0.2
    )

  
)

