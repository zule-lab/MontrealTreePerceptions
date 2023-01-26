make_boxplot <- function(dataframe, grp, lvls, pal){
  
    ggplot(dataframe, aes(question, response)) + 
    geom_boxplot(outlier.shape = NA) + 
    geom_jitter(aes(color = grp), alpha = 0.7, size = 0.5, width =0.25) + 
    theme_classic() + 
    labs(x = NULL, y = NULL, color = NULL) + 
    scale_color_manual(breaks = lvls, values = pal) + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          axis.text = element_text(size=14),
          legend.text = element_text(size =14))
  
}
