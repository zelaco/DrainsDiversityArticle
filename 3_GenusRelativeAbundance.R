# Load required libraries
library(readxl)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)  

# Read data
dataG <- read_excel("Data/Genera.xlsx")

# Reshape data to long format and calculate relative abundance
dfG_long <- dataG %>%
  pivot_longer(cols = -c(Ward, Sampling),   
               names_to = "Genera",
               values_to = "Abundance") %>%
  na.omit() %>%                             
  group_by(Ward, Sampling) %>%              
  mutate(TotalAbundance = sum(Abundance)) %>%  
  ungroup() %>%
  mutate(RelativeAbundance = Abundance / TotalAbundance)  

# Generate a color palette for the unique genera
genus_colors <- colorRampPalette(brewer.pal(11, "Paired"))(n_distinct(dfG_long$Genera))

# Plot relative abundance by genera for each Sampling and Ward
genera_plot <- ggplot(dfG_long, aes(x = Sampling, y = RelativeAbundance, fill = Genera)) +
  geom_bar(stat = "identity") +  
  facet_wrap(~ Ward) +           
  labs(x = "Sampling", 
       y = "Relative Abundance", 
       fill = "Genera") +       
  theme_minimal() +              
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  
    legend.text = element_text(face = "italic"),        
    legend.position = "right",                           
    panel.background = element_rect(fill = "white", colour = NA),  
    plot.background = element_rect(fill = "white", colour = NA)    
  ) +
  scale_fill_manual(values = genus_colors)  

# Display the plot
print(genera_plot)

# Save the plot as a PNG file 
ggsave("output/Fig3_genera_relative_abundance.png", genera_plot, width = 10, height = 8, bg = "white", dpi = 300)
ggsave("output/Fig3_genera_relative_abundance.tiff", genera_plot, width = 10, height = 8, bg = "white", dpi = 300)
ggsave("output/Fig3_genera_relative_abundance.svg", genera_plot, width = 10, height = 8, bg = "white")

