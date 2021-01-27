###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com

wd=paste0("~/Programmes/calibration_molonari_mini/scripts_R")
# a modifier

setwd(wd)

Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving
source('utils_functionsHoboDates.R')

# initialize paths
pathToFormatted = '../data/1_raw_data/'

folders = list.files(pathToFormatted,pattern = '^p') # where raw data is stored
print(folders)

for(iFold in 1:length(folders)){
  # for(iFold in c(10,12,16,17)){ 
  #  iFold=17
  sub_folders = list.files(paste0(pathToFormatted,folders[iFold]),pattern = '^p')
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
          dataHobo <- read.csv(file = pathFile,sep=',',header = T)
        }
        
        if(grepl(pattern = 'UH',x = pathFile)){ # in that case plot U vs deltaH
          
          pathPlot = paste0('../plots/1_raw/for(iFold in 1:length(folders)){',folders[iFold],'/',sub_folders[iSubFold])
          if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)}
          pathFileplot = paste0(pathPlot,'/',
                                gsub(pattern = '.csv',replacement = '.pdf',x = files[iFile]))
   
          pdf(pathFileplot,width = 5,height = 4)
          plot(dataHobo$tension,dataHobo$deltaH,
               xlab='t = ension [V]',ylab = expression(Delta*'H'['meas']* '[cm]'))
          abline(v=pretty(as.numeric(dataHobo$tension)),col='lightblue',lty=2)
          abline(h=pretty(as.numeric(dataHobo$deltaH)),col='lightblue',lty=2)
          dev.off()#,dates,temperature,tension,,,
          
        }else{ # here plot U vs temp
          
          pathPlot = paste0('../plots/1_raw/',folders[iFold],'/',sub_folders[iSubFold])
          if(!file.exists(pathPlot)){dir.create(pathPlot,recursive = T)}
          dataHobo=subset(dataHobo,dataHobo$temperature<40)
          pathFileplot = paste0(pathPlot,'/',
                                gsub(pattern = '.csv',replacement = '.pdf',x = files[iFile]))
          
          pdf(pathFileplot,width = 5,height = 4)
          dates <- as.POSIXct(dataHobo$dates,format='%d/%m/%Y %H:%M')
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

