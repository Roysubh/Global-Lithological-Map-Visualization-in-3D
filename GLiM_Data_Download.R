# Set the download URL for GLiM
glim_url <- "https://hdl.handle.net/10013/epic.39939.d001"

# Set the destination directory
dest_file <- "D:/RStudio_3/Lithological_Map/GLiM_Lithological_Map.zip"  # Change path as needed

# Download the file
download.file(glim_url, destfile = dest_file, mode = "wb")

# Verify download
if (file.exists(dest_file)) {
  print("Download successful!")
} else {
  print("Download failed. Check URL or path.")
}

unzip(dest_file, exdir = "D:/RStudio_3/Lithological_Map/")

list.files("D:/RStudio_3/Lithological_Map/", recursive = TRUE)

library(terra)

# Load the raster
glim_raster <- rast("D:/RStudio_3/Lithological_Map/glim_wgs84_0point5deg.txt.asc")

# Plot the raster
plot(glim_raster, main = "GLiM Lithological Map (Raster)")

print(glim_raster)

glim_df <- as.data.frame(glim_raster, xy = TRUE)
colnames(glim_df)[3] <- "lithology" 