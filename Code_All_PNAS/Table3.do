************************************************************
* Why Does Artificial Intelligence Hinder Democratization?
* by C. Y. Cyrus Chu, Academia Sinica; 
*    Juin-Jen Chang, Academia Sinica; 
*    Chang-Ching Lin, National Cheng Kung University.
* Sep. 18, 2024.
* Submit to PNAS
*
* Stata Code "Table_3.do" is used to generate Table 3: 
*      "Effects of the Government’s Implementation Practices on Democracy"   
*
************************************************************

clear
cd "C:\Users\NCKU\Downloads\Code_All"
use "data_xtreg_240729A.dta", clear

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
gen x2211 = Total
gen x2212 = PR
gen x2213 = democ_score

* Create year dummy variables

capture drop year_c*
tab year, gen(year_c)
drop year_c1
drop year_c2
drop year_c18

drop v2* v3*

capture drop d22*
forvalue y=1(1)13 {
   gen dx22`y' = d.x22`y'
}

capture drop ld22*
forvalue y=1(1)13 {
   gen ldx22`y' = l.dx22`y'
}

global dz dx2211 dx2212 dx2213
global dx dx221 dx223 dx229
global dy dx222 dx224 dx225 dx226 dx227 dx228
global dxyz dx221 dx223 dx229 dx222 dx224 dx225 dx226 dx227 dx228 dx2211 dx2212 dx2213

eststo clear
    xtreg dx2211 l.dx2211 $dy l.($dy) year_c*, fe
	eststo abond_hl_`v'_0
foreach v of global dz {
    xtabond `v' year_c*, endo($dy, lag(0,.)) inst(l(1/3).($dy)) maxldep(3) maxlags(3) pre($dy, lag(1,.))
    eststo abond_`v'_al
}
esttab abond_* using "Table3_All.csv", title(`esttitle') mtitle replace b(3) se(3) constant scalars(N r2_w r2_o r2_b p chi2 sigma_u sigma_e rho) star(+ 0.10 * 0.05 ** 0.01 *** 0.001 ) wide

**************
* Groups L and H defined by FH's Political Rights 
**************
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

foreach v of varlist year_c* {
    capture drop l_`v'
	gen l_`v' = `v' * (TT_quart_l==1)
}

global dy_l dx222_l dx224_l dx225_l dx226_l dx227_l dx228_l
global dy_h dx222_h dx224_h dx225_h dx226_h dx227_h dx228_h
global dy_hl dx222_h dx224_h dx225_h dx226_h dx227_h dx228_h dx222_l dx224_l dx225_l dx226_l dx227_l dx228_l

eststo clear
    xtreg dx2211 l.dx2211 ldx2211_l $dy_l $dy_h l.($dy_l) l.($dy_h) year_c* l_year_c* TT_quart_l, fe
	eststo abond_hl_`v'_0	
foreach v of global dz {
    xtabond `v' year_c* l_year_c*, endo(l`v'_l, lag(0,1)) endo($dy_hl, lag(0,.)) inst(l(1/3).($dy_hl) l(2/3).(`v'_l)) maxldep(3) maxlags(3) pre(($dy_hl), lag(1,.))
    eststo abond_hl_`v'_2g
}
esttab abond_* using "Table3_HL_PR.csv.csv", title(`esttitle') mtitle replace b(3) se(3) constant scalars(N r2_w r2_o r2_b p chi2 sigma_u sigma_e rho) star(+ 0.10 * 0.05 ** 0.01 *** 0.001 ) wide

**************
* Groups L and H defined by FH's Global Freedom 
**************

capture drop tt2006
capture drop TT_mean
capture drop TT_quart
capture drop TT_quart_h
capture drop TT_quart_l

gen tt2006 = Total if year==2006
egen TT_mean = mean(tt2006) , by(country)
label var TT_mean "The FH's Global Freedom in the first year (2006)"
xtile TT_quart = TT_mean if TT_mean~=., nq(2)
gen TT_quart_h=(TT_quart==2) if TT_mean~=.
gen TT_quart_l=(TT_quart==1) if TT_mean~=.

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

foreach v of varlist year_c* {
    capture drop l_`v'
	gen l_`v' = `v' * (TT_quart_l==1)
}

global dy_l dx222_l dx224_l dx225_l dx226_l dx227_l dx228_l
global dy_h dx222_h dx224_h dx225_h dx226_h dx227_h dx228_h
global dy_hl dx222_h dx224_h dx225_h dx226_h dx227_h dx228_h dx222_l dx224_l dx225_l dx226_l dx227_l dx228_l

eststo clear
    xtreg dx2211 l.dx2211 ldx2211_l $dy_l $dy_h l.($dy_l) l.($dy_h) year_c* l_year_c* TT_quart_l, fe
	eststo abond_hl_`v'_0	
foreach v of global dz {
    xtabond `v' year_c* l_year_c*, endo(l`v'_l, lag(0,1)) endo($dy_hl, lag(0,.)) inst(l(1/3).($dy_hl) l(2/3).(`v'_l)) maxldep(3) maxlags(3) pre(($dy_hl), lag(1,.))
    eststo abond_hl_`v'_2g
}
esttab abond_* using "Table3_HL_Tot.csv.csv", title(`esttitle') mtitle replace b(3) se(3) constant scalars(N r2_w r2_o r2_b p chi2 sigma_u sigma_e rho) star(+ 0.10 * 0.05 ** 0.01 *** 0.001 ) wide

**************
* Groups L and H defined by EIU's democracy scores 
**************

capture drop tt2006
capture drop TT_mean
capture drop TT_quart
capture drop TT_quart_h
capture drop TT_quart_l

gen tt2006 = democ_score if year==2006
egen TT_mean = mean(tt2006) , by(country)
label var TT_mean "The EIU's democracy scores in the first year (2006)"
xtile TT_quart = TT_mean if TT_mean~=., nq(2)
gen TT_quart_h=(TT_quart==2) if TT_mean~=.
gen TT_quart_l=(TT_quart==1) if TT_mean~=.

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

foreach v of varlist year_c* {
    capture drop l_`v'
	gen l_`v' = `v' * (TT_quart_l==1)
}

global dy_l dx222_l dx224_l dx225_l dx226_l dx227_l dx228_l
global dy_h dx222_h dx224_h dx225_h dx226_h dx227_h dx228_h
global dy_hl dx222_h dx224_h dx225_h dx226_h dx227_h dx228_h dx222_l dx224_l dx225_l dx226_l dx227_l dx228_l

eststo clear
    xtreg dx2211 l.dx2211 ldx2211_l $dy_l $dy_h l.($dy_l) l.($dy_h) year_c* l_year_c* TT_quart_l, fe
	eststo abond_hl_`v'_0	
foreach v of global dz {
    xtabond `v' year_c* l_year_c*, endo(l`v'_l, lag(0,1)) endo($dy_hl, lag(0,.)) inst(l(1/3).($dy_hl) l(2/3).(`v'_l)) maxldep(3) maxlags(3) pre(($dy_hl), lag(1,.))
    eststo abond_hl_`v'_2g
}
esttab abond_* using "Table3_HL_EIU.csv.csv", title(`esttitle') mtitle replace b(3) se(3) constant scalars(N r2_w r2_o r2_b p chi2 sigma_u sigma_e rho) star(+ 0.10 * 0.05 ** 0.01 *** 0.001 ) wide

