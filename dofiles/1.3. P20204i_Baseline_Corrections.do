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

* CORRECTING GENDER
********************************************************************************
* Done by checking against script

replace q2=2 if id_number == "I41W8J"
replace q2=1 if id_number == "KZIB9L"
replace q2=1 if id_number == "PWPXC3"
replace q2=2 if id_number == "T1RMUH"
replace q2=2 if id_number == "U2TNXQ"
replace q2=2 if id_number == "U9F1CN"
replace q2=2 if id_number == "VAFSDB"
replace q2=2 if id_number == "XHFEOV"
replace q2=1 if id_number == "YIWYME"
replace q2=1 if id_number == "ZF8UA9"
replace q2=2 if id_number == "A6ZTLD"
replace q2=2 if id_number == "CVIG1V"
replace q2=1 if id_number == "J8T7TI"
replace q2=2 if id_number == "TII5SD"
replace q2=2 if id_number == "DHLKNM"
replace q2=2 if id_number == "HQW6YT"
replace q2=1 if id_number == "QPXBTC"
replace q2=2 if id_number == "M8FKAL"
********************************************************************************
* CORRECTING duplicate form_number
replace form_number = 527 if id_number == "J7BYJD"
replace form_number = 241 if id_number == "SIUL8K"
replace form_number = 121 if id_number == "YJ3R2J"


*******************************************************************************
********************************************************************************

********************************************************************************
* CORRECTING REFUGEE STATUS
********************************************************************************
* Done by checking against script
replace q4_a=1 if id_number == "106BUV"
replace q4_a=1 if id_number == "22O2R5"
replace q4_a=1 if id_number == "SBVDIP"
replace q4_a=1 if id_number == "TL1YZN"
replace q4_a=1 if id_number == "VM6OS6"
replace q4_a=1 if id_number == "GZEE6V"
replace q4_a=1 if id_number == "IXF4A8"
replace q4_a=1 if id_number == "UGUMSD"
replace q4_a=1 if id_number == "VRY6FX"
replace q4_a=1 if id_number == "VRY6FX"


replace q4_a=2 if id_number == "9D3LQB"
replace q4_a=2 if id_number == "QT5VP1"
replace q4_a=2 if id_number == "SGG13R"
replace q4_a=2 if id_number == "VAFSDB"
replace q4_a=2 if id_number == "ZLLA1O"
replace q4_a=2 if id_number == "994NNX"
replace q4_a=2 if id_number== "057FOO"








********************************************************************************
* CORRECTING CONSENT
********************************************************************************
* Done by checking against script
replace consent = 1 if id_number == "3ZN6LB"

replace no_consent=1 if id_number=="6TRYJ3"
replace no_consent=1 if id_number=="DUCDHK"
replace no_consent=1 if id_number== "25Q3NF"
replace no_consent=1 if id_number== "3ZN6LB"
replace no_consent=1 if id_number== "77W967"
replace no_consent=1 if id_number== "7WO4TY"
replace no_consent=1 if id_number== "B8FL5J"
replace no_consent=1 if id_number== "DTM0TP"
replace no_consent=1 if id_number== "EHQ410"
replace no_consent=1 if id_number== "H5J35O"
replace no_consent=1 if id_number== "HKKBGB"
replace no_consent=1 if id_number== "I136G9"
replace no_consent=1 if id_number== "LKWTMZ"
replace no_consent=1 if id_number== "MBHAG3"
replace no_consent=1 if id_number== "TPY720"
replace no_consent=1 if id_number== "V4D9RT"
replace no_consent=1 if id_number== "YXLZ8Q"

replace no_consent=1 if id_number== "121ZC2"
replace no_consent=1 if id_number== "1GYR8Y"
replace no_consent=1 if id_number== "2OZGM7"
replace no_consent=1 if id_number== "2OZGM7"
replace no_consent=1 if id_number== "515L4Q"
replace no_consent=1 if id_number== "701448"
replace no_consent=1 if id_number== "7GML8O"
replace no_consent=1 if id_number== "9WHB99"
replace no_consent=1 if id_number== "BEB4DI"
replace no_consent=1 if id_number== "DRC0XD"
replace no_consent=1 if id_number== "DS1IBV"
replace no_consent=1 if id_number== "FNJSER"
replace no_consent=1 if id_number== "HAFVDY"
replace no_consent=1 if id_number== "IXF4A8"
replace no_consent=1 if id_number== "KUWPQT"
replace no_consent=1 if id_number== "KY0CNI"
replace no_consent=1 if id_number== "OUW01Q"
replace no_consent=1 if id_number== "PKKJ2P"
replace no_consent=1 if id_number== "QA9MU5"
replace no_consent=1 if id_number== "RJVAAA"
replace no_consent=1 if id_number== "UZRVWP"
replace no_consent=1 if id_number== "ZZH997"
replace no_consent=1 if id_number== "GU65AY"
replace no_consent=1 if id_number== "HVNH67"
replace no_consent=1 if id_number== "ZEO72B"
replace no_consent=1 if id_number== "5ASXX8"
replace no_consent=1 if id_number== "7V36NZ"
replace no_consent=1 if id_number== "L15E0X"
replace no_consent=1 if id_number== "YAI623"






replace consent=1 if id_number== "2SLFIR"
replace consent=1 if id_number== "449L48"
replace consent=1 if id_number== "NMAYYS"
replace consent=1 if id_number== "SIUL8K"
replace consent=1 if id_number== "ZB52IS"
replace consent=1 if id_number== "RWMLBR"
replace consent=1 if id_number== "O8VBOB"












********************************************************************************
* DUPLICATE SCRIPTS
********************************************************************************
* Done by checking against scripts based on similar names
replace duplicate_script = 1 if id_number=="EWG4KS"
replace form_number = 454 if id_number == "9K2H4R"
replace duplicate_script = 1 if id_number == "V63BNU"
replace duplicate_script = 1 if id_number == "WY3QB0"
replace duplicate_script = 1 if id_number == "N7NY01"



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

replace above_18 = 1  if id_number=="9D3LQB"
replace above_18 = 1  if id_number=="E4X2TW"
replace above_18 = 1  if id_number=="GP6PJA"	 
replace above_18 = 1  if id_number=="GZ9JX6"
replace above_18 = 1  if id_number=="HUJ7VJ"
replace above_18 = 1  if id_number=="K023NI"	 
replace above_18 = 1  if id_number=="TE6VFQ"	 
replace above_18 = 1  if id_number=="U3J6WZ"
replace above_18 = 1  if id_number=="VAFSDB"	 
replace above_18 = 1  if id_number=="VRWPDW" 
replace above_18 = 1 if id_number == "0B2ECL"
replace above_18 = 1 if id_number == "18G3O7"
replace above_18 = 1 if id_number == "3WYMQA"
replace above_18 = 1 if id_number == "63PRZG"
replace above_18 = 1 if id_number == "7WO4TY"
replace above_18 = 1 if id_number == "CK8EFO"
replace above_18 = 1 if id_number == "FHSPMY"
replace above_18 = 1 if id_number == "JFB55U"
replace above_18 = 1 if id_number == "KVHIPG"
replace above_18 = 1 if id_number == "L5Q5MP"
replace above_18 = 1 if id_number == "QNIUPZ"
replace above_18 = 1 if id_number == "S16SIF"
replace above_18 = 1 if id_number == "YA7D6C"
replace above_18 = 1 if id_number == "Z10AD3"
replace above_18 = 1 if id_number == "ZVWM0Q"
replace above_18 = 1 if id_number == "9BUQ5Y"
replace above_18 = 1 if id_number == "I78DZ6"
replace above_18 = 1 if id_number == "KTT42M"
replace above_18 = 1 if id_number == "N1N5Z5"
replace above_18 = 1 if id_number == "O0MZ8J"
replace above_18 = 1 if id_number == "OGU32Q"
replace above_18 = 1 if id_number == "PGPCWH"
replace above_18 = 1 if id_number == "T273MV"
replace above_18 = 1 if id_number == "XAS581"
replace above_18 = 1 if id_number == "UF7GYK"
replace above_18 = 1 if id_number == "XWL3JD"

replace above_18 = 1 if id_number == "4ZA1HN"
replace above_18 = 1 if id_number == "7A9X2D"
replace above_18 = 1 if id_number == "D5JJL3"
replace above_18 = 1 if id_number == "EEKCHU"
replace above_18 = 1 if id_number == "KNJ5FC"
replace above_18 = 1 if id_number == "PRDWQS"
replace above_18 = 1 if id_number == "V8I2IC"
replace above_18 = 1 if id_number == "YCEWYZ"
replace above_18 = 1 if id_number == "ZZ3BLB"







replace above_18 = 0 if id_number == "ANM6JA"
replace above_18 = 0 if id_number == "FDR76L"
replace above_18 = 0 if id_number == "G1EVZT"
replace above_18 = 0 if id_number == "GP2L2N"





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
replace age_correct = "01/01/1997" if id_number== "0B2ECL"
replace age_correct = "18/06/2002" if id_number == "3WYMQA"
replace age_correct = "08/04/2004" if id_number== "CK8EFO"
replace age_correct = "09/11/2002" if id_number== "FHSPMY"
replace age_correct = "01/01/1996" if id_number== "KVHIPG"
replace age_correct = "02/02/2002" if id_number == "S16SIF"
replace age_correct = "01/01/2000" if id_number == "YA7D6C"
replace age_correct = "01/03/2003" if id_number == "9BUQ5Y"
replace age_correct = "14/02/1998" if id_number == "FDR76L"
replace age_correct = "03/02/2000" if id_number == "I78DZ6"
replace age_correct = "03/04/2004" if id_number == "KTT42M"
replace age_correct = "04/09/2002" if id_number == "N1N5Z5"
replace age_correct = "08/05/1993" if id_number == "OGU32Q"
replace age_correct = "01/01/2003" if id_number == "T273MV"
replace age_correct = "01/05/1999" if id_number == "XAS581"
replace age_correct = "20/10/2000" if id_number == "4ZA1HN"
replace age_correct = "04/08/2000" if id_number == "D5JJL3"
replace age_correct = "08/07/1996" if id_number ==  "EEKCHU"
replace age_correct = "08/10/1998"  if id_number == "KNJ5FC"






***Age validation: 
*****************************************************************************
*These trainees need to have their age validated because they did not fill out the age section of the form. If they are beloe the age of 18 they must not be allowed to join the training.
******************************************************************************
replace validate_age = 1 if id_number == "18G3O7"
replace validate_age = 1 if id_number == "63PRZG"
replace validate_age = 1 if id_number == "7WO4TY"
replace validate_age = 1 if id_number == "JFB55U"
replace validate_age = 1 if id_number == "L5Q5MP"
replace validate_age = 1 if id_number == "QNIUPZ"
replace validate_age = 1 if id_number == "Z10AD3"
replace validate_age = 1 if id_number == "Z10AD3"

replace validate_age = 1 if id_number == "G1EVZT"
replace validate_age = 1 if id_number == "GP2L2N"
replace validate_age = 1 if id_number == "O0MZ8J"
replace validate_age = 1 if id_number == "PGPCWH"
replace validate_age = 1 if id_number == "UF7GYK"
replace validate_age = 1 if id_number == "XWL3JD"

replace validate_age = 1 if id_number == "7A9X2D"
replace validate_age = 1 if id_number == "PRDWQS"
replace validate_age = 1 if id_number == "V8I2IC"
replace validate_age = 1 if id_number == "YCEWYZ"
replace validate_age = 1 if id_number == "ZZ3BLB"






 
	 
	 
	 
	 
	
	 
	 
	 













********************************************************************************
* CONSENT CHECKS
********************************************************************************
* Done by checking against script and confirming no consent / consent = no
replace consent = 1 if id_number == "0M9SB0"
replace consent = 1 if id_number == "ACRLFL"
replace consent = 1 if id_number == "E4X2TW"
replace consent = 1 if id_number == "S2DDQG"



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
* Removing reapplicants who are in the control group from Cohort 1 to avoid contamination before randomisation
********************************************************************************	
drop if id_number == "CW8B67"
drop if id_number == "KEV1MD"
drop if id_number == "KUP6VC"

drop if id_number == "IXZ2JV"
drop if id_number == "BY3V2O"
drop if id_number == "6EMER8"
drop if id_number == "8ADA6K"
drop if id_number == "WPAXWL"

drop if id_number == "1XAYLD"
drop if id_number == "A66GK8"
drop if id_number == "HM2I3X"
drop if id_number == "MU66TE"
drop if id_number == "VYHX18"



********************************************************************************
* SAVE CORRECTED DATA
********************************************************************************

save "$main_table", replace 



*******************************************
*Exit code
*******************************************
n: di "${proj}_${round}_Corrections.do Completed"
}
