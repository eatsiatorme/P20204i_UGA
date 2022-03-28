quietly {
n: di "${proj}_${round}_Decryption.do Started"

/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file decrypts the veracrypt container holding PII data. 

*/

capture veracrypt, dismount drive(H)
cd "$project_folder"
veracrypt 04_Raw_Data_Ready2, mount drive($encrypted_drive)

n: di "${proj}_${round}_Decryption.do Completed"
}