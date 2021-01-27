###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
###############################################
library(lubridate)
wd=paste0("/home/ariviere/Programmes/calibration_molonari_mini/scripts_R/")


Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving

# initialize paths
pathToFormatted = '../data/2_formatted_data/'

folders = list.files(pathToFormatted,pattern = '^p') # where raw data is stored
print(folders)

for(iFold in 1:length(folders)){
 # for(iFold in c(7,9,16,17)){  
  sub_folders = list.files(paste0(pathToFormatted,folders[iFold]),pattern = '^p')
  print(sub_folders)
  
  for(iSubFold in 1:length(sub_folders)){
    
    pathSubFold = paste0(pathToFormatted,folders[iFold],'/',sub_folders[iSubFold])
    
    files = list.files(pathSubFold,pattern = '.csv')
    print(files)
    
    for(iFile in 1:length(files)){
      
      pathFile = paste0(pathSubFold,'/',files[iFile])
    print(paste0('plotting formatted files in ',pathFile))
      
      dataHobo <- read.csv(file = pathFile,sep=',')
      
      if(grepl(pattern = 'UH',x = pathFile)){ # in that case plot U vs deltaH
        
        pathPlot = paste0('../plots/2_formatted/',folders[iFold],'/',sub_folders[iSubFold])
        if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)}
        pathFileplot = paste0(pathPlot,'/',
                          gsub(pattern = '.csv',replacement = '.pdf',x = files[iFile]))
        
        pdf(pathFileplot,width = 5,height = 4)
        plot(dataHobo$tension,dataHobo$deltaH,
             xlab='tension [V]',ylab = expression(Delta*'H'['meas']* '[m]'))
        abline(v=pretty(dataHobo$tension),col='lightblue',lty=2)
        abline(h=pretty(dataHobo$deltaH),col='lightblue',lty=2)
        lin_fit <- lm(formula = deltaH~tension,data = dataHobo)
        lines(dataHobo$tension,fitted.values(lin_fit),col='red')
        dev.off()
        
      }else{ # here plot U vs temp
        
        pathPlot = paste0('../plots/2_formatted/',folders[iFold],'/',sub_folders[iSubFold])
        if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)}
        pathFileplot = paste0(pathPlot,'/',
                              gsub(pattern = '.csv',replacement = '.pdf',x = files[iFile]))
        
        pdf(pathFileplot,width = 5,height = 4)
        dates <- as.POSIXct(dataHobo$dates,format='%d/%m/%Y %H:%M:%S')
       if (is.na(dates[1]))  {dates <- as.POSIXct(dataHobo$dates,format='%d/%m/%Y %H:%M')}
        par(mar = c(5, 4, 4, 4) + 0.3)  # Leave space for z axis
        plot(dates,dataHobo$tension,type='l',
             xlab='dates',ylab = 'tension [V]',xaxt='n')
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
