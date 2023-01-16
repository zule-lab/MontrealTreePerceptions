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
  
  # model
  tar_target(
    cohesion_mod,
    sem('
        # regressions 
        social_cohesion_new_1_help_neighbors + social_cohesion_new_2_close_knit_neighborhood + social_cohesion_new_3_neighborhood_trust + social_cohesion_new_4_negative_people_don_t_get_along_reversed + social_cohesion_new_5_negative_do_not_share_values_reverse ~ city_type + years_neigh + years_urban + housing_code + housing_type_of_dwelling + canborn + canborn_par + esl + language_french_spoken + decade + edu + gender_f
        ',
        data = mtl_clean,
        ordered = T)
    
  )
  
)

