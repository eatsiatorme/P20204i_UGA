*quietly {
n: di "${proj}_${round}_Data_Progress.do Started"

/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file runs creates outputs for checking on data progress

It has two main outputs - the first being the Data Entry Progress which is effectively a master list of all the Application Forms scripts shared and then an indicator of whether
it has been submitted to the server. This is then split between the Zambia and Uganda assignments and saves an output to their respective shared folders. 

The second output is the Trades Preference Dashboard - it's not named so well. The summary page is actually a good summary of submissions in general, broken down by VTI, gender, refugee status etc.
Then there are individual sheets for each of the VTIs with a table summary of the trade preferences for each trade.

	1. Creates a single data_entry_progress sheet with all cases and whether they have been submitted to the server or not - then splits between UGA and Zambia
	2. Creates the Trades_Preference_Dashboard

*/

**********This might take sometime to run****************


********************************************************************************
* 1. Creating Data Entry Progress Sheet
********************************************************************************
<<<<<<< Updated upstream

=======
/*
>>>>>>> Stashed changes
import delimited using "$data_entry_assign", varnames(1) clear // if changed to numeric - delete stringcols
merge 1:1 vti form_number using "$cleaning\/$main_table.dta", keepusing(q1 cbr_2)
gen submission=(_merge==3)
label def L_submission 0 "No Submission" 1 "Submitted"
label val submission L_submission
drop _merge
label val vti vti

export excel using "$field_progress/data_entry_progress.xlsx", sheet("Caselist", modify)  firstrow(var)

preserve
keep if firm=="CBR"
drop firm
export excel using "$share_CBR/data_entry_progress.xlsx", firstrow(var) replace
restore

preserve
keep if firm=="ZMB"
drop firm
export excel using "$share_ZMB/data_entry_progress.xlsx", firstrow(var) replace
restore
<<<<<<< Updated upstream

=======
*/
>>>>>>> Stashed changes


********************************************************************************
* 2. Creating Trades Preference Dashboard
********************************************************************************


if $dashboard == 1 {
n: di "Dashboard Option Selected - will take approx 5 mins"
use "$corrections\/$main_table.dta", clear

putexcel set "$ONEDRIVE\$folder\04_Field Work\04_Randomisation\Trades_Preference_Dashboard.xlsx", modify sheet ("Summary")

forvalues num=1/6 {
count if vti==`num'
global cellx = `num'+2
putexcel C${cellx}=`r(N)', nformat(number)
count if vti==`num' & duplicate_script==1
putexcel G${cellx}=`r(N)', nformat(number)
count if vti==`num' & above_18==0
putexcel H${cellx}=`r(N)', nformat(number)
count if vti==`num' & blank_preference==1
putexcel I${cellx}=`r(N)', nformat(number)
count if vti==`num' & no_consent==1
putexcel J${cellx}=`r(N)', nformat(number)
}


use "$randomization_ready\/$main_table.dta", clear

forvalues num=1/6 {
count if vti==`num'
global cellz = `num'+2
putexcel L${cellz}=`r(N)', nformat(number)
count if vti==`num' & q2==1 & q4_a == 2
putexcel M${cellz}=`r(N)', nformat(number)
count if vti==`num' & q2==2 & q4_a == 2
putexcel N${cellz}=`r(N)', nformat(number)
count if vti==`num' & q2==1 & q4_a == 1
putexcel O${cellz}=`r(N)', nformat(number)
count if vti==`num' & q2==2 & q4_a == 1
putexcel P${cellz}=`r(N)', nformat(number)
count if vti==`num' & q2==1 & !(inlist (q4_a, 1, 2))
putexcel Q${cellz}=`r(N)', nformat(number)
count if vti==`num' & q2==2 & !(inlist(q4_a, 1, 2))
putexcel R${cellz}=`r(N)', nformat(number)
}

decode vti, gen(vti_s)
levelsof vti_s, l(vti_str)



foreach l of local vti_str {
di "`l'"

local vti_`l'_str_u = upper("`l'")
local vti_`l'_str_l = lower("`l'")

putexcel set "$ONEDRIVE\$folder\04_Field Work\04_Randomisation\Trades_Preference_Dashboard.xlsx", modify sheet ("`vti_`l'_str_u'")

forvalues i=1/14 {
global x=`i'+2
count if t1_`vti_`l'_str_l' ==`i'
putexcel C${x}=`r(N)', nformat(number)
count if t2_`vti_`l'_str_l'==`i'
putexcel D${x}=`r(N)', nformat(number)
count if t3_`vti_`l'_str_l'==`i'
putexcel E${x}=`r(N)', nformat(number)

count if t1_`vti_`l'_str_l' ==`i' & q2==1
putexcel I${x}=`r(N)', nformat(number)
count if t2_`vti_`l'_str_l'==`i' & q2==1
putexcel J${x}=`r(N)', nformat(number)
count if t3_`vti_`l'_str_l'==`i' & q2==1
putexcel K${x}=`r(N)', nformat(number)

count if t1_`vti_`l'_str_l' ==`i' & q2==2
putexcel O${x}=`r(N)', nformat(number)
count if t2_`vti_`l'_str_l'==`i' & q2==2
putexcel P${x}=`r(N)', nformat(number)
count if t3_`vti_`l'_str_l'==`i' & q2==2
putexcel Q${x}=`r(N)', nformat(number)

}

global x=${x}+3

count if vti_s=="`l'"
di "G${x}"
putexcel G${x}=`r(N)', nformat(number)

count if vti_s=="`l'" & q2==1
di "M${x}"
putexcel M${x}=`r(N)', nformat(number)

count if vti_s=="`l'" & q2==2
di "S${x}"
putexcel S${x}=`r(N)', nformat(number)
}

}

n: di "${proj}_${round}_Data_Progress.do Completed"
*}


