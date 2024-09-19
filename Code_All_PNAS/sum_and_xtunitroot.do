************************************************************
* Why Does Artificial Intelligence Hinder Democratization?
* by C. Y. Cyrus Chu, Academia Sinica; 
*    Juin-Jen Chang, Academia Sinica; 
*    Chang-Ching Lin, National Cheng Kung University.
* Sep. 18, 2024.
* Submit to PNAS
*
* Stata Code "sum_and_xtunitroot.do" 
*   is used to summarize data and conduct the panel data unitroot test.
*   The results are reported in Table A of Appendix A and in Table B of Appendix B 
*   in Supporting Information A.
*
************************************************************

clear
cd "C:\Users\NCKU\Downloads\Code_All"
use "data_xtreg_240729A.dta", clear

drop if year == 2024

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
*gen x2210 = v2smpolcap

**********************************************************
* Summary Statistics, Table A1, Appendix: Data Description 
**********************************************************

summarize PR Total democ_score x22* 

***********************************************************
* Panel Unitroot Test, Table A2, Appendix: Data Description
***********************************************************

encode country, gen(n_country)
xtset n_country year

global xyz PR Total democ_score x221 x222 x223 x224 x225 x226 x227 x228 x229  
foreach y of global xyz {
  xtunitroot ips `y', demean lag(aic 3)
  scalar b`y'=r(p_wtbar)
  xtunitroot ips `y' , demean lag(aic 3)
  scalar bh`y'=r(p_wtbar)
  xtunitroot hadri `y', demean robust
  scalar c`y'=r(p)
}

foreach y of global xyz {
  display b`y' _s c`y' _s bh`y' _s 
}

*********************************************************
* Correlations between Capacities and Democracy Indices (Main Article, Footnote 8)
*********************************************************

* Raw data
pwcorr  PR x221, sig
pwcorr  democ_score x221, sig
pwcorr  PR x223, sig
pwcorr  democ_score x223, sig
pwcorr  PR x229, sig
pwcorr  democ_score x229, sig

* Demeaned Data
bysort n_country: egen democ_score_demean = mean(democ_score)
bysort n_country: egen PR_demean = mean(PR)
bysort n_country: egen x221_demean = mean(x221)
bysort n_country: egen x223_demean = mean(x223)
bysort n_country: egen x229_demean = mean(x229)
gen democ_score_fe = democ_score - democ_score_demean
gen PR_fe = PR - PR_demean
gen x221_fe = x221 - x221_demean
gen x223_fe = x221 - x223_demean
gen x229_fe = x221 - x229_demean
pwcorr PR_fe x221_fe, sig
pwcorr democ_score_fe x221_fe, sig
pwcorr PR_fe x223_fe, sig
pwcorr democ_score_fe x223_fe, sig
pwcorr PR_fe x229_fe, sig
pwcorr democ_score_fe x229_fe, sig
