quietly {
n: di "${proj}_${round}_Export.do Started"

/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file prepare the raw exported data from the SurveyCTO server
	1. This do file first erases all .dta files in the export, corrections, and cleaning folders in prepartion for new exports from the local drive. Data from the local drive is auomatically overwitten once SurveyCTO Desktop downloads data. 
	2. Amend the downloaded SurveyCTO do-file  to fix corrections in working directory of the local drive. 
	3. Run the amended SurveyCTO do-file for preliminary cleanining.
	4. Export .dta file from the local folder to the export folder.   

The output in the exported data folder is the raw data from the field - no further changes, cleaning or corrections. It is simply the CSV file from the SurveyCTO server with the SurveyCTO do-file ran

*/


***************************
** 1. erase files in export **
***************************
local deletepathexp = "$exported\/"
local files : dir "`deletepathexp'" file "*.dta", respectcase	
foreach file in `files'{	
	local fileandpathtodelete = "`deletepathexp'"+"`file'"
	capture erase "`fileandpathtodelete'"
}


***************************
** 2. erase files in cleaning **
***************************
local deletepathclean = "$cleaning\/"
local files : dir "`deletepathclean'" file "*.dta", respectcase	
foreach file in `files'{	
	local fileandpathtodelete = "`deletepathclean'"+"`file'"
	capture erase "`fileandpathtodelete'"
}

***************************
** 3. erase files in corrections **
***************************
local deletepathclean = "$corrections\/"
local files : dir "`deletepathclean'" file "*.dta", respectcase	
foreach file in `files'{	
	local fileandpathtodelete = "`deletepathclean'"+"`file'"
	capture erase "`fileandpathtodelete'"
}

/*
************************
** 4. SurveyCTO do-file 
************************
cd "$scto_download"
	do import_rise_baseline_form.do 
*/
**************************
 ** 5. Export .dta file to "export" folder
**************************
	clear
	local files: dir "$local_path" file "*.dta", respectcase
foreach file of local files{
	di `"`file'"'
	copy `""$local_path\/`file'"' `"$exported\/`file'"', replace
	}
	
	
n: di "${proj}_${round}_Export.do Completed"
}