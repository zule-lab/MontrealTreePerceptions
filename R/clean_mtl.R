clean_mtl <- function(mtl_raw){
  
  mtl_cols <- clean_names(mtl_raw)
  
  mtl_sel <- mtl_cols %>% 
    select(c(id, recorded_date, location_latitude, location_longitude, postcode, language, in_which_city_or_municipal_boundary_do_you_live_in,
             city_type, starts_with("uf_vals"), starts_with("beliefs"), starts_with("wtp"), starts_with("knowledge"), tree_in_front_of_house_original,
             planted_a_tree_original, contact_council_for_trees_original, provide_feedback_new, starts_with("hours"), 
             starts_with("tree"), starts_with("mgmt"), starts_with("city"), starts_with("social"), years_neigh, years_urban,
             years_rural, housing, housing_other, housing_type_of_dwelling, housing_type_of_dwelling_other, canborn, 
             can_born_year_in_canada, canborn_par, esl, language_1, language_french_spoken, decade, education, envorg,
             ethnicity, ethnicity_other, gender, gender_other))
  
  
  
  
}