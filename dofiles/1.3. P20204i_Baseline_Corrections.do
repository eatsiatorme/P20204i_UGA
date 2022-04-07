quietly {
	
n: di "${proj}_${round}_Corrections.do Started"

/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file makes corrections to the data based on the checks
	1. Copies the data from the cleaning folder to the corrections folder
	2. Corrects the data

The order of the data corrections is effectively chronological rather than necessarily by type of correction. Though we have tried to at least describe what we are doing in sub-sections

*/
 
cd "$corrections"

local files: dir "$cleaning" file "*.dta", respectcase
foreach file of local files{
	di `"`file'"'
	copy `""$cleaning\/`file'"' `"$corrections\/`file'"', replace
}

use "$main_table", clear


********************************************************************************
* CORRECTING REFUGEE STATUS
********************************************************************************
* Done by checking against script



********************************************************************************
* CORRECTING CONSENT
********************************************************************************
* Done by checking against script



********************************************************************************
* DUPLICATE SCRIPTS
********************************************************************************
* Done by checking against scripts based on similar names



// Making the duplicate scripts "empty" - so not included in any dashboards for numbers of women etc.

ds vti form_number key duplicate_script id_number, not 
foreach var of varlist `r(varlist)' {

	capture confirm numeric variable `var'
    if !_rc {
		replace `var' = .z if duplicate_script == 1 
  
		}
	else {
	replace `var' = "" if duplicate_script == 1 
	}
	
}


********************************************************************************
* DUPLICATE SCRIPTS - CHECKS AND CONFIRMING WHEN NOT A DUPLICATE
********************************************************************************
* These are cases where we confirmed script is not duplicate despite similar name




********************************************************************************
* FIXING AGES
********************************************************************************
* Done by checking against script and confirming above 18 if less than or equal to 19 years old
replace above_18 = 1 if age>=19 & age!=.

* Done by checking against script and confirming the age is missing 



* Done by checking against script and confirming the age is below 18




********************************************************************************
* CONSENT CHECKS
********************************************************************************
* Done by checking against script and confirming no consent / consent = no


********************************************************************************
* FIXING INCORRECTLY ENTERED AGES
********************************************************************************
* Done by checking against script and finding correct age




********************************************************************************
* CREATING A CLEAN AGE VARIABLE USING CURRENT AGE ON 16TH NOVEMBER 2021
********************************************************************************

gen age_correct_dt=date(age_correct,"DMY",2025)
format %td age_correct_dt

replace q3 = age_correct_dt if age_correct_dt!=.


gen age_current_date="07/04/2022" // Age calculated from 16th November
gen age_correct_date_dt=date(age_current_date,"DMY",2025)
format %td age_correct_date_dt

personage q3, gen(current_age) currdate(age_correct_date_dt)

label var current_age "Current Age (In years)"

********************************************************************************
* CREATING EXCEPTIONS FOR THE BLANK PREFERENCE APPLICANTS - SO THEY DON'T GET REMOVED
********************************************************************************



********************************************************************************
* ANY CONSENT FIXING FOR OMUGO
********************************************************************************	

********************************************************************************
* SAVE CORRECTED DATA
********************************************************************************

save "$main_table", replace 



*******************************************
*Exit code
*******************************************
n: di "${proj}_${round}_Corrections.do Completed"
}
