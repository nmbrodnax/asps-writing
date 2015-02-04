library(RCurl) #for http requests
library(RJSONIO)

#define key(s)
mytoken <- "[user_token]:api_token" #my user token
wstoken <- "[workspace_token]:api_token" #workspace token
login <- "[login]:[password]" #toggl login info

#get my data from toggl - either method works
#me = getURL("https://www.toggl.com/api/v8/me", userpwd=login, httpauth=1L)
#me = getURL("https://www.toggl.com/api/v8/me", userpwd=mytoken, httpauth=1L)

#get workspace user data from toggl - workspace token doesn't work but login does
users <- getURL("https://www.toggl.com/api/v8/workspaces/724807/users", userpwd=login, httpauth=1L, verbose=TRUE)
projects <- getURL("https://www.toggl.com/api/v8/workspaces/724807/projects", userpwd=login, httpauth=1L, verbose=TRUE)

#parse data
userinfo <- fromJSON(users) #need this to match user ids to writing time
user_details <- data.frame(matrix(unlist(userinfo), ncol=35, byrow=T))
colnames(user_details) <- names(userinfo[[1]][1:35])

proj_data <- fromJSON(projects) #this creates a nested list
#can't put these into a matrix because the lists are of unequal lengths
