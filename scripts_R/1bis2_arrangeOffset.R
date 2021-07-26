###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com
wd=paste0('/home/ariviere/Programmes/calibration_molonari_mini/scripts_R')
#setwd(wd)
source('utils_functionsHoboDates.R')

# sensor for which to make the correction
sensor = 'p532'
pathFormatted = '../data/2_formatted_data/'
pathCalib=paste0('../calib/',sensor,'/intermediate/')

# read U-H calibration corresponding to sensor
UHfolder = list.files(paste0(pathFormatted,sensor),pattern = 'UH',ignore.case = T)

for(i in 1:length(UHfolder)){
  fileUH = list.files(path = paste0(pathFormatted,sensor,'/',UHfolder[i]),pattern = '.csv')  
print(fileUH)
dataUH <- read.csv(file = paste0(pathFormatted,sensor,'/',UHfolder[i],'/',fileUH),sep = ',')
  head(dataUH)
  linUH <- lm(formula = tension~deltaH,data = dataUH)
  T_calibUH <- unique(dataUH$temperature)
}
 
if (!is.na(T_calibUH)){
# loop over U-T experiments
UTfolder = list.files(paste0(pathFormatted,sensor),pattern = 'UT',ignore.case = T)
UTpath = paste0(pathFormatted,sensor,'/',UTfolder,'/')
UTfiles = list.files(UTpath,pattern = '.csv')
print(UTfiles)
iFile=1
for(iFile in 1:length(UTfiles)){
  
  data_expUT_i <- read.csv(paste0(UTpath,UTfiles[iFile]),header = T,sep = ',')
  if(ncol(data_expUT_i)==1) {  data_expUT_i <- read.csv(paste0(UTpath,UTfiles[iFile]),header = T,sep = ';')}
  
  # deltaH_calibUT : get deltaH corresponding to U-T experiment
  deltaH_calibUT <- unique(data_expUT_i$deltaH)
  
  # in U-H calibration, get expected expectedU_calibUT for deltaH_calibUT
  expectedU_calibUT <- coefficients(linUH)['(Intercept)'] + 
    coefficients(linUH)['deltaH'] * deltaH_calibUT
  
  # + U-H calibration is performed at temperature T_calibUH
  
  # now, in U-T relationship, the tension expected for T_calibUH is expectedU_calibUT
  # what is the actual tension actualU_UT measured at T_calibUH
  lin_UT <- lm(tension ~ temperature, data = data_expUT_i)
  actualU_UT <- coefficients(lin_UT)['(Intercept)'] +
    coefficients(lin_UT)['temperature'] * T_calibUH
  
    # the correction offset is expectedU_calibUT - actualU_UT
  correction_offset <- expectedU_calibUT - actualU_UT
  
  # now correct the entire timeseries
  data_expUT_i$tension <- data_expUT_i$tension + correction_offset
  
  # save corresponding timeseries
  write.table(x = data_expUT_i,file = paste0(UTpath,UTfiles[iFile]),
              sep = ',',quote = F,row.names = F)
  

}

}
