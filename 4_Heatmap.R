# Load required libraries
library(readxl)
library(tidyr)
library(ggplot2)

# Read data
data_heatmap <- read_excel("Data/Heatmap.xlsx")

# Preprocess data, remove rows with NA values
data_processed <- na.omit(data_heatmap)

# Assign NA to zero values for better handling in the heatmap
data_processed[data_processed == 0] <- NA

# Define the color gradient for low, medium, and high values
colors <- colorRampPalette(c("#3182bd", "#34ebb4", "red"))(100)  # Gradient from blue to green to red

# Reshape data for ggplot
data_long <- tidyr::pivot_longer(data_processed, cols = -Species, names_to = "Sample", values_to = "Abundance")

# Plot heatmap 
heatmap_plot <- ggplot(data_long, aes(x = Sample, y = Species, fill = Abundance)) +
  geom_tile(color = "white") +
  scale_fill_gradientn(colors = colors, na.value = "#f2f2f2", name = "Abundance") +  
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
    axis.text.y = element_text(face = "italic")
  ) +  
  labs(x = "Sample", y = "Species")

# Display the heatmap
print(heatmap_plot)

# Optionally save the plot
ggsave("output/Fig4_heatmap.png", heatmap_plot, width = 10, height = 8, dpi = 300)
ggsave("output/Fig4_heatmap.tiff", heatmap_plot, width = 10, height = 8, dpi = 300)
ggsave("output/Fig4_heatmap.svg", heatmap_plot, width = 10, height = 8)
