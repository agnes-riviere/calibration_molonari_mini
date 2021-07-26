###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
# reading processed timeseries from data/processed_data 
# performing the linear calibration
######################################################

wd=paste0('/home/ariviere/Programmes/calibration_molonari_mini/scripts_R/')

#setwd(wd)



Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving

pathProcessed = '../data/3_processed_data/'
files = list.files(pathProcessed,pattern = '.csv') # where processed data is stored

for (iFile in 1:length(files)){
  #  for (iFile in c(8,10,13,14)){ # loop over all sensors
    
    
    
  sensorName <- unlist(strsplit(files[iFile],split = '_')[[1]][1])
  
  dataHobo=read.table(file = paste0(pathProcessed,files[iFile]),
                     sep=',',header=T,
                     colClasses=c('character',rep('numeric',3),'character'))
  
  # --- perform calibration -----
  # U = k0 + k1 H + k2 T
  
  # perform U-H calibrationpathSave 
  dataCalibUH = dataHobo[which(grepl('UH',dataHobo$experiment)),]
  UH_fit = lm(formula = tension ~ deltaH, data = dataCalibUH)
  
  # save coefficients
  dataSave = c(coefficients(UH_fit),dataCalibUH$temperature[1])
  names(dataSave) <- c('Intercept','dU/dH','temperature')
  pathSave = paste0('../calib/',sensorName,'/intermediate/')
  if(!file.exists(paste0('../calib/',sensorName))){
    dir.create(paste0('../calib/',sensorName))  
  }
  if(!file.exists(pathSave)){
    dir.create(pathSave)  
  }
  
  write.table(x = dataSave, file = paste0(pathSave,sensorName,'_calibUH.csv'),
              quote=F,sep=';',col.names = F)
  
  # calculate errors
  U_lin = coefficients(UH_fit)['(Intercept)'] + coefficients(UH_fit)['deltaH'] * dataHobo$deltaH
  errorU = dataHobo$tension - U_lin
  
  # fit error with temperature
  fit_errorUvsT = lm(errorU ~ dataHobo$temperature)
  
  pathSave = paste0('../calib/',sensorName,'/')
  if(!dir.exists(pathSave)){dir.create(pathSave)}
  
  pathFile = paste0(pathSave,'calibfit_',sensorName,'.csv')
  coefs=data.frame(intercept=as.numeric(coefficients(UH_fit)['(Intercept)'] +
                                          fit_errorUvsT$coefficients['(Intercept)']),
                   deltaH=coefficients(UH_fit)['deltaH'],
                   temperature=as.numeric(fit_errorUvsT$coefficients['dataHobo$temperature']))
  names(coefs) <- c('Intercept','dU/dH','dU/dT')
  write.table(t(coefs),
              file=pathFile,quote=F,col.names=F,sep=',')
  
}

# calculate errors
U_linT = coefficients(UH_fit)['(Intercept)'] + coefficients(UH_fit)['deltaH'] * dataHobo$deltaH+ coefficients(fit_errorUvsT )['dataHobo$temperature'] * dataHobo$temperature


plot(dataHobo$tension,U_linT,xlim=c(1,1.4))
