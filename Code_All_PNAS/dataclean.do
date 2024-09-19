************************************************************
* Why Does Artificial Intelligence Hinder Democratization?
* by C. Y. Cyrus Chu, Academia Sinica; 
*    Juin-Jen Chang, Academia Sinica; 
*    Chang-Ching Lin, National Cheng Kung University.
* Sep. 18, 2024.
* Submit to PNAS
*
* Stata Code "dataclean.do" 
* is used to prepare the data for analysis.
*
************************************************************

clear

cd "C:\Users\NCKU\Downloads\Code_All"
use "Democracy_2024.dta", clear

drop *_VDem

* Remove countries with missing data.
keep if merge_Wiki==3
tab country, gen(c)
local q `r(r)'
capture drop miscountry
gen miscountry=0
foreach v of varlist PR v2smgovfilprc{
	forvalues i = 1(1)`q'{
		tab `v' if `v'==. & c`i'==1,m
		replace miscountry=`i' in `i' if r(N)>0 
	}
	}

tab miscountry if miscountry>0 
capture drop dropc
gen dropc=0

tab country
local q `r(r)'
forvalues i = 1/`q'{	
	tab miscountry if miscountry== `i' in `i'
	*list country if r(r)>0 & c`i'==1
	replace dropc=1 if r(r)>0 & c`i'==1 
}

drop if dropc==1
forvalues i = 1/`q'{	
	drop c`i'
}
* tab country  
* dis r(r)

keep country  
duplicates drop country, force
save "1.dta", replace

use "Democracy_2024.dta", clear

merge m:1 country using "1.dta",gen(m0902)
capture drop country_164
gen country_164 = 1 if m0902==3
label var country_164 "Fixed 164 countries"
drop m0902
keep if country_164 == 1 
keep if PR~=.
tab year

* Group based on the democracy indicator of the first year
* EIU Democracy Index
capture drop democ_score_mean
capture drop d2006
gen d2006 = democ_score if year==2006
egen democ_score_mean = mean(d2006) , by(country)
label var democ_score_mean "The EIU democracy indicator in the first year (2006)"
capture drop democ_score_quart
xtile democ_score_quart = democ_score_mean if democ_score_mean~=., nq(4)

* Freedom House' Political Rights
capture drop PR_mean
capture drop d2006
gen d2006 = PR if year==2006
egen PR_mean = mean(d2006) , by(country)
label var PR_mean "The FH's Political Rights in the first year (2006)"
capture drop PR_quart
xtile PR_quart = PR_mean if PR_mean~=., nq(4)

* Freedom House' Global Freedom
capture drop Total_mean
capture drop d2006
gen d2006 = Total if year==2006
egen Total_mean = mean(d2006) , by(country)
label var Total_mean "The FH's Global Freedom in the first year (2006)"
capture drop Total_quart
xtile Total_quart = Total_mean if Total_mean~=., nq(4)

* The data is divided into two groups: the group L, as the low democracy group, and group H as the high democracy group.
* Groups are based on the indicators in the first year (2006).
capture drop democ_quart_l
capture drop democ_quart_h
gen democ_quart_l = (democ_score_quart==1 | democ_score_quart==2) if democ_score_mean~=.
gen democ_quart_h = (democ_score_quart==3 | democ_score_quart==4) if democ_score_mean~=.

capture drop PR_quart_l
capture drop PR_quart_h
gen PR_quart_l = (PR_quart==1 | PR_quart==2) if PR_mean~=.
gen PR_quart_h = (PR_quart==3 | PR_quart==4) if PR_mean~=.

capture drop Total_quart_l
capture drop Total_quart_h
gen Total_quart_l = (Total_quart==1 | Total_quart==2) if Total_mean~=.
gen Total_quart_h = (Total_quart==3 | Total_quart==4) if Total_mean~=.

gen democ_score_l = democ_quart_l
gen PR_l = PR_quart_l
gen Total_l = Total_quart_l

gen democ_score_h = democ_quart_h
gen PR_h = PR_quart_h
gen Total_h = Total_quart_h

save "data_xtreg_240729A.dta", replace
