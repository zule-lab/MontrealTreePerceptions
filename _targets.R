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
    sem('
        # regressions 
        uf_vals_large_old_trees + uf_vals_a_place_for_human_history_and_stories + uf_vals_getting_away_from_stresses_of_everyday_life + uf_vals_a_place_for_a_short_walk + uf_vals_learning_about_cultural_traditions + uf_vals_a_place_that_is_accessible_for_everybody + uf_vals_clean_air_clean_water_and_healthy_cities + uf_vals_habitat_for_rare_or_threatened_plants_birds_and_animals + uf_vals_make_the_city_more_welcoming + uf_vals_a_more_liveable_city + uf_vals_spaces_for_people_to_interact_and_socialise + uf_vals_improving_community_cohesion + uf_vals_beautiful_sights_sounds_and_smells + uf_vals_a_healthy_environment_that_supports_human_life + uf_vals_attracting_tourists_and_residents_to_the_city +  uf_vals_maintaining_aboriginal_or_european_culture ~ city_type + housing_code + housing_type_of_dwelling + edu + immigrant + firstlanguage
        ',
        data = mtl_clean,
        ordered = T)
    
  ),
  
  tar_target(
    posbeliefs_mod,
    sem('
        # regressions 
        beliefs_positives_attract_desirable_animals + beliefs_positives_screen_unattractive_views + beliefs_positives_make_streets_and_parks_safer + beliefs_positives_are_calming + beliefs_positives_clean_the_air + beliefs_positives_provide_shade + beliefs_positives_produce_oxygen + beliefs_positives_cool_the_neighborhood + beliefs_positives_reduce_flooding + beliefs_positives_make_a_place_good_for_exercise_walk_run_cycle + beliefs_positives_make_a_place_good_for_shopping + beliefs_positives_increase_property_values + beliefs_positives_are_spiritual + beliefs_extra_positive_make_me_feel_healthy ~ city_type + housing_code + housing_type_of_dwelling + edu + immigrant + firstlanguage
        ',
        data = mtl_clean,
        ordered = T)
    
  ),
  
  tar_target(
    negbeliefs_mod,
    sem('
        # regressions 
        beliefs_negatives_cause_allergies + beliefs_negatives_block_the_visibility_of_road_signs + beliefs_negatives_damage_property_including_concrete_paths_and_powerlines + beliefs_negatives_create_mess +  beliefs_negatives_are_ugly + beliefs_negatives_use_too_much_water + beliefs_negatives_block_water_pipes_and_drains + beliefs_negatives_block_the_sun +  beliefs_negatives_are_expensive_to_maintain + beliefs_negatives_drop_branches + beliefs_negatives_take_up_too_much_space + beliefs_negatives_promote_wildfires + beliefs_negatives_attract_undesirable_animals + beliefs_extra_negative_make_me_feel_stressed ~ city_type + housing_code + housing_type_of_dwelling + edu + immigrant + firstlanguage
        ',
        data = mtl_clean,
        ordered = T)
    
  ),
  
  tar_quarto(
    meeting_report,
    path = "meeting_report.qmd"
  )
  
)

