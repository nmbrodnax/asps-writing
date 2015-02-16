###This script creates user and workspace summary reports in a format suitable for an academic
###writing group, showing weekly and semester-long progress.
###User and time entry data must first be generated via togglapi.R and/or togglapi_all_time.r


##GET DATA

users <- read.table("user_details_2015-02-15.dat") #created by togglapi.r
week_time <- read.table("time_entries_2015-02-09_to_2015-02-15.dat") #created by togglapi_all_time.r
semester_time <- read.table("time_entries_2015-01-11_to_2015-02-15.dat") #created by togglapi_all_time.r


##USER INFO

user_info <- NULL
for (i in 1:length(users$id)) {
  id <- as.character(users$id[i])
  name <- as.character(users$fullname[i])
  email <- as.character(users$email[i])
  vars <- c(id,name,email)
  user_info <- rbind(user_info,vars,deparse.level=0)
}
labels <- c("id","name","email")
colnames(user_info) <- labels


##CREATE WEEK VARIABLES

week_data <- NULL
for (i in 1:length(users$id)) {
  wk_mon <- wk_tue <- wk_wed <- wk_thu <- wk_fri <- wk_sat <- wk_sun <-  0
  for (j in 1:length(week_time$entry_id)) {
    if (users$id[i] == week_time$user_id[j]) {
      if (week_time$end_day[j] == "Monday") {
        wk_mon <- (wk_mon + (week_time$entry_hrs[j]*60 + week_time$entry_min[j]))
      } else if (week_time$end_day[j] == "Tuesday") {
        wk_tue <- (wk_tue + (week_time$entry_hrs[j]*60 + week_time$entry_min[j]))
      } else if (week_time$end_day[j] == "Wednesday") {
        wk_wed <- (wk_wed + (week_time$entry_hrs[j]*60 + week_time$entry_min[j]))
      } else if (week_time$end_day[j] == "Thursday") {
        wk_thu <- (wk_thu + (week_time$entry_hrs[j]*60 + week_time$entry_min[j]))
      } else if (week_time$end_day[j] == "Friday") {
        wk_fri <- (wk_fri + (week_time$entry_hrs[j]*60 + week_time$entry_min[j]))
      } else if (week_time$end_day[j] == "Saturday") {
        wk_sat <- (wk_sat + (week_time$entry_hrs[j]*60 + week_time$entry_min[j]))
      } else {
        wk_sun <- (wk_sun + (week_time$entry_hrs[j]*60 + week_time$entry_min[j]))
      }
      }
    }
  vars <- c(wk_mon,wk_tue,wk_wed,wk_thu,wk_fri,wk_sat,wk_sun)
  week_data <- rbind(week_data,vars,deparse.level=0)
}
labels <- c("wk_mon","wk_tue","wk_wed","wk_thu","wk_fri","wk_sat","wk_sun")
colnames(week_data) <- labels
user_data <- cbind(data.frame(user_info),data.frame(week_data),deparse.level=0)


##CREATE SEMESTER VARIABLES

semester_data <- NULL
for (i in 1:length(users$id)) {
  sem_mon <- sem_tue <- sem_wed <- sem_thu <- sem_fri <- sem_sat <- sem_sun <-  0
  for (j in 1:length(semester_time$entry_id)) {
    if (users$id[i] == semester_time$user_id[j]) {
      if (semester_time$end_day[j] == "Monday") {
        sem_mon <- (sem_mon + (semester_time$entry_hrs[j]*60 + semester_time$entry_min[j]))
      } else if (semester_time$end_day[j] == "Tuesday") {
        sem_tue <- (sem_tue + (semester_time$entry_hrs[j]*60 + semester_time$entry_min[j]))
      } else if (semester_time$end_day[j] == "Wednesday") {
        sem_wed <- (sem_wed + (semester_time$entry_hrs[j]*60 + semester_time$entry_min[j]))
      } else if (semester_time$end_day[j] == "Thursday") {
        sem_thu <- (sem_thu + (semester_time$entry_hrs[j]*60 + semester_time$entry_min[j]))
      } else if (semester_time$end_day[j] == "Friday") {
        sem_fri <- (sem_fri + (semester_time$entry_hrs[j]*60 + semester_time$entry_min[j]))
      } else if (semester_time$end_day[j] == "Saturday") {
        sem_sat <- (sem_sat + (semester_time$entry_hrs[j]*60 + semester_time$entry_min[j]))
      } else {
        sem_sun <- (sem_sun + (semester_time$entry_hrs[j]*60 + semester_time$entry_min[j]))
      }
    }
  }
  vars <- c(sem_mon,sem_tue,sem_wed,sem_thu,sem_fri,sem_sat,sem_sun)
  semester_data <- rbind(semester_data,vars,deparse.level=0)
}
labels <- c("sem_mon","sem_tue","sem_wed","sem_thu","sem_fri","sem_sat","sem_sun")
colnames(semester_data) <- labels
user_data <- cbind(user_data,data.frame(semester_data),deparse.level=0)


#CREATE PLOTS

