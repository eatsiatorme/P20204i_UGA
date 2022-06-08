clear all
/*
*** Baseline
*** Application Form
*  Nathan Sivewright Dec 2021

This do-file creates final PDF scripts

Steps for preparing the scripts:

BEFORE DATA ENTRY:
For each VTI, select all scripts and rename (with all selected) as the name of the VTI. This will automatically rename them as 

Amelo (1)
Amelo (2)
Amelo (3)
...

Then use PDF Filename Stamper - https://www.saintjohnny.com/ - bit weird but it works well - and it will stamp the name of the file Amelo(1) etc. This is what then should be used
by the Data Entry Clerks for entering the form number.

AFTER DATA ENTRY:
It will be useful to rename and stamp the pdf with the unique ID number as this is what we will use going forward to identify participants in the evaluation

Enter the paths and then run this do-file - you should make a copy of the scripts on your local drive rather than the one-drive as there is a lot of data being worked on and syncing will be very long

*/
**********************************************************
* MACROS
**********************************************************
global encrypted_drive "H"
global encrypted_path "$encrypted_drive:"
global project_folder "$ONEDRIVE\$folder\02_Analysis\" 
global dofiles "C:\Users\/`c(username)'\Documents\GitHub\P20204_GMB\P20204i_UGA\dofiles"
global exported "$encrypted_path\Baseline\C2\Application Form\exported"
global corrections "$encrypted_path\Baseline\C2\Application Form\corrections"
global cleaning "$encrypted_path\Baseline\C2\Application Form\cleaning"
global randomization_ready "$encrypted_path\Baseline\C2\Application Form\randomization_ready"
global local_scripts "C:\Users\ElikplimAtsiatorme\Documents\00_Archive\Projects\08_All_Scripts - ID NUMBER - Copy\"


**********************************************************
* GETTING THE FORM NUMBER (e.g. Amelo (1) ) AS A STRING VARIABLE
**********************************************************
use "$corrections\Rise Baseline Form.dta", clear

decode vti, gen(vti_s)
tostring form_number, gen(form_number_s)

gen filenamepdf = vti_s + " (" + form_number_s + ")"

tempfile nate
save `nate'

**********************************************************
* FOR EACH VTI - GO THROUGH EACH FORM NUMBER AND RENAME THE PDF WITH THAT NAME AS ID NUMBER
**********************************************************

levelsof vti_s, l(vti_s)
foreach l of local vti_s {
	di "`l'"
	use `nate', clear
	keep if vti_s == "`l'"
	levelsof form_number_s, l(l_formnum)
	foreach x of local l_formnum {
	preserve
	keep if form_number_s=="`x'"
	di "`x'"
	local idnum = "`l'" + " (" + "`x'" + ")"
	local idnum = upper("`idnum'")	
		di "`idnum'"
	local riseid = id_number[1]
		local helb = upper("`riseid'")	
		di "`riseid'"
	di "$local_scripts\/`l'\/`idnum'.pdf"
	di "$local_scripts\/`l'\/`helb'.pdf"
	cd "$local_scripts\/`l'\"
	!rename "$local_scripts\/`l'\/`idnum'.pdf" "`riseid'.pdf"		
		restore
}

}
