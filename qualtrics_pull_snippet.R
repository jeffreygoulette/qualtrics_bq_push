#####Loading Required Packages#####
###################################


library(qualtRics)
library(tidyverse)
library(bigrquery)
library(sqldf)

getwd()

######Loading Qualtrics Credentials######
#########################################
#########################################

###@Kelly - you will have to add you specific Qualtrics API credentials below

#TO_DO api_key = kellys_qualrics_api_key
base_url = "burtoncorp.az1.qualtrics.com"


qualtrics_api_credentials("VU8AAFs6huDmeGUyzsO3HmBXgnv9dMMUb92bFANT",
                          base_url, install = TRUE)


#readRenviron("~/.Renviron")

######Importing Surveys through the Qualtrics API######

surveys = all_surveys()

#Checking to see list
surveys

#Selecting specific questions from single survey - this example would be survey
#with the id of 12
survey_questions(surveys$id[12])


#Pulling the actual survey responses into a dataframe, questions can be specified
#with a list of ids

questions = fetch_survey(surveyID = surveys$id[12],label = TRUE,convert = FALSE,force_request = TRUE,
                   include_questions = c('QID30','QID11','QID12','QID36','QID1','QID4','QID5',
                                         'QID6','QID7','QID8'))

#Updating columns names and cleaning data

questions_trim = questions%>%
  dplyr::select(starts_with("Q"))%>%
  dplyr::rename("Email" = Q4,
                "Gender" = Q8,
                "Age" = Q9,
                "Country" =Q35)%>%
  drop_na(starts_with("Q"))

#Checking out the results

questions_trim

#Renaming for upload to BigQuery

  
#####Upload to BigQuery#####

project_id = "cdp-alpha-v1"


#TO_DO data_set_name = "enter_data_set_name" #must exist before upload!
#TO_DO table_name = "enter_table_name"
  
insert_upload_job(project_id,data_set_name,table_name,upload_file, write_disposition = "WRITE_APPEND")

