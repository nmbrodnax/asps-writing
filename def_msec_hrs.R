#Convert time from milliseconds to hours, minutes, and seconds

msec.to.hrs <- function(milliseconds) {
  sec <- milliseconds/1000
  min_sec <- c(sec%/%60,sec%%60)
  hr_min_sec <- c(hr=min_sec[1]%/%60,min=min_sec[1]%%60,sec=min_sec[2])
}