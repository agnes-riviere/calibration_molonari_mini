###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
### Gathering all formatted data in one file
### Keeping only the climatic chambre timeseries for U-T calibration
###############################################

wd=paste0("/home/ariviere/Documents/Bassin-Orgeval/Donnee_Orgeval_Mines/raw_data/DESC_data/DATA_SENSOR/capteurs_pression/calibration_tmp/scripts_R")

#setwd(wd)


Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving

# initialize paths
pathToFormatted = '../data/2_formatted_data/'
pathToProcessed = '../data/3_processed_data/'

### read and clean all data

folders = list.files(pathToFormatted,pattern = '^p') # where raw data is stored
# p507 has no data in climatic chamber, must be treated differently
folders = folders[which(folders!="p507")]
print(folders)

for (iFold in 1:length(folders)){

  dirs <- list.files(paste0(pathToFormatted,folders[iFold]))
  dirUH <- dirs[grepl(pattern = 'UH',x = dirs)]
  dirUT <- dirs[grepl(pattern = 'UT',x = dirs,ignore.case = T)]
  print(dirUH)
  print(dirUT)

  # create empty data vector
  dataHobo = data.frame(
    dates = rep('',0),
    tension = rep(0,0),
    temperature = rep(0,0),
    deltaH = rep(0,0),
    experiment = rep('',0)
  )
  
  # append data from U-H calibrations
  if(length(dirUH)==1){
    
    nameFile <- list.files(paste0(pathToFor- 2_formattedToProcessed.R : script qui prend les donnees dans 2_formatted_data, les rassemble dans un seul fichier enregistre dans 3_processed_data.
                                  - processedToCalib.R : script lisant les données processées et effectuant les calibrations. Il fait les calibrations 
                                  U-H enregistrees dans calib/[capteur]/intermediate
                                  UHT (finales) enregistrees dans calib/[capteur]
                                  - 2bis_plot_processed.R : plot les séries correspondant aux données dans 3_processed_data et enregistre dans plots/matted,folders[iFold],'/',dirUH))
    pathFile <- paste0(pathToFormatted,folders[iFold],'/',dirUH,'/',nameFile)
    dataFile <- read.csv(file = pathFile,header = T,sep = ',')
    dataFile$experiment <- rep(nameFile,nrow(dataFile))
    dataHobo <- rbind(dataHobo,dataFile)
  }else if(length(dirUH)>1){
    warning(paste0('more than 1 UH folder in ',folders[iFold]))
  }else{warning(paste0('no UH folder in ',folders[iFold]))}
  
  # copy paste files UT
  if(length(dirUT)==1){
    
    nameFiles <- list.files(paste0(pathToFormatted,folders[iFold],'/',dirUT),pattern = '.csv')
    print(nameFiles)
    for(iFile in 1:length(nameFiles)){
      pathFile <- paste0(pathToFormatted,folders[iFold],'/',dirUT,'/',nameFiles[iFile])
      dataFile <- read.csv(file = pathFile,header = T,sep = ',')
      dataFile$experiment <- rep(nameFiles[iFile],nrow(dataFile))
      dataHobo <- rbind(dataHobo,dataFile)
    }
  }else if(length(dirUT)>1){
    warning(paste0('more than 1 UT folder in ',folders[iFold]))
  }else{warning(paste0('no UT folder in ',folders[iFold]))}
  
  # save data in data/3_processed_data
  pathSave = paste0(pathToProcessed,folders[iFold],'_allData.csv')
  write.table(dataHobo,file = pathSave,quote = F,sep = ',',row.names = F)
  
}
