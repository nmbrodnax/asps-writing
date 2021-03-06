##[Association of SPEA PhD Students](http://spea.iu.edu/~asphds/home.php)
###Academic Writing Group Reporting Project

Documentation Last Modified: February 15, 2015

Members of the [writing group](http://spea.iu.edu/~asphds/writing.php) are using multi-platform time-tracking tool [Toggl](http://www.toggl.com) to track writing time on weekdays.  

Using the [Toggl API](https://github.com/toggl/toggl_api_docs), I am in the process of developing user- and group-level reports to summarize our group's writing progress over the course of a semester.

All scripts are written using [R](http://www.r-project.org).

**Status**
 * [togglapi.R](https://github.com/nmbrodnax/asps-writing/blob/master/togglapi.R) requests user and time-entry details from the Toggl website. By default, requests return all time entries for one week prior to the date of query. A Toggl account and administrative access to a workspace are required. 
 * [togglapi_all_time.R](https://github.com/nmbrodnax/asps-writing/blob/master/togglapi_all_time.R) requests time-entry details from a date specified by the user to the date of the query. A Toggl account and administrative access to a workspace are required. 
 * [togglreports.R](https://github.com/nmbrodnax/asps-writing/blob/master/togglreports.R) IN PROGRESS
 * Function Definitions
  * [def_fromISO.R](https://github.com/nmbrodnax/asps-writing/blob/master/def_fromISO.R) converts date/time in [ISO 8601](http://www.ietf.org/rfc/rfc3339.txt) format to a format readable by the [chron](http://cran.r-project.org/web/packages/chron/index.html) R package.
  * [def_msec_hrs.R](https://github.com/nmbrodnax/asps-writing/blob/master/def_msec_hrs.R) converts time in milliseconds to hours, minutes, and seconds.
