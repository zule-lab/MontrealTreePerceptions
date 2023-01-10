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



# Targets: input ----------------------------------------------------------

targets_input <- c(
  
  tar_file_read(mtl_eng_raw,
           "input/survey/UrbanForestCommunitySurvey_Montreal_ENG_corrected.csv",
           read.csv(file = !!.x, skip = 1)),
  
  tar_file_read(mtl_fre_raw,
           "input/survey/UrbanForestCommunitySurvey_Montreal_FRE_corrected.csv",
           read.csv(file = !!.x, skip = 1)),
  
  tar_target(
    mtl_eng_clean,
    clean_mtl_eng(mtl_eng_raw)
  ),
  
  tar_target(
    mtl_fre_clean,
    clean_mtl_fre(mtl_fre_raw)
  ),
  
  tar_target(
    mtl_clean,
    rbind(mtl_eng_clean, mtl_fre_clean) # need to remove duplicates? matching IP addresses across FR/EN surveys?
  )
  
)


# Targets: models ---------------------------------------------------------



# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)

