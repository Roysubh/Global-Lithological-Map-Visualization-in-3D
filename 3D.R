# Load required libraries
library(threejs)
library(terra)
library(htmltools)

# Load your raster file 
glim_raster <- rast("D:/RStudio_3/Lithological_Map/glim_wgs84_0point5deg.txt.asc")

# Convert raster to data frame
glim_df <- as.data.frame(glim_raster, xy = TRUE, na.rm = TRUE)
colnames(glim_df)[3] <- "lithology"

# Interpolate to higher resolution
higher_res <- aggregate(glim_raster, fact = 0.5, method = "bilinear") 
glim_df <- as.data.frame(higher_res, xy = TRUE, na.rm = TRUE)

# Define 16 lithology values explicitly
lithology_values <- 1:16  
color_palette <- colorRampPalette(c("blue", "cyan", "green", "yellow", "orange", "red", "purple"))(length(lithology_values))

# GLiM Lithology Class Names and Abbreviations
lithology_classes <- c(
  "Unconsolidated Sediments (SU)", "Basic Volcanic Rocks (VB)", 
  "Siliciclastic Sedimentary Rocks (SS)", "Mixed Sedimentary Rocks (SM)", 
  "Pyroclastic Rocks (PY)", "Carbonate Sedimentary Rocks (SC)", 
  "Evaporites (EV)", "Metamorphic Rocks (MT)", "Acid Plutonic Rocks (PA)", 
  "Intermediate Volcanic Rocks (VI)", "Water Bodies (WB)", "Basic Plutonic Rocks (PB)", 
  "Ultrabasic Plutonic Rocks (PU)", "Volcanic Rocks (Undefined Composition) (VC)", 
  "No Data / Undefined (ND)", "Ice and Glaciers (IG)"
)

# Assign each lithology value to a fixed color
glim_df$color_bin <- factor(glim_df$lithology, levels = lithology_values)  
colors <- color_palette[as.numeric(glim_df$color_bin)]

# Create the 3D globe with full-screen settings
earth <- globejs(
  bg = "black", lat = glim_df$y, long = glim_df$x, value = glim_df$lithology, 
  color = colors, pointsize = 1.7, atmosphere = TRUE, 
  width = "100%", height = "100%"  
)

# Create a legend positioned on the right side, showing only lithology class names and abbreviations
legend_html <- HTML(paste0(
  "<div style='position:absolute; top:50%; right:20px; transform:translateY(-50%);
               background:black; padding:10px; color:white; border-radius:5px;
               display:flex; flex-direction:column; align-items:flex-start; font-size:14px;'>",
  "<b style='margin-bottom:5px;'>Lithology Legend (GLiM)</b>",
  paste0("<div style='display:flex; align-items:center; margin-bottom:3px;'>
            <div style='width:20px; height:10px; background:", color_palette, 
         "; margin-right:5px;'></div>", lithology_classes, "</div>", collapse = ""),
  "</div>"
))

# Full-screen wrapper
full_screen_div <- tags$div(
  style = "position:fixed; top:0; left:0; width:100vw; height:100vh; overflow:hidden; background:black;",
  earth, legend_html
)

# Display the full-screen globe with the right-side legend
browsable(full_screen_div)

# Save output as an HTML file
save_html(full_screen_div, file = "D:/RStudio_3/Lithological_Map/3D_Lithology_Map.html")