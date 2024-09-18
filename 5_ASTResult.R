# Load required libraries
library(readxl)
library(tidyverse)
library(ggplot2)
library(patchwork)

# Read data
dataATB <- read_excel("Data/AST.xlsx")

# Reshape data to long format
df_long <- dataATB %>%
  pivot_longer(cols = -c(Species, Antibiotic),
               names_to = "Resistance",
               values_to = "Result") %>%
  na.omit()  # Remove rows with NA values

# Calculate total abundance for each combination of Species and Antibiotic
df_long <- df_long %>%
  group_by(Species, Antibiotic) %>%
  mutate(TotalAbundance = sum(Result)) %>%
  ungroup()

# Define species for individual plots
species_list <- unique(df_long$Species)

# Define a function to create a plot for a given species
create_species_plot <- function(species_name, data) {
  ggplot(data %>% filter(Species == species_name), aes(x = Antibiotic, y = Result, fill = Resistance)) +
    geom_bar(stat = "identity") +
    labs(title = species_name, x = "", y = "Nr. of isolates") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "italic")) +
    scale_fill_manual(values = c(S = "#C3D7A4", I = "#F4EDCA", R = "#D16103"), name = NULL)
}

# Create a list of plots for each species
species_plots <- lapply(species_list, create_species_plot, data = df_long)

# Combine plots vertically using patchwork
combined_plot <- wrap_plots(species_plots, ncol = 1)

# Display the combined plot
print(combined_plot)

# Save the combined plot
ggsave("output/antibiotic_resistance_plots.png", combined_plot, width = 8, height = 12, dpi = 300)
ggsave("output/antibiotic_resistance_plots.tiff", combined_plot, width = 8, height = 12, dpi = 300)
ggsave("output/antibiotic_resistance_plots.svg", combined_plot, width = 8, height = 12)
