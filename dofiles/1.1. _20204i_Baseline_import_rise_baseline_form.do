* import_rise_baseline_form.do
*
* 	Imports and aggregates "Rise Baseline Form" (ID: rise_baseline_form) data.
*
*	Inputs:  "C:/Users/ElikplimAtsiatorme/OneDrive - C4ED/Dokumente/Desktop/P20204i_Baseline_Local/Rise Baseline Form_WIDE.csv"
*	Outputs: "C:/Users/ElikplimAtsiatorme/OneDrive - C4ED/Dokumente/Desktop/P20204i_Baseline_Local/Rise Baseline Form.dta"
*
*	Output by SurveyCTO March 28, 2022 11:15 AM.

* initialize Stata
clear all
set more off
set mem 100m

* initialize workflow-specific parameters
*	Set overwrite_old_data to 1 if you use the review and correction
*	workflow and allow un-approving of submissions. If you do this,
*	incoming data will overwrite old data, so you won't want to make
*	changes to data in your local .dta file (such changes can be
*	overwritten with each new import).
local overwrite_old_data 0

* initialize form-specific parameters
local csvfile "C:/Users/ElikplimAtsiatorme/OneDrive - C4ED/Dokumente/Desktop/P20204i_Baseline_Local/Rise Baseline Form_WIDE.csv"
local dtafile "C:/Users/ElikplimAtsiatorme/OneDrive - C4ED/Dokumente/Desktop/P20204i_Baseline_Local/Rise Baseline Form.dta"
local corrfile "C:/Users/ElikplimAtsiatorme/OneDrive - C4ED/Dokumente/Desktop/P20204i_Baseline_Local/Rise Baseline Form_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid subscriberid simid devicephonenum commentsx username duration caseid id_number q1 age q4_a_specify q4_b q6_c q6_d q6_f q7_village district_specify sub_county_specify_b parish_zone q8_specify"
local text_fields2 "q9_a q10_a q11_specify q12 q12_specify q15_specify q17 q17_specify q18_specify q13_a q13_c instanceid"
local date_fields1 "q3 q5 q13_b"
local datetime_fields1 "submissiondate starttime endtime"

disp
disp "Starting import of: `csvfile'"
disp

* import data from primary .csv file
insheet using "`csvfile'", names clear

* drop extra table-list columns
cap drop reserved_name_for_field_*
cap drop generated_table_list_lab*

* continue only if there's at least one row of data to import
if _N>0 {
	* drop note fields (since they don't contain any real data)
	forvalues i = 1/100 {
		if "`note_fields`i''" ~= "" {
			drop `note_fields`i''
		}
	}
	
	* format date and date/time fields
	forvalues i = 1/100 {
		if "`datetime_fields`i''" ~= "" {
			foreach dtvarlist in `datetime_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=clock(`tempdtvar',"DMYhms",2025)
						* automatically try without seconds, just in case
						cap replace `dtvar'=clock(`tempdtvar',"DMYhm",2025) if `dtvar'==. & `tempdtvar'~=""
						format %tc `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
		if "`date_fields`i''" ~= "" {
			foreach dtvarlist in `date_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=date(`tempdtvar',"DMY",2025)
						format %td `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
	}

	* ensure that text fields are always imported as strings (with "" for missing values)
	* (note that we treat "calculate" fields as text; you can destring later if you wish)
	tempvar ismissingvar
	quietly: gen `ismissingvar'=.
	forvalues i = 1/100 {
		if "`text_fields`i''" ~= "" {
			foreach svarlist in `text_fields`i'' {
				cap unab svarlist : `svarlist'
				if _rc==0 {
					foreach stringvar in `svarlist' {
						quietly: replace `ismissingvar'=.
						quietly: cap replace `ismissingvar'=1 if `stringvar'==.
						cap tostring `stringvar', format(%100.0g) replace
						cap replace `stringvar'="" if `ismissingvar'==1
					}
				}
			}
		}
	}
	quietly: drop `ismissingvar'


	* consolidate unique ID into "key" variable
	replace key=instanceid if key==""
	drop instanceid


	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable cbr_1 "CBR supervisor ID"
	note cbr_1: "CBR supervisor ID"
	label define cbr_1 1 "Maureen Nakirunda"
	label values cbr_1 cbr_1

	label variable cbr_2 "CBR officer ID"
	note cbr_2: "CBR officer ID"
	label define cbr_2 1 "Edward" 2 "Jonah" 3 "Alfred" 4 "Bani" 5 "Juma" 6 "Andrew" 7 "data_clerk_ 7" 8 "data_clerk_ 8"
	label values cbr_2 cbr_2

	label variable vti "Selected VTI"
	note vti: "Selected VTI"
	label define vti 1 "Omugo" 2 "Inde" 3 "Amelo" 4 "Ayilo" 5 "Nyumanzi" 6 "Ocea"
	label values vti vti

	label variable form_number "Please type in the form number"
	note form_number: "Please type in the form number"

	label variable q1 "1. Name of the youth"
	note q1: "1. Name of the youth"

	label variable q2 "2. Gender"
	note q2: "2. Gender"
	label define q2 1 "Male" 2 "Female" 3 "other" -555 "No response"
	label values q2 q2

	label variable q3 "3. Date of birth (ddmm/yyyy)"
	note q3: "3. Date of birth (ddmm/yyyy)"

	label variable q4_a "4.a. Status (Refugee/Ugandan)"
	note q4_a: "4.a. Status (Refugee/Ugandan)"
	label define q4_a 1 "Refugee" 2 "Ugandan National/Host community member" -96 "Other (please specify)" -555 "No response"
	label values q4_a q4_a

	label variable q4_a_specify "4.a.specify. Other Status Specify"
	note q4_a_specify: "4.a.specify. Other Status Specify"

	label variable q4_b "4.b. ID number (Ugandan/Reugee)"
	note q4_b: "4.b. ID number (Ugandan/Reugee)"

	label variable q5 "Date of Application"
	note q5: "Date of Application"

	label variable q6_a "6.a. Telephone Number 1"
	note q6_a: "6.a. Telephone Number 1"

	label variable q6_b "6.b. Telephone number 2"
	note q6_b: "6.b. Telephone number 2"

	label variable q6_c "Contact person name"
	note q6_c: "Contact person name"

	label variable q6_d "Relationship to contact person"
	note q6_d: "Relationship to contact person"

	label variable q6_e "Contact person telephone number"
	note q6_e: "Contact person telephone number"

	label variable q6_f "Email address of applicant"
	note q6_f: "Email address of applicant"

	label variable q7_village "7.a. Village/Town (Host Community) or Block (Refugees)"
	note q7_village: "7.a. Village/Town (Host Community) or Block (Refugees)"

	label variable district "7.b. District"
	note district: "7.b. District"
	label define district 1 "Adjumani" 2 "Arua" 3 "Madi-Okollo" 4 "Obongi" 5 "Moyo" 6 "Terego" -96 "Other (Specify)" -555 "No response"
	label values district district

	label variable district_specify "Specify other districts"
	note district_specify: "Specify other districts"

	label variable sub_county "7.c. Sub-County"
	note sub_county: "7.c. Sub-County"
	label define sub_county 101 "Adropi" 102 "Pachara" 103 "Adjumani Town Council" 104 "Ciforo" 105 "Ukusijoni" 106 "Dzaipi" 107 "Arinyapi" 108 "Ofua" 109 "Itirikwa" 110 "Pakele" 201 "Adumi" 202 "Aroi" 203 "Aii-Vu" 204 "Ajia" 205 "Arivu" 206 "Arua Hill" 207 "Ayivuni" 208 "Bileaffe" 209 "Dadamu" 210 "katrini" 211 "Logiri" 212 "Manibe" 213 "Oluko" 214 "Aroi" 215 "Omugo" 216 "River Oil" 217 "Uriama" 218 "Pajulu" 219 "Udupi" 220 "Uleppi" 221 "Vurra" 301 "Anyiribu" 302 "Ewanga" 303 "Inde" 304 "Offaka" 305 "Ogoko" 306 "Okollo" 307 "Pawor" 308 "Rhino Camp" 309 "Rigbo" 310 "Uleppi" 401 "Aliba" 402 "Gimara" 403 "Itula" 404 "Obongi" 501 "Difule" 502 "Laropi" 503 "Lefori" 504 "Metu" 505 "Moyo" -96 "Other(Specify)" -555 "No response"
	label values sub_county sub_county

	label variable sub_county_specify_b "Please specify the county within which your address is located"
	note sub_county_specify_b: "Please specify the county within which your address is located"

	label variable parish_zone "7.d. Parish/Zone"
	note parish_zone: "7.d. Parish/Zone"

	label variable q8 "8. Marital Status"
	note q8: "8. Marital Status"
	label define q8 1 "Married" 2 "Divorced" 3 "Single" 4 "Widowed" -96 "Other" -555 "No reponse"
	label values q8 q8

	label variable q8_specify "Please specify other marital status"
	note q8_specify: "Please specify other marital status"

	label variable q9_a "9.a. Mother's name"
	note q9_a: "9.a. Mother's name"

	label variable q9_b "9.b. Mothers telephone"
	note q9_b: "9.b. Mothers telephone"

	label variable q10_a "10.a. Father's name"
	note q10_a: "10.a. Father's name"

	label variable q10_b "10.b. Father's telephone"
	note q10_b: "10.b. Father's telephone"

	label variable q11 "11. What was your highest level of formal education you completed?"
	note q11: "11. What was your highest level of formal education you completed?"
	label define q11 1 "Primary Education" 2 "O-level" 3 "A-level" 4 "Tertiary Education" 5 "Vocational Education" 6 "No formal Education" -96 "Other" -555 "No response"
	label values q11 q11

	label variable q11_specify "Please specify your educational status"
	note q11_specify: "Please specify your educational status"

	label variable q12 "12. Reasons for dropping out of school (if any)"
	note q12: "12. Reasons for dropping out of school (if any)"

	label variable q12_specify "Please specify othe reasons"
	note q12_specify: "Please specify othe reasons"

	label variable q14 "14. In the last 6 months have you worked or currently working in a paid job that"
	note q14: "14. In the last 6 months have you worked or currently working in a paid job that has lasted one month or more?"
	label define q14 1 "Yes" 0 "No" -555 "No response"
	label values q14 q14

	label variable q15 "15. If YES, what was your position in said above job?"
	note q15: "15. If YES, what was your position in said above job?"
	label define q15 1 "Regular employee (of someone who is not a member of your household)" 2 "Regular family worker (of someone who is a member of your household)" 3 "Self employed" 4 "Apprentice" 5 "Casual worker (works upon demand and acording to needs of employer)" -96 "Other (Specify)" -555 "No response"
	label values q15 q15

	label variable q15_specify "Please specify other employment status in said job"
	note q15_specify: "Please specify other employment status in said job"

	label variable q17 "17. Why are you applying for this course?"
	note q17: "17. Why are you applying for this course?"

	label variable q17_specify "Please specify other reason for applying for this course"
	note q17_specify: "Please specify other reason for applying for this course"

	label variable q18_a "18.a. Household-related Vulnerabilities"
	note q18_a: "18.a. Household-related Vulnerabilities"
	label define q18_a 1 "Yes" 0 "No" -555 "No response"
	label values q18_a q18_a

	label variable q18_b "18.b. Mental health Vulnerabilities"
	note q18_b: "18.b. Mental health Vulnerabilities"
	label define q18_b 1 "Yes" 0 "No" -555 "No response"
	label values q18_b q18_b

	label variable q18_c "18.c. Physical health vulnerabilites"
	note q18_c: "18.c. Physical health vulnerabilites"
	label define q18_c 1 "Yes" 0 "No" -555 "No response"
	label values q18_c q18_c

	label variable q18_d "18.d. Chronic disease or conditions"
	note q18_d: "18.d. Chronic disease or conditions"
	label define q18_d 1 "Yes" 0 "No" -555 "No response"
	label values q18_d q18_d

	label variable q18_other "18.e. Other vulnerabilities aside vulnerabilities mentioned above?"
	note q18_other: "18.e. Other vulnerabilities aside vulnerabilities mentioned above?"
	label define q18_other 1 "Yes" 0 "No" -555 "No response"
	label values q18_other q18_other

	label variable q18_specify "Specify other vulnerabilities"
	note q18_specify: "Specify other vulnerabilities"

	label variable q13_a "13.a. TVET course attended"
	note q13_a: "13.a. TVET course attended"

	label variable q13_b "13.b. Year Last attended"
	note q13_b: "13.b. Year Last attended"

	label variable q13_c "Name of the TVET school previously attended"
	note q13_c: "Name of the TVET school previously attended"

	label variable q13_d "13.c. Certificate from DIT"
	note q13_d: "13.c. Certificate from DIT"
	label define q13_d 1 "Yes" 0 "No" -555 "No response"
	label values q13_d q13_d

	label variable q19 "19.a. Distance to VTI"
	note q19: "19.a. Distance to VTI"

	label variable q19_b "19.b. Kilometres"
	note q19_b: "19.b. Kilometres"
	label define q19_b 1 "Kilometers" 2 "Miles" -555 "No response"
	label values q19_b q19_b

	label variable q20 "20. Distance to VTI in minutes"
	note q20: "20. Distance to VTI in minutes"

	label variable consent "Do you wish to participate?"
	note consent: "Do you wish to participate?"
	label define consent 1 "Yes" 0 "No" -555 "No response"
	label values consent consent

	label variable signed "Did the applicant sign the form?"
	note signed: "Did the applicant sign the form?"
	label define signed 1 "Yes" 0 "No" -555 "No response"
	label values signed signed

	label variable t1_omugo "Which trade is your first choice?"
	note t1_omugo: "Which trade is your first choice?"
	label define t1_omugo 1 "Building & Concrete practices -Tiling & land scaping" 2 "Tailoring & Garment Cutting-Tailoring machines repair" 3 "Solar Installation, Repair & Maintenance" 4 "Plumbing - Repair of boreholes" 5 "Knitting & Weaving" 6 "Welding & Metal fabrication" 7 "Catering & Hotel Management" -555 "No Response"
	label values t1_omugo t1_omugo

	label variable t2_omugo "Which trade is your second choice?"
	note t2_omugo: "Which trade is your second choice?"
	label define t2_omugo 1 "Building & Concrete practices -Tiling & land scaping" 2 "Tailoring & Garment Cutting-Tailoring machines repair" 3 "Solar Installation, Repair & Maintenance" 4 "Plumbing - Repair of boreholes" 5 "Knitting & Weaving" 6 "Welding & Metal fabrication" 7 "Catering & Hotel Management" -555 "No Response"
	label values t2_omugo t2_omugo

	label variable t1_inde "16.a. First Trade Preference"
	note t1_inde: "16.a. First Trade Preference"
	label define t1_inde 1 "Carpentry & Joinery" 2 "Welding & Metal fabrication" 3 "Maintenance of small scale & industrial machines" 4 "Building & Concrete practices -Tiling & land scaping" 5 "Tailoring & Garment Cutting-Tailoring machines repair & fashion design" 6 "Motorcycle, Repair & Maintenance" 7 "Electrical Installation" -555 "No Response"
	label values t1_inde t1_inde

	label variable t2_inde "16.b. Second Trade Preference"
	note t2_inde: "16.b. Second Trade Preference"
	label define t2_inde 1 "Carpentry & Joinery" 2 "Welding & Metal fabrication" 3 "Maintenance of small scale & industrial machines" 4 "Building & Concrete practices -Tiling & land scaping" 5 "Tailoring & Garment Cutting-Tailoring machines repair & fashion design" 6 "Motorcycle, Repair & Maintenance" 7 "Electrical Installation" -555 "No Response"
	label values t2_inde t2_inde

	label variable t1_amelo "Which trade is your first choice?"
	note t1_amelo: "Which trade is your first choice?"
	label define t1_amelo 1 "Electrical Installation" 2 "BCP - Tailing and Compound scaping" 3 "Fashion" 4 "Welding and metal fabrication" 5 "Motorcycle repair" -555 "No Response"
	label values t1_amelo t1_amelo

	label variable t2_amelo "Which trade is your second choice?"
	note t2_amelo: "Which trade is your second choice?"
	label define t2_amelo 1 "Electrical Installation" 2 "BCP - Tailing and Compound scaping" 3 "Fashion" 4 "Welding and metal fabrication" 5 "Motorcycle repair" -555 "No Response"
	label values t2_amelo t2_amelo

	label variable t1_ayilo "Which trade is your first choice?"
	note t1_ayilo: "Which trade is your first choice?"
	label define t1_ayilo 1 "Tailoring & Garment Cutting-Tailoring machines repair" 2 "ICT-Graphic design & branding" 3 "Catering & Hotel Management" 4 "Solar Installation, Repair & Maintenance" 5 "Building & Concrete practices -Tiling & land scaping" 6 "Mechanics of small scale & industrial machines" -555 "No Response"
	label values t1_ayilo t1_ayilo

	label variable t2_ayilo "Which trade is your second choice?"
	note t2_ayilo: "Which trade is your second choice?"
	label define t2_ayilo 1 "Tailoring & Garment Cutting-Tailoring machines repair" 2 "ICT-Graphic design & branding" 3 "Catering & Hotel Management" 4 "Solar Installation, Repair & Maintenance" 5 "Building & Concrete practices -Tiling & land scaping" 6 "Mechanics of small scale & industrial machines" -555 "No Response"
	label values t2_ayilo t2_ayilo

	label variable t1_nyumanzi "Which trade is your first choice?"
	note t1_nyumanzi: "Which trade is your first choice?"
	label define t1_nyumanzi 1 "Tailoring & Garment Cutting-Tailoring machines repair" 2 "ICT-Graphic design & branding" 3 "Catering & Hotel Management" 4 "Solar Installation & Maintenance" 5 "Building & Concrete practices -Tiling & land scaping" 6 "Mechanics of small scale & industrial machines" -555 "No Response"
	label values t1_nyumanzi t1_nyumanzi

	label variable t2_nyumanzi "Which trade is your second choice?"
	note t2_nyumanzi: "Which trade is your second choice?"
	label define t2_nyumanzi 1 "Tailoring & Garment Cutting-Tailoring machines repair" 2 "ICT-Graphic design & branding" 3 "Catering & Hotel Management" 4 "Solar Installation & Maintenance" 5 "Building & Concrete practices -Tiling & land scaping" 6 "Mechanics of small scale & industrial machines" -555 "No Response"
	label values t2_nyumanzi t2_nyumanzi

	label variable t1_ocea "Which trade is your first choice?"
	note t1_ocea: "Which trade is your first choice?"
	label define t1_ocea 1 "Tailoring & Garment Cutting-Tailoring machines repair" 2 "ICT-Graphic design & branding" 3 "Catering & Hotel Management" 4 "Solar Installation, Repair & Maintenance" 5 "Building & Concrete practices -Tiling & land scaping" 6 "Mechanics of small scale & industrial machines" -555 "No Response"
	label values t1_ocea t1_ocea

	label variable t2_ocea "Which trade is your second choice?"
	note t2_ocea: "Which trade is your second choice?"
	label define t2_ocea 1 "Tailoring & Garment Cutting-Tailoring machines repair" 2 "ICT-Graphic design & branding" 3 "Catering & Hotel Management" 4 "Solar Installation, Repair & Maintenance" 5 "Building & Concrete practices -Tiling & land scaping" 6 "Mechanics of small scale & industrial machines" -555 "No Response"
	label values t2_ocea t2_ocea






	* append old, previously-imported data (if any)
	cap confirm file "`dtafile'"
	if _rc == 0 {
		* mark all new data before merging with old data
		gen new_data_row=1
		
		* pull in old data
		append using "`dtafile'"
		
		* drop duplicates in favor of old, previously-imported data if overwrite_old_data is 0
		* (alternatively drop in favor of new data if overwrite_old_data is 1)
		sort key
		by key: gen num_for_key = _N
		drop if num_for_key > 1 & ((`overwrite_old_data' == 0 & new_data_row == 1) | (`overwrite_old_data' == 1 & new_data_row ~= 1))
		drop num_for_key

		* drop new-data flag
		drop new_data_row
	}
	
	* save data to Stata format
	save "`dtafile'", replace

	* show codebook and notes
	codebook
	notes list
}

disp
disp "Finished import of: `csvfile'"
disp

* OPTIONAL: LOCALLY-APPLIED STATA CORRECTIONS
*
* Rather than using SurveyCTO's review and correction workflow, the code below can apply a list of corrections
* listed in a local .csv file. Feel free to use, ignore, or delete this code.
*
*   Corrections file path and filename:  C:/Users/ElikplimAtsiatorme/OneDrive - C4ED/Dokumente/Desktop/P20204i_Baseline_Local/Rise Baseline Form_corrections.csv
*
*   Corrections file columns (in order): key, fieldname, value, notes

capture confirm file "`corrfile'"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile'"
	disp

	* save primary data in memory
	preserve

	* load corrections
	insheet using "`corrfile'", names clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		drop notes
		
		* make sure that all values are in string format to start
		gen origvalue=value
		tostring value, format(%100.0g) replace
		cap replace value="" if origvalue==.
		drop origvalue
		replace value=trim(value)
		
		* correct field names to match Stata field names (lowercase, drop -'s and .'s)
		replace fieldname=lower(subinstr(subinstr(fieldname,"-","",.),".","",.))
		
		* format date and date/time fields (taking account of possible wildcards for repeat groups)
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvar in `datetime_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						gen origvalue=value
						replace value=string(clock(value,"MDYhms",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
						* allow for cases where seconds haven't been specified
						replace value=string(clock(origvalue,"MDYhm",2025),"%25.0g") if strmatch(fieldname,"`dtvar'") & value=="." & origvalue~="."
						drop origvalue
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvar in `date_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						replace value=string(clock(value,"MDY",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
					}
				}
			}
		}

		* write out a temp file with the commands necessary to apply each correction
		tempfile tempdo
		file open dofile using "`tempdo'", write replace
		local N = _N
		forvalues i = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local keyval=key[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if key=="`keyval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if key=="`keyval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if key=="`keyval'""' _n
			}
			file write dofile _tab `"if _rc ~= 0 {"' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab _tab `"disp "CAN'T APPLY CORRECTION IN ROW #`rownumval'""' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab `"}"' _n
			file write dofile `"}"' _n
		}
		file close dofile
	
		* restore primary data
		restore
		
		* execute the .do file to actually apply all corrections
		do "`tempdo'"

		* re-save data
		save "`dtafile'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile'"
	disp
}
