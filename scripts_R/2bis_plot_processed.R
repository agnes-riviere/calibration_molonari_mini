###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
###############################################
wd=paste0("/home/ariviere/Documents/Bassin-Orgeval/Donnee_Orgeval_Mines/raw_data/DESC_data/DATA_SENSOR/capteurs_pression/calibration_tmp/scripts_R")

#setwd(wd)


Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving

library(colorRamps) # for colorbar blue2green

boolPlotPdf=T

pathProcessed = '../data/3_processed_data/'
files = list.files(pathProcessed,pattern = '.csv') # where data is stored
print(files)
pathPlot=paste0('../plots/3_processed/')
if(!file.exists(paste0(pathPlot))){
  dir.create(paste0(pathPlot))  
}

library(classInt)
source('utils_colorbar.R')

for (iFile in c(8,10,13,14)){ # loop over all sensors
  
  nameSensor <- unlist(strsplit(files[iFile],'_')[[1]][1])
  
  if(!file.exists(paste0(pathPlot,nameSensor))){
    dir.create(paste0(pathPlot,nameSensor))  
  }
  

  
  print(files[iFile])
  
  # plot tension vs deltaH and temperature
  dataHobo=read.table(file = paste0(pathProcessed,files[iFile]),
                      sep=',',header=T,
                      colClasses=c('character','numeric','numeric','numeric','character'))
  
  if(boolPlotPdf) pdf(paste0(pathPlot,nameSensor,'_plot2D_tension.pdf'),width=6,height=4)
  colInt = classIntervals(dataHobo$tension,n=20,style = "pretty")
  colPoints = findColours(colInt,c('blue','yellow'))
  layout(matrix(c(1,2),nrow=1), widths=c(3,1))
  plot(x=dataHobo$deltaH,y=dataHobo$temperature,pch=19,
       xlab=expression(Delta*'H [m]'),ylab='T [C]',xlim = range(dataHobo$deltaH),
       col=colPoints)
  color.bar(colorRampPalette(c('blue','yellow'))(20),
            min=min(dataHobo$tension),max=max(dataHobo$tension),title = 'tension [V]')
  if(boolPlotPdf) dev.off()
  
  if(boolPlotPdf) pdf(paste0(pathPlot,nameSensor,'_plot2D_Temperature.pdf'),width=6,height=4)
  if(length(unique(dataHobo$temperature))>1){
    colInt = classIntervals(dataHobo$temperature,n=3,style = "pretty",largeN = 100000)
    colPoints = findColours(colInt,c('blue','yellow'))
  }else{
    colPoints = 'black'
  }
  layout(matrix(c(1,2),nrow=1), widths=c(3,1))
  plot(x=dataHobo$deltaH,y=dataHobo$tension,pch=19,
       xlab=expression(Delta*'H [m]'),ylab='tension [V]',
       col=colPoints)
  color.bar(colorRampPalette(c('blue','yellow'))(20),
            min=min(dataHobo$temperature),max=max(dataHobo$temperature),
            title = 'T [C]')
  if(boolPlotPdf) dev.off()
  
  if(boolPlotPdf) pdf(paste0(pathPlot,nameSensor,'_plot2D_DeltaH.pdf'),width=6,height=4)
  colInt = classIntervals(dataHobo$deltaH,n=7,style = "pretty")
  colPoints = findColours(colInt,c('blue','yellow'))
  layout(matrix(c(1,2),nrow=1), widths=c(3,1))
  plot(x=dataHobo$tension,y=dataHobo$temperature,pch=19,xlab='tension [V]',ylab='temperature [C]',
       col=colPoints)
  color.bar(colorRampPalette(c('blue','yellow'))(20),
            min=min(dataHobo$deltaH),max=max(dataHobo$deltaH),
            title = expression(Delta*'H [m]'))
  if(boolPlotPdf) dev.off()
  
}
