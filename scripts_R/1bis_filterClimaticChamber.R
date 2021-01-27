###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
wd=paste0('scripts_R')
# a modifier
#setwd(wd)

Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving

pathToFormatted = '../data/2_formatted_data/'

folders = list.files(pathToFormatted,pattern = '^p') # where raw data is stored
print(folders)

for(iFold in 1:length(folders)){
  
  sub_folders = list.files(paste0(pathToFormatted,folders[iFold]),pattern = '^p')
  print(sub_folders)
  # find folder containing data from climatic chamber
  iSubFold_chb = grep(pattern = 'UT',x = sub_folders,ignore.case = T)
  cat(paste0(folders[iFold],'/',sub_folders[iSubFold_chb]))
  
  # consider only modified data
  files <- list.files(paste0(pathToFormatted,folders[iFold],'/',sub_folders[iSubFold_chb]),
                      pattern = 'modif.csv')
  print(files)
  
  if(length(files)>0){
    
    iFile=1
    for(iFile in 1:length(files)){
      fileName <- paste0(pathToFormatted,folders[iFold],
                         '/',sub_folders[iSubFold_chb],
                         '/',files[iFile])
      dataHobo = read.csv(file = fileName,
                          sep=';',colClasses = c('character',rep('numeric',3)))
      str(dataHobo)
      
      if(all(is.na(dataHobo$dates))){
        dataHobo$dates_posix <- 1:nrow(dataHobo)
      }else{
        dataHobo$dates_posix <- as.POSIXct(dataHobo$dates,format='%d/%m/%Y %H:%M:%S')
      }
      dataHobo$idx <- 1:nrow(dataHobo)
      
      head(dataHobo)
      
      # find break in temperature timeseries -- equivalently find minimum
      idx_min = which(dataHobo$temperature==min(dataHobo$temperature))
      # check if V- or U- shape
      idx_low <- which(dataHobo$temperature <= (min(dataHobo$temperature) + 0.2) )
      if(length(idx_low) > (nrow(dataHobo)/5)){ # in that case it is a U shape
        idx_break = c(1,idx_low[1],idx_low[length(idx_low)],nrow(dataHobo))
      }else{
        idx_break = c(1,median(idx_min),nrow(dataHobo))
      }
      plot(dataHobo$dates_posix,dataHobo$temperature)
      points(dataHobo$dates_posix[idx_break],
             dataHobo$temperature[idx_break],col='red',cex=2,lwd=3)
      
      # fit linear curve to temperature slopes
      fitted_tension = numeric(nrow(dataHobo))
      lin_fit <- list()
      for(i in 1:(length(idx_break)-1)){
        lin_fit[[i]] <- lm(formula = tension ~ temperature,
                      data = dataHobo[idx_break[i]:idx_break[i+1],])
        fitted_tension[idx_break[i]:idx_break[i+1]] <- fitted.values(lin_fit[[i]])
      }
      
      plot(dataHobo$dates_posix,dataHobo$tension,type='l')
      lines(dataHobo$dates_posix,fitted_tension,col='red')
      
      dataHobo$tension <- fitted_tension
      
      fileName_filtered <- paste0(unlist(strsplit(fileName,'.csv')),'_flt.csv')
      write.table(x = dataHobo[1:idx_break[2],1:4],file = fileName_filtered,
                  quote = F,sep = ';',row.names = F,col.names = names(dataHobo[,1:4]))
      
      ## save coefficients in calib folder
      coefs <- coefficients(lin_fit[[1]])
      names(coefs) <- c('Intercept','dU/dT')
      saveData <- c(coefs,deltaH=dataHobo$deltaH[1])
      pathSave <- paste0('../calib/',folders[iFold],'/',
                         'intermediate')
      if(!file.exists(pathSave)) dir.create(pathSave,recursive = T)
      write.table(saveData,file = paste0(pathSave,'/',files[iFile]),
                quote=F,col.names = F,sep=';')
      
    }
    
  }
  
}


