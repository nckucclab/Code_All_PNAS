************************************************************
* Why Does Artificial Intelligence Hinder Democratization?
* by C. Y. Cyrus Chu, Academia Sinica; 
*    Juin-Jen Chang, Academia Sinica; 
*    Chang-Ching Lin, National Cheng Kung University.
* Sep. 18, 2024.
* Submit to PNAS
*
* Stata Code "SB_demovaiict_2.do" is used to estimate a structure break in 
*    the regression of democracy score on ai/ict measure, trend, and an intercept.
*    
************************************************************

clear
cd "C:\Users\NCKU\Downloads\Code_All\Structural Break"
use "C:\Users\NCKU\Downloads\Code_All\data_xtreg_240729A.dta", clear

collapse (mean) Total PR democ_score, by(year)
save "demo_aiict.dta", replace

* Caculate the averages of EIU, PR, and Total by year among 164 countries.
* Save in the excel file "demo_aiict.xls" 
* Re-load the data from "demo_aiict.xls" 

import excel "demo_aiict.xls", sheet("aiict") firstrow clear
tsset year

gen AIpatents_a= AIpatents/100000
gen ICTpatents_a = ICTpatents/1000000
gen AIGranted_a = AIGranted/100000
gen AIPublished_a = AIPublished/100000
gen ICTGranted_a = ICTGranted/1000000
gen ICTPublished_a = ICTPublished/1000000
gen lnAIGranted = ln(AIGranted+1)
gen lnAIPublished = ln(AIPublished+1)
gen lnICTGranted = ln(ICTGranted+1)
gen lnICTPublished = ln(ICTPublished+1)

label var democ_score "EIU's Democracy Index"
label var PR "FH's Political Right"
label var Total "FH's Global Freedom"
label var AIGranted_a "AI Granted Patent"
label var AIPublished_a "AI Published Patent"
label var ICTGranted_a "ICT Granted Patent"
label var ICTPublished_a "ICT Published Patent"

tsset year
capture drop EIU
gen EIU=democ_score
replace EIU=(l.democ_score+f.democ_score)/2 if year==2007 |year==2009

capture trend
gen trend = year-2014

global yy0 EIU PR Total
global var1 AIGranted_a AIPublished_a ICTGranted_a ICTPublished_a

local kk=0
foreach yy of varlist $yy0 {
   local kk=`kk'+1
eststo clear
local jj=0
foreach v of varlist $var1 {
    local jj=`jj'+1
	qui: reg `yy' `v' trend
	eststo re_`v'
	if `jj'== 1 {
	    local endy=2019
	}
	else {
	    local endy=2019
	}
	
	forvalues ii=2011(1)`endy' {
		qui: reg `yy' `v' trend if year<=`ii'
		eststo re_`v'_`ii'_b
		** test `v'
		** estadd scalar ppa = r(p) 
        qui: reg `yy' `v' trend if year>`ii'
		eststo re_`v'_`ii'_a
        ** test `v'
		** estadd scalar ppa = r(p)		
	}	
}

esttab re_* using "`yy'_all.csv", mtitles replace b(3) p wide star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

foreach v of varlist $var1{

	qui: regress `yy' `v' trend
	estat sbsingle, trim(25) gen(wald22)
	local title_1 : variable label `v'
	line wald22 year if year >= 2010 & year <= 2020, title("`title_1'") graphregion(color(white)) saving(`v'b`kk', replace)
	capture drop wald22

}

local title : variable label `yy'
gr combine AIGranted_ab`kk'.gph AIPublished_ab`kk'.gph ICTGranted_ab`kk'.gph ICTPublished_ab`kk'.gph, graphregion(color(white)) saving(`yy'_all, replace) title(`title'_all)
graph export `yy'_all.png, replace

}
