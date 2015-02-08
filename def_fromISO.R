#Helper function that converts ISO 8601 format to date/time format needed for chron package
#ISO 8601 format YYYY-MM-DDTHH:MM:SS-00:00 (where -00:00 corresponds to UTC time zone)

fromISO <- function(char) {
  #change YYYY-MM-DD to MM/DD/YYYY
  date <- paste(substr(char,6,7),"/",substr(char,9,10),"/",substr(char,1,4),sep="")
  #get time (ignoring time zone)
  time <- substr(char,12,19)
  chron <- c(date,time)
}

