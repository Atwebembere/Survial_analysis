# Survial_analysis

***Dataset will provided upon reasonable request***

Project Title: Clinic Policy and Retention in Methadone Maintenance: A Survival Analysis of the ADDICTS Cohort (1986–1990)

⸻

📌 Problem Statement / Background

Opioid use disorder remains a major public health crisis, with methadone maintenance therapy (MMT) proven to reduce overdose and improve retention outcomes. However, retention varies greatly by clinic policy. This project reanalyzes the historical ADDICTS dataset using modern survival methods to quantify the impact of clinic policy (abstinence vs. maintenance), methadone dose, and incarceration history on treatment retention.

⸻

🔍 Methods Used
	•	Dataset: ADDICTS cohort (N = 238), 1986–1990
	•	Software: Stata 18
	•	Models:
	•	Kaplan–Meier curves
	•	Cox proportional-hazards regression
	•	Piecewise-exponential survival model
	•	Diagnostics:
	•	Schoenfeld residuals
	•	Log-rank tests
	•	Wald tests for interaction effects

⸻

📊 Key Findings
	•	Patients in the maintenance-oriented clinic (Clinic 2) had a 64% lower risk of drop-out than those in the abstinence clinic (HR = 0.36, p < 0.001).
	•	Higher methadone doses significantly improved retention (HR = 0.965 per 1 mg, p < 0.001).
	•	Incarceration history slightly elevated dropout risk (HR = 1.39, p = 0.051).
	•	Drop-out risk increased dramatically after 12 months, especially after 24 months (HR = 7.42).
	•	No statistically significant three-way interaction between clinic, prison, and dose.

📈 Sample Output:


⸻

▶️ How to Run the Code (STATA)
	1.	Open Stata 18
	2.	Load dataset:

use addicts.dta, clear


	3.	Convert and declare survival data:

gen survt_mo = survt / 30.4375
replace survt_mo = 1 if survt == 0
stset survt_mo, failure(status ==1) id(id)


	4.	Generate life table and survival plot:

ltable survt_mo status, interval(1) by(clinic)
sts graph, by(clinic)
sts test clinic 


	5.	Run Cox regression:

stcox i.clinic prison dose, efron
estat phtest, detail


	6.	Run piecewise exponential model:

stsplit period, at(1 3 6 12 24 36)
streg i.clinic prison dose i.period, distribution(exponential)


	7.	Test interactions:

summarize dose
gen dose_c = dose - r(mean)
stcox i.clinic##i.prison##c.dose_c, efron
testparm i.clinic#c.dose_c
testparm i.prison#c.dose_c
testparm i.clinic#i.prison


	8.	Plot adjusted survival:

stcurve, survival at1(clinic=1 prison=0 dose_c=0) at2(clinic=2 prison=0 dose_c=0) ///
    title("Predicted Retention by Clinic") xlabel(0(6)36) legend(order(1 "Clinic 1" 2 "Clinic 2"))
