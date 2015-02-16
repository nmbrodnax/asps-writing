###This script accesses the Toggl API, obtains time entries for all workspace users, and creates 
###dataframes for all time entry data from a given date for use in reports
###User login, user API token, and workspace API token are required for authentication

library(RCurl) #for http requests
library(RJSONIO) #for parsing JSON-formatted data
source("def_msec_hrs.R") #to convert milliseconds to hrs, min, and sec
#source("def_fromISO.R") #converts from ISO 8601 to R-readable date format

##AUTHENTICATION

#login/key info for toggl
login <- "[username]" #enter your username
password <- "[password]" #enter your password
workspace <- "[workspace_id]" #enter your workspace id

#api keys
mytoken <- "[user_api_token]:api_token" #enter your user token
wstoken <- "[workspace_api_token]:api_token" #enter your workspace token
auth <- paste(login,":",password,sep="")


#REQUEST TIME ENTRY DATA FROM SPECIFIC DATE

from_date <- "[YYYY-MM-DD]T01:00:00-05:00" #enter the start date

#url for detailed time entries
detail_url <- "https://toggl.com/reports/api/v2/details"

#request parameters for weekly, detailed, and summary reports
query <- paste("?user_agent=",login,"&workspace_id=",workspace,"&grouping:users",sep="")
query <- paste(query,"&since=",from_date,"&page:1",sep="")

#user time data
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


##CREATE DATAFRAME
time_entries <- NULL

for (i in 1:pages) {
  query <- paste("?user_agent=",login,"&workspace_id=",workspace,"&grouping:users",sep="")
  query <- paste(query,"&since=",from_date,"&page=",i,sep="")
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

stamp <- strsplit(from_date,"T")[[1]][1]
write.table(time_entries,paste("time_entries_",stamp,"_to_",Sys.Date(),".dat",sep=""))
