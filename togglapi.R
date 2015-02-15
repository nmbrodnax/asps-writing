###This script accesses the Toggl API, obtains time entries for all workspace users, and creates 
###dataframes for user and time entry data for the last week for use in reports
###User login, user API token, and workspace API token are required for authentication

library(RCurl) #for http requests
library(RJSONIO) #for parsing JSON-formatted data
source("def_msec_hrs.R") #to convert milliseconds to hrs, min, and sec

##AUTHENTICATION

#login/key info for toggl
login <- "[username]" #enter your username
password <- "[password]" #enter your password
workspace <- "[workspace_id]" #enter your workspace id

#api keys
mytoken <- "[user_api_token]:api_token" #enter your user token
wstoken <- "[workspace_api_token]:api_token" #enter your workspace token


##REQUEST USER DATA

auth <- paste(login,":",password,sep="")

#get current user data - either method works
#me = getURL("https://www.toggl.com/api/v8/me", userpwd=auth, httpauth=1L)
#me = getURL("https://www.toggl.com/api/v8/me", userpwd=mytoken, httpauth=1L)

#url for workspace reports
ws_url <- "https://www.toggl.com/api/v8/workspaces/"

#get workspace user data - workspace token doesn't work but login does
users <- getURL(paste(ws_url,workspace,"/users",sep=""), userpwd=auth, httpauth=1L, verbose=TRUE)
projects <- getURL(paste(ws_url,workspace,"/projects",sep=""), userpwd=auth, httpauth=1L, verbose=TRUE)


#REQUEST TIME ENTRY DATA

#urls for weekly, detailed, and summary reports
weekly_url <- "https://toggl.com/reports/api/v2/weekly"
detail_url <- "https://toggl.com/reports/api/v2/details"
summary_url <- "https://toggl.com/reports/api/v2/summary"

#request parameters for weekly, detailed, and summary reports
query <- paste("?user_agent=",login,"&workspace_id=",workspace,"&grouping:users",sep="")

#user time data - need to use user api key rather than login
#time_week <- getURL(paste(weekly_url,query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)
time_detail <- getURL(paste(detail_url,query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)
#time_summary <- getURL(paste(summary_url,query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)


##PARSE DATA

#user information
userinfo <- fromJSON(users) #need this to match user ids to writing time
user_details <- data.frame(matrix(unlist(userinfo), ncol=35, byrow=T))
colnames(user_details) <- names(userinfo[[1]][1:35])

#time entries - need to unlist into usable format
detail <- fromJSON(time_detail) #user details are in list 6 of 6


##CREATE DATAFRAME

#create table of time entries by user
time_entries <- NULL

for (i in 1:length(detail[[6]])) {
  tid <- as.character(detail[[6]][[i]]["id"]) #time entry
  pid <- as.character(detail[[6]][[i]]["pid"]) #project
  uid <- as.character(detail[[6]][[i]]["uid"]) #user
  dur <- as.numeric(detail[[6]][[i]]["dur"]) #duration
  time <- msec.to.hrs(dur)
  entry <- c(tid,pid,uid,time)
  time_entries <- rbind(time_entries,entry,deparse.level=0)
}
colnames(time_entries) <- c("entry_id","proj_id","user_id","entry_hrs","entry_min","entry_sec")
time_entries <- data.frame(time_entries)
time_entries$entry_hrs <- as.numeric(time_entries$entry_hrs)
time_entries$entry_min <- as.numeric(time_entries$entry_min)
time_entries$entry_sec <- as.numeric(time_entries$entry_sec)

##SAVE DATA

write.table(user_details,paste("user_details_",Sys.Date(),".dat",sep=""))
write.table(time_entries,paste("time_entries_",Sys.Date(),".dat",sep=""))