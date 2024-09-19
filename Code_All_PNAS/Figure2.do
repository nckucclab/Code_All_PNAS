************************************************************
* Why Does Artificial Intelligence Hinder Democratization?
* by C. Y. Cyrus Chu, Academia Sinica; 
*    Juin-Jen Chang, Academia Sinica; 
*    Chang-Ching Lin, National Cheng Kung University.
* Sep. 18, 2024.
* Submit to PNAS
*
* Stata Code "Figure2.do" is used for Figure 2: 
*      "Governments’ Technological Capacities for Low (Blue) 
*       and High (Red) Democracy Groups."   
* Then, run Python code "Figure 2.py" in the fold "Figure2_AI" to generate Figure 2
*
************************************************************

clear
cd "C:\Users\NCKU\Downloads\Code_All"
use "data_xtreg_240729A.dta", clear

******
/*
(1) Divide into H&L groups (L and H). 
(2) Calculate (Country A in year i) - (Country A's average from 2006 to 2023) >> only for EIU & PR. 
(3) Run Python code to plot the average values of various capacities and democracy indices for each year.
*/
******

******
* EIU
******

keep if year >=2006 & year <= 2023
gen tt2006 = democ_score if year==2006
egen TT_mean = mean(tt2006) , by(country)
label var TT_mean "The EIU's democracy indicator for the first year (2006)."

capture drop TT_quart
xtile TT_quart = TT_mean if TT_mean~=., nq(2)

capture drop democ_score_c
egen democ_score_c = mean(democ_score), by(country)

capture drop democ_score_2
gen democ_score_2 = democ_score - democ_score_c
* Organize and save the data in an Excel file.
drop if TT_quart==.
collapse democ_score_2 v2smgovfilcap v2smgovshutcap v2smgovcapsec , by(TT_quart year)
rename TT_quart Q_EIU
rename democ_score_2 EIU
rename v2smgovfilcap Y221
rename v2smgovshutcap Y223
rename v2smgovcapsec Y229

***
capture drop QQ 
gen QQ = Q_EIU
sort QQ year
save "EIU_Figure2.dta", replace
*** 

* export excel using "EIU_Figure2.xls", firstrow(variables) replace



*********************************************************************

******
* FH's PR
******


clear
cd "C:\Users\NCKU\Downloads\Code_All"
use "data_xtreg_240729A.dta", clear

keep if year >=2006 & year <= 2023
gen tt2006 = PR if year==2006
egen TT_mean = mean(tt2006) , by(country)
label var TT_mean "The Freedom House's Political Right for the first year (2006)."

capture drop TT_quart
xtile TT_quart = TT_mean if TT_mean~=., nq(2)

capture drop PR_c
egen PR_c = mean(PR) , by(country)

capture drop PR_2
gen PR_2 = PR - PR_c

* Organize and save the data in an Excel file.

drop if TT_quart==.
collapse PR_2 v2smgovfilcap v2smgovshutcap v2smgovcapsec  , by(TT_quart year)
rename TT_quart Q_PR
rename PR_2 PR
rename v2smgovfilcap Y221P
rename v2smgovshutcap Y223P
rename v2smgovcapsec Y229P

***
capture drop QQ 
gen QQ = Q_PR
sort QQ year
save "PR_Figure2.dta", replace
***

* export excel using "PR_Figure2.xls", firstrow(variables) replace

*****
* Then, combine these two files and save as Figure2.xlsx
*   and run Python code "Figure 2.py" in the fold "Figure2_AI" 
*   to plot the average values of various capacities and democracy indices for each year in Figure 2.
*****

clear

use "EIU_Figure2.dta", clear
sort QQ year
merge 1:1 QQ year using "PR_Figure2.dta"
drop _merge QQ
export excel using "Figure2.xlsx", firstrow(variables) replace

