###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
######################################################
wd=paste0('/home/ariviere/Programmes/calibration_molonari_mini/scripts_R/')

setwd(wd)

Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving

pathCalib = '../calib/'

folders = list.files(pathCalib,recursive = F)

# take out sensor p507 because no calibration in the climatic chamber
folders <- folders[which(folders!='p507')]

vectCoefs = array(dim = c(0,3))
colnames(vectCoefs) <- c('sensor','dU/dT','deltaH')
for(iFold in 1:length(folders)){

  files <- list.files(paste0(pathCalib,folders[iFold],'/intermediate/'),pattern = 'UH')
  print(files)
  
  for(iFile in 1:length(files)){
    
    pathFile <- paste0(pathCalib,folders[iFold],'/intermediate/',files[iFile])
    dataCoefs <- read.csv(file = pathFile,sep=';',header = F,
                          colClasses = c('character','numeric'))
    
    vectCoefs <- rbind(vectCoefs,c(folders[iFold],
                                   dataCoefs[2,2],
                                   dataCoefs[3,2]))
    
  }
  
}

idxSensor = as.numeric(as.factor(vectCoefs[,1]))
namesSensors = unique(vectCoefs[,1])
pdf('../plots/coefsdUdT.pdf',width = 5,height=4)
plot(NA,xlab=expression(Delta*'H [m]'),ylab='dU/dT',
     xlim=range(as.numeric(vectCoefs[,3])),ylim=range(as.numeric(vectCoefs[,2])))
for(i in 1:nrow(vectCoefs)){
  points(as.numeric(vectCoefs[i,3]),as.numeric(vectCoefs[i,2]),
         col=idxSensor[i],pch=14+idxSensor[i])
}
legend('topright',legend=namesSensors,
       col=1:length(namesSensors),pch=14+(1:length(namesSensors)))
dev.off()
