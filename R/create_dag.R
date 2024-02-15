create_dag <- function(){
  
  
  dagified <- dagify(
    values ~ age + city_type + education + dwelling + language + immigration + ethnicity + socioeconomic,
    education ~ age,
    city_type ~ ethnicity + age + immigration + socioeconomic + language,
    ethnicity ~ immigration,
    language ~ ethnicity + immigration,
    dwelling ~ ethnicity + immigration + socioeconomic + city_type,
    socioeconomic ~ immigration + ethnicity + age + education,
    labels = c(
      "values" = "Tree Values\n & Beliefs",
      "age" = "Age",
      "education" = "Education",
      "city_type" = "City\n Type",
      "ethnicity" = "Ethnicity",
      "language" = "Language\n Spoken",
      "dwelling" = "Dwelling Type",
      "immigration" = "Immigration\n Status",
      "socioeconomic" = "Socioeconomic\n Status"),
    exposure = 'language',
    outcome = 'values',
    latent = 'socioeconomic') %>% 
    #coords = list(x = c(cooling = 0, tree_density = -1, tree_size = 0, tree_diversity = 1, age = 1, soil = 0, past_land_use = 0),
    #              y = c(cooling = 3, tree_density = 2, tree_size = 2, tree_diversity = 2, age = 1, soil = 1, past_land_use = 0))) %>%
    tidy_dagitty() %>%
    mutate(status = case_when(name == "values" ~ 'outcome',
                              name == "language" ~ 'exposure',
                              name == "socioeconomic" ~ "latent",
                              .default = 'NA'))
  
  i <- ggplot(dagified, aes(x = x, y = y, xend = xend, yend = yend)) +
    theme_dag() + 
    geom_dag_point(aes(color = status)) +
    geom_dag_label_repel(aes(label = label, fill = status),
                         color = "white", fontface = "bold") +
    geom_dag_edges() + 
    scale_fill_manual(values = c('darkseagreen','goldenrod3', 'grey', 'lightskyblue')) + 
    scale_colour_manual(values = c('darkseagreen', 'goldenrod3', 'grey', 'lightskyblue')) + 
    theme(legend.position = 'none')
  
  ggsave('graphics/dag.png', plot = i, width = 10, height = 8, units = "in")
  
  return(i)
  
  
}