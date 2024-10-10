clean_mtl <- function(mtl_raw){
  
  mtl_cols <- clean_names(mtl_raw)
  
  mtl_sel <- mtl_cols %>% 
    select(c(id, recorded_date, location_latitude, location_longitude, postcode, language, in_which_city_or_municipal_boundary_do_you_live_in,
             starts_with("uf_vals"), starts_with("beliefs"), starts_with("tree_satisfaction"), 
             city_type, housing_code, housing_type_of_dwelling, 
             canborn, esl, language, language_french_spoken, edu_uni, ethnicity, decade_num))
  
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
      
      immigrant = case_when(canborn %in% 1 ~ 1, # born in Canada
                            canborn %in% 0 ~ 2 # immigrant
                            ),
      
      firstlanguage = case_when(esl %in% 1 & language_french_spoken %in% 1 ~ 1, # french first language
                                esl %in% 0 ~ 2, # english first language
                                esl %in% 1 & language_french_spoken %in% 0 ~ 3), # other first language
      
      education = case_when(edu_uni %in% 0 ~ 1, # not university educated
                            edu_uni %in% 1 ~ 2), # university educated
      
      ethncode = case_when(ethnicity %in% "White/Blanc" == T & canborn %in% 1 ~ 1, # white Canadian born
                           ethnicity %in% "White/Blanc" == T & canborn %in% 0 ~ 2, # white immigrant
                           ethnicity %in% "Arab/Arabe" == T ~ 3,
                           ethnicity %in% "Black/Noire" == T ~ 4,
                           ethnicity %in% "Indigenous, Métis, Aboriginal Canadian /Autochtone, Métis" == T ~ 5,
                           ethnicity %in% "Latin American/Latino-Américain" == T ~ 6,
                           ethnicity %in% c("South Asian/Sud-Asiatique", "West Asian/Asie occidentale", 
                                            "Central Asian/Asie centrale", "East Asian/Asie orientale",
                                            "Southeast Asian/Asie du Sud-Est") == T ~ 7,
                           ethnicity %in% "Other/Autre" == T ~ 8,
                           ethnicity %in% c("", "Don’t know or prefer not to answer/Ne sais pas ou préfère ne pas répondre") == T ~ 9,
                           ethnicity %in% c("White/Blanc", "Arab/Arabe", "Black/Noire", "Indigenous, Métis, Aboriginal Canadian /Autochtone, Métis",
                                             "Latin American/Latino-Américain", "South Asian/Sud-Asiatique", "West Asian/Asie occidentale",
                                             "Central Asian/Asie centrale", "East Asian/Asie orientale", "Southeast Asian/Asie du Sud-Est", "Other/Autre",
                                            "", "Don’t know or prefer not to answer/Ne sais pas ou préfère ne pas répondre") == F ~ 10 # multiple ethnicities
                           )

      ) %>%
    # recode negative answers so that they are going in the same direction as positive answers 
    # ie, higher numbers mean more positive feelings toward trees 
    mutate_at(vars(starts_with(c('beliefs_negative', 'beliefs_extra_negative'))), ~case_when(. == 1 ~ 5,
                                                                                             . == 2 ~ 4, 
                                                                                             . == 3 ~ 3,
                                                                                             . == 4 ~ 2, 
                                                                                             . == 5 ~ 1))
  
  mtl_factors <- mtl_code %>%
    mutate(id = as.factor(id),
           city_type = as.factor(city_type),
           housing_code = as.factor(housing_code),
           housing_type_of_dwelling = as.factor(housing_type_of_dwelling),
           canborn = as.factor(canborn),
           esl = as.factor(esl),
           language_french_spoken = as.factor(language_french_spoken),
           edu_uni = as.factor(edu_uni), 
           ethnicity = as.factor(ethnicity),
           immigrant = as.factor(immigrant),
           firstlanguage = as.factor(firstlanguage),
           education = as.factor(education),
           ethncode = as.factor(ethncode),
           decade_num = as.factor(decade_num))
    
  
  return(mtl_code)
  
  
}