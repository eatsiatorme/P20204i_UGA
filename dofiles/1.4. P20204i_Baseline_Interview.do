quietly {
n: di "${proj}_${round}_Interview.do Started"

/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file runs checks at an interview level

A basic narrative is that it runs checks on both -cleaning- and -corrections- datasets - so they should be aligned in the variables, variable types etc.
The data manager then makes changes to fix issues in the corrections do-file. If the issue is flagged in the cleaning but not in the corrections data after
then it implies that it was fixed. 

In future - if we go further with this, maybe checking against both is not necessary.

	1. Sets up the coding required to make the hyperlink in excel - should try and come up with a more permanent solution here
	2. Sets up the coding required for the checking sheets
	3. Checks for existence of cleaning and corrections datasets
	4. Coding of the logical checks
	5. Creating the outputs of the checking sheets 
	
	
Normally I would include outliers in this using -ipacheckoutliers- however for this survey, outliers were not really applicable

*/

local checksheet "${main_table}_CHECKS"

****************************************
* 1. SETTING UP HYPERLING CODE IN EXCEL*
****************************************

mata: 
mata clear
void basic_formatting(string scalar filename, string scalar sheet, string matrix vars, string matrix colors, real scalar nrow) 
{

class xl scalar b
real scalar i, ncol
real vector column_widths, varname_widths, bottomrows
real matrix bottom

b = xl()
ncol = length(vars)

b.load_book(filename)
b.set_sheet(sheet)
b.set_mode("open")

b.set_bottom_border(1, (1, ncol), "thin")
b.set_font_bold(1, (1, ncol), "on")
b.set_horizontal_align(1, (1, ncol), "center")

if (length(colors) > 1 & nrow > 2) {	
for (j=1; j<=length(colors); j++) {
	b.set_font((3, nrow+1), strtoreal(colors[j]), "Calibri", 11, "lightgray")
	}
}


// Add separating bottom lines : figure out which columns to gray out	
bottom = st_data(., st_local("bottom"))
bottomrows = selectindex(bottom :== 1)
column_widths = colmax(strlen(st_sdata(., vars)))	
varname_widths = strlen(vars)

for (i=1; i<=cols(column_widths); i++) {
	if	(column_widths[i] < varname_widths[i]) {
		column_widths[i] = varname_widths[i]
	}

	b.set_column_width(i, i, column_widths[i] + 2)
}

if (rows(bottomrows) > 1) {
for (i=1; i<=rows(bottomrows); i++) {
	b.set_bottom_border(bottomrows[i]+1, (1, ncol), "thin")
	if (length(colors) > 1) {
		for (k=1; k<=length(colors); k++) {
			b.set_font(bottomrows[i]+2, strtoreal(colors[k]), "Calibri", 11, "black")
		}
	}
}
}
else b.set_bottom_border(2, (1, ncol), "thin")

b.close_book()

}

void add_scto_link(string scalar filename, string scalar sheetname, string scalar variable, real scalar col)
{
	class xl scalar b
	string matrix links
	real scalar N

	b = xl()
	links = st_sdata(., variable)
	N = length(links) + 1

	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	b.put_formula(2, col, links)
	b.set_font((2, N), col, "Calibri", 11, "5 99 193")
	b.set_font_underline((2, N), col, "on")
	b.set_column_width(col, col, 17)
	
	b.close_book()
	}
	
void add_script_link(string scalar filename, string scalar sheetname, string scalar variable, real scalar col)
{
	class xl scalar b
	string matrix links
	real scalar N

	b = xl()
	links = st_sdata(., variable)
	N = length(links) + 1

	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	b.put_formula(2, col, links)
	b.set_font((2, N), col, "Calibri", 11, "5 99 193")
	b.set_font_underline((2, N), col, "on")
	b.set_column_width(col, col, 17)
	
	b.close_book()
	}

end



********************************************************************************
*2. SETTING UP THE PROGRAM FOR THE ERROR LOOPS                                
********************************************************************************


	global i=0
	capture prog drop newErr	
	program newErr
	global i=${i}+1
	end
	
	capture prog drop addErr
	cd "$field_work_reports"
	cap mkdir checking_log

	program addErr
	qui{
		gen errDesc="`1'"
		di "`errorfile'"
			if !missing("$scto_server") {
			    gen scto_link=""
		local bad_chars `"":" "%" " " "?" "&" "=" "{" "}" "[" "]""'
		local new_chars `""%3A" "%25" "%20" "%3F" "%26" "%3D" "%7B" "%7D" "%5B" "%5D""'
		local url "https://$scto_server.surveycto.com/view/submission.html?uuid="
		local url_redirect "https://$scto_server.surveycto.com/officelink.html?url="

		foreach bad_char in `bad_chars' {
			gettoken new_char new_chars : new_chars
			replace scto_link = subinstr(key, "`bad_char'", "`new_char'", .)
		}
		replace scto_link = `"HYPERLINK("`url_redirect'`url'"' + scto_link + `"", "View Submission")"'
	}
	
		gen script_link=""
		decode vti, gen(vti_s)
		replace vti_s = upper(vti_s)
		clonevar form_number_s=form_number
		tostring form_number_s, replace 

		replace script_link = `"HYPERLINK("$scripts"' + vti_s + "\" + vti_s + " (" + form_number_s + ")" +".pdf" + `"", "View Script")"'
		drop vti_s form_number_s
	
		count if error!=.
		if `r(N)'>0{
			save "${errorfile}\error_${main_table}_${i}.dta", replace
		}
		keep if error!=.
		keep id error errDesc scto_link script_link vti form_number
		count if error != .
		dis "Found `r(N)' instances of error ${i}: `1'"
		capture duplicates drop
		save "`c(tmpdir)'error_${main_table}_${i}.dta", replace
	}
	end

******************************************
* 3. Check if files are present in cleaning**
******************************************

	local cleaningfiles: dir "$corrections" file "*.dta", respectcase
	if `"`cleaningfiles'"' != ""{
		local dirs cleaning corrections
		local flgNocleaning 0 
	}
	else{
		local dirs cleaning
		local flgNocleaning 1
	}
	
	foreach datadir in `dirs'{
		n di as result "Running Standard Checks  on `datadir' data"
		clear	
		tempfile `checksheet'
		gen float error=.
		gen str244 errDesc=""
		gen str86 Comment = ""
		gen scto_link=""
		format errDesc %-244s
		save "$checking_log\\`checksheet'_`datadir'", replace 

	 	n di "Running user specified checks on `datadir' data:"
	 	noisily{ //delete if you want to see less output
		


cd "$encrypted_path\Baseline\C2\Application Form\/`datadir'"

	
******************************************
* 4. CHECKS - DATA MANAGER TO ADD THESE IN
******************************************
		
	global i=1
	use "$main_table", clear
	gen error=${i} if form_number==10
	addErr "TEST"

	global i=2
	use "$main_table", clear
	gen error=${i} if (q2==.a |  q2==.b |  q2==.c |  q2==.) & duplicate_script==0
	addErr "Missing Value for Gender - Fix for Randomisation"
	
	global i=3
	use "$main_table", clear
	qui: duplicates tag vti form_number, gen(dup_formnum)
	gen error=${i} if dup_formnum>0
	addErr "Duplicate VTI Form Number"
	
	global i=4
	use "$main_table", clear
	gen q4_a_miss = !(q4_a==1 | q4_a==2)
	gen error=${i} if q4_a_miss==1 & (vti==1 | vti==4 | vti==5 | vti==6) & duplicate_script==0
	addErr "Missing Value for Refugee Status - Fix for Randomisation"
		
	/*global i=5
	use "$main_table", clear
	gen error=.
	ds t?_*_comx
	local comment_vars `r(varlist)'
	foreach var of varlist `comment_vars' {
		preserve
		gen `var'_dummy = (`var'!="")
		replace error=${i} if `var'_dummy==1  & duplicate_script==0
		addErr "Comment in variable `var' - Review for trade preference"
		global i=${i}+1
		restore
	}
	*/

	global i=30
	use "$main_table", clear
	gen error=${i} if (consent==.a |  consent==.b |  consent==.c |  consent==.)  & duplicate_script==0 & no_consent==0
	addErr "Missing Value for Consent - Fix for Randomisation"

	global i=31
	use "$main_table", clear
	gen error=${i} if consent==0 & no_consent==0
	addErr "Selected no for consent - Remove"
	
	global i=32
	use "$main_table", clear
	gen error=${i} if q1=="-444" | q1=="-555"
	addErr "Missing Name - Check against Paper Copy"
	
	global i=33
	use "$main_table", clear
	gen error=${i} if age<19 &  above_18==. & duplicate_script==0
	addErr "Age Below 18 - Check against Paper Copy"
	
	global i=34
	use "$main_table", clear
	gen error=${i} if q20<0 & duplicate_script==0
	addErr "Distance is Negative mins - Check against Paper Copy"
	
	*global i=35
	*use "$main_table", clear
	*gen error=${i} if q20>1000 & duplicate_script==0 & !(q20==.a |  q20==.b |  q20==.c |  q20==.) 
	*addErr "Distance is more than 1000 mins - Check against Paper Copy"
	
	*global i=36
	*use "$main_table", clear
	*gen error=${i} if q19<1 & duplicate_script==0
	*addErr "Distance is less than 1km/mile - Check against Paper Copy"
	
	global i=37
	use "$main_table", clear
	gen error=${i} if q19>100 & !(q19==.a |  q19==.b |  q19==.c |  q19==.) & duplicate_script==0
	addErr "Distance more than 100 Km/miles - Check against Paper Copy"
	
	global i=38
	use "$main_table", clear
	gen x= floor(log10( q6_a ))
	gen error=${i} if x!=8 & x!=.
	addErr "Less than 8 digits in phone number 1 - Check against Paper Copy"
	
	global i=39
	use "$main_table", clear
	gen x= floor(log10( q6_b ))
	gen error=${i} if x!=8 & x!=.
	addErr "Less than 8 digits in phone number 2 - Check against Paper Copy"
	
	global i=40
	use "$main_table", clear
	gen no_name = (q1=="-444" | q1=="-555")
	
	
	qui: bysort vti: strgroup q1 if (no_name==0 & name_ok==0), gen(duplicate_id) threshold(0.2)
	qui: duplicates tag duplicate_id if (no_name==0 & name_ok==0), gen(duplicate_name)
	levelsof duplicate_id if duplicate_name>0 & (no_name==0 & name_ok==0), l(dup_id)
	foreach l of local dup_id {
	preserve
	gen error=${i} if duplicate_name>0 & duplicate_id==`l' & (no_name==0 & name_ok==0)
	addErr "Very Similar name within a VTI - duplicateid `l' - Check against Paper Copy"
	global i=${i}+1
	restore
	}
	
	
	global i=200
	use "$main_table", clear
	gen error=${i} if (strpos( q4_b , "CM") == 1 | strpos( q4_b , "CF") == 1) & q4_a!=2
	addErr "Not listed as Ugandan but ID starts with C"
	
	global i=201
	use "$main_table", clear
	gen error=${i} if age<18 & above_18==1 & duplicate_script==0 & no_consent==0 & age_correct==""
	addErr "Correct Age"
	
	global i=202
	use "$main_table", clear
	gen error=${i} if dist_km>100 & dist_km!=. & above_18==1 & duplicate_script==0 & no_consent==0
	addErr "More than 100 Km away - check script"
	
	global i=203
	use "$main_table", clear
	gen error=${i} if t1_ayilo==.b & above_18==1 & duplicate_script==0 & no_consent==0
	addErr "No trade preferences - check script"
	
	global i=204
	use "$main_table", clear
	gen error=${i} if t1_nyumanzi==.b & above_18==1 & duplicate_script==0 & no_consent==0
	addErr "No trade preferences - check script"
	
	global i=205
	use "$main_table", clear
	gen error=${i} if t1_ocea==.b & above_18==1 & duplicate_script==0 & no_consent==0
	addErr "No trade preferences - check script"
		}

	/*
	
	
		global i=
	use $main_table, clear
	gen error=${i} if
	addErr ""	

	
	*/
	
	
*****************************************************************************************************************
********************************************* END ERRORS ********************************************************
*****************************************************************************************************************
		
******************************************
* 4. Creating output
******************************************


		**************************	
		**CREATE CHECKING SHEETS**
		**************************	
	di "Creating checking sheets"
		cd "$field_work_reports"
		local I=$i
		di "`datadir'"
		use "$checking_log\/`checksheet'_`datadir'", clear
			forvalues f=1/`I'{
			capture confirm file "`c(tmpdir)'error_${main_table}_`f'.dta"
			*dis _rc
			if _rc==0{	
				append using "`c(tmpdir)'error_${main_table}_`f'.dta", nol
				sort id
				erase "`c(tmpdir)'error_${main_table}_`f'.dta"
			}
		}	
		save, replace

	}
		
**************************
**Merge exported and cleaning**
**************************
use "$checking_log\\`checksheet'_cleaning"
*destring id, replace
*drop if id==.
duplicates drop id_number error, force
save "$checking_log\\`checksheet'_cleaning", replace

use "$checking_log\\`checksheet'_corrections", clear
	if wordcount("`dirs'") > 1{
		merge 1:1 id error using "$checking_log\\`checksheet'_cleaning"

		replace Comment = "Fixed by cleaning" if _merge == 2
		replace Comment = "Caused by cleaning" if _merge == 1
		drop _merge
		save "$checking_log\\`checksheet'_all", replace
		cap export excel using  "$checking_log\/`checksheet'_FIXED.xlsx" if Comment == "Fixed by cleaning" , firstrow(var) sheet("`errors'") replace
		drop if Comment == "Fixed by cleaning"
	}

	** filter for already checked errors
	preserve
	capture	import excel using `"$checking_log\/`checksheet'_OK.xlsx"', clear first
	if _rc == 0 {
		tostring id, replace
		tempfile filter
		save `filter'
		restore
		merge 1:m id error using `filter', keepusing(id error) keep(1) nogen
	}
	else {
		drop if _n > 0
		set obs 1
		export excel using `"$checking_log\/`checksheet'_OK.xlsx"', firstrow(var) sheet("`errors'") replace
		restore
	}
	sort errDesc
	sort error id

	*display messages
	if _N == 0 {
		set obs 1
		n di "No errors to export! Checking sheet empty."
	}
	export excel using  "$checking_log\/`checksheet'.xlsx", firstrow(var) sheet("`errors'") replace

	n di "Checking sheet saved as $checking_log\/`checksheet'.xlsx"

	if `flgNocleaning'{
		n di "Cleaning data not found; checks only run on raw data"
	}

import excel "$checking_log\/${main_table}_CHECKS.xlsx", clear firstrow 
destring vti, replace
tostring Comment, replace
merge 1:1 id error using "$checking_log\\`checksheet'_all", keep(3) nogen

	sort errDesc
	sort error id
		unab allvars : _all
		local pos : list posof "scto_link" in allvars
		mata: add_scto_link("$checking_log\/${main_table}_CHECKS", "Sheet1", "scto_link", `pos')
		local pos : list posof "script_link" in allvars
		mata: add_script_link("$checking_log\/${main_table}_CHECKS", "Sheet1", "script_link", `pos')
		
n: di "${proj}_${round}_Interview.do Completed"	
}

