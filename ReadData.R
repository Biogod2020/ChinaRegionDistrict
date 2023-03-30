library(jsonlite)

# Read file, change "data/region.json" into your own passage
china_coord <- read_json("data/region.json")

# Create empty df
china_coord_df <- data.frame(province = character(), city = character(), district = character(), x = numeric(), y = numeric())

# Initialize variables used
n_provinces <- length(china_coord$districts)
row <- 1

# Run
for (i in 1:n_provinces) {
  if(i == 10){
    next
  }
  n_cities <- length(china_coord$districts[[i]]$districts)
  for (j in 1:n_cities) {
    n_districts <- length(china_coord$districts[[i]]$districts[[j]]$districts)
    for(k in 1:n_districts){
      if(k == 0){
        next
      }
      china_coord_df[row ,"province"] <- china_coord$districts[[i]]$name
      china_coord_df[row ,"city"] <- china_coord$districts[[i]]$districts[[j]]$name
      if(i == 1 | (i == 5 & j == 2) | i == 29 | (i == 32 & (j == 17 | j == 18 | j == 20 | j == 21))){ # Data does not contain third dimension
        china_coord_df[row ,"district"] <- NA
        china_coord_df[row ,"x"] <- china_coord$districts[[i]]$districts[[j]]$center$longitude
        china_coord_df[row ,"y"] <- china_coord$districts[[i]]$districts[[j]]$center$latitude
        row <- row + 1
        break
      } 
      china_coord_df[row ,"district"] <- china_coord$districts[[i]]$districts[[j]]$districts[[k]]$name
      china_coord_df[row ,"x"] <- china_coord$districts[[i]]$districts[[j]]$districts[[k]]$center$longitude
      china_coord_df[row ,"y"] <- china_coord$districts[[i]]$districts[[j]]$districts[[k]]$center$latitude
      row <- row + 1
    }
  }
}

# Save result
write_csv(china_coord_df, "output/whole_country_coord.csv")
