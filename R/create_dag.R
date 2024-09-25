create_dag <- function(){
  
  
  dagified <- dagify(
    values ~ age + education_level + income + daily_exposure + dwelling_type + ethnicity + city_type + language,
    education_level ~ age,
    income ~ education_level + ethnicity, 
    language ~ ethnicity + city_type,
    daily_exposure ~ income + dwelling_type + city_type,
    dwelling_type ~ city_type + income,
    labels = c(
      "values" = "Tree Values\n & Beliefs",
      "age" = "Age",
      "education_level" = "Education",
      "daily_exposure" = "Daily Exposure\n to Nature",
      "city_type" = "City\n Type",
      "ethnicity" = "Ethnicity",
      "language" = "Language\n Spoken",
      "dwelling_type" = "Dwelling Type",
      "income" = "Income"),
    exposure = 'language',
    outcome = 'values',
    latent = 'income',
    coords = list(x = c(age = -0.5, values = 0, education_level = 0, income = 0.5, daily_exposure = 1.75, ethnicity = 1.5, language = 1, dwelling_type = 2, city_type = 2),
                  y = c(age = 0, values = 1, education_level = -1, income = -1, daily_exposure = -0.5, ethnicity = 0, language = 1.25, dwelling_type = -1, city_type = 0.25))) %>% 
    tidy_dagitty() %>%
    mutate(status = case_when(name == "values" ~ 'outcome',
                              name == "language" ~ 'exposure',
                              name == "ethnicity" ~ 'exposure',
                              name == "city_type" ~ 'exposure',
                              name == "socioeconomic" ~ "latent",
                              .default = 'NA'))
  
  i <- ggplot(dagified, aes(x = x, y = y, xend = xend, yend = yend)) +
    theme_dag() + 
    geom_dag_point(aes(color = status)) +
    geom_dag_label_repel(aes(label = label, fill = status),
                         color = "white", fontface = "bold") +
    geom_dag_edges() + 
    scale_fill_manual(values = c('darkseagreen','grey', 'lightskyblue', 'goldenrod3')) + 
    scale_colour_manual(values = c('darkseagreen','grey', 'lightskyblue', 'goldenrod3')) + 
    theme(legend.position = 'none')
  
  ggsave('graphics/dag.png', plot = i, width = 10, height = 8, units = "in")
  
  return(i)
  
  
}