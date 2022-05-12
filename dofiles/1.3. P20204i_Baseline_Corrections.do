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
replace q4_a=1 if id_number == "106BUV"
replace q4_a=1 if id_number == "22O2R5"
replace q4_a=1 if id_number == "SBVDIP"
replace q4_a=1 if id_number == "TL1YZN"
replace q4_a=1 if id_number == "VM6OS6"

replace q4_a=2 if id_number == "9D3LQB"
replace q4_a=2 if id_number == "QT5VP1"
replace q4_a=2 if id_number == "SGG13R"
replace q4_a=2 if id_number == "VAFSDB"
replace q4_a=2 if id_number == "ZLLA1O"






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
replace above_18 = 1 if age>=18 & age!=.


* Done by checking against script and confirming the age is missing 



* Done by checking against script and confirming the age is below 18
replace above_18 = 1 if id_number == "1235R3"

replace above_18 = 1 if id_number == "126BI9"
replace above_18 = 1 if id_number == "1MR36J"
replace above_18 = 1 if id_number == "238L10"
replace above_18 = 1 if id_number == "23K13O"
replace above_18 = 1 if id_number == "248K2Q"
replace above_18 = 1 if id_number == "25DOHB"
replace above_18 = 1 if id_number == "2TPMNC"
replace above_18 = 1 if id_number == "360DWC"
replace above_18 = 1 if id_number == "383PNP"
replace above_18 = 1 if id_number == "399L3G"
replace above_18 = 1 if id_number == "3EY97N"
replace above_18 = 1 if id_number == "3NKRZ1"
replace above_18 = 1 if id_number == "3XYR3M"
replace above_18 = 1 if id_number == "41UEDL"
replace above_18 = 1 if id_number == "44CWJC"
replace above_18 = 1 if id_number == "48OLRU"
replace above_18 = 1 if id_number == "4BXOYC"
replace above_18 = 1 if id_number == "4K82CP"
replace above_18 = 1 if id_number == "4TG76J"
replace above_18 = 1 if id_number == "4UDKT1"
replace above_18 = 1 if id_number == "4UX6A8"
replace above_18 = 1 if id_number == "5IX2CP"
replace above_18 = 1 if id_number == "68C0UO"
replace above_18 = 1 if id_number == "6UQNVA"
replace above_18 = 1 if id_number == "6YZF7G"
replace above_18 = 1 if id_number == "70TO71"
replace above_18 = 1 if id_number == "7ZC468"
replace above_18 = 1 if id_number == "804IB6"

replace above_18 = 1 if id_number == "85IGGX"
replace above_18 = 1 if id_number == "8SO733"
replace above_18 = 1 if id_number == "ARW6ZM"
replace above_18 = 1 if id_number == "DAXD1C"
replace above_18 = 1 if id_number == "EU60XT"
replace above_18 = 1 if id_number == "FIEQND"
replace above_18 = 1 if id_number == "FIXUT9"
replace above_18 = 1 if id_number == "FYV7WN"
replace above_18 = 1 if id_number == "G8MLBH"
replace above_18 = 1 if id_number == "GH26I6"
replace above_18 = 1 if id_number == "HKSI0K"
replace above_18 = 1 if id_number == "I9Y1D4"
replace above_18 = 1 if id_number == "KV41YC"
replace above_18 = 1 if id_number == "MFVBCV"
replace above_18 = 1 if id_number == "NMFEJA"
replace above_18 = 1 if id_number == "OM21CF"
replace above_18 = 1 if id_number == "Q32JSC"
replace above_18 = 1 if id_number == "S5FGT6"
replace above_18 = 1 if id_number == "SDGT4F"
replace above_18 = 1 if id_number == "T1RMUH"
replace above_18 = 1 if id_number == "T94K4H"
replace above_18 = 1 if id_number == "VX8J4V"
replace above_18 = 1 if id_number == "WU1F6O"
replace above_18 = 1 if id_number == "ZF8UA9"


* Done by checking against script and finding correct age
replace age_correct="10/03/2000"  if id_number=="9D3LQB"
replace age_correct="01/01/2003"  if id_number=="E4X2TW"
replace age_correct="05/10/1996"  if id_number=="GP6PJA"	 
replace age_correct="21/03/1998"  if id_number=="GZ9JX6"
replace age_correct="27/09/1991"  if id_number=="HUJ7VJ"
replace age_correct="23/2/2002"  if id_number=="K023NI"	 
replace age_correct="20/3/2003"  if id_number=="TE6VFQ"	 
replace age_correct="06/11/2003"  if id_number=="U3J6WZ"
replace age_correct="1/3/1998"  if id_number=="VAFSDB"	 
replace age_correct="24/01/2002"  if id_number=="VRWPDW"
	 
	 
	 
	 
	 
	
	 
	 
	 













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
