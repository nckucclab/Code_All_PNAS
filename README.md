Why Does Artificial Intelligence Hinder Democratization?

by

C. Y. Cyrus Chu, Academia Sinica; 

Juin-Jen Chang, Academia Sinica; 

Chang-Ching Lin, National Cheng Kung University.
Mar. 31, 2025.

Submit to PNAS

---------

Stata Code "dataclean.do" is used to prepare the data for analysis.

Stata Code "Figure2.do" is used for Figure 2: 
      "Governments’ Technological Capacities for Low (Blue) and High (Red) Democracy Groups."   
      Then, run Python code "Figure 2.py" in the fold "Figures2_S1" to generate Figure 2.

Stata Code "FigureS1.do" is used for Figure S1 
      "Governments’ Technological Capacities for the Least (Blue) and Most (Red) Democratic Groups" in Appendix C of Supporting Information A.   
      Then, run Python code "Figure S1.py" in the fold "Figures2_S1" to generate Figure S1.

Stata Code "sum_and_xtunitroot.do" is used to summarize data and conduct the panel data unitroot test.
      The results are reported in Table S1 of Appendix A and in Table S2 of Appendix B in Supporting Information A. 

Stata Code "Table_S3_SR.do" is used to report Governments' Technological Capacities for Various Democracy Groups in Table S3 in Appendix C of Supporting Information A.

Stata Code "Table_2.do" is used to generate Table 2 (and Table S8): 
      "Governments' Technological Capacities and Their Actual Practices for Various Democracy Groups"  

Stata Code "Table_3.do" is used to generate Table 3 (and Tables S9-1 and S9-2): 
      "Effects of the Government's Implementation Practices on Democracy"

Stata Code "SB_demovaiict_1.do" in the fold "Structure Break" is used to estimate a structure break in the regression of democracy score on ai/ict measure, trend, and an intercept.
    Here we assume that no break in either trend or intercept. Under the alternative hypothesis that there is a unknown break in the coefficient of ai/ict.

Stata Code "SB_demovaiict_2.do" in the fold "Structure Break" is used to estimate a structure break in the regression of democracy score on ai/ict measure, trend, and an intercept.

In the fold "Structural Break", Figure 1 is generated based on "demo_aiict_0909.xls"

Stata Code used to generate 

In the fold "Population Adjustemnt", there are the stata data and do files used to generate Tables S4 to S7 in Appendix D of Supporting Information A, including 

    The dataset "data_xtreg_240907.dta" merges "data_xtreg_240729A.dta" with population data sourced from the UN. Taiwan's population data is obtained from the Directorate General of Budget, Accounting and Statistics (DGBAS) under the Executive Yuan, Taiwan.
    Table2_pop.do: for Table S4 (and Table S10)   
    Table3_pop.do: for Table S5 (and Tables S11-1 and S11-2)
    Table2_pop_2.do: for Table S6 (and Table S12)
    Table3_pop_2.do: for Table S7 (and Tables S13-1 and S13-2)
