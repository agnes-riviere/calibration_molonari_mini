###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
# reading processed timeseries from data/processed_data
# performing the linear calibration
######################################################

wd=paste0('/home/ariviere/Programmes/calibration_molonari_mini/scripts_R/')
setwd(wd)

Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving

# where processed data is stored
pathProcessed = '../data/3_processed_data/'
filesData = list.files(pathProcessed,pattern = '.csv')

pathPlot = '../plots/3_processed/'

boolPlotPdf=T

for (iFile in 1:length(filesData)){
  
  sensorName <- unlist(strsplit(filesData[iFile],split = '_')[[1]][1])
  
  # read processed data
  dataHobo=read.table(file = paste0(pathProcessed,filesData[iFile]),
                     sep=',',header=T,
                     colClasses=c('character',rep('numeric',3),'character'))
  
  # --------- consider only U-H calibration -----------------
  dataCalibUH = dataHobo[which(grepl('UH',dataHobo$experiment)),]
  
  UH_fit = lm(formula = tension ~ deltaH, data = dataCalibUH)
  
  U_lin = coefficients(UH_fit)['(Intercept)'] + 
    coefficients(UH_fit)['deltaH'] * dataHobo$deltaH
  errorU=dataHobo$tension - U_lin
  if(boolPlotPdf) pdf(paste0(pathPlot,sensorName,'/',sensorName,'_errorUvsT_noTCorrection.pdf'),
                      width = 4,height=4)
  plot(x=dataHobo$temperature,y=errorU,
       xlab='',ylab='',pch=16)
  mtext(text = 'T [C]',side = 1,line = 2)
  mtext(text = expression('U'[fit]*' - U'['meas']*'[V]'),side=2,line=2)
  if(boolPlotPdf) dev.off()
  
  deltaH_lin = (dataHobo$tension - coefficients(UH_fit)['(Intercept)'])/
    coefficients(UH_fit)['deltaH']
  errorDeltaH=dataHobo$deltaH - deltaH_lin
  if(boolPlotPdf) pdf(paste0(pathPlot,sensorName,'/',sensorName,'_errordeltaHvsT.pdf'),
                      width = 8,height=4)
  layout(matrix(c(1,2),nrow=1))
  plot(x=dataHobo$temperature,y=errorDeltaH,
       xlab='',ylab='',pch=16,cex=0.5)
  mtext(text = 'T [C]',side = 1,line = 2)
  mtext(text = expression(Delta*'H'[fit]*' - '*Delta*'H'['meas']* '[m]'),
        side = 2,line = 2)
   if(boolPlotPdf) dev.off()
  
  # --------- consider U=f(H,T) calibration ------------------
  dataCalibUHT0 = read.table(file = paste0('../calib/',sensorName,
                                           '/calibfit_',sensorName,'.csv'),
                             sep=',')
  dataCalibUHT=as.list(dataCalibUHT0[,2]);names(dataCalibUHT) <- dataCalibUHT0[,1]
  rm(dataCalibUHT0)
  deltaH_lin =1/dataCalibUHT$`dU/dH` * (dataHobo$tension - dataCalibUHT$Intercept -
                                         dataCalibUHT$`dU/dT` * dataHobo$temperature)
   if(boolPlotPdf) pdf(paste0(pathPlot,sensorName,'/',sensorName,'_errordeltaHvsT_TCorrection.pdf'),
                      width = 4,height=4)
  plot(x=dataHobo$temperature,y=deltaH_lin - dataHobo$deltaH,
       xlab='',
       ylab='',
       pch=16,cex=0.5)
  mtext(text = 'T [C]',side = 1,line = 2)
  mtext(text = expression(Delta*'H'[fit]*' - '*Delta*'H'['meas']* '[m]'),
        side = 2,line = 2)
  if(boolPlotPdf) dev.off()
  
}
