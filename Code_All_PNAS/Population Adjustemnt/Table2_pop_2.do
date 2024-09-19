************************************************************
* Why Does Artificial Intelligence Hinder Democratization?
* by C. Y. Cyrus Chu, Academia Sinica; 
*    Juin-Jen Chang, Academia Sinica; 
*    Chang-Ching Lin, National Cheng Kung University.
* Sep. 18, 2024.
* Submit to PNAS
*
* Stata Code "Table2_pop_2.do" is used to generate Table A.3 in Appendix D of Supporting Information A. 
*
************************************************************

clear
cd "C:\Users\NCKU\Downloads\Code_All\Population Adjustemnt"
use "data_xtreg_240907.dta", clear

drop if year == 2024

encode country, gen(n_country)
xtset n_country year


* Capacities
*2.2.1 Government Internet Filtering Capacity
tab v2smgovfilcap
label var v2smgovfilcap "2.2.1 Government Internet Filtering Capacity"
*2.2.3 Government Internet Shut Down Capacity
tab v2smgovshutcap
label var v2smgovshutcap "2.2.3 Government Internet Shut Down Capacity"
*2.2.9 Government Cyber Security Capacity
tab v2smgovcapsec
label var v2smgovcapsec "2.2.9 Government Cyber Security Capacity"
*2.2.10 Political Parties Cyber Security Capacity
tab v2smpolcap
label var v2smpolcap "2.2.10 Political Parties Cyber Security Capacity"

* Actions in Practice
*2.2.2 Government Internet Filtering in Practice, v2smgovfilprc 
replace v2smgovfilprc = v2smgovfilprc * (-1)
label var v2smgovfilprc "2.2.2 Government Internet Filtering in Practice"
*2.2.4 Government Internet Shut Down in Practice, v2smgovshut 
replace v2smgovshut = v2smgovshut * (-1)
label var v2smgovshut "2.2.4 Government Internet Shut Down in Practice"
*2.2.5 Government Social Media Shut Down in Practice, v2smgovsm 
replace v2smgovsm = v2smgovsm * (-1)
label var v2smgovsm "2.2.5 Government Social Media Shut Down in Practice"
*2.2.6 Government Social Media Alternatives, v2smgovsmalt 
replace v2smgovsmalt = v2smgovsmalt * (-1)
label var v2smgovsmalt "2.2.6 Government Social Media Alternatives"
*2.2.7 Government Social Media Monitoring, v2smgovsmmon 
replace v2smgovsmmon = v2smgovsmmon * (-1)
label var v2smgovsmmon "2.2.7 Government Social Media Monitoring"
*2.2.8 Government Social Media Censorship in Practice, v2smgovsmcenprc 
replace v2smgovsmcenprc = v2smgovsmcenprc * (-1)
label var v2smgovsmcenprc "2.2.8 Government Social Media Censorship in Practice"

capture drop x22*

gen x221 = v2smgovfilcap
gen x222 = v2smgovfilprc
gen x223 = v2smgovshutcap
gen x224 = v2smgovshut
gen x225 = v2smgovsm
gen x226 = v2smgovsmalt
gen x227 = v2smgovsmmon
gen x228 = v2smgovsmcenprc
gen x229 = v2smgovcapsec
gen x2210 = v2smpolcap

* Create year dummy variables

capture drop year_c*
tab year, gen(year_c)
drop year_c1
drop year_c2
drop year_c18

capture drop tt2006
capture drop TT_mean
capture drop TT_quart
capture drop TT_quart_h
capture drop TT_quart_l

gen tt2006 = PR if year==2006
egen TT_mean = mean(tt2006) , by(country)
label var TT_mean "The FH's Political Rights in the first year (2006)"
xtile TT_quart = TT_mean if TT_mean~=., nq(2)
gen TT_quart_h=(TT_quart==2) if TT_mean~=.
gen TT_quart_l=(TT_quart==1) if TT_mean~=.

foreach v of varlist year_c* {
    capture drop l_`v'
	gen l_`v' = `v' * (TT_quart_l==1)
}

drop v2* v3*

capture drop dx22*
forvalue y=1(1)10 {
   gen dx22`y' = d.x22`y'
}

capture drop ldx22*
forvalue y=1(1)10 {
   gen ldx22`y' = l.dx22`y'
}

global xyz x221 x223 x229 x222 x224 x225 x226 x227 x228
global dxyz dx221 dx223 dx229 dx222 dx224 dx225 dx226 dx227 dx228

foreach v of global dxyz {
    capture drop `v'_h
	capture drop `v'_l
    capture drop l`v'_h
	capture drop l`v'_l
	gen `v'_h=`v'*TT_quart_h
	gen `v'_l=`v'*TT_quart_l	
    gen l`v'_h=l.`v'*TT_quart_h
	gen l`v'_l=l.`v'*TT_quart_l
}

** Table 2 with population weights
capture drop p2006
capture drop popmean
capture drop popmin
capture drop ww0
capture drop ww

gen p2006 = population if year==2006
egen popmean = mean(p2006) , by(country)
egen popmin=min(population)
gen ww0 = popmean / popmin
*** Table 2 
* gen ww = 1

*** Table 2 pop_1
* gen ww = sqrt(ww0)

*** Table 2 pop_2
  gen ww = sqrt(ln(ww0)+1)

global dz dx222 dx224 dx225 dx226 dx227 dx228 dx222_l dx224_l dx225_l dx226_l dx227_l dx228_l dx221_h dx223_h dx229_h dx221_l dx223_l dx229_l

foreach v of global dz {
    capture drop w_`v'
	gen w_`v' = ww * `v'
}

forvalues k = 3/17 {
    capture drop w_year_c`k'
	capture drop w_l_year_c`k'
	gen w_year_c`k' = ww * year_c`k'
    gen w_l_year_c`k' = ww * l_year_c`k'
}

global dy w_dx222 w_dx224 w_dx225 w_dx226 w_dx227 w_dx228
global dx_h w_dx221_h w_dx223_h w_dx229_h
global dx_l w_dx221_l w_dx223_l w_dx229_l
global dx_hl w_dx221_h w_dx223_h w_dx229_h w_dx221_l w_dx223_l w_dx229_l
global dwy_l w_dx222_l w_dx224_l w_dx225_l w_dx226_l w_dx227_l w_dx228_l

foreach v of global dwy_l {
    capture drop l`v'
	gen l`v' = l.`v'
}

eststo clear
    xtreg w_dx222 l.w_dx222 lw_dx222_l $dx_l $dx_h l.($dx_l) l.($dx_h) w_year_c* w_l_year_c*, fe
	eststo abond_hl_`v'_0	
foreach v of global dy {
    xtabond `v' w_year_c* w_l_year_c*, endo(l`v'_l, lag(0,1)) endo($dx_hl, lag(0,.)) inst(l(1/3).($dx_hl) l(2/3).(`v'_l)) maxldep(3) maxlags(3) pre(($dx_hl), lag(1,.))
    eststo abond_hl_`v'_2g
}
esttab abond_* using "TableA3_D_SI_A.csv", title(`esttitle') mtitle replace b(3) se(3) constant scalars(N r2_w r2_o r2_b p chi2 sigma_u sigma_e rho) star(+ 0.10 * 0.05 ** 0.01 *** 0.001 ) wide
