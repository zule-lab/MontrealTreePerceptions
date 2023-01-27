clean_mtl <- function(mtl_raw){
  
  mtl_cols <- clean_names(mtl_raw)
  
  mtl_sel <- mtl_cols %>% 
    select(c(id, recorded_date, location_latitude, location_longitude, postcode, language, in_which_city_or_municipal_boundary_do_you_live_in,
             starts_with("uf_vals"), starts_with("beliefs"), city_type, housing_code, housing_type_of_dwelling, 
             canborn, canborn_par, esl, language, language_french_spoken, edu))
  
  mtl_code <- mtl_sel %>%
    mutate(
      
      city_type = case_when(city_type %in% "inner" == T ~ 1,
                            city_type %in% "middle" == T ~ 2, 
                            city_type %in% "outer" == T ~ 3, 
                            city_type %in% "regional" == T ~ 4),
      
      # housing code: 1 = own, 2 = rent, 3 = other
      
      housing_type_of_dwelling = case_when(housing_type_of_dwelling %in% "House / Maison" == T ~ 1,
                                           housing_type_of_dwelling %in% "Apartment house / Appartement maison" == T ~ 2,
                                           housing_type_of_dwelling %in% "Apartment building / Appartement édifice" == T ~ 3,
                                           housing_type_of_dwelling %in% "Other / Autre" == T ~ 4,
                                           housing_type_of_dwelling %in% "Don’t know or Prefer not to answer / Je ne sais pas ou Je préfère ne pas répondre" == T ~ 5),
      
      immigrant = case_when(canborn %in% 1 & canborn_par %in% 1 ~ 1, # 2nd gen Canadian
                            canborn %in% 1 & canborn_par %in% 0 ~ 2, # 1st gen Canadian
                            canborn %in% 0 & canborn_par %in% 0 ~ 3, # 1st gen immigrant
                            canborn %in% 0 & canborn_par %in% 1 ~ 4 # foreign born Canadian
                            ),
      
      firstlanguage = case_when(esl %in% 1 & language_french_spoken %in% 1 ~ 1, # french first language
                                esl %in% 0 ~ 2, # english first language
                                esl %in% 1 & language_french_spoken %in% 0 & language %in% "French" ~ 3, # french second language
                                esl %in% 1 & language_french_spoken %in% 0 & language %in% "English" ~ 4# english second language
                                ) 
      
      # edu: 0 = prefer not to answer, 1 = did not complete high school, 2 = high school, 3 = trade school, 4 = bac, 5 = masters, 6 = doc
      
      )
  
  return(mtl_code)
  
  
}