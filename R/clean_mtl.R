clean_mtl <- function(mtl_raw){
  
  mtl_cols <- clean_names(mtl_raw)
  
  mtl_sel <- mtl_cols %>% 
    select(c(id, recorded_date, location_latitude, location_longitude, postcode, language, in_which_city_or_municipal_boundary_do_you_live_in,
             city_type, starts_with("uf_vals"), starts_with("beliefs"), starts_with("wtp"), starts_with("knowledge"), tree_in_front_of_house_original,
             planted_a_tree_original, contact_council_for_trees_original, provide_feedback_new, starts_with("hours"), 
             starts_with("tree"), starts_with("mgmt"), starts_with("city"), starts_with("social"), years_neigh, years_urban,
             years_rural, housing_code, housing_type_of_dwelling, canborn, can_born_year_in_canada, canborn_par, esl, language_1, 
             language_french_spoken, decade, age40, edu, edu_uni, envorg, ethnicity, ethnicity_other, gender_f))
  
  mtl_code <- mtl_sel %>%
    mutate(
      years_neigh = as.numeric(years_neigh),
      
      years_urban = as.numeric(years_urban),
      
      housing_type_of_dwelling = case_when(housing_type_of_dwelling %in% "House / Maison" == T ~ 0,
                                           housing_type_of_dwelling %in% "Apartment house / Appartement maison" == T ~ 1,
                                           housing_type_of_dwelling %in% "Apartment building / Appartement édifice" == T ~ 2,
                                           housing_type_of_dwelling %in% "Other / Autre" == T ~ 3,
                                           housing_type_of_dwelling %in% "Don’t know or Prefer not to answer / Je ne sais pas ou Je préfère ne pas répondre" == T ~ 4),
      
      decade = case_when(decade %in% "20s" == T ~ 0,
                         decade %in% "30s" == T ~ 1, 
                         decade %in% "40s" == T ~ 2,
                         decade %in% "50s" == T ~ 3, 
                         decade %in% "60s" == T ~ 4,
                         decade %in% "70s" == T ~ 5,
                         decade %in% "80s" == T ~ 6, 
                         decade %in% "90s" == T ~ 7,
                         decade %in% "00s" == T ~ 8, 
                         decade %in% "Don’t know / Prefer not to answer" == T ~ 9,
                         decade %in% "Je ne sais pas / Je préfère ne pas répondre" == T ~ 9),
      
      city_type = case_when(city_type %in% "inner" == T ~ 0,
                            city_type %in% "middle" == T ~ 1, 
                            city_type %in% "outer" == T ~ 2, 
                            city_type %in% "regional" == T ~ 3)
      
      
      )
  
  return(mtl_code)
  
  
}