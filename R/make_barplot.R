make_barplot <- function(dataframe, grp, lvls, pal){
  
  ggplot(dataframe) + 
    geom_bar(aes(response, fill = factor(grp, levels = lvls)), position = position_stack(reverse = T)) + 
    facet_wrap(~ question) + 
    scale_fill_manual(breaks = lvls, values = pal) +
    theme_classic() + 
    labs(x = NULL, y = NULL, fill = NULL) + 
    theme(axis.text = element_text(size=14),
          legend.text = element_text(size =14),
          strip.text.x = element_text(size=12))
  
}
