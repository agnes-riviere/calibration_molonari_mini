###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
# get and format information relative to calibration experiments  
# for calibration UH : 
#     get points along linear curve 
#     get mean temperature during calibration
# for calibration UT : 
#     get timeseries of temsion and temperature measurements
#     get corresponding head differential reported in dashboard
# saving complete timeseries U-H-T in 2_formatted_data
##################################################################

wd=paste0("/home/ariviere/Documents/Bassin-Orgeval/Donnee_Orgeval_Mines/raw_data/DESC_data/DATA_SENSOR/capteurs_pression/calibration_tmp/scripts_R")

#setwd(wd)

Sys.setenv(TZ='UTC') # to avoid the problem of daylight saving
source('utils_functionsHoboDates.R')

# initialize paths
pathToRaw = '../data/1_raw_data/'
pathToFormatted = '../data/2_formatted_data/'

### read and clean all data

folders = list.files(pathToRaw,pattern = '^p') # where raw data is stored
print(folders)


#for(iFold in 1:length(folders)){
for(iFold in c(10,12,16,17)){

  if(!file.exists(paste0(pathToFormatted,folders[iFold]))){
    dir.create(paste0(pathToFormatted,folders[iFold]))  
  }
  
  sub_folders = list.files(paste0(pathToRaw,folders[iFold]),pattern = '^p')
  print(sub_folders)
  iSubFold = 1
  print(sub_folders[iSubFold])
  for(iSubFold in 1:length(sub_folders)){
    
    cat(paste0(folders[iFold],'/',sub_folders[iSubFold]))
    
    if(grepl('UH',sub_folders[iSubFold])){ # data corresponding to U-H calibration
      
      # create full path to raw data
      pathDataRaw = paste0(pathToRaw,folders[iFold],'/',sub_folders[iSubFold])
      
      # get names of csv files in the calibUH folder
      files = list.files(pathDataRaw,pattern = '.csv')
      print(files)
      
      # read data recorded by hand during calibration
      dataRaw = read.csv(file = paste0(pathDataRaw,'/',sub_folders[iSubFold],'.csv'),
                         sep=',',colClasses = 'character')
      if(ncol(dataRaw)==1){
        dataRaw = read.csv(file = paste0(pathDataRaw,'/',sub_folders[iSubFold],'.csv'),
                           sep=',',colClasses = 'character')
      }
      dataHobo = data.frame(
        dates = rep(NA,nrow(dataRaw)),
        tension = as.numeric(sub(',','.',dataRaw$tension)),
        temperature = rep(NA,nrow(dataRaw)),
        deltaH = as.numeric(sub(',','.',dataRaw$deltaH))/100 # cm to m
      )
      str(dataHobo)
      
      # get rid of saturated values (keep if between 0.65V and 2.45V)
      idxKeep = which(dataHobo$tension >= 0.65 & dataHobo$tension <= 2.45)
      dataHobo <- dataHobo[idxKeep,]
      
      # import temperature during calibration
      dataRaw = read.csv(file = paste0(pathDataRaw,'/',sub_folders[iSubFold],'_enregistrement.csv'),
                         sep=',',skip=1,colClasses = 'character')
      ### en 1e approximation, je prends la temperature moyenne sur la calibration
      T_etal = mean(as.numeric(dataRaw[,4]))
      dataHobo$temperature = rep(T_etal,nrow(dataHobo))
      
      # save that data
      # create path where formatted data should be saved
      pathSave = paste0(pathToFormatted,folders[iFold],'/',sub_folders[iSubFold])
      if(!file.exists(pathSave)) dir.create(pathSave)
      # write in file
      write.table(dataHobo,
                  file = paste0(pathSave,'/',sub_folders[iSubFold],'.csv'),sep=',',quote=F,row.names=F)
      
    }
    
    if(grepl('UT',sub_folders[iSubFold])){ # data corresponding to U-T calibration
      
      # create full path to raw data
      pathDataRaw = paste0(pathToRaw,folders[iFold],'/',sub_folders[iSubFold])
      
      # save content of dashboard
      # the dashboard contains head differentials for U-T calibrations
      data_dashboard <- read.csv(paste0(pathDataRaw,'/',
                                        list.files(pathDataRaw,pattern = 'tableauDeBord.csv')),
                                 sep=',',header=T,colClasses = 'character')
      print(data_dashboard)
      
      # files to read are first column of dashboard  
      devCoupl <- data_dashboard[,1]
      devCoupl <- devCoupl[devCoupl!='']
      print(devCoupl)
      
      # loop over U-T files as indicated in the dashboard
      i=1
      for (i in 1:length(devCoupl)){
        
        # read temperature and tension data from file
        pathFile_i <- paste0(pathDataRaw,'/',devCoupl[i])
        dataRaw_i <- read.csv(file = pathFile_i,header=T,
                              sep=',',colClasses = 'character')
        str(dataRaw_i)

      
        dataRaw_i=subset( dataRaw_i, dataRaw_i$temperature<40)
        
        
        # get corresponding head differential from csv filedates,tension,deltaH
        deltaH_i <- data_dashboard[which(data_dashboard[,1]==devCoupl[i]),2]
        print(deltaH_i)
        
        if(is.na(suppressWarnings(as.numeric(deltaH_i)))){
          print(paste0('ignoring #,dates,temperature,tension,,,file ',devCoupl[i]))
        }else{
          
          dataHobo_i = data.frame(
            dates =dataRaw_i$dates,
            tension = as.numeric(sub(',','.',dataRaw_i$tension)),
            temperature = as.numeric(sub(',','.',dataRaw_i$temperature)),
            deltaH = rep(as.numeric(deltaH_i),nrow(dataRaw_i))/100 # cm to m
          )
          
          # save that data
          # create path where formatted data should be saved
          pathSave = paste0(pathToFormatted,folders[iFold],'/',sub_folders[iSubFold])
          if(!file.exists(pathSave)) dir.create(pathSave)
          # write in file
          write.table(dataHobo_i,
                      file = paste0(pathSave,'/',devCoupl[i]),
                      sep=',',quote=F,row.names=F)
        }
        
      }
      
    }
    
  }
  
}

