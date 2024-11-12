# Load required libraries
library(readxl)
library(vegan)
library(ggplot2)

# Read data
Drainplot <- read_excel("Data/SpeciesBeta.xlsx")

# Check for missing values and remove if necessary
Drainplot <- na.omit(Drainplot)

# Extract community data
comDrain <- Drainplot[, 3:ncol(Drainplot)]

# Calculate dissimilarity matrix using Bray-Curtis method
dissimilarity_matrix <- vegdist(comDrain, method = "bray")

# Perform PCoA (Principal Coordinates Analysis)
pcoa_result <- cmdscale(dissimilarity_matrix, k = 2, eig = TRUE)  # Retain eigenvalues for explained variance

# Convert PCoA result to data frame
pcoa_df <- as.data.frame(pcoa_result$points)

# Add additional variables (Sampling, Ward) to PCoA data frame
pcoa_df$Sampling <- Drainplot$Sampling
pcoa_df$Ward <- Drainplot$Ward

# Define color palette for Ward
ward_colors <- c("#C4961A", "#F4EDCA", "#52854C", "#C3D7A4", "#D16103", "#4E84C4")

# Plot PCoA
pcoa_plot <- ggplot(pcoa_df, aes(x = V1, y = V2)) + 
  geom_point(size = 4, aes(shape = Sampling, colour = Ward)) + 
  theme(
    axis.text = element_text(colour = "black", size = 12, face = "bold"),
    legend.text = element_text(size = 12, face = "bold", colour = "black"),
    legend.position = "right",
    axis.title = element_text(face = "bold", size = 14, colour = "black"),
    legend.title = element_text(size = 14, colour = "black", face = "bold"),
    panel.background = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 1.2),
    legend.key = element_blank()
  ) + 
  labs(
    x = paste0("PCoA1"),
    y = paste0("PCoA2"),
    colour = "Ward", shape = "Sampling"
  ) + 
  scale_colour_manual(values = ward_colors)

# Save PCoA plot to file
ggsave("output/Fig2_pcoa_plot.png", pcoa_plot, width = 8, height = 6, dpi = 300)
ggsave("output/Fig2_pcoa_plot.tiff", pcoa_plot, width = 8, height = 6, dpi = 300)
ggsave("output/Fig2_pcoa_plot.svg", pcoa_plot, width = 8, height = 6)

# Display PCoA plot
print(pcoa_plot)

# Perform PERMANOVA using Bray-Curtis dissimilarity matrix
permanova_result <- adonis2(comDrain ~ Sampling + Ward, data = Drainplot, permutations = 999, method = "bray")

# Print PERMANOVA results
print(permanova_result)
