quietly {
	
n: di "${proj}_${round}_Cleaning.do Started"

/*
*** Baseline
*** Application Form
*  Elikplim Atsiatorme June 2021

This do-file begins the cleaning of the data
	1. Copies the data from the exported folder to the cleaning folder
	2. Cleans the data

The order of the data cleaning is effectively chronological rather than necessarily by type of cleaning. Though we have tried to at least describe what we are doing in sub-sections

*/
 
******************************
** 1. Copy Corrections Files to Cleaning
******************************

cd "$cleaning"

local files: dir `"$exported\/`file'"' file "*.dta", respectcase
foreach file of local files{
	di `"`file'"'
	copy `"$exported\/`file'"' `"$cleaning\/`file'"', replace
}


******************************
** 2. Cleaning
******************************

use "$main_table", clear


#d ;
capture order id_number
q1
vti
q2
q4_a
;
#d cr

destring age duration form_number , replace // Often SurveyCTO outputs variables as strings that are more intuitive as numeric
gen duration_m = duration/60 // Phone call duration in 60 mins

/*
********************************************************************************
* FIXING NAMES PROVIDED BY CBR
********************************************************************************
replace q1="Obhim Martin" if id_number=="MHIW1C"
replace q1="Anzovule Samuel" if id_number=="8HR97K"
replace q1="-555" if id_number=="YGEJIR"
replace q1="-555" if id_number=="Z4SJJG"
replace q1="-555" if id_number=="M60RFL"
replace q1="-555" if id_number=="H81MTL"
replace q1="Bullen Onjer" if id_number=="B36OLX"
replace q1="Grace Absalah" if id_number=="TVNT1V"
replace q1="Nyanbiitch Chuol Deng" if id_number=="6PXC5Y"
replace q1="Furaha Nugisha" if id_number=="G2ETG2"
replace q1="Alumati Suviour" if id_number=="SKVQF3"
replace q1="-555" if id_number=="LQR0N4"
replace q1="Sarafina Nyamijok" if id_number=="UNL2FY"
replace q1="Nyannyok Thon Monyawan" if id_number=="1E5CUC"
replace q1="Nyaboth Gatluak Malual" if id_number=="HR3UUX"
replace q1="-555" if id_number=="R5U6QC"
replace q1="-555" if id_number=="G3ND41"
replace q1="Angua Alice" if id_number=="AJLI8G"
replace q1="Ombaga Moses" if id_number=="MFNKS6"
replace q1="O'DAMA ALEX" if id_number=="Z5LPBE"
replace q1="APEW KENON" if id_number=="2ZFEW5"
replace q1="ENZAMA WILSON" if id_number=="49JUMV"
replace q1="AMVIKO MOLLY" if id_number=="HNRH3V"
replace q1="AWATIYO SIMONI" if id_number=="I5X48N"
replace q1="BENSON LOKE EDUKU" if id_number=="W0MKXB"
replace q1="ASKER SUNDAY" if id_number=="WZFUZ0"
*/
********************************************************************************
* TIDYING NAMES
********************************************************************************

replace q1 = upper(q1)
replace q1= strtrim(q1)
replace q1 = stritrim(q1)

foreach char in $ & @ \ / ! ? ^ % # {
replace q1=subinstr(q1,"`char'","",.)
}


cap replace q4_b = upper(q4_b)
cap replace q6_c = upper(q6_c)
cap replace q7_village = upper(q7_village)
cap replace q9_a = upper(q9_a)
cap replace q10_a = upper(q10_a)

********************************************************************************
* LABELLING VARIABLES
********************************************************************************

lab var duration "duration. Time spent by enumerator on data entry"
lab var id_number "id_number. Unique Identification"
lab var q1 "q1. What is  your name?"
lab var q2 "q2. Gender"
lab var q4_a "q4. Are you a refugee or a host community member"
lab var cbr_1 "cbr_1. Name of CBR supersivor"
lab var cbr_2 "cbr_2. Name of CBR officers doing data colllection"
lab var age "age. Age of respondent"
lab var q4_b "q4_b. Ugandan or refugee status number"
lab var q6_a "q6_a Telephone Number 1"
lab var q6_b "q6_b. Telephone Number 2"
lab var q6_c "q6_c. Contact person name"
lab var q6_d "q6_d. Relationship to contact person"
lab var q6_e "q6_e. Conact person telephone number " 
lab var q6_f "Email address of applicant"
lab var q7_village "Which village or block is your permanent reseidence" 
label var q6_f "q6_f. Email address of applicant"
label var q7_village "q7_village. Which village or block is your permanent residence"
label var district "district. Inwhich district is your current address"
label var district_specify "district_specify. Specify other district"
label var sub_county "sub_county. In which sub county is your address"
label var sub_county_specify_b "sub_county_specify. Please specify the sub county of your address"
label var parish_zone "parish_zone. In which Parish or zone is your address"
label var q8 "q8. What is your current marital status"
label var q8_specify "q8_specify. Please specify other marital status"
label var q9_a "q9_a. Mother's name"
label var q9_b "q9_b. Mother's telephone number"
label var q10_a "q10_a. Father's name"
label var q10_b "q10_b. Father's phone"
label var q11 "q11. What was your highest level of formal education"
label var q11_specify "q11_specify. Please specify your educational status"
label var q12 "q12. Reasons for dropping out of school"
label var q12_1 "q12_1. Reasons for dropping out of school [Financial reasons]"
label var q12_2 "q12_2. Reasons for dropping out of school [Domestic obligations]"
label var q12_3 "q12_3. Reasons for dropping out of school [Employment]"
label var q12_4 "q12_4. Reasons for dropping out of school [Peer pressure]"
label var q12_5 "q12_5. Reasons for dropping out of school [Health]"
label var q12_6 "q12_6. Reasons for dropping out of school [Conflict]"
label var q12_7 "q12_7. Reasons for dropping out of school [Migration]"
label var q12_8 "q12_8. Reasons for dropping out of school [Pregnancy]"
cap label var q13_begin "q13_begin. Has respondent attended a previous TVET training"
label var q13_a "q13_a. Name of previous TVET training attended"
label var q13_b "q13_b. Year previous TVET training was attended"
label var q13_c "q13_c. Name of the previous TVET school previously attended"
label var q13_d "q13_d. Certificate from DIT"
label var q14 "q14. Worked or working in a paid job in the last 6 months that lasted at least 1 month" 
label var q15 "q15. Employment status in said job"
label var q15_specify "q15_specify. Please specify other status in said job"
label var t1_omugo "t1_omugo. First preferred trade [Omugo]"
label var t2_omugo "t2_omugo. Second preferred trade [Omugo]"
*label var t3_omugo "t3_omugo. Third preferred trade [omugo]"
label var t1_inde "t1_inde. First preferred trade [Inde]"
label var t2_inde "t2_inde. Second preferred trade [Inde]"
*label var t3_inde "t3_inde. Third preferred trade [Inde]"
label var t1_amelo "t1_amelo. First preferred trade [Amelo]"
label var t2_amelo "t2_amelo. Second preferred trade [Amelo]"
*label var t3_amelo "t3-amelo. Third preferred trade [Amelo]"
label var t1_ayilo "t1_ayilo. First preferred trade [Ayilo]"
label var t2_ayilo "t2_ayilo. Second preferred trade [Ayilo]"
*label var t3_ayilo "t3_ayilo. Third preferred trade [Ayilo]"
label var t1_nyumanzi "t1_nyumanzi. First preferred trade [nyumanzi]"
label var t2_nyumanzi "t2_nyumanzi. Second preferred trade [Nyumanzi]"
*label var t3_nyumanzi "t3_nyumanzi. Third preferred trade [Nyumanzi]"
label var t1_ocea "t1_ocea. first preferred trade [Ocea]"
label var t2_ocea "t2_ocea. Second preferred trade [Ocea]"
*label var t3_ocea "t3_ocea. Third preferred trade [Ocea]"
label var q17 "q17. Reason for applying to preferred course"
label var q17_specify "q17_specify. Other reasons for applying to preferred course"
label var q18_a "q18_a. Exposed to household vulnerabilities"
label var q18_b "q18_b. Exposed to mental health vulnerabilities"
label var q18_c "q18_c. Exposed to physical health vulnerabilities"
label var q18_d "q18_d. Exposed to a chronic disease or condition"
label var q18_other "q18_other. Exposed to other vulneralities"
label var q18_specify "q18_specify. Please specify the other vulnerabilities"
label var q19 "q19. Distance from home of applicant to VTI"
label var q19_b "q19_b. Unit of distance [Kilometres or Miles]"
label var q20 "q20. Travelling time in minutes from home of applicant to VTI" 
label var q3 "q3. Date of birth of applicant"
label var q5 "q5. Date of application"

********************************************************************************
* REMOVING UNNECCESARY VARIABLES
********************************************************************************
* I think many of these are from the Gambia but is set up in a way that doesn't matter if they don't exist

local test_list "v99 v100 v101 v102 v103 v104 v105 v106 v107 v108 v109 v110 v111 v112 cbr_1_label cbr_2_label vti_label consent_label q2_label q4_a_label district_label sub_county_label q11_label q12_a_label q12_label q13_begin_label q13_d_label q15_label t1_omugo_label t2_omugo_label  t1_inde_label t2_inde_label t1_amelo_label t2_amelo_label  t2_ayilo_label  t1_nyumanzi_label t2_nyumanzi_label t2_ocea_label q17_label q18_a_label q18_b_label q18_d_label q18_other_label q19_b_label sub_county_specify_a v113 q8_label q14_label t1_ayilo_label t1_ocea_label q18_c_label age_check_check age_validate_check age_check y age_validate v114 v115 v116 v117 v118 v119 v120 v121 v122 v123 v124 v125 v126 v127 v128 v129 v130 v131 v132"


tokenize `test_list'

while "`*'" != "" {
    capture confirm variable `1'
        if !_rc {
            di "`1' exists"
            drop `1'
        }
        else {
            di "not exist - do nothing"
        }
macro shift
}

********************************************************************************
* CREATING MISSING VARIABLES FOR NUMERIC AND TIDYING UP (NUMERIC AND STRING)
********************************************************************************

foreach var of varlist q1 q2 q4_a consent age q4_b q6_a q6_b q6_c q6_d q6_e q6_f q7_village district district_specify sub_county sub_county_specify_b parish_zone q8 q8_specify q9_a q9_b q10_a q10_b q11 q11_specify q12 q12_* q12_specify q13_a q13_c q13_d q14 q15 q15_specify t1_* t2_* q17_* q18_* q19 q19_b q20 {

	capture confirm numeric variable `var'
    if !_rc {
		recode `var' (555=-555)
		mvdecode `var', mv(-444 = .a \ -555 = .b \ -666 = .c )
  
		}
	else {
	replace `var' = "-444" if (strpos(lower(`var'), "444") | strpos(lower(`var'), "-44"))  > 0
	replace `var' = "-555" if (strpos(lower(`var'), "555") | strpos(lower(`var'), "-55"))  > 0
	replace `var' = "-666" if (strpos(lower(`var'), "666") | strpos(lower(`var'), "-66"))  > 0
	}
	
}




********************************************************************************
* REMOVING DUPLICATES - FOR SOME REASON DID SAME SCRIPTS
********************************************************************************
/*
drop if key=="uuid:270109f8-f404-4607-a12c-63eb7a5098cb"
drop if key=="uuid:6c23eec2-7f41-473d-82b1-8a6b7322e9af"
drop if key=="uuid:803856a2-eb60-47b8-9227-c90785e976a6"
drop if key=="uuid:811c44a6-97b4-4eb0-8eb8-78adc148b5a2"
drop if key=="uuid:8e42373f-2f43-4c31-890f-e4bdf3f18f5d"
drop if key=="uuid:acc6abd4-f775-47e6-a191-7e804aecfc16"
drop if key=="uuid:c42260b8-6294-4159-ae9d-100f87af7259"
drop if key=="uuid:cd306920-b81f-4bf2-8066-7de3377ee03a"
drop if key=="uuid:cf0f4b9b-3a69-412b-9b7c-3193939ae9ce"
drop if key=="uuid:e87ff208-415d-4fd9-b07f-628dcf834cc4"

drop if key=="uuid:ec2d5f3d-1c29-4605-9f96-c0db78357c45"
drop if key=="uuid:5c51c0f2-63c7-437f-93d2-c2da537f3021"
drop if key=="uuid:70b8d3a1-49d2-4bcd-b2b4-6831ba625a5a"

drop if key=="uuid:1a0e9dbe-5731-41c1-a08f-35c0dcb56ed3"
drop if key=="uuid:d2b39ce9-bd0a-4aaa-a8a7-3144e2aebf1a"

drop if key=="uuid:e21210e7-42d5-4874-9508-7be7da5dda29"
drop if key=="uuid:9d2a29fc-fd62-4ecb-b18d-ac5cecd1c914"
drop if key=="uuid:629ca447-38e4-48ed-8fa5-5ca7e7f7f43b"
drop if key=="uuid:9da50690-6a46-4c46-a537-63f735d35874"
drop if key=="uuid:a537808b-9977-48c5-ab9c-b67726fece12"
drop if key=="uuid:54756cc1-3610-4c3a-8c53-bb83aa936430"
drop if key=="uuid:e84c1709-65c6-434d-8476-e4138120a2d2"
drop if key=="uuid:e1073ec9-5a97-4bbb-8621-6f961b7049f8"
drop if key=="uuid:af6cc93f-6c88-479c-882f-782000f94bcf"
drop if key=="uuid:7fa8ced1-b184-4b4d-a5f4-28b1be8be559"

drop if key=="uuid:82c76e6f-c823-49f5-bb04-adeeffc00c24"
drop if key=="uuid:42b78477-56e2-4474-acde-f594cf6df0cd"
drop if key=="uuid:87b07019-9a39-4e80-a7d2-f7352a883aaa"

drop if key=="uuid:ab8fa8f6-39a9-45ce-8282-6878c499d1c8"
drop if key=="uuid:d2fdc055-58f9-4067-8d1c-469c0b111827"
drop if key=="uuid:8be36eea-48df-4ea7-baa4-e8f27bfb1463"
drop if key=="uuid:befa2fcc-576d-4c12-9a17-7f94e8b083c8"

drop if key=="uuid:fb78ff67-ac48-4402-a6f5-7e4ca14fc91c"

********************************************************************************
* DROPPING DUPLICATE SUBMISSIONS - SEEMS TO BE SOMETHING WEIRD ON SURVEYCTO
********************************************************************************
drop if key=="uuid:988d7c75-514a-40fe-9bcd-3fea385ddc7d"

********************************************************************************
* CORRECTING INCORRECT FORM_NUMBER
********************************************************************************
replace form_number="220" if key== "uuid:f6a068d3-26d4-49d1-a4fd-1876febc1b5b" // Enumerator entered name of respondent as form number thus converting variable 'form_number' into string and not allowing destring to convert variable
destring form_number, replace 

replace form_number=302 if key=="uuid:e65e11db-053b-4624-95f8-dd5896059d59"
replace form_number=82 if key=="uuid:03c18c42-f95a-4e90-be74-a88bcea2e161"
replace form_number=182 if key=="uuid:eb5a9c0c-5d13-4a21-af77-14f71a995184"

replace form_number=38 if key=="uuid:cb5b9b3f-e367-4488-ac55-0985d45cfc7b"
replace form_number=241 if key=="uuid:c225a40f-9f4a-4cce-bed8-0eddb9fcdb23"
replace form_number=62 if key=="uuid:1b641107-84de-47c0-bc09-4a1bbafea9fe"
replace form_number=24 if key=="uuid:91e73982-ca0e-4fb0-b7c4-35b050b665e6"
replace form_number=90 if key=="uuid:c89f8e17-ba30-4762-996f-3565862cf74e"
replace form_number=240 if key=="uuid:65338011-a671-446a-9332-f07bd9338557"

replace form_number=141 if key=="uuid:49c7aa92-01b7-4173-b5c9-8a5991ad78dd"
replace form_number=132 if key=="uuid:611cbcbe-dbd5-4cbf-953b-d1483dff5f98"

replace form_number=220 if key=="uuid:442251e3-6fb7-4616-953f-d841c4bb8f06"
replace form_number=323 if key=="uuid:84666b49-1f2b-4f96-93ae-7016cdab444b"
replace form_number=229 if  key=="uuid:8b4e13b1-f9f7-4607-97ab-b6967a155320"
replace form_number=257 if key=="uuid:c0ba514f-80ca-4e4a-804c-e5a447c0ed47"
replace form_number=252 if key=="uuid:a2190bb2-e7ad-4c70-afe4-04000f765d92"
replace form_number=244 if key=="uuid:1439832c-a834-4f99-a0eb-7c32d68b8c0b"
replace form_number=423 if key=="uuid:444cdc33-4e1d-4008-8ead-660fbe060ce6"

*replace form_number=-999 if key=="uuid:82c76e6f-c823-49f5-bb04-adeeffc00c24" // PLACEHOLDER FORM NUMBER UNTIL WE CAN FIGURE OUT
*/
********************************************************************************
* CREATING BINARY VARIABLE FOR NO PREFERENCE INDICATED
********************************************************************************
gen no_pref=0
label def l_nopref 0 "Preference Indicated" 1 "No Preference Indicated"
label val no_pref l_nopref
label var no_pref "Preference Indicated in Trade"

/*
replace no_pref=1 if id_number=="PW0AKM"
replace no_pref=1 if id_number=="JFLDOT"
replace no_pref=1 if id_number=="25Q703"
replace no_pref=1 if id_number=="29S5R3"
replace no_pref=1 if id_number=="2UGRB8"
replace no_pref=1 if id_number=="4BEXYT"
replace no_pref=1 if id_number=="4JNZQR"
replace no_pref=1 if id_number=="513XZP"
replace no_pref=1 if id_number=="7KLA67"
replace no_pref=1 if id_number=="AOB7FK"
replace no_pref=1 if id_number=="ARA0F8"
replace no_pref=1 if id_number=="AYNL9M"
replace no_pref=1 if id_number=="B26JX4"
replace no_pref=1 if id_number=="BCLLGO"
replace no_pref=1 if id_number=="BDXJY8"
replace no_pref=1 if id_number=="BJSUQS"
replace no_pref=1 if id_number=="BOTR44"
replace no_pref=1 if id_number=="BY2NAG"
replace no_pref=1 if id_number=="CQFFFG"
replace no_pref=1 if id_number=="DS135L"
replace no_pref=1 if id_number=="H8DMA8"
replace no_pref=1 if id_number=="HAMNG7"
replace no_pref=1 if id_number=="I4RQN2"
replace no_pref=1 if id_number=="JIF9HV"
replace no_pref=1 if id_number=="JLPCD8"
replace no_pref=1 if id_number=="JO9X7E"
replace no_pref=1 if id_number=="LZXETO"
replace no_pref=1 if id_number=="MY6PAL"
replace no_pref=1 if id_number=="QBBN18"
replace no_pref=1 if id_number=="REO8LV"
replace no_pref=1 if id_number=="SRVXXO"
replace no_pref=1 if id_number=="T5TV8J"
replace no_pref=1 if id_number=="TDAY50"
replace no_pref=1 if id_number=="UIB4WJ"
replace no_pref=1 if id_number=="WK28RS"
replace no_pref=1 if id_number=="ZC951H"
replace no_pref=1 if id_number=="ZKU0AG"
replace no_pref=1 if id_number=="W1F8BG"
replace no_pref=1 if id_number=="JFLDOT"
replace no_pref=1 if id_number=="PW0AKM"

replace no_pref=1 if id_number=="Y1BW3I"
replace no_pref=1 if id_number=="MA7EJ2"
replace no_pref=1 if id_number=="GM862G"
replace no_pref=1 if id_number=="M9OXVP"
*/
********************************************************************************
* STANDARDIZING TRADES
********************************************************************************
/*
label def L_Trades 1 "BCP - Tailing and Compound scaping" 2 "TGC - Repair of Machines" 3 "Electrical Installation" 4 "Plumbing - Repair of deep well (boreholes)" 5 "Knitting and Weaving" 6 "Welding and Metal Fabrication" 7 "Solar Installation, Repair and Maintenance" 8 "Catering and Hotel Management" 9 "Carpentry & Joinery" 10 "Maintenance of small-scale industrial plants" 11 "Computer ICT Skills (Graphic design and branding)" 12 "TGC-fashion and Design" 13 "Motorcycle Repair" 14 "Maintenance of small scale and industrial machines"

** INDE
recode t1_inde t2_inde (5 = 2) (4 = 3) (7 = 6) (2 = 9) (6 = 10) (8 = 12) (3 = 13) (9 = 14)
label val t1_inde t2_inde  L_Trades

** AMELO
recode t1_amelo t2_amelo (2=1) (1=3) (4=6) (3=12) (5=13) 
label val t1_amelo t2_amelo  L_Trades

** AYILO
recode t1_ayilo t2_ayilo (5=1) (1=2) (8=3) (7=4) (10=6) (4=7) (3=8) (6=10) (2=11) (9=13)
label val t1_ayilo t2_ayilo  L_Trades

** NYUMANZI
recode t1_nyumanzi t2_nyumanzi (5=1) (1=2) (4=3) (11=4) (13=5) (8=6) (7=7) (3=8) (9=9) (6=10) (2=11) (12=12) (10=13) 
label val t1_nyumanzi t2_nyumanzi  L_Trades

** OCEA
recode t1_ocea t2_ocea (5=1) (1=2) (9=3) (11=4) (13=5) (10=6) (4=7) (3=8) (6=9) (2=10) (7=11) (12=12) (8=13)
label val t1_ocea t2_ocea L_Trades
*/

label def L_Trades 1 "Building & Concrete Practices - Tiling & Land Scaping" 2 "Tailoring and Garment Cutting - Tailoring Machine Repair" 3 "Solar Installation, Repair and Maintenance" 4 "Plumbing - Repair of Boreholes" 5 "Knitting and Weaving" 6 "Welding and Metal Fabrication" 7 "Catering and Hotel Management" 8 "Carpentry & Joinery" 9 "Maintenance of Small-Scale Industrial Machines" 10 "Electrical Installation" 11 "CT - Graphic Design and Branding" 12 "Tailoring and Garment Cutting - Tailoring Machines Repair and Fashion Design"  13 "Motorcycle Repair" 14 "Mechanics of Small Scale & Industrial Machine"

** INDE
recode t1_inde t2_inde (1 = 8) (2 = 6) (3 = 9) (4 = 1) (5 = 12) (6 = 13) (7 = 10)
label val t1_inde t2_inde  L_Trades


** AYILO
recode t1_ayilo t2_ayilo (1=2) (2=11) (3=7) (4=3) (5=1) (6=14) 
label val t1_ayilo t2_ayilo  L_Trades

** NYUMANZI
recode t1_nyumanzi t2_nyumanzi (1=2) (2=11) (3=7) (4=3) (5=1) (6=14)  
label val t1_nyumanzi t2_nyumanzi  L_Trades

** OCEA
recode t1_ocea t2_ocea (1=2) (2=11) (3=7) (4=3) (5=1) (6=14)
label val t1_ocea t2_ocea L_Trades

********************************************************************************
* FIXING TRADE PREFERENCES - correct!
********************************************************************************
/*
replace t1_ocea=3 if id_number=="ZO2KWH" 


replace t1_ayilo=11 if id_number=="YPQ1J7"
replace t3_ayilo=8 if id_number=="YPQ1J7"

replace t2_nyumanzi = 10 if id_number=="20A37L"
replace t3_nyumanzi = 1 if id_number=="BZ7JE8"

replace t2_nyumanzi = 8 if id_number=="6D9ZZ0"
replace t3_nyumanzi = 11 if id_number=="6D9ZZ0"

replace t2_nyumanzi = .b if id_number=="UDHPCD"

replace t1_nyumanzi = 11 if id_number=="A5GPU5"
replace t2_nyumanzi = .b if id_number=="A5GPU5"
replace t3_nyumanzi = 8 if id_number=="A5GPU5"

replace t1_nyumanzi = 1 if id_number=="LMNNDW"
replace t2_nyumanzi = .b if id_number=="LMNNDW"

replace t1_nyumanzi = 11 if id_number=="P6A1UC"
replace t2_nyumanzi = 10 if id_number=="P6A1UC"
*/
********************************************************************************
* DROPPING UNAVAILABLE TRADES AND ADJUSTING PREFERENCES
********************************************************************************
gen blank_preference=0
label var blank_preference "Blank Trades - Either incomplete or Removed Trades"
label def L_blank 0 "Has Trades Selected" 1 "Blank Trades"
label val blank_preference L_blank

*******************************
* AYILO
*******************************

forvalues num=1/2 {
	replace t`num'_ayilo=7 if t`num'_ayilo==3 & vti==4 // Changing Electrical Installation to Solar
	replace t`num'_ayilo=.b if inlist(t`num'_ayilo, 4, 5, 6, 9, 12, 13, 14) & vti==4 // Making missing if trade not offered
}


** Fixing any duplicate preferences - keep highest preference
forvalues trade=1/14 {
	egen x_`trade' = anycount(t?_ayilo), v(`trade')
	count if x_`trade' > 1
 	*replace t3_ayilo=.b if t3_ayilo==`trade' & x_`trade' > 1 & (t1_ayilo==`trade' | t2_ayilo==`trade') 
	replace t2_ayilo=.b if t2_ayilo==`trade' & x_`trade' > 1 & (t1_ayilo==`trade')
}


gen shift_left = .

forvalues num=1/2 {
	if `num'==1 {
	local num_plus_1 = `num'+1
	*local num_plus_2 = `num'+2
	replace shift_left = (t`num'_ayilo==.b & t`num_plus_1'_ayilo!=.b  & vti==4)
	replace t`num'_ayilo = t`num_plus_1'_ayilo if shift_left==1
	replace t`num_plus_1'_ayilo = .b if shift_left==1
	*replace shift_left = (t`num'_ayilo==.b & t`num_plus_1'_ayilo==.b & t`num_plus_2'_ayilo!=.b  & vti==4)
	*replace t`num'_ayilo = t`num_plus_2'_ayilo if shift_left==1
	*replace t`num_plus_2'_ayilo = .b  if shift_left==1
	}

/*	if `num'==2 {
	local num_plus_1 = `num'+1
	replace shift_left = (t`num'_ayilo==.b & t`num_plus_1'_ayilo!=.b  & vti==4)
	replace t`num'_ayilo = t`num_plus_1'_ayilo if shift_left==1 
	replace t`num_plus_1'_ayilo = .b if shift_left==1 
	}
	*/
}

drop x_* shift_left

replace blank_preference=1 if t1_ayilo==.b
*******************************
* NYUMANZI
*******************************

forvalues num=1/2 {
	replace t`num'_nyumanzi=7 if t`num'_nyumanzi==3 & vti==5 // Changing Electrical Installation to Solar
	replace t`num'_nyumanzi=.b if inlist(t`num'_nyumanzi, 4, 5, 6, 9, 12, 13, 14) & vti==5 // Making missing if trade not offered
}


** Fixing any duplicate preferences - keep highest preference
forvalues trade=1/14 {
	egen x_`trade' = anycount(t?_nyumanzi), v(`trade')
	count if x_`trade' > 1
 	*replace t3_nyumanzi=.b if t3_nyumanzi==`trade' & x_`trade' > 1 & (t1_nyumanzi==`trade' | t2_nyumanzi==`trade') 
	replace t2_nyumanzi=.b if t2_nyumanzi==`trade' & x_`trade' > 1 & (t1_nyumanzi==`trade')
}


gen shift_left = .

forvalues num=1/2 {
	if `num'==1 {
	local num_plus_1 = `num'+1
	*local num_plus_2 = `num'+2
	replace shift_left = (t`num'_nyumanzi==.b & t`num_plus_1'_nyumanzi!=.b  & vti==5)
	replace t`num'_nyumanzi = t`num_plus_1'_nyumanzi if shift_left==1
	replace t`num_plus_1'_nyumanzi = .b if shift_left==1
	*replace shift_left = (t`num'_nyumanzi==.b & t`num_plus_1'_nyumanzi==.b & t`num_plus_2'_nyumanzi!=.b  & vti==5)
	*replace t`num'_nyumanzi = t`num_plus_2'_nyumanzi if shift_left==1
	*replace t`num_plus_2'_nyumanzi = .b  if shift_left==1
	}
/*
	if `num'==2 {
	local num_plus_1 = `num'+1
	replace shift_left = (t`num'_nyumanzi==.b & t`num_plus_1'_nyumanzi!=.b  & vti==5)
	replace t`num'_nyumanzi = t`num_plus_1'_nyumanzi if shift_left==1 
	replace t`num_plus_1'_nyumanzi = .b if shift_left==1 
	}
*/
	}

drop x_* shift_left
replace blank_preference=1 if t1_nyumanzi==.b
*******************************
* OCEA
*******************************

forvalues num=1/2 {
	replace t`num'_ocea=7 if t`num'_ocea==3 & vti==6 // Changing Electrical Installation to Solar
	replace t`num'_ocea=.b if inlist(t`num'_ocea, 4, 5, 6, 9, 12, 13, 14) & vti==6 // Making missing if trade not offered
}


** Fixing any duplicate preferences - keep highest preference
forvalues trade=1/14 {
	egen x_`trade' = anycount(t?_ocea), v(`trade')
	count if x_`trade' > 1
 	*replace t3_ocea=.b if t3_ocea==`trade' & x_`trade' > 1 & (t1_ocea==`trade' | t2_ocea==`trade') 
	replace t2_ocea=.b if t2_ocea==`trade' & x_`trade' > 1 & (t1_ocea==`trade')
}


gen shift_left = .

forvalues num=1/2 {
	if `num'==1 {
	local num_plus_1 = `num'+1
	*local num_plus_2 = `num'+2
	replace shift_left = (t`num'_ocea==.b & t`num_plus_1'_ocea!=.b  & vti==6)
	replace t`num'_ocea = t`num_plus_1'_ocea if shift_left==1
	replace t`num_plus_1'_ocea = .b if shift_left==1
	*replace shift_left = (t`num'_ocea==.b & t`num_plus_1'_ocea==.b & t`num_plus_2'_ocea!=.b  & vti==6)
	*replace t`num'_ocea = t`num_plus_2'_ocea if shift_left==1
	*replace t`num_plus_2'_ocea = .b  if shift_left==1
	}
/*
	if `num'==2 {
	local num_plus_1 = `num'+1
	replace shift_left = (t`num'_ocea==.b & t`num_plus_1'_ocea!=.b  & vti==6)
	replace t`num'_ocea = t`num_plus_1'_ocea if shift_left==1 
	replace t`num_plus_1'_ocea = .b if shift_left==1 
	}
*/
	}

drop x_* shift_left

replace blank_preference=1 if t1_ocea==.b


*******************************
* INDE
*******************************

forvalues num=1/2 {
	replace t`num'_inde=10 if t`num'_inde==14 & vti==2 // Changing Electrical Installation to Solar
	replace t`num'_inde=.b if inlist(t`num'_inde, 4, 5, 7, 8, 11, 12, 14) & vti==2 // Making missing if trade not offered
}


** Fixing any duplicate preferences - keep highest preference
forvalues trade=1/14 {
	egen x_`trade' = anycount(t?_inde), v(`trade')
	count if x_`trade' > 1
 	*replace t3_inde=.b if t3_inde==`trade' & x_`trade' > 1 & (t1_inde==`trade' | t2_inde==`trade') 
	replace t2_inde=.b if t2_inde==`trade' & x_`trade' > 1 & (t1_inde==`trade')
}


gen shift_left = .

forvalues num=1/2 {
	if `num'==1 {
	local num_plus_1 = `num'+1
	*local num_plus_2 = `num'+2
	replace shift_left = (t`num'_inde==.b & t`num_plus_1'_inde!=.b  & vti==2)
	replace t`num'_inde = t`num_plus_1'_inde if shift_left==1
	replace t`num_plus_1'_inde = .b if shift_left==1
	*replace shift_left = (t`num'_inde==.b & t`num_plus_1'_inde==.b & t`num_plus_2'_inde!=.b  & vti==2)
	*replace t`num'_inde = t`num_plus_2'_inde if shift_left==1
	*replace t`num_plus_2'_inde = .b  if shift_left==1
	}
/*
	if `num'==2 {
	local num_plus_1 = `num'+1
	replace shift_left = (t`num'_inde==.b & t`num_plus_1'_inde!=.b  & vti==2)
	replace t`num'_inde = t`num_plus_1'_inde if shift_left==1 
	replace t`num_plus_1'_inde = .b if shift_left==1 
	}
*/
	}

drop x_* shift_left

replace blank_preference=1 if t1_inde==.b



*******************************
* OMUGO
*******************************

forvalues num=1/2 {
	replace t`num'_omugo=.b if inlist(t`num'_omugo, 9, 10, 11, 12, 13, 14) & vti==1 // Making missing if trade not offered
}


** Fixing any duplicate preferences - keep highest preference
forvalues trade=1/14 {
	egen x_`trade' = anycount(t?_omugo), v(`trade')
	count if x_`trade' > 1
 	*replace t3_omugo=.b if t3_omugo==`trade' & x_`trade' > 1 & (t1_omugo==`trade' | t2_omugo==`trade') 
	replace t2_omugo=.b if t2_omugo==`trade' & x_`trade' > 1 & (t1_omugo==`trade')
}


gen shift_left = .

forvalues num=1/2 {
	if `num'==1 {
	local num_plus_1 = `num'+1
	*local num_plus_2 = `num'+2
	replace shift_left = (t`num'_omugo==.b & t`num_plus_1'_omugo!=.b  & vti==1)
	replace t`num'_omugo = t`num_plus_1'_omugo if shift_left==1
	replace t`num_plus_1'_omugo = .b if shift_left==1
	*replace shift_left = (t`num'_omugo==.b & t`num_plus_1'_omugo==.b & t`num_plus_2'_omugo!=.b  & vti==1)
	*replace t`num'_omugo = t`num_plus_2'_omugo if shift_left==1
	*replace t`num_plus_2'_omugo = .b  if shift_left==1
	}
/*
	if `num'==2 {
	local num_plus_1 = `num'+1
	replace shift_left = (t`num'_omugo==.b & t`num_plus_1'_omugo!=.b  & vti==1)
	replace t`num'_omugo = t`num_plus_1'_omugo if shift_left==1 
	replace t`num_plus_1'_omugo = .b if shift_left==1 
	}
*/
	}

drop x_* shift_left

replace blank_preference=1 if t1_omugo==.b


*******************************
* AMELO
*******************************

forvalues num=1/2 {
	replace t`num'_amelo=.b if inlist(t`num'_amelo, 2, 4, 5, 7, 8, 9, 10, 11, 14) & vti==3 // Making missing if trade not offered
}


** Fixing any duplicate preferences - keep highest preference
forvalues trade=1/14 {
	egen x_`trade' = anycount(t?_amelo), v(`trade')
	count if x_`trade' > 1
 	*replace t3_amelo=.b if t3_amelo==`trade' & x_`trade' > 1 & (t1_amelo==`trade' | t2_amelo==`trade') 
	replace t2_amelo=.b if t2_amelo==`trade' & x_`trade' > 1 & (t1_amelo==`trade')
}


gen shift_left = .

forvalues num=1/3 {
	if `num'==1 {
	local num_plus_1 = `num'+1
	*local num_plus_2 = `num'+2
	replace shift_left = (t`num'_amelo==.b & t`num_plus_1'_amelo!=.b  & vti==3)
	replace t`num'_amelo = t`num_plus_1'_amelo if shift_left==1
	replace t`num_plus_1'_amelo = .b if shift_left==1
	*replace shift_left = (t`num'_amelo==.b & t`num_plus_1'_amelo==.b & t`num_plus_2'_amelo!=.b  & vti==3)
	*replace t`num'_amelo = t`num_plus_2'_amelo if shift_left==1
	*replace t`num_plus_2'_amelo = .b  if shift_left==1
	}
/*
	if `num'==2 {
	local num_plus_1 = `num'+1
	replace shift_left = (t`num'_amelo==.b & t`num_plus_1'_amelo!=.b  & vti==3)
	replace t`num'_amelo = t`num_plus_1'_amelo if shift_left==1 
	replace t`num_plus_1'_amelo = .b if shift_left==1 
	}
*/
	}

drop x_* shift_left

replace blank_preference=1 if t1_amelo==.b

* check for invald preference
* if 1 / 2 then make 2 / 3 = 1 / 2
/*
replace q18_b=.b if id_number=="UKO10K"
replace q18_b=.b if id_number=="VC0UZS"
*/

********************************************************************************
* DUPLICATE SCRIPT NOT ENTERED BY DEC - INPUTTING HERE
********************************************************************************
/*
expand 2 if vti==3 & form_number==62, gen(dupindicator)
replace id_number="ALJ6HB" if dupindicator==1 & vti==3 & form_number==62
replace form_number=61 if id_number=="ALJ6HB"
drop dupindicator
*/

********************************************************************************
* CLEANING TVET
********************************************************************************
replace q13_a = upper(q13_a)
replace q13_c = upper(q13_c)
replace q13_a = "NONE" if (strpos(q13_a, "NO") | strpos(q13_a, "N0") | strpos(q13_a, "N/A") | strpos(q13_a, "NILL") | strpos(q13_a, "NIL"))  > 0
replace q13_c = "NONE" if (strpos(q13_c, "NO") | strpos(q13_c, "N0") | strpos(q13_c, "N/A") | strpos(q13_c, "NILL") | strpos(q13_c, "NIL") | strpos(q13_c, "NA"))  > 0

********************************************************************************
* MISC CLEANING
********************************************************************************
/*
replace district = .b if vti==5 & form_number==286


replace q19=.b if id_number=="M1TY92"
replace q20=20 if id_number=="M1TY92"
replace q19=.b if id_number=="ZEMWAC"


replace q19=1.5 if id_number=="70XCBW"
replace q19=0.3 if id_number=="A1P8JK"
replace q19_b=1 if id_number=="A1P8JK"
replace q19=0.5 if id_number=="C1H741"
replace q19_b=1 if id_number=="C1H741"

replace q20=39 if id_number=="CQFFFG"
replace q19=.b if id_number=="CQFFFG"
replace q19_b=.b if id_number=="CQFFFG"

replace q19=0.3 if id_number=="HAC6ER"
replace q19_b=1 if id_number=="HAC6ER"

replace q20=50 if id_number=="I7MH6D"
replace q19=.b if id_number=="I7MH6D"
replace q19_b=.b if id_number=="I7MH6D"

replace q19=0.3 if id_number=="JQN051"
replace q19_b=1 if id_number=="JQN051"

replace q20=50 if id_number=="NAR54L"
replace q19=.b if id_number=="NAR54L"
replace q19_b=.b if id_number=="NAR54L"

replace q20=30 if id_number=="P9YY6U"
replace q19=.b if id_number=="P9YY6U"
replace q19_b=.b if id_number=="P9YY6U"

replace q19=0.2 if id_number=="PGACQF"
replace q19_b=1 if id_number=="PGACQF"

replace q20=20 if id_number=="YXF9K2"
replace q19=.b if id_number=="YXF9K2"
replace q19_b=.b if id_number=="YXF9K2"
*/
********************************************************************************
* TRYING TO CLEAN UP THE DISTANCE TO VTI VARIABLE
********************************************************************************

gen dist_km = q19 if q19_b==1
replace dist_km = . if (dist_km==.a | dist_km==.b | dist_km==.c)
replace dist_km = q19 * 1.60934 if q19_b==2

replace dist_km = q20 / 15 if dist_km==. // Assume that approx 15 mins per km - this was the median when dividing time / km 

replace dist_km = q19 if q19_b==.b & q19!=. // Assume that distance is in km 

replace dist_km = . if (dist_km==.a | dist_km==.b | dist_km==.c)

label var dist_km "Distance in Km to VTI (Cleaned)"


********************************************************************************
* LABELLING VARIABLES AND VALUES
********************************************************************************
label def refugee_lbl .b "Unknown" .z "Removed (Duplicate Script)", modify


label var q17_1 "q17 [Find a job in a business]"
label var q17_2 "q17 [Start or develop a business]"
label var q17_3 "q17 [Develop skills without concrete professional ambitions]"
label var q17__96 "q17 [others (specify)]"
label var q17__555 "q17 [No response]"

********************************************************************************
* CREATING ELIGIBILITY VARIABLES
********************************************************************************
* I don't actually do anything here, but I am creating them to have consistency between cleaning and corrections data - better for the checks
gen duplicate_script = 0
label var duplicate_script "Duplicate script status" 
label def l_dupscript 0 "Not Duplicate - OK" 1 "Duplicate Script - Ineligible"
label val duplicate_script l_dupscript
 
gen name_ok = 0
 
gen above_18 = .
label var above_18 "Above cutoff age status" 
label def l_overage 0 "Under 18 - Ineligible" 1 "18 or over at application"
label val above_18 l_overage

gen no_consent = 0
label var no_consent "Consent status" 
label def l_consent 0 "Gave Consent" 1 "No Consent - Ineligible"
label val no_consent l_consent

gen age_correct = "" 

********************************************************************************
* CLEANING OTHER SPECIFIES
********************************************************************************
* This was mainly done by a Hiwi

clonevar district_recode = district // Create a new variable for recoding

label list district // Check current value labels - find first available one

replace district_specify = lower(district_specify) 

replace district_recode = 7 if (strpos(lower(district_specify), "maracha") | strpos(lower(district_specify), "maracho"))  > 0 // Recode
label def district 7 "Maracha", modify // Modify the value labels to include the new code

replace district_recode = 8 if (strpos(lower(district_specify), "yumbe")) > 0
label def district 8 "Yumbe", modify //

// Didn't code Gerego as couldn't find it on google - there is Terego however
replace district_recode = 6 if (strpos(lower(district_specify), "gerego")) > 0

// Didn't code Bor as not found on google

************************************************************************************************
*Second: q4a_specify (no observations)
************************************************************************************************

*Third: sub_county_specify_b (nathan: how to deal with cases, in which district instead of sub-county mentioned?)
*Generate recode variable
clonevar sub_county_recode = sub_county // Create a new variable for recoding
*label var sub_county "sub_county. Please specify the sub county of your address [RECODE]" // Label with [RECODE] at the end

label list sub_county

replace sub_county_specify_b = lower(sub_county_specify_b)
tab sub_county_specify_b

*1st: Odupi (equal to Udupi: 219)
replace sub_county_recode = 219 if (strpos(sub_county_specify_b), "odupi") > 0 

*2nd: 773995952 (did not recode) 


*3rd: Aii-Vu and A11-vu (equal to: Aii-Vu)
replace sub_county_recode = 203 if (strpos(sub_county_specify_b), "a11-vu") > 0 
replace sub_county_recode = 203 if (strpos(sub_county_specify_b), "aii-vu") > 0 

*4th: ajang (did not recode, as not found on Google)

*5th: alaipi (did not recode, as not found on google)

*6th: alivu
replace sub_county_recode = 222 if (strpos(lower(sub_county_specify_b), "alivu")) > 0
label def sub_county 222 "Alivu", modify //

*7th: ariama (typo: should be Uriama, as Parish Katiku part of Uriama)
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "ariama") > 0 

*8th: ariyapi/arinyapi (former missspelled)
replace sub_county_recode = 107 if (strpos(sub_county_specify_b), "arinyapi") > 0 
replace sub_county_recode = 107 if (strpos(sub_county_specify_b), "ariyapi") > 0 


*9th atabo b (not recoded, not on google)

*10th: atc (refers to Adjumani Town Council) 
replace sub_county_recode = 103 if (strpos(sub_county_specify_b), "atc") > 0 

*11th: ayavu (Parish which is part of Vurra subcounty)
replace sub_county_recode = 221 if (strpos(sub_county_specify_b), "ayavu") > 0 

*12th: bileafe (typo: Bileaffe)
replace sub_county_recode = 208 if (strpos(sub_county_specify_b), "bileafe") > 0 

*13th: daipi/dzapi/dzipi (typo: dzaipi)
replace sub_county_recode = 106 if (strpos(sub_county_specify_b), "daipi") > 0 
replace sub_county_recode = 106 if (strpos(sub_county_specify_b), "dzapi") > 0 
replace sub_county_recode = 106 if (strpos(sub_county_specify_b), "dzipi") > 0 


*14th: djapzi, dzipi (not recoded, not on Google)

*15th: drajini
replace sub_county_recode = 801 if (strpos(lower(sub_county_specify_b), "drajini")) > 0
label def sub_county 801 "Drajini", modify //

*16th: egge (village part of Dzaipi subcounty)
replace sub_county_recode = 106 if (strpos(sub_county_specify_b), "egge") > 0 

*17th: inde town council (refers to inde)
replace sub_county_recode = 303 if (strpos(sub_county_specify_b), "inde town council") > 0 

*18th: Katiku (Parish part of Uriama)
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "katiku") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "katiku 3") > 0 

*19th: kotiko (not recoded, not found on google)

*20th: madi (unclear to which Madi, i.e. Madi-Opei or Madi-Okollo this refers to, thus not recoded)

*21st: makuach (not recoded, not on google)

*22nd: missing. (not recoded)

*23rd: ocea (parish in Rigbo subcounty 309)
replace sub_county_recode = 309 if (strpos(sub_county_specify_b), "ocea") > 0 

*24th: odobu/odubu (Village in Uriama subcounty 217)
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "odobu") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "odubu") > 0 

*25th: odopi/oudupi (refers to Udupi 219)
replace sub_county_recode = 219 if (strpos(sub_county_specify_b), "odopi") > 0 
replace sub_county_recode = 219 if (strpos(sub_county_specify_b), "oudupi") > 0 

*26th: omuge/omugo/omugu (refers to Omugo 215)
replace sub_county_recode = 215 if (strpos(sub_county_specify_b), "omuge") > 0 
replace sub_county_recode = 215 if (strpos(sub_county_specify_b), "omugo") > 0 
replace sub_county_recode = 215 if (strpos(sub_county_specify_b), "omugu") > 0 

*27th: onjama (not recoded, not on google)

*28th: oraima (not recoded, not on Google)

*29th: oramna/orema (not recoded, not on Google)

*30th: origma (not recoded, not on Google)

*31st: oriyama (refers to Uriama)
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "oriyama") > 0 

*32nd: orumia (not recoded, not on Google)

*33rd: otce (not recoded, not on Google, nathan: any idea?)

*34th: p.t. council, p.t. (not recoded, not on Google, nathan: any idea?)

*35th: rhino/rhino (c), rhino camp (refers to 308 Rhino Camp)
replace sub_county_recode = 308 if (strpos(sub_county_specify_b), "rhino") > 0 
replace sub_county_recode = 308 if (strpos(sub_county_specify_b), "rhino (c)") > 0 
replace sub_county_recode = 308 if (strpos(sub_county_specify_b), "rhino camp") > 0 

*36th: ribo/rigbo (refers to 309 Rigbo)
replace sub_county_recode = 309 if (strpos(sub_county_specify_b), "ribo") > 0 
replace sub_county_recode = 309 if (strpos(sub_county_specify_b), "rigbo") > 0 

*37th: riti council (not recoded, not found on Google)

*38th: siripi (village in Odupi county)
replace sub_county_recode = 219 if (strpos(sub_county_specify_b), "siripi") > 0 
replace sub_county_recode = 219 if (strpos(sub_county_specify_b), "siripi zone") > 0 

*39th: terega (not recoded, not on google)

*40th: terego (not recoded, as terego a district and not a sub-county)

*41st: uiriama/ukiama/urama (refers to Uriama)
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "uiriama") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "ukiama") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "urama") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "uriam") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "uriama") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "uriamo") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "uriawa") > 0 
replace sub_county_recode = 217 if (strpos(sub_county_specify_b), "urima") > 0 

*42nd: umogo/umugo (refers to Omugo 215)
replace sub_county_recode = 215 if (strpos(sub_county_specify_b), "umogo") > 0 
replace sub_county_recode = 215 if (strpos(sub_county_specify_b), "umugo") > 0 

*43rd: urema (not recoded, not found on google)

*44th: vivu (not recoded, not on google)

*45th: west moyo (not clearly identifyable if it should refer to 505 Moyo, hence not recoded)

*46th: zaipi (refers to 106 dzaipi)
replace sub_county_recode = 106 if (strpos(sub_county_specify_b), "zaipi") > 0 


/*
**********************************************************************************************
*Fourth: q8_specify

*Generate recode variable
clonevar q8_recode = q8 // Create a new variable for recoding
*label var q8 "q8. What is your current marital status [RECODE]" // Label with [RECODE] at the end

label list q8

replace q8_specify = lower(q8_specify)


*-444 and -666 not recoded

*1st: carpentry and joinery (not recoded)

*2nd: catholic (not recoded)

*3rd: celibate (could be either divorced, single or widowed, thus not recoded) // Single
replace q8_recode = 3 if (strpos(q8_specify), "celibate")  > 0 
*4th: computer (not recoded)

*5th: dependa (not recoded) 

*6th: maitah (not recoded)

*7th: male/woman (not recoded)

*8th: motorcycle repairing (not recoded)

*9th: nill/no/nothing (not recoded, as could be anything except married) // Single
replace q8_recode = 3 if (strpos(q8_specify), "nill") | (strpos(q8_specify), "no") | (strpos(q8_specify), "not married") | (strpos(q8_specify), "nothing") > 0 
*10th: not married/unmarried (unclear if this automatically implies single) // Single

*11th: wrong details (not recoded)

*12th: single mother
replace q8_recode = 3 if (strpos(q8_specify), "single mother") > 0 

*************************************************************************************************
*Fifth: q11_specify

*Generate recode variable
clonevar q11_recode = q11 // Create a new variable for recoding
*label var q11_recode "q11. What was your highest level of formal education [RECODE]" // Label with [RECODE] at the end

label list q11

replace q11_specify = lower(q11_specify)
tab q11_specify

*-444 and -555 not recoded
replace q11_recode = .b if (strpos(q11_specify), "-444") | (strpos(q11_specify), "-555") > 0 
*1st: dropped out (unclear, not recoded)

*2nd: dropped out before attaining primary education (implies 5 no formal education)
replace q11_recode = 5 if (strpos(q11_specify), "dropped out") > 0 

*3rd: level 2 adult education (not recoded, not sure what this refers to)

*4th: p.6, p.3, p.5, primary 4 (not recoded, but probably means primary school not completed as this usually takes 7 grades, Nathan: any idea?)
replace q11_recode = 5 if (strpos(q11_specify), "p.") | (strpos(q11_specify), "primary") > 0 


*5th: s. 2 (secondary education probably not completed as there are commonly 6 years, primary education assumed)
replace q11_recode = 1 if (strpos(q11_specify), "s.2") > 0 

*************************************************************************************************
*Fifth: q12_specify (should q12_1 to 96 have a recoded version?)
* Covid-19
gen q12_9=0
replace q12_9=.z if q12_1==.z
label var q12_9 "q12_9. Reasons for dropping out of school [Covid-19]"

* Orphan
gen q12_10=0
replace q12_10=.z if q12_1==.z
label var q12_10 "q12_10. Reasons for dropping out of school [Orphan]"

* Lack of support for education
gen q12_11=0
replace q12_11=.z if q12_1==.z
label var q12_11 "q12_11. Reasons for dropping out of school [Lack Support for Education]"

* Marriage
gen q12_12=0
replace q12_12=.z if q12_1==.z
label var q12_12 "q12_12. Reasons for dropping out of school [Marriage]"

* No School
gen q12_13=0
replace q12_13=.z if q12_1==.z
label var q12_13 "q12_13. Reasons for dropping out of school [No Availability]"

* Poor Performance
gen q12_14=0
replace q12_14=.z if q12_1==.z
label var q12_14 "q12_14. Reasons for dropping out of school [Poor Performance]"

* Domestic Issues
gen q12_15=0
replace q12_15=.z if q12_1==.z
label var q12_15 "q12_15. Reasons for dropping out of school [Domestic Issues]"

* N/A
gen q12_16=0
replace q12_16=.z if q12_1==.z
label var q12_16 "q12_16. Reasons for dropping out of school [N/A]"

*Generate recode variable

foreach var of varlist q12_* {
	clonevar `var'_recode = `var'
	*label  var `var'_recode "q12. Reasons for dropping out of school [RECODE]"
}
drop q12_specify_recode


replace q12_specify = lower(q12_specify)
tab q12_specify

*-444 not altered

*due to huge quantity of specifications, I only mention critical ones - I also altered the values of the dummies q12_1 to q12__96 whenever necessary
tab q12_6

*because of war / rampant war (Conflict 6)
*replace q12_recode = "6" if (strpos(q12_specify), "because   of  war") > 0 
replace q12_6_recode = 1 if ((strpos(q12_specify), "war") | (strpos(q12_specify), "conflict") | (strpos(q12_specify), "crisis") | (strpos(q12_specify), "political")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "war")| (strpos(q12_specify), "conflict") | (strpos(q12_specify), "crisis") | (strpos(q12_specify), "political")) > 0 

*because of poverty (1: financial reasons)
replace q12_1_recode = 1 if ((strpos(q12_specify), "fees") | (strpos(q12_specify), "fee") | (strpos(q12_specify), "finance") | (strpos(q12_specify), "financial") |  (strpos(q12_specify), "pove")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "fees") | (strpos(q12_specify), "fee") | (strpos(q12_specify), "finance") | (strpos(q12_specify), "financial") |  (strpos(q12_specify), "pove"))  > 0 

*because of sickness (5 health) - Nathan: does sickness of parents count, as well?
replace q12_5_recode = 1 if ((strpos(q12_specify), "sick") | (strpos(q12_specify), "ill") | (strpos(q12_specify), "health")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "sick") | (strpos(q12_specify), "ill") | (strpos(q12_specify), "health")) > 0 

*due to family responsibility that i have and no proper support from the family (domestic obligation)
replace q12_2_recode = 1 if ((strpos(q12_specify), "responsibilit") | (strpos(q12_specify), "head of")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "responsibilit") | (strpos(q12_specify), "head of")) > 0 

* Pregnancy
replace q12_8_recode = 1 if ((strpos(q12_specify), "preg") | (strpos(q12_specify), "young mother")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "preg") | (strpos(q12_specify), "young mother"))  > 0 

replace q12__555_recode = 1 if (strpos(q12_specify), "-444") > 0 
replace q12__96_recode = 0 if (strpos(q12_specify), "-444") > 0 


*due to COVID-19: Nathan: part of health or own category?
replace q12_9_recode = 1 if ((strpos(q12_specify), "covid") | (strpos(q12_specify), "corona")  | (strpos(q12_specify), "lockdown")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "covid") | (strpos(q12_specify), "corona")  | (strpos(q12_specify), "lockdown")) > 0 

* Orphan
replace q12_10_recode = 1 if ((strpos(q12_specify), "orph") | (strpos(q12_specify), "oph") | (strpos(q12_specify), "died") | (strpos(q12_specify), "dead")  | (strpos(q12_specify), "death")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "orph") | (strpos(q12_specify), "oph") | (strpos(q12_specify), "died") | (strpos(q12_specify), "dead")  | (strpos(q12_specify), "death")) > 0 

replace q12_10_recode = 1 if ((strpos(q12_specify), "loss") | (strpos(q12_specify), "lose") | (strpos(q12_specify), "lost")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "loss") | (strpos(q12_specify), "lose") | (strpos(q12_specify), "lost")) > 0 

* Lack of support for education
replace q12_11_recode = 1 if ((strpos(q12_specify), "support") | (strpos(q12_specify), "guidance")  | (strpos(q12_specify), "assistance") | (strpos(q12_specify), "help")  | (strpos(q12_specify), "lack of parental care")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "support") | (strpos(q12_specify), "guidance")  | (strpos(q12_specify), "assistance") | (strpos(q12_specify), "help")  | (strpos(q12_specify), "lack of parental care")) > 0 

* Marriage
replace q12_12_recode = 1 if ((strpos(q12_specify), "marriage") | (strpos(q12_specify), "mariage") | (strpos(q12_specify), "married")) > 0 
replace q12__96_recode = 0 if ((strpos(q12_specify), "marriage") | (strpos(q12_specify), "mariage") | (strpos(q12_specify), "married"))  > 0 


replace q12_15_recode=1 if id_number=="FIC4NQ"
replace q12_15_recode=1 if id_number=="1MEZAV"
replace q12_15_recode=1 if id_number=="38UER3"
replace q12_13_recode=1 if id_number=="ITAW7A"
replace q12_13_recode=1 if id_number=="RGVTOR"
replace q12_14_recode=1 if id_number=="L0JV51"
replace q12_14_recode=1 if id_number=="QE2JYS"
replace q12_11_recode=1 if id_number=="7P1O2U"
replace q12_10_recode=1 if id_number=="8EX3YR"
replace q12_15_recode=1 if id_number=="MDPIDL"
replace q12_11_recode=1 if id_number=="IENI68"
replace q12_11_recode=1 if id_number=="GXWN69"
replace q12_15_recode=1 if id_number=="E68U10"
replace q12_10_recode=1 if id_number=="MKPX99"
replace q12_10_recode=1 if id_number=="FSGZGM"
replace q12_16_recode=1 if id_number=="3SYPYT"
replace q12_1_recode=1 if id_number=="ESL3T1"
replace q12_3_recode=1 if id_number=="B2GJJR"
replace q12_15_recode=1 if id_number=="1MKAUH"
replace q12_15_recode=1 if id_number=="ZUS2RH"
replace q12_15_recode=1 if id_number=="G6F5W3"
replace q12_14_recode=1 if id_number=="58DNBY"
replace q12_16_recode=1 if id_number=="1T9SX5"
replace q12_16_recode=1 if id_number=="I1O114"
replace q12_16_recode=1 if id_number=="GEMQT9"
replace q12_14_recode=1 if id_number=="RGK63U"
replace q12_15_recode=1 if id_number=="W8488V"
replace q12_16_recode=1 if id_number=="5L7PPZ"
replace q12_10_recode=1 if id_number=="M3HJWC"
replace q12_11_recode=1 if id_number=="KZV27J"
replace q12_16_recode=1 if id_number=="4VGD4Y"
replace q12_11_recode=1 if id_number=="LREL1P"
replace q12_14_recode=1 if id_number=="1B564Z"
replace q12_16_recode=1 if id_number=="RX7K59"
replace q12_15_recode=1 if id_number=="SRU4M7"

replace q12__96_recode=0 if id_number=="FIC4NQ"
replace q12__96_recode=0 if id_number=="1MEZAV"
replace q12__96_recode=0 if id_number=="38UER3"
replace q12__96_recode=0 if id_number=="ITAW7A"
replace q12__96_recode=0 if id_number=="RGVTOR"
replace q12__96_recode=0 if id_number=="L0JV51"
replace q12__96_recode=0 if id_number=="QE2JYS"
replace q12__96_recode=0 if id_number=="7P1O2U"
replace q12__96_recode=0 if id_number=="8EX3YR"
replace q12__96_recode=0 if id_number=="MDPIDL"
replace q12__96_recode=0 if id_number=="IENI68"
replace q12__96_recode=0 if id_number=="GXWN69"
replace q12__96_recode=0 if id_number=="E68U10"
replace q12__96_recode=0 if id_number=="MKPX99"
replace q12__96_recode=0 if id_number=="FSGZGM"
replace q12__96_recode=0 if id_number=="3SYPYT"
replace q12__96_recode=0 if id_number=="ESL3T1"
replace q12__96_recode=0 if id_number=="B2GJJR"
replace q12__96_recode=0 if id_number=="1MKAUH"
replace q12__96_recode=0 if id_number=="ZUS2RH"
replace q12__96_recode=0 if id_number=="G6F5W3"
replace q12__96_recode=0 if id_number=="58DNBY"
replace q12__96_recode=0 if id_number=="1T9SX5"
replace q12__96_recode=0 if id_number=="I1O114"
replace q12__96_recode=0 if id_number=="GEMQT9"
replace q12__96_recode=0 if id_number=="RGK63U"
replace q12__96_recode=0 if id_number=="W8488V"
replace q12__96_recode=0 if id_number=="5L7PPZ"
replace q12__96_recode=0 if id_number=="M3HJWC"
replace q12__96_recode=0 if id_number=="KZV27J"
replace q12__96_recode=0 if id_number=="4VGD4Y"
replace q12__96_recode=0 if id_number=="LREL1P"
replace q12__96_recode=0 if id_number=="1B564Z"
replace q12__96_recode=0 if id_number=="RX7K59"
replace q12__96_recode=0 if id_number=="SRU4M7"

**************************************************************************************************************
*Sixth: q15_specify

*Generate recode variable
clonevar q15_recode = q15 // Create a new variable for recoding
*label var q15 "q15. Employment status in said job [RECODE]" // Label with [RECODE] at the end

clonevar q14_recode = q14 // Create a new variable for recoding

label list q15

replace q15_specify = lower(q15_specify)
tab q15_specify
replace q15_recode=1 if id_number=="X57RI8"
replace q15_recode = .b if ((strpos(q15_specify), "-444") | (strpos(q15_specify), "-555")) > 0 

replace q14_recode=0 if id_number=="U9XEAR"
replace q14_recode=0 if id_number=="7PW4WG"
replace q14_recode=0 if id_number=="A4M5KP"
replace q14_recode=0 if id_number=="PFGNKJ"

tab q15


**************************************************************************************************************
*Seventh: q17_specify (Nathan: how do I deal with those cases where multiple ones have been selected?)




* Domestic Issues
gen q17_4=0
replace q17_4=.z if q17_1==.z
label var q17_4 "q17. [Improve Self-Esteem/Reliance]"

gen q17_5=0
replace q17_5=.z if q17_1==.z
label var q17_5 "q17. [Increase Earnings/Standard of Living]"

gen q17_6=0
replace q17_6=.z if q17_1==.z
label var q17_6 "q17. [Help Others]"

*Generate recode variable
foreach var of varlist q17_* {
	clonevar `var'_recode = `var'
	*label var `var'_recode "q17. Reason for applying to preferred course [RECODE]"
}

drop q17_specify_recode
replace q17_specify = lower(q17_specify)
tab q17_specify


tab q17__96

replace q17__555_recode = 1 if ((strpos(q17_specify), "-555")  | (strpos(q17_specify), "-444")) > 0 
replace q17__96_recode = 0 if ((strpos(q17_specify), "-555")  | (strpos(q17_specify), "-444")) > 0 

replace q17_2_recode = 1 if ((strpos(q17_specify), "self employment")  | (strpos(q17_specify), "self employee") | (strpos(q17_specify), "business") | (strpos(q17_specify), "self employed")) > 0 
replace q17__96_recode = 0 if ((strpos(q17_specify), "self employment") | (strpos(q17_specify), "self employee") | (strpos(q17_specify), "business") | (strpos(q17_specify), "self employed")) > 0 

replace q17_1_recode = 1 if (strpos(q17_specify), "job") > 0 
replace q17__96_recode = 0 if(strpos(q17_specify), "job") > 0 

replace q17_3_recode = 1 if (((strpos(q17_specify), "skill") | (strpos(q17_specify), "knowledge") | (strpos(q17_specify), "certifi")) > 0) & q17_1_recode == 0 & q17_2_recode == 0
replace q17__96_recode = 0 if ((strpos(q17_specify), "skill") | (strpos(q17_specify), "knowledge") | (strpos(q17_specify), "certifi")) > 0 

replace q17_4_recode = 1 if ((strpos(q17_specify), "reliance") | (strpos(q17_specify), "relience") | (strpos(q17_specify), "reliency")) > 0 
replace q17_4_recode = 1 if ((strpos(q17_specify), "reliant") | (strpos(q17_specify), "relient") | (strpos(q17_specify), "esteem")) > 0

replace q17__96_recode = 0 if ((strpos(q17_specify), "reliance") | (strpos(q17_specify), "relience") | (strpos(q17_specify), "reliency")) > 0
replace q17__96_recode = 0 if ((strpos(q17_specify), "reliant") | (strpos(q17_specify), "relient") | (strpos(q17_specify), "esteem")) > 0

replace q17_5_recode = 1 if ((strpos(q17_specify), "earn") | (strpos(q17_specify), "financ") | (strpos(q17_specify), "income")) > 0 
replace q17__96_recode = 0 if ((strpos(q17_specify), "earn") | (strpos(q17_specify), "financ") | (strpos(q17_specify), "income")) > 0 

replace q17_6_recode = 1 if ((strpos(q17_specify), "other") | (strpos(q17_specify), "family") | (strpos(q17_specify), "child")) > 0 
replace q17__96_recode = 0 if ((strpos(q17_specify), "other") | (strpos(q17_specify), "family") | (strpos(q17_specify), "child")) > 0 


replace q17_4_recode=1 if id_number=="LIWTAD"
replace q17_5_recode=1 if id_number=="BYA7QB"
replace q17_3_recode=1 if id_number=="UITE6K"
replace q17_1_recode=1 if id_number=="NLUHS8"
replace q17_3_recode=1 if id_number=="KBSU12"
replace q17_4_recode=1 if id_number=="QJRYI6"
replace q17_4_recode=1 if id_number=="DY4AOI"
replace q17_3_recode=1 if id_number=="5W77HM"
replace q17_4_recode=1 if id_number=="95CP2K"
replace q17_5_recode=1 if id_number=="JOD6IU"
replace q17_3_recode=1 if id_number=="HC89RM"
replace q17_4_recode=1 if id_number=="4JMXYE"
replace q17_5_recode=1 if id_number=="OCU01C"
replace q17_5_recode=1 if id_number=="KE4J1L"
replace q17_3_recode=1 if id_number=="DPXQD6"
replace q17_4_recode=1 if id_number=="R7PR3H"
replace q17_1_recode=1 if id_number=="ESIDNR"
replace q17_5_recode=1 if id_number=="7HQWE4"

replace q17__96_recode=0 if id_number=="LIWTAD"
replace q17__96_recode=0 if id_number=="BYA7QB"
replace q17__96_recode=0 if id_number=="UITE6K"
replace q17__96_recode=0 if id_number=="NLUHS8"
replace q17__96_recode=0 if id_number=="KBSU12"
replace q17__96_recode=0 if id_number=="QJRYI6"
replace q17__96_recode=0 if id_number=="DY4AOI"
replace q17__96_recode=0 if id_number=="5W77HM"
replace q17__96_recode=0 if id_number=="95CP2K"
replace q17__96_recode=0 if id_number=="JOD6IU"
replace q17__96_recode=0 if id_number=="HC89RM"
replace q17__96_recode=0 if id_number=="4JMXYE"
replace q17__96_recode=0 if id_number=="OCU01C"
replace q17__96_recode=0 if id_number=="KE4J1L"
replace q17__96_recode=0 if id_number=="DPXQD6"
replace q17__96_recode=0 if id_number=="R7PR3H"
replace q17__96_recode=0 if id_number=="ESIDNR"
replace q17__96_recode=0 if id_number=="7HQWE4"


**************************************************************************************************************
*Eighth: q18_specify (Nathan: should I create a q18_a, b, c and d recoded version?)

*Generate recode variable
clonevar q18_other_recode = q18_other // Create a new variable for recoding
*label var q18_other_recode "q18_other. Exposed to other vulneralities [RECODE]" // Label with [RECODE] at the end

clonevar q18_a_recode = q18_a // Create a new variable for recoding
*label var q18_a_recode "q18_a. Exposed to household vulnerabilities [RECODE]" // Label with [RECODE] at the end

clonevar q18_b_recode = q18_b // Create a new variable for recoding
*label var q18_b_recode "q18_b. Exposed to mental health vulnerabilities [RECODE]" // Label with [RECODE] at the end

clonevar q18_c_recode = q18_c // Create a new variable for recoding
*label var q18_c_recode "q18_c. Exposed to physical health vulnerabilities [RECODE]" // Label with [RECODE] at the end

clonevar q18_d_recode = q18_d // Create a new variable for recoding
*label var q18_d_recode "q18_d. Exposed to a chronic disease or condition [RECODE]" // Label with [RECODE] at the end


replace q18_specify = lower(q18_specify)

* -444, -555, 0.6, 1.5, 2 not recoded
replace q18_other_recode = 0 if q18_specify!=""
replace q18_a_recode = 1 if ((strpos(q18_specify), "mother") | (strpos(q18_specify), "young") | (strpos(q18_specify), "house")) > 0
replace q18_c_recode = 1 if ((strpos(q18_specify), "pain") | (strpos(q18_specify), "hearing") | (strpos(q18_specify), "bone")  | (strpos(q18_specify), "eyesight")) > 0
replace q18_d_recode = 1 if ((strpos(q18_specify), "asthma") | (strpos(q18_specify), "chronic") | (strpos(q18_specify), "hepa") | (strpos(q18_specify), "kidney")) > 0 



********************************************************************************
* CLEANING COMMENTS
********************************************************************************
*q11
replace q11_recode = 2 if id_number=="OG4UH8"
replace q11_recode = 1 if id_number=="7UOAOK"

*q8
replace q8_recode = .b if id_number=="4OKP7X"
replace q8_recode = .b if id_number=="BY3V2O"

*q9_b
clonevar q9_b_recode = q9_b // Create a new variable for recoding
*label var q9_b_recode "q9_b. Mother's telephone number [RECODE]" // Label with [RECODE] at the end
replace q9_b_recode = .b if id_number=="GQUA3G"
replace q9_b_recode = .b if id_number=="OBC01B"
replace q9_b_recode = .b if id_number=="78DXLK"
replace q9_b_recode = .b if id_number=="LKSLM2" //incomplete numbers

*q10_b
clonevar q10_b_recode = q10_b // Create a new variable for recoding
*label var q10_b_recode "q9_b. Father's telephone number [RECODE]" // Label with [RECODE] at the end

replace q10_b_recode = .b if id_number=="JY6RY2"
replace q10_b_recode = .b if id_number=="JNN9ZV"
replace q10_b_recode = .b if id_number=="MA7EJ2"
replace q10_b_recode = .b if id_number=="11PHVU" //incomplete numbers
replace q10_b_recode = .b if id_number=="ODAW97"
replace q10_b_recode = .b if id_number=="7FUH4V"
replace q10_b_recode = .b if id_number=="BQC284"

*q19
clonevar q19_recode = q19 // Create a new variable for recoding
*label var q19_recode "q19. Distance from home of applicant to VTI [RECODE]" // Label with [RECODE] at the end

replace q19_recode = .b if id_number == "HD9OT6"
replace q19_recode = .b if id_number == "J705DG"

*q19_b
clonevar q19_b_recode = q19_b // Create a new variable for recoding
*label var q19_b_recode "q19_b. Unit of distance [Kilometres or Miles] [RECODE]" // Label with [RECODE] at the end
replace q19_b_recode = 1 if id_number == "MXUO99"

*q13_b
clonevar q13_b_recode = q13_b // Create a new variable for recoding
*label var q13_b_recode "q13_b. Year previous TVET training was attended [RECODE]" // Label with [RECODE] at the end


replace q13_b_recode = .b if inlist(id_number, "37Q9ZS", "14K88E", "0W02CC", "SGV3CU", "MZBW34", "QZNVT3", "HU8DOA")

drop q8_recode q11_recode


********************************************************************************
* CONVERTING RECODE VARIABLES TO ORIGINAL
********************************************************************************
ds *_recode, not

foreach var of varlist `r(varlist)' {
	capture confirm  variable `var'_recode
	if !_rc {
		order `var'_recode, after(`var')
		drop `var'
		rename `var'_recode `var'
	}
}
*/
********************************************************************************
* FINAL CLEANING
********************************************************************************	
label var deviceid  "ID of data entry device"
label var subscriberid "Subscriber ID of sim card of data entry device"
label var simid "Sim card ID of data entry device"
label var devicephonenum "Phone number of data entry device"
label var commentsx "Path of comments media files"
label var username "SCTO Username of data entry clerk"
label var caseid "Caseid (N/A as case management not used)"
label var form_number "Form number of script (By VTI)"
label var starttime "Start of data entry [Timestamp]"
label var endtime "End of data entry [Timestamp]"
label var duration_m "Duration of Data Entry [Minutes]"
label var name_ok "Name is Cleared [Flagged for being similar]"
label var age_correct "Correct age manually entered"

ctomergecom, fn(commentsx) mediapath("$media_path")

********************************************************************************
* ANY CONSENT FIXING FOR OMUGO
********************************************************************************	
/*
replace consent=1 if id_number=="FIC4NQ"
replace consent=1 if id_number=="8RMWOW"
replace consent=1 if id_number=="LZXETO"
replace consent=1 if id_number=="JIF9HV"
replace consent=1 if id_number=="HNRH3V"
replace consent=1 if id_number=="BJSUQS"
replace consent=1 if id_number=="UVAEBL"
replace consent=1 if id_number=="RJVJVN"
replace consent=1 if id_number=="UIB4WJ"
replace consent=1 if id_number=="K6G8TI"
replace consent=1 if id_number=="YB5HBA"
replace consent=1 if id_number=="REO8LV"
replace consent=1 if id_number=="BY3V2O"
replace consent=1 if id_number=="6C2N5B"
replace consent=1 if id_number=="EU6CUV"
replace consent=1 if id_number=="IENI68"
replace consent=1 if id_number=="HHZH3X"
replace consent=1 if id_number=="Q0KWYN"
replace consent=1 if id_number=="8G6ZGW"
replace consent=1 if id_number=="DSW69S"
replace consent=1 if id_number=="W4H1GV"
replace consent=1 if id_number=="OEOCOH"
replace consent=1 if id_number=="32I2OT"
replace consent=1 if id_number=="1C4FVR"
replace consent=1 if id_number=="6CI976"
replace consent=1 if id_number=="5VTM9U"
replace consent=1 if id_number=="XHHDN4"
replace consent=1 if id_number=="2VY233"
replace consent=1 if id_number=="6TP03D"
replace consent=1 if id_number=="PCZNT4"
replace consent=1 if id_number=="DVFG06"
replace consent=1 if id_number=="61AK2E"
replace consent=1 if id_number=="PWRIAE"
replace consent=1 if id_number=="LRTTAJ"
replace consent=1 if id_number=="6LI9SH"
replace consent=1 if id_number=="1ESVEQ"
replace consent=1 if id_number=="VJ37XA"
replace consent=1 if id_number=="PYKF1H"
replace consent=1 if id_number=="S5FW7S"

*/
********************************************************************************
* SAVE CLEANING DATA
********************************************************************************
save "$main_table",replace

n: di "${proj}_${round}_Cleaning.do Completed"
}

