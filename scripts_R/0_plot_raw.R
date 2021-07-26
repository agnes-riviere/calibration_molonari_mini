###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
#TODO attention ordre des colonnes à modifier.
library(tidyverse)

wd=paste0("~/Programmes/calibration_molonari_mini/scripts_R")
# a modifier


setwd(wd)

Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving
source('utils_functionsHoboDates.R')

# initialize paths
pathToFormatted = '../data/1_raw_data/'


pathPlot = paste0('../plots/')
if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)}




folders = list.files(pathToFormatted,pattern = '^p') # where raw data is stored
print(folders)

for(iFold in 1:length(folders)){
  sub_folders = list.files(paste0(pathToFormatted,folders[iFold]),pattern = '^p')
  pathPlot = paste0('../plots/1_raw/',folders[iFold],'/')
  if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)} 
  if('apoub' %in% list.files(paste0(pathToFormatted,folders[iFold]))){ # append folders in apoub
    sub_folders = c(sub_folders,
                    paste0('apoub/',
                           list.files(paste0(pathToFormatted,folders[iFold],'/apoub'),pattern = '^p')))
  }
  
  print(sub_folders)
  
  for(iSubFold in 1:length(sub_folders)){
    
    pathSubFold = paste0(pathToFormatted,folders[iFold],'/',sub_folders[iSubFold])
    
    files = list.files(pathSubFold,pattern = '.csv')
    files = files[grep(pattern = 'tableauDeBord',x = files,invert = T)]
    files = files[grep(pattern = 'enregistrement',x = files,invert = T)]
    files = files[grep(pattern = 'Enregistrement',x = files,invert = T)]
    print(files)
    
    if(length(files)>0){
      
      for(iFile in 1:length(files)){
        
        pathFile = paste0(pathSubFold,'/',files[iFile])
        print(paste0('plotting formatted files in ',pathFile))
        dataHobo <- read.csv(file = pathFile,sep=',',header = T) 
         if(ncol(dataHobo)==1){
          dataHobo <- read.csv(file = pathFile,sep=';',header = T)
        }

        if(grepl(pattern = 'UH',x = pathFile)){ # in that case plot U vs deltaH
          
          print('Vos noms de colonnes sont :')
          print(colnames(dataHobo))
          
          
          
          if(!is.null(grep(colnames(dataHobo),pattern='Temp'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='Temp')]="temperature"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='Temp'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='temp')]="temperature"}
          
          
          
          if(!is.null(grep(colnames(dataHobo),pattern='Tension'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='Tension')]="tension"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='tension'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='tension')]="tension"}
          
          
          if(!is.null(grep(colnames(dataHobo),pattern='Date'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='Date')]="dates"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='date'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='date')]="dates"}
          
          
          if(!is.null(grep(colnames(dataHobo),pattern='DeltaH'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='DeltaH')]="deltaH"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='deltah'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='deltah')]="deltaH"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='DELTAH'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='DELTAH')]="deltaH"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='deltaH'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='deltaH')]="deltaH"}
          
          print('Vos noms de colonnes sont devenus:')
          print(colnames(dataHobo))
          
          pathPlot = paste0('../plots/1_raw/',folders[iFold],'/',sub_folders[iSubFold])
          if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)}
          pathFileplot = paste0(pathPlot,'/',
                                gsub(pattern = '.csv',replacement = '.pdf',x = files[iFile]))
   
          pdf(pathFileplot,width = 5,height = 4)
          plot(dataHobo$tension,dataHobo$deltaH,
               xlab='tension [V]',ylab = expression(Delta*'H'['meas']* '[cm]'))
          abline(v=pretty(as.numeric(dataHobo$tension)),col='lightblue',lty=2)
          abline(h=pretty(as.numeric(dataHobo$deltaH)),col='lightblue',lty=2)
          dev.off()#,dates,temperature,tension,,,
          
        }else{ # here plot U vs temp
          
          pathPlot = paste0('../plots/1_raw/',folders[iFold],'/',sub_folders[iSubFold])
          dataHobo=dataHobo[,1:4]
          print('Vos noms de colonnes sont :')
          print(colnames(dataHobo))
          
          if(!is.null(grep(colnames(dataHobo),pattern='Temp'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='Temp')]="temperature"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='Temp'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='temp')]="temperature"}
          
          
          
          if(!is.null(grep(colnames(dataHobo),pattern='Tension'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='Tension')]="tension"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='tension'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='tension')]="tension"}
          
          
          if(!is.null(grep(colnames(dataHobo),pattern='Date'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='Date')]="dates"}
          
          if(!is.null(grep(colnames(dataHobo),pattern='date'))) {colnames(dataHobo)[grep(colnames(dataHobo),pattern='date')]="dates"}
          print('Vos noms de colonnes sont devenus:')
          print(colnames(dataHobo))
          
          
          if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)}
          dataHobo=subset(dataHobo,dataHobo$temperature<40)
          pathFileplot = paste0(pathPlot,'/',
                                gsub(pattern = '.csv',replacement = '.pdf',x = files[iFile]))
          
          pdf(pathFileplot,width = 5,height = 4)
          dataHobo$dates=formatHoboDate(dataHobo$dates)
          dates <- as.POSIXct(dataHobo$dates,format='%d/%m/%Y %H:%M:%S')
          par(mar = c(5, 4, 4, 4) + 0.3)  # Leave space for z axis
          plot(dates,dataHobo$tension,type='l',xlab='dates',ylab = 'tension [V]',xaxt='n')
          axis.POSIXct(1,dates,at=pretty(dates),format='%d/%m/%Y')
           abline(v=pretty(dates),col='lightblue',lty=2)
          abline(h=pretty(dataHobo$tension),col='lightblue',lty=2)
          par(new = TRUE)
          plot(x=dates,y=dataHobo$temperature,
               col='firebrick2',type='l',xlab='',ylab='',axes=FALSE)
          axis(4, ylim=range(dataHobo$temperature), at = pretty(dataHobo$temperature),
               las=1,col='firebrick2',col.axis="firebrick2")
          mtext("temperature [C]", side=4, line=3,col='firebrick2')
          dev.off()
          
        }
        
      }   
      
    }
    
  }
  
}

