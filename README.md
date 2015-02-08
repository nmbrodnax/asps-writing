##Association of SPEA PhD Students
###Academic Writing Group Reporting Project

Documentation Last Modified: February 7, 2015

Members of the writing group are using multi-platform time-tracking tool [Toggl](http://www.toggl.com) to specifically track writing time on weekdays.  However, the Toggl dashboard is not conducive to the structure of a semester-long writing group session.

Using the [Toggl API](https://github.com/toggl/toggl_api_docs), I am in the process of developing user- and group-level reports to summarize our writing progress.

All scripts are written using [R](http://www.r-project.org).

**Status**
 * [togglapi.R](https://github.com/nmbrodnax/asps-writing/blob/master/togglapi.R) requests user and time-entry details from the Toggl website. A Toggl account and administrative access to a workspace is required.
 * [togglreports.R](https://github.com/nmbrodnax/asps-writing/blob/master/togglreports.R) IN PROGRESS
