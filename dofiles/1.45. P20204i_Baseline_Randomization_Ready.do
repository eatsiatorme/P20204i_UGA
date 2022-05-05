quietly {
n: di "${proj}_${round}_Randomization_Ready.do Started"

/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file runs creates the final randomization ready dataset

	1. Filters out the ineligible cases for the randomization
	2. Creates a variable indicating that we are missing data for a variable to collect post-randomization
	3. Creates a binary variable for a previous TVET - to be honest this should probably be in cleaning do-file, but it's here - maybe because it's possibly a bit contentious
	4. Final cleaning
	5. Creating notes on the dataset and variable
	
*/


cd "$randomization_ready"

local files: dir "$corrections" file "*.dta", respectcase
foreach file of local files{
	di `"`file'"'
	copy `""$corrections\/`file'"' `"$randomization_ready\/`file'"', replace
}




use "$randomization_ready\/$main_table.dta", clear

********************************************************************************
* 1. FILTERING OUT INELIGIBLE
********************************************************************************

gen ineligible = 0
replace  ineligible = 1 if duplicate_script==1
replace  ineligible = 1 if above_18!=1
replace  ineligible = 1 if no_consent==1
replace  ineligible = 1 if blank_preference==1

**********************
* UNDERAGE - REMOVE
**********************

preserve
keep if ineligible == 1 & above_18!=1 
save "$randomization_ready\/underage.dta", replace
restore

**********************
* WAITLIST
**********************

preserve
keep if ineligible == 1  & above_18==1 
save "$randomization_ready\/waitlist.dta", replace
restore

********************************************************************************
* ELIGIBLE APPLICANTS
********************************************************************************

keep if ineligible == 0
count if above_18!=1 | duplicate_script==1 | no_consent==1 | blank_preference==1
if `r(N)'> 0 {
	di as error "Ineligible Applicant in Randomization - Please Remove"
}


********************************************************************************
* 2. GENERATING BINARY VARIABLE FOR COLLECTION POST-RANDOMIZATION
********************************************************************************
gen pr_name = (q1=="-555")
label var pr_name "Get Name Post Randomization"

gen pr_refugee=(q4_a==.b)
label var pr_name "Get Refugee Status Post Randomization"
********************************************************************************
* 3. GENERATING BINARY VARIABLE FOR PREVIOUS TVET
********************************************************************************
gen q17_a_binary = 1
replace q17_a_binary = 0 if q17_a=="NONE" | q17_a=="-555"
replace q17_a_binary = .b if q17_a=="-666" | q17_a=="-444"

gen q17_c_binary = 1
replace q17_c_binary = 0 if q17_c=="NONE" | q17_c=="-555"
replace q17_c_binary = .b if q17_c=="-666" | q17_c=="-444" | q17_c=="-888"

gen q17_d_binary = q17_d
replace q17_d_binary = 0 if q17_d==.b

gen q17_b_binary = (q17_b<td(27oct2021))

egen any_tvet = rowtotal(q17_a_binary q17_b_binary q17_c_binary q17_d_binary)
replace any_tvet = 1 if any_tvet > 0

drop q17_a_binary
drop q17_c_binary
drop q17_d_binary
drop q17_b_binary


label var any_tvet "Any previous TVET (1=YES)"


********************************************************************************
* 4. FINAL CLEANING
********************************************************************************
#d ;
cap drop 
deviceid 
subscriberid 
simid 
devicephonenum 
commentsx 
username 
duration 
caseid
formdef_version 
key 
isvalidated 
submissiondate 
starttime 
endtime 
q5 
duration_m 
age_correct_dt 
age_current_date 
age_correct_date_dt
age_correct
q6_c 
q6_d 
q6_e 
q6_f
q4_a_specify
cbr_1
cbr_2
name_ok
;
#d cr

cap drop *_comx

gen round = "$round"
label var round "Data Collection Round"
gen cohort = "$cohort"
label var cohort "Cohort Number"

label var q12__96 "q12_8. Reasons for dropping out of school [Other]"
label var q12__555 "q12_8. Reasons for dropping out of school [Unanswered]"
label var ineligible "Eligibility status for randomization [1 = Ineligible]"
label var pr_refugee "Collect refugee staus post-randomization [1 = Yes]"
label var pr_name "Collect name post-randomization [1 = Yes]"

label def L_TVET 0 "No previous TVET" 1 "Attended Previous TVET"
label val any_tvet L_TVET

cap order q12_9-q12_16, after(q12_8)
cap order q15_4-q15_6, after(q15_3)
order q3 current_age, after(q2)
order q17_b, after(q17_a)
cap order round cohort duplicate_script above_18 no_consent blank_preference blank_preference_ex ineligible, after(id_number)
order dist_km, after(q18_b)

destring q6_a, replace
destring q6_b, replace


foreach var of varlist q6_a q6_b {

gen x= floor(log10(`var'))

replace `var'=.x if x!=8 & x!=.
drop x
}




ds, has(type string) 
foreach var of varlist `r(varlist)' {
	
replace `var' = upper(`var')
}


********************************************************************************
* 5. NOTES
********************************************************************************
note duplicate_script: In some cases there were duplicate scripts that were scanned but had different form_numbers. We checked these cases by checking for similar names and filtered out the duplicate scripts. If this is the case, the value was coded as 1. For the randomization, all cases where duplicate_script=1, are removed.

note above_18: After the cleaning of the age variable, we created a binary variable that indicated whether the Applicant was 18 when applying for the RISE program. If this is the case, the value was coded as 0. For the randomization, all cases where above_18=0, are removed.

note no_consent: There were two main issues in the consent 1) Applicants selecting NO 2) Applicants leaving the consent blank. If either of these are the case, the value is coded as 1. For the randomization, all cases where no_consent=1, are removed.

note blank_preference: There were two main Due to the issues relating to the Application Scripts and Trades listed 1) Applicants who did not select any (very few cases) and 2) applicants selecting only trades which turned out not to be offered. If either of these are the case, the value is coded as 1.  For the randomization, all cases where blank_preference=1, are removed.

*note blank_preference_ex: In some cases, where it was in the interest of the programme/evaluation to allow them to be considered for randomization such as women/refugees, we made an exception for those with a blank preference and assigned them to a trade - Check with Thomas Eekhout

note ineligible: If any of duplicate_script, above_18, no_consent or blank_preference caused the applicant to be ineligible for randomization, the value is coded as 1. So for the evaluation, only those with ineligible=0 will be included.

note current_age: Age calculated at 16th November 2021

note dist_km: This is an attempt at cleaning the distance to VTI variable. There were two ways that I tried to estimate the distance, when it was missing. 1) If there was a missing value for the distance (q19) but there was a value for minutes to travel to VTI (q20) - we took 15 minutes per km (this was approx average when dividing minutes by km in dataset). 2) If the unit was missing (q19_b) but there was a value for the distance (q19) then I assumed it was km - vast majority of respondents gave in km

note any_tvet: It was not clear exactly how to code whether somebody had attended a previous TVET before. Coded as 1 if ANY of the form is filled in for the TVET section, to do this we created a binary variable for each of the TVET questions, q13_a-q13_d, if the question was answered. If any of them were = 1, the value was coded as 1. 

notes: This is the data entry output and ready for randomization for the RISE Impact Evaluation cohort 1. The data was entered and cleaned in October/November 2021 - RMs: Nathan Sivewright and Elikplim Atsiatorme. Some coding notes: variables: "-444" / .a means Illegible Handwriting, "-555" /.b means No answer written and "-666" / .c means Respondent indicated they don't know. .z means that the value was Removed as it was a duplicate Script. .x means that it was an inelgible response (such as for a phone number).

save "$randomization_ready\/$main_table.dta", replace

n: di "${proj}_${round}_Randomization_Ready.do Completed"
}