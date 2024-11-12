# Load required libraries
library(readxl)
library(ggplot2)
library(vegan)
library(patchwork)

# Read data
divInd <- read_excel("Data/DiversityIndexes.xlsx")

# Extract community data
data_alphadiv <- divInd[, 1:ncol(divInd)]

# Define color palette for box plots
boxplot_colors <- c("#C4961A", "#F4EDCA", "#52854C", "#C3D7A4", "#D16103", "#4E84C4")

# Create a custom function for boxplots
create_boxplot <- function(data, y_var, y_label, tag_label) {
  ggplot(data, aes(x = Ward, y = !!sym(y_var))) +
    geom_boxplot(fill = boxplot_colors) +
    geom_point() +
    labs(title = '', x = '', y = y_label, tag = tag_label) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(hjust = 0.5, size = 14))
}

# Generate plots for different alpha diversity indices
P1 <- create_boxplot(data_alphadiv, 'Shannon_H', 'Shannon', 'A')
P2 <- create_boxplot(data_alphadiv, 'Simpson', 'Simpson', 'B')
P3 <- create_boxplot(data_alphadiv, 'Taxa_S', 'Richness', 'C')
P4 <- create_boxplot(data_alphadiv, 'Chao1', 'Chao-1', 'D')

# Combine plots using patchwork
combined_plots <- (P1 | P2) / (P3 | P4)

# Save the combined plots as a PNG file 
ggsave("output/Fig1_alpha_diversity.png", combined_plots, width = 10, height = 8, dpi = 300)
ggsave("output/Fig1_alpha_diversity.tiff", combined_plots, width = 10, height = 8, dpi = 300)
ggsave("output/Fig1_alpha_diversity.svg", combined_plots, width = 10, height = 8)

# Print combined plots
print(combined_plots)

# Perform ANOVA for Shannon Index by ward
shannon_anova <- summary(aov(Shannon_H ~ Ward, data = data_alphadiv))
print(shannon_anova)

# Perform ANOVA for Shannon Index by Sampling
sampling_anova <- summary(aov(Shannon_H ~ Sampling, data = data_alphadiv))
print(sampling_anova)

