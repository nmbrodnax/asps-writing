library(RCurl) #for http requests
library(RJSONIO) #for converting JSON-format to R

##AUTHENTICATION

#login/key info for toggl
login <- "[username]" #enter your username
password <- "[password]" #enter your password
workspace <- "[workspace id]" #enter your workspace id

#api keys
mytoken <- "[user api key]:api_token" #enter your user token
wstoken <- "[workspace api key]:api_token" #enter your workspace token


##REQUEST USER DATA

auth <- paste(login,":",password)

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
weekly_query <- paste("?user_agent=",login,"&workspace_id=",workspace,"&grouping:users",sep="")

#user time data - need to use user api key rather than login
time_week <- getURL(paste(weekly_url,weekly_query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)
time_detail <- getURL(paste(detail_url,weekly_query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)
time_summary <- getURL(paste(summary_url,weekly_query,sep=""), userpwd=mytoken, httpauth=1L, verbose=TRUE)


##PARSE DATA

#user information
userinfo <- fromJSON(users) #need this to match user ids to writing time
user_details <- data.frame(matrix(unlist(userinfo), ncol=35, byrow=T))
colnames(user_details) <- names(userinfo[[1]][1:35])

#time entries - need to unlist into usable format
weekly <- fromJSON(time_week)
detail <- fromJSON(time_detail)
summary <- fromJSON(time_summary)

#projects created by users - not really needed for reports at this time
proj_data <- fromJSON(projects) #this creates a nested list
#can't put these into a matrix because the lists are of unequal lengths
#use length(proj_data[[i]]) to count rows in list i


##CREATE REPORTS

#user report


#writing group report


