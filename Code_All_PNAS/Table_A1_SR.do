************************************************************
* Why Does Artificial Intelligence Hinder Democratization?
* by C. Y. Cyrus Chu, Academia Sinica; 
*    Juin-Jen Chang, Academia Sinica; 
*    Chang-Ching Lin, National Cheng Kung University.
* Sep. 18, 2024.
* Submit to PNAS
*
* Stata Code "Table_A1_SR.do" 
*   is used to report Governments’ Technological Capacities 
*   for Various Democracy Groups
*   in Table A.1 in Appendix C of Supporting Information A.
*
************************************************************

clear
cd "C:\Users\NCKU\Downloads\Code_All"
use "data_xtreg_240729A.dta", clear

drop if year == 2024

*Table A1 in Supplementary Regressions

eststo clear
foreach y of varlist democ_score PR Total {
  capture drop `y'_g
  gen `y'_g = `y'_l + `y'_h * 2
  foreach v of varlist v2smgovfilcap v2smgovshutcap v2smgovcapsec {
    reg `v' `y'_l `y'_h, nocon vce(cluster `y'_g) 
    eststo m_`v'
  }
  capture drop `y'g
  esttab m_* using "modle_`y'a.csv", title(`esttitle') mtitle replace b(3) se(3) r2 ar2 constant scalars(N p ll_0 ll chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001 ) wide
  eststo clear
}
