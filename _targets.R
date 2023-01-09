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


# Scripts -----------------------------------------------------------------
# tar_source('scripts')
tar_source('scripts')


# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets" lists above

lapply(grep('targets', ls(), value = TRUE), get)
