clear
use "/Users/ray/Library/CloudStorage/Box-Box/2024/WASHU/MPH Year 2/Semester 2/Survival Analysis/Assignments/Final/addicts.dta"
use addicts.dta, clear
gen survt_mo = survt / 30.4375
replace survt_mo = 1 if survt == 0
stset survt_mo, failure(status ==1) id(id)
*************************************************************

** Descriptives

ltable survt_mo status, interval(1) by(clinic)
sts graph, by(clinic)
sts test clinic 
stci, by(clinic) p(50)

************************************************************

** Cox-propotional hazard

stcox i.clinic prison dose, efron

** Testing assumptions:

estat phtest, detail

************************************************************

** Piecewise exponential model

stsplit period, at(1 3 6 12 24 36)
streg i.clinic prison dose i.period, distribution(exponential)

** Testing interraction terms

	* Centering dose

summarize dose
local m = r(mean)
gen dose_c = dose - `m'

	* Three-way interaction terms

stcox i.clinic##i.prison##c.dose_c, efron

* Test interactions one at a time
testparm i.clinic#c.dose_c
testparm i.prison#c.dose_c
testparm i.clinic#i.prison

stcurve, survival at1(clinic=1 prison=0 dose_c=0) at2(clinic=2 prison=0 dose_c=0) title("Predicted Retention by Clinic") xlabel(0(6)36) legend(order(1 "Clinic 1" 2 "Clinic 2"))
