library(plotly)
visualize <- function(category) {
  filename <- paste("COLOR_DAT/", category, ".info.dat", sep='')
  test <- readLines(filename)
  
  # Create output directories
  directory <- paste("VIS/", category, sep='')
  if (dir.exists("VIS")){
    if (dir.exists(directory)){
      
    } else {
      dir.create(directory)
    }
  } else {
    dir.create("VIS")
    dir.create(directory)
  }
  
  # Pull downloads and RGB tuples from file
  downloads <- 0
  total_downloads <- 0
  color <- 0
  appIds <- 0
  ratings <- 0
  for (i in seq(1,length(test))) {
    if (i %% 4 == 0) {
      downloads[i / 4] <- as.numeric(test[i])
    } 
    if (i %% 4 == 2) {
      color[(i / 4) + 1] <- strsplit(test[i], " ")
    }
    if (i %% 4 == 1) {
      appIds[(i / 4) + 1] <- test[i]
    }
    if (i %% 4 == 4) {
      ratings[(i / 3) + 1] <- as.numeric(test[i])
    }
  }
  
  # Sum up all downloads to get total downloads
  total_downloads = sum(downloads)
  
  # Read RGB values into vectors
  red = 0
  blue = 0
  green = 0
  ndownloads = 0
  appId = 0
  index = 1
  weights = c(1,0,0,0,0)
  for (i in seq(1,length(color))) {
    for (j in seq(1,1)) {
      red[index] = as.numeric(color[[i]][(j*3)-3+1])
      green[index] = as.numeric(color[[i]][(j*3)-3+2])
      blue[index] = as.numeric(color[[i]][(j*3)-3+3])
      ndownloads[index] = downloads[i] * weights[j]
      appId[index] = appIds[i]
      index = index + 1
    }
  }
  
  # Convert RGB vectors into HSV vectors
  hsv = rgb2hsv(red, green, blue)
  hues = round(hsv[seq(1,length(hsv),3)],3)
  sats = round(hsv[seq(2,length(hsv),3)],3)
  vals = round(hsv[seq(3,length(hsv),3)],3)
  
  # Declaring variables
  x = seq(0,1,0.001)
  nhues = x * 0
  nsats = x * 0
  nvals = x * 0
  dhues = x * 0
  dsats = x * 0
  dvals = x * 0
  mhues = x * 0
  msats = x * 0
  mvals = x * 0
  
  # Find HSV frequency and num downloads
  for (i in seq(1, length(hues))) {
    nhues[hues[i] * 1000] <- nhues[hues[i] * 1000] + 1
    nsats[sats[i] * 1000] <- nsats[sats[i] * 1000] + 1
    nvals[vals[i] * 1000] <- nvals[vals[i] * 1000] + 1
    dhues[hues[i] * 1000] <- dhues[hues[i] * 1000] + ndownloads[i]
    dsats[sats[i] * 1000] <- dsats[sats[i] * 1000] + ndownloads[i]
    dvals[vals[i] * 1000] <- dvals[vals[i] * 1000] + ndownloads[i]
  }
  
  # Find HSV mass
  mhues = dhues / total_downloads
  msats = dsats / total_downloads
  mvals = dvals / total_downloads
  
  # Change plot parameters for black bg
  par(bg="black",col="black",col.axis="white",col.lab="white",col.main="white",col.sub="white")
  
  # Save hue frequency plot
  #dev.copy(png,paste(directory, "/", category, "_hue_freq.png", sep=''))
  plot(x, nhues,type = 'h', main=paste("Frequency by Hue -", category), xlab = "Hue", ylab = "Frequency")
  segments(x, 0, x, nhues, col=hsv(x,1,1))
  #dev.off()
  
  # Save hue mass plot
  #dev.copy(png,paste(directory, "/", category, "_hue_mass.png", sep=''))
  plot(x, mhues,type = 'h', main=paste("Mass by Hue -", category), xlab = "Hue", ylab = "Probability")
  segments(x, 0, x, mhues, col=hsv(x,1,1))
  #dev.off()
  
  # Save hue CDF plot
  #dev.copy(png,paste(directory, "/", category, "_hue_cdf.png", sep=''))
  HueCDF = ecdf(hues)
  plot(HueCDF, main=paste("CDF by Hue -", category), xlab = "Hue", ylab = "Probability")
  segments(x, 0, x, HueCDF(x), col=hsv(x,1,1))
  #dev.off()
  
  # Save saturation frequency plot
  #dev.copy(png,paste(directory, "/", category, "_sat_freq.png", sep=''))
  plot(x, nsats,type = 'h', main=paste("Frequency by Saturation -", category), xlab = "Saturation", ylab = "Frequency")
  segments(x, 0, x, nsats, col=hsv(x[which.max(mhues)],x,1))
  #dev.off()
  
  # Save saturation mass plot
  #dev.copy(png,paste(directory, "/", category, "_sat_mass.png", sep=''))
  plot(x, msats,type = 'h', main=paste("Mass by Saturation -", category), xlab = "Saturation", ylab = "Probability")
  segments(x, 0, x, msats, col=hsv(x[which.max(mhues)],x,1))
  #dev.off()
  
  # Save saturation CDF plot
  #dev.copy(png,paste(directory, "/", category, "_sat_cdf.png", sep=''))
  SatCDF = ecdf(sats)
  plot(SatCDF, main=paste("CDF by Saturation -", category), xlab = "Saturation", ylab = "Probability")
  segments(x, 0, x, SatCDF(x), col=hsv(x[which.max(mhues)],x,1))
  #dev.off()
  
  # Change plot parameters to white bg
  par(bg="white",col="white",col.axis="black",col.lab="black",col.main="black",col.sub="black")
  
  # Save value frequency plot
  #dev.copy(png,paste(directory, "/", category, "_val_freq.png", sep=''))
  plot(x, nvals,type = 'h', main=paste("Frequency by Lightness -", category), xlab = "Lightness", ylab = "Frequency")
  segments(x, 0, x, nvals, col=hsv(x[which.max(mhues)],x[which.max(msats)],x))
  #dev.off()
  
  # Save value mass plot
  #dev.copy(png,paste(directory, "/", category, "_val_mass.png", sep=''))
  plot(x, mvals,type = 'h', main=paste("Mass by Lightness -", category), xlab = "Lightness", ylab = "Probability")
  segments(x, 0, x, mvals, col=hsv(x[which.max(mhues)],1,x))
  #dev.off()
  
  # Save value CDF plot
  #dev.copy(png,paste(directory, "/", category, "_val_cdf.png", sep=''))
  ValCDF = ecdf(vals)
  plot(ValCDF, main=paste("CDF by Lightness -", category), xlab = "Lightness", ylab = "Probability")
  segments(x, 0, x, ValCDF(x), col=hsv(x[which.max(mhues)],1,x))
  #dev.off()
  
  # Convert to dataframe
  df <- data.frame(hues, sats, vals, ndownloads)
  
  # Plot 3d scatter plot
  fig <- plot_ly(df, type="scatter3d", mode="markers", x = ~hues, y = ~sats, z = ~vals, size = ~ndownloads,
                 marker = list(symbol = 'circle', sizemode = 'area', color=hsv(hues, sats, vals), 
                               line=list(width=1,color=hsv(hues, sats, vals))),
                 sizes = c(50, 35000),
                 hoverinfo='text',
                 text = ~paste('</br> Hue: ', hues,
                               '</br> Saturation: ', sats,
                               '</br> Lightness: ', vals,
                               '</br> AppId: ', appId,
                               '</br> Downloads: ', ndownloads))
  fig <- fig %>% layout(title = paste('Number of Downloads by Color -', category),
                        scene = list(xaxis = list(title = 'Hue',
                                                  gridcolor = 'rgb(255, 255, 255)',
                                                  range = c(0, 1),
                                                  zerolinewidth = 1,
                                                  ticklen = 5,
                                                  gridwidth = 2),
                                     yaxis = list(title = 'Saturation',
                                                  gridcolor = 'rgb(255, 255, 255)',
                                                  range = c(0, 1),
                                                  zerolinewidth = 1,
                                                  ticklen = 5,
                                                  gridwith = 2),
                                     zaxis = list(title = 'Lightness',
                                                  gridcolor = 'rgb(255, 255, 255)',
                                                  zerolinewidth = 1,
                                                  ticklen = 5,
                                                  gridwith = 2)),
                        paper_bgcolor = 'rgb(243, 243, 243)',
                        plot_bgcolor = 'rgb(243, 243, 243)')
  
  fig
  f<-paste(directory,"\\", category,".html", sep='')
  htmlwidgets::saveWidget(as_widget(fig), file.path(normalizePath(dirname(f)),basename(f)))
  
  # Proportion warm colors
  (HueCDF(0.33)) + (HueCDF(1) - HueCDF(0.777))
  # Proportion cool colors
  (HueCDF(0.777) - HueCDF(0.33))
}

# List of all app categories
categories <- c("APPLICATION", "ANDROID_WEAR", "ART_AND_DESIGN", "AUTO_AND_VEHICLES", 
                "BEAUTY", "BOOKS_AND_REFERENCE", "BUSINESS", "COMICS", "COMMUNICATION",
                "DATING", "EDUCATION", "ENTERTAINMENT", "FINANCE", "FOOD_AND_DRINK",
                "GAME", "GAME_ACTION", "GAME_ADVENTURE", "GAME_ARCADE", "GAME_BOARD",
                "GAME_CARD", "GAME_CASINO", "GAME_CASUAL", "GAME_EDUCATIONAL",
                "GAME_MUSIC", "GAME_PUZZLE", "GAME_RACING", "GAME_ROLE_PLAYING",
                "GAME_SIMULATION", "GAME_SPORTS", "GAME_STRATEGY", "GAME_TRIVIA",
                "GAME_WORD", "HEALTH_AND_FITNESS", "HOUSE_AND_HOME", "LIFESTYLE",
                "MAPS_AND_NAVIGATION", "MEDICAL", "MUSIC_AND_AUDIO", "NEWS_AND_MAGAZINES",
                "PARENTING", "PERSONALIZATION", "PHOTOGRAPHY", "PRODUCTIVITY", "SHOPPING",
                "SOCIAL", "SPORTS", "TOOLS", "TRAVEL_AND_LOCAL", "VIDEO_PLAYERS", "WEATHER")

#visualize("WEATHER")
# Generate visualizations for each category
if (dir.exists("COLOR_DAT")) {
  for (category in categories) {
    print(paste("Starting new category:", category))
    visualize(category)
    #print(paste('<option value="',category, "/", category, '.html\">', category,'</option>', sep=''))
  }
} else {
  print("Must put color data files in folder DAT in working directory.")
}
print("Done.")