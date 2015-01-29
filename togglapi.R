library(RCurl) #for http requests
library(XML) #for parsing data

#define key(s)
mytoken = "[user_token]:api_token" #my user token
wstoken = "[workspace_token]:api_token" #workspace token
login = "[toggl_username]:[password]" #toggl login info

#get my data from toggl - either method works
#me = getURL("https://www.toggl.com/api/v8/me", userpwd=login, httpauth=1L)
me = getURL("https://www.toggl.com/api/v8/me", userpwd=mytoken, httpauth=1L)

#get workspace user data from toggl - workspace token doesn't work but login does
users = getURL("https://www.toggl.com/api/v8/workspaces/724807/users", userpwd=login, httpauth=1L, verbose=TRUE)
projects = getURL("https://www.toggl.com/api/v8/workspaces/724807/projects", userpwd=login, httpauth=1L, verbose=TRUE)
