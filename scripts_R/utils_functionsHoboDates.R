###############################################
# authors: Agnes Riviere agnes.riviere@mines-paristech.fr et Karina Cucchi karina.cucchi@gmail.com

# this script contains functions for reading hobo dates
# these functions detect the format of input dates
# the standard output format is dd/mm/YYYY HH:MM:SS
# main function is formatHoboDate
###############################################
library(dplyr)



# in string str, add character char at location loc
addCharInString = function(char,str,loc){
  locRev = loc[order(loc,decreasing = T)]
  str_split = unlist(strsplit(str,split=''))
  for(ind in locRev){
    if(ind==1){
      str_split = c(char,str_split)
    }else if(ind == length(str_split)){
      str_split = c(str_split,char)
    }else{
      str_split = c(str_split[1:(ind-1)],char,str_split[ind:length(str_split)])
    }
  }
  return(paste(str_split,collapse=''))
}

# format an unformatted date, the output is a string of the form "dd/mm/YYYY HH:MM:SS"
addZerosInHoboDate = function(dateStr){
  # in that case the times are different than HH:MM:SS like Hobbo34_03_03_14.csv
  dateSplit = unlist(strsplit(dateStr,split=''))
  whichSplit = c(0,which(dateSplit == '/' | dateSplit == ' ' | dateSplit == ':'))
  whichSplitHead = whichSplit[1:6] # to avoid space in front of am-pm
  whichRef = c(0,3,6,11,14,17) # locations where / or space or :
  addZero = 1 + whichSplit[which(diff(whichRef)!=diff(whichSplitHead))]
  dateStr=addCharInString(char = '0',str = dateStr,loc = addZero)
  return(dateStr)
}

# formats a date yy to YYYY by adding '20' in front of yy
formatDateWithFullYear = function(dateStr){
  # locate where year starts
  locYear=which(unlist(strsplit(dateStr,''))=='/')[2]+1
  dateStr=paste0(substr(dateStr,1,locYear-1),'20',
                 substr(dateStr,locYear,nchar(dateStr)))
  return(dateStr)
}

# add am and pm to the vector of dates
addAmPm = function (datesStr){
  VectAmPm = character(length = length(datesStr))
  datesHobo_0 = strptime(datesStr,format='%m/%d/%Y %I:%M:%S ')
  # index du debut du 1er jour rond
  indNextDay = 1+which(format(datesHobo_0[2:length(datesHobo_0)],'%d')!=
                         format(datesHobo_0[1],'%d'))[1]
  VectAmPm[indNextDay] <- 'AM'
  # indices de changement de pm/am
  idxChange = 1 + which(
    diff(as.numeric(difftime(datesHobo_0,
                             strptime(paste0(
                               format(datesHobo_0[indNextDay],'%d/%m/%Y'),
                               ' 00:00:00'),'%d/%m/%Y %H:%M:%S'),
                             units='hours'))
         %%24) 
    < 0)
  # indNextDay correspond a am, remplir le tableau a partir de cet index
  IndicatorVect = c('AM','PM')
  #bigger than indNextDay
  IndicatorInd = 1
  for(i in (indNextDay+1):length(datesHobo_0)){
    if(i %in% idxChange){
      IndicatorInd = 1 + as.integer((IndicatorInd-1)==0)
    }
    VectAmPm[i] <- IndicatorVect[IndicatorInd]
  }
  #smaller than indNextDay
  IndicatorInd=2
  for(i in (indNextDay-1):1){
    VectAmPm[i] <- IndicatorVect[IndicatorInd]
    if(i %in% idxChange){
      IndicatorInd = 1 + as.integer((IndicatorInd-1)==0)
    }
  }
  for (i in 1:length(datesHobo_0)){
    datesStr[i] <- paste(datesStr[i],VectAmPm[i])
  }
  return(datesStr)
}

# painful wrapper function combining all functions to format of dates
# input is a vector from any kind of hobo date format
# output is a vector with format %d/%m/%Y %H:%M:%S
formatHoboDate = function(datesStrHoboRaw){
  
  cat('\n \t formatting dates...')
  
  # first thing check format mm/dd/YYYY and not mm/dd/yy
  ncharYear=nchar(unlist(strsplit(unlist(strsplit(datesStrHoboRaw[1],'/')),' '))[3])
  if(ncharYear!=4){ # in that case the years are written on 2 digits (yy)
    cat('\n\tchanging year format')
    for (iRow in 1:length(datesStrHoboRaw)){
      datesStrHoboRaw[iRow] <- formatDateWithFullYear(datesStrHoboRaw[iRow])
    }
    cat(paste(' ... now with full year, eg.',datesStrHoboRaw[1]))
  }
  # now dates have format mm/dd/YYYY
  
  # then checking that no missing zeros
  ncharDates=unlist(lapply(strsplit(datesStrHoboRaw,' '),function(x) nchar(x[[1]])))
  isOkDates = all(ncharDates==10) # mm/dd/YYYY
  ncharTime=unlist(lapply(strsplit(datesStrHoboRaw,' '),function(x) nchar(x[[2]])))
  isOkTime = all(ncharTime==8) # HH:MM:SS
  # si ce n'est pas le bon nombre de caract?res on ajoute les z?ros...
  if( !isOkDates | !isOkTime){
    cat('\n\tadding zeros where missing')
    for (iRow in 1:length(datesStrHoboRaw)){
      datesStrHoboRaw[iRow] <- addZerosInHoboDate(datesStrHoboRaw[iRow])
    }
    cat(paste(' ... now with filled zeros, eg.'),datesStrHoboRaw[1])
  }
  # now all vector has format mm/dd/YYYY HH:MM:SS
  
  # then check that am pm is not missing...
  if(max(as.numeric(substr(datesStrHoboRaw,12,13)))<=12){
    if(!(grepl('AM',datesStrHoboRaw[1]) | grepl('PM',datesStrHoboRaw[1]))){
      cat('\n\tadding am-pm field')
      #format des vieux hobos (pas de am-pm il faut le rajouter a la main)
      datesStrHoboRaw = addAmPm(datesStrHoboRaw)
      cat(paste(' ... now with am-pm, eg.'),datesStrHoboRaw[1])
    }
    cat('\n\tfrom am-pm to 24-hour time')
    datesHoboRaw= strptime(datesStrHoboRaw,format = '%m/%d/%Y %I:%M:%S %p')
    datesStrHoboRaw = format(datesHoboRaw,'%m/%d/%Y %H:%M:%S')
    cat(paste(' ... now in 24-hour time, eg.'),datesStrHoboRaw[1])
  }
  
  # finally transform from mm/dd/YYYY HH:MM:SS to dd/mm/YYYY HH:MM:SS

  
  if (is.na(as.numeric(difftime(strptime(datesStrHoboRaw[100], format="%d/%m/%Y  %H:%M"),strptime(datesStrHoboRaw[1], format="%d/%m/%Y  %H:%M"),units="mins")))==FALSE){
    if (as.numeric(difftime(strptime(datesStrHoboRaw[100], format="%d/%m/%Y  %H:%M"),strptime(datesStrHoboRaw[1], format="%d/%m/%Y  %H:%M"),units="day"))<2){
      datesHoboRaw  = strptime(datesStrHoboRaw,"%d/%m/%Y  %H:%M:%S")
      datesStrHoboRaw = format(datesHoboRaw ,'%d/%m/%Y %H:%M:%S')
    }
    if (as.numeric(difftime(strptime(datesStrHoboRaw[100], format="%d/%m/%Y  %H:%M"),strptime(datesStrHoboRaw[1], format="%d/%m/%Y  %H:%M"),units="day"))>2){
      datesHoboRaw = strptime(datesStrHoboRaw,format = '%m/%d/%Y %H:%M:%S')
      datesStrHoboRaw = format(datesHoboRaw,'%d/%m/%Y %H:%M:%S')
    }
  } else if (is.na(as.numeric(difftime(strptime(datesStrHoboRaw[2], format="%m/%d/%Y  %H:%M"),strptime(datesStrHoboRaw[1], format="%m/%d/%Y  %H:%M"),units="day")))==FALSE) {
    datesHoboRaw = strptime(datesStrHoboRaw,format = '%m/%d/%Y %H:%M:%S')
    datesStrHoboRaw = format(datesHoboRaw,'%d/%m/%Y %H:%M:%S')
  } else  {
    print("Pb date")}
  
  
  
  
  #here the dates have the form dd/mm/YYYY HH:MM:SS with no problem of AM-PM
  # that's what we want !
  return(datesStrHoboRaw)
}

