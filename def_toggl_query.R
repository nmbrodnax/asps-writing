###Returns a dataframe with all time entries between the dates entered
###Dates must be in the format YYYY-MM-DD

library(RCurl) #for http requests
library(RJSONIO) #for parsing JSON-formatted data

msec.to.hrs <- function(milliseconds) {
  sec <- milliseconds/1000
  min_sec <- c(sec%/%60,sec%%60)
  hr_min_sec <- c(hr=min_sec[1]%/%60,min=min_sec[1]%%60,sec=min_sec[2])
}

toggl.time <- function(username,workspace_id,user_api_token,start_date,end_date) {
  
  #authentication
  mytoken <- paste(user_api_token,":api_token",sep="")
  
  #dates
  from_date <- paste(start_date,"T01:00:00-05:00",sep="")
  thru_date <- paste(end_date,"T11:59:59-05:00",sep="")
  
  #query
  detail_url <- "https://toggl.com/reports/api/v2/details"
  query <- paste("?user_agent=",username,"&workspace_id=",workspace_id,"&grouping:users",sep="")
  query <- paste(query,"&since=",from_date,"&until=",thru_date,"&page:1",sep="")
  
  #get data from toggl
  time_detail <- getURL(paste(detail_url,query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)
  
  #get count of time entries
  detail <- fromJSON(time_detail) #page 1 only
  entry_count <- detail[[4]] #total entries
  per_page <- detail[[5]] #max entries per page
  
  #calculate number of pages needed to request (can only request one at a time per Toggl)
  if (entry_count %% per_page > 0) {
    pages <- entry_count %/% per_page + 1
  } else {
    pages <- entry_count / per_page
  }
  
  #create dataframe
  time_entries <- NULL
  
  for (i in 1:pages) {
    query <- paste("?user_agent=",username,"&workspace_id=",workspace_id,"&grouping:users",sep="")
    query <- paste(query,"&since=",from_date,"&until=",thru_date,"&page=",i,sep="")
    time_detail <- getURL(paste(detail_url,query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)
    detail <- fromJSON(time_detail)
    for (i in 1:length(detail[[6]])) {
      tid <- as.character(detail[[6]][[i]]["id"]) #time entry
      pid <- as.character(detail[[6]][[i]]["pid"]) #project
      uid <- as.character(detail[[6]][[i]]["uid"]) #user
      dur <- as.numeric(detail[[6]][[i]]["dur"]) #duration
      start <- as.character(detail[[6]][[i]]["start"]) #start date/time
      end <- as.character(detail[[6]][[i]]["end"]) #end date/time
      time <- msec.to.hrs(dur)
      day <- weekdays(as.Date(strsplit(end,"T")[[1]][1]))
      entry <- c(tid,pid,uid,start,end,day,time)
      time_entries <- rbind(time_entries,entry,deparse.level=0)
    }
  }
  colnames(time_entries) <- c("entry_id","proj_id","user_id","start","end","end_day","entry_hrs","entry_min","entry_sec")
  time_entries <- data.frame(time_entries)
  time_entries$entry_hrs <- as.numeric(time_entries$entry_hrs)
  time_entries$entry_min <- as.numeric(time_entries$entry_min)
  time_entries$entry_sec <- as.numeric(time_entries$entry_sec)
  time_entries$start <- as.character(time_entries$start)
  time_entries$end <- as.character(time_entries$end)
}