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
    values_mod,
    
  )
  
)

