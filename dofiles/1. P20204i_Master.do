n: di "${proj}_Master.do Started"
/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file is the Master do-file for the baseline data management.
It will run do files that take data from export (from SurveyCTO) to clean.
	1. Decrypt the veracrypt container holding the PII
	2. Take the exported data from the local drive
	3. Clean the data 
	4. Make Corrections to the data based on the data quality checks run
	5. Do final preparation for the randomization
	6. Encrypt the veracrypt container holding PII

From the randomization_ready data you will be able to run the randomization do-files


****************************************************************************
**************IMPORTANT*****************************************************
*1. Run SurveyCTO Desktop first to export data from server to local drive before running this master do file.
*2. Download SurveyCTO do-file and into the "local_path" which will be created after running this master do file for the first time. 


^ The data collection is now closed, so the data downloaded from the SurveyCTO Desktop:
1. CSV
2. SurveyCTO Do-file
3. Media files fodler

Have now been moved to the encrypted folder and the paths updated. For a new data collection, the $scto_download should be reverted to $local_path
****************************************************************************
****************************************************************************
*/
clear all

// General Globals
global ONEDRIVE "C:\Users\/`c(username)'\C4ED\"

if "`c(username)'" == "DennisOundo" {
capture mkdir "C:\Users\Personal\OneDrive - C4ED\Desktop\P20204i_Baseline_Local" 
global local_path "C:\Users\/`c(username)'\Desktop\P20204i_Baseline_Local\"
global dofiles "C:\Users\/`c(username)'\Documents\GitHub\P20204i_UGA\dofiles"
}

if "`c(username)'" == "ElikplimAtsiatorme"{
capture mkdir "C:\Users\/`c(username)'\OneDrive - C4ED\Dokumente\Desktop\P20204i_Baseline_Local\" 
global local_path "C:\Users\/`c(username)'\OneDrive - C4ED\Dokumente\Desktop\P20204i_Baseline_Local"
global dofiles "C:\Users\/`c(username)'\Documents\GitHub\P20204_GMB\P20204i_UGA\dofiles"
}

global version = 0
global date = string(date("`c(current_date)'","DMY"),"%tdNNDD")
global time = string(clock("`c(current_time)'","hms"),"%tcHHMMSS")
global datetime = "$date"+"$time"
global dashboard = 1 // Enter 1 if you want the dashboard to run NOTE: Adds approx 5 mins


// Round and Tool
global proj "P20204i"
global round "Baseline"
global cohort "C2"
global tool "Application Form"

// Data Management Paths



global encrypted_drive "H"
global encrypted_path "$encrypted_drive:"
global project_folder "$ONEDRIVE\$folder\02_Analysis\" 
*global dofiles "$ONEDRIVE\$folder\02_Analysis\01_DoFiles\Field Data Management/$round\/$cohort\/$tool" 
global exported "$encrypted_path\Baseline\C2\Application Form\exported"
global corrections "$encrypted_path\Baseline\C2\Application Form\corrections"
global cleaning "$encrypted_path\Baseline\C2\Application Form\cleaning"
global randomization_ready "$encrypted_path\Baseline\C2\Application Form\randomization_ready"
global scto_download "$encrypted_path\Baseline\C2\Application Form\scto"
global qx "$ONEDRIVE\$folder\03_Questionnaires\01_Baseline\Programming\Rise_baseline_Form.xlsx"
global tables "$ONEDRIVE\$folder\02_Analysis\03_Tables_Graphs"
global scto_server "mannheimc4ed"
global main_table "Rise Baseline Form"
global field_progress "$encrypted_path\Baseline\C2\Application Form\field progress"
global data_entry_assign "$ONEDRIVE\$folder\04_Field Work\Data_Entry_Assignments.csv"
global share_CBR "$ONEDRIVE\$folder\04_Field Work\Share with CBR"
global share_ZMB "$ONEDRIVE\$folder\04_Field Work\Share with Zambia"
global location "$encrypted_drive:\"

global media_path "$local_path\media" // Enter media path on local
global main_data_path "$cleaning\/$main_table.dta" // Enter main dataset path


// Data Checks
global errorfile "$ONEDRIVE\$folder\04_Field Work\06_Checks\error datasets"
global checking_log "$ONEDRIVE\$folder\04_Field Work\06_Checks\checking_log"
local checksheet "${main_table}_CHECKS"
global scripts "C:\Users\NathanSivewright\C4ED\P20204i_EUTF_UGA - Documents\04_Field Work\07_All_Scripts\"


cd "$dofiles"

** ADO-FILES REQUIRED
*ssc install strgroup


*****************************************
****** 1. DATA PROCESSING *********
*****************************************
*do "1.0. ${proj}_${round}_Decryption.do"

cd "$dofiles"
do "1.1. ${proj}_${round}_Export.do"
cd "$dofiles"
do "1.2. ${proj}_${round}_Cleaning.do"
cd "$dofiles"
do "1.3. ${proj}_${round}_Corrections.do"
cd "$dofiles"
do "1.4. ${proj}_${round}_Interview.do"
cd "$dofiles"
do "1.45. ${proj}_${round}_Randomization_Ready.do"
cd "$dofiles"
do "1.5. ${proj}_${round}_Data_Progress.do"
cd "$dofiles"
*do "2.0. ${proj}_${round}_Encryption.do"


di "Ran Successfully"

n: di "${proj}_${tool}_Master.do Completed"
