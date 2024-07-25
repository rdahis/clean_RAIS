
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "F://data/rais"

local SAMPLE FALSE

local FIRST_YEAR 1985
local LAST_YEAR  2020

local SECOND_YEAR = `FIRST_YEAR' + 1

//----------------------------------------------------------------------------//
// collapse: municipality level
//----------------------------------------------------------------------------//

foreach year of numlist 1995(1)`LAST_YEAR' {
	
	//-----------------------//
	// jobs
	//-----------------------//
	
	use "output/data/normalized/job/`year'.dta", clear
	
	ren wage_total_def wage
	
	gen n_jobs = 1
	
	if `year' <= 1994 {
		
		collapse (sum) n_jobs, by(id_munic_6)
		
		la var n_jobs "Jobs"
		
	}
	else {
		
		merge m:1 id_estab id_munic_6 using "output/data/normalized/establishment/`year'.dta"
		drop if _merge == 2
		drop _merge
		
		//if `year' == 1995 replace wage = .	// TODO: why was this condition here?
		
		preserve
			
			collapse (sum) n_jobs wage, by(id_munic_6)
			
			la var n_jobs	"Jobs"
			la var wage		"Wages (R$ 2018)"
			
			tempfile munic_`year'
			save `munic_`year''
			
		restore
		
		preserve
			
			collapse (sum) n_jobs wage, by(id_munic_6 public public_federal public_state public_municipal public_exec public_leg public_jud company nonprofit)
			
			gen x = ""
			replace x = "pub_fed_exec"	if public_federal == 1 & public_exec == 1
			replace x = "pub_fed_leg"	if public_federal == 1 & public_leg == 1
			replace x = "pub_fed_jud"	if public_federal == 1 & public_jud == 1
			replace x = "pub_stt_exec"	if public_state == 1 & public_exec == 1
			replace x = "pub_stt_leg"	if public_state == 1 & public_leg == 1
			replace x = "pub_stt_jud"	if public_state == 1 & public_jud == 1
			replace x = "pub_mun_exec"	if public_municipal == 1 & public_exec == 1
			replace x = "pub_mun_leg"	if public_municipal == 1 & public_leg == 1
			replace x = "pub_mun_jud"	if public_municipal == 1 & public_jud == 1
			replace x = "priv"			if company == 1
			replace x = "np"			if nonprofit == 1
			
			keep if x != ""
			drop public* company nonprofit
			
			ren n_jobs n_jobs_
			ren wage wage_
			reshape wide n_jobs_ wage_, i(id_munic_6) j(x) string
			
			replace n_jobs_pub_fed_exec	= 0 if n_jobs_pub_fed_exec == .
			replace n_jobs_pub_fed_leg	= 0 if n_jobs_pub_fed_leg == .
			replace n_jobs_pub_fed_jud	= 0 if n_jobs_pub_fed_jud == .
			replace n_jobs_pub_stt_exec	= 0 if n_jobs_pub_stt_exec == .
			replace n_jobs_pub_stt_leg	= 0 if n_jobs_pub_stt_leg == .
			replace n_jobs_pub_stt_jud	= 0 if n_jobs_pub_stt_jud == .
			replace n_jobs_pub_mun_exec	= 0 if n_jobs_pub_mun_exec == .
			replace n_jobs_pub_mun_leg	= 0 if n_jobs_pub_mun_leg == .
			replace n_jobs_pub_mun_jud	= 0 if n_jobs_pub_mun_jud == .
			replace n_jobs_np			= 0 if n_jobs_np == .
			replace n_jobs_priv			= 0 if n_jobs_priv == .
			
			la var n_jobs_pub_fed_exec	"Federal Executive Public Jobs"
			la var n_jobs_pub_fed_leg	"Federal Legislative Public Jobs"
			la var n_jobs_pub_fed_jud	"Federal Judicial Public Jobs"
			la var n_jobs_pub_stt_exec	"State Executive Public Jobs"
			la var n_jobs_pub_stt_leg	"State Legislative Public Jobs"
			la var n_jobs_pub_stt_jud	"State Judicial Public Jobs"
			la var n_jobs_pub_mun_exec	"Municipal Executive Public Jobs"
			la var n_jobs_pub_mun_leg	"Municipal Legislative Public Jobs"
			la var n_jobs_pub_mun_jud	"Municipal Judicial Public Jobs"
			la var n_jobs_priv			"Private Jobs"
			la var n_jobs_np			"Non-Profit Jobs"
			la var wage_pub_fed_exec	"Federal Executive Public Wages (R$ 2018)"
			la var wage_pub_fed_leg		"Federal Legislative Public Wages (R$ 2018)"
			la var wage_pub_fed_jud		"Federal Judiciary Public Wages (R$ 2018)"
			la var wage_pub_stt_exec	"State Executive Public Wages (R$ 2018)"
			la var wage_pub_stt_leg		"State Legislative Public Wages (R$ 2018)"
			la var wage_pub_stt_jud		"State Judiciary Public Wages (R$ 2018)"
			la var wage_pub_mun_exec	"Municipal Executive Public Wages (R$ 2018)"
			la var wage_pub_mun_leg		"Municipal Legislative Public Wages (R$ 2018)"
			la var wage_pub_mun_jud		"Municipal Judiciary Public Wages (R$ 2018)"
			la var wage_priv			"Private Wages (R$ 2018)"
			la var wage_np				"Non-Profit Wages (R$ 2018)"
			
			tempfile munic_cat_`year'
			save `munic_cat_`year''
			
		restore
		
		use `munic_`year'', clear
		
		merge 1:1 id_munic_6 using `munic_cat_`year''
		drop if _merge == 2
		drop _merge
			
	}
	*
	
	tempfile munic_jobs_`year'
	save `munic_jobs_`year''
	
	//-----------------------//
	// job categories
	//-----------------------//
	
	use "output/data/normalized/job/`year'.dta", clear
	
	ren wage_total_def wage
	
	merge m:1 id_estab id_munic_6 using "output/data/normalized/establishment/`year'.dta"
	drop if _merge == 2
	drop _merge
	
	//if `year' == 1995 replace wage = .
	
	if `year' <= 2002 {
		
		tostring CBO1994, replace force
		replace CBO1994 = "0" + CBO1994 if length(CBO1994) == 4
		ren CBO1994 CBO
		
	}
	else {
		
		tostring CBO2002, replace force
		ren CBO2002 CBO
		
	}
	*
	
	gen n_jobs = 1
	
	collapse (sum) n_jobs wage, by(id_munic_6 CBO public public_federal public_state public_municipal public_exec public_leg public_jud company nonprofit)
	
	gen     x = ""
	replace x = "pub_fed_exec"	if public_federal == 1		& public_exec == 1
	replace x = "pub_fed_leg"	if public_federal == 1		& public_leg == 1
	replace x = "pub_fed_jud"	if public_federal == 1		& public_jud == 1
	replace x = "pub_stt_exec"	if public_state == 1		& public_exec == 1
	replace x = "pub_stt_leg"	if public_state == 1		& public_leg == 1
	replace x = "pub_stt_jud"	if public_state == 1		& public_jud == 1
	replace x = "pub_mun_exec"	if public_municipal == 1	& public_exec == 1
	replace x = "pub_mun_leg"	if public_municipal == 1	& public_leg == 1
	replace x = "pub_mun_jud"	if public_municipal == 1	& public_jud == 1
	replace x = "priv"			if company == 1
	replace x = "np"			if nonprofit == 1
	
	keep if x != ""
	drop public* company nonprofit
	
	ren n_jobs n_jobs_
	ren wage wage_
	reshape wide n_jobs_ wage_, i(id_munic_6 CBO) j(x) string
	
	gen aux_ocup = ""
	if `year' <= 2002 {
		replace aux_ocup = "_educ"		if real(substr(CBO, 1, 3)) >= 131 & real(substr(CBO, 1, 3)) <= 149
		replace aux_ocup = "_health"	if real(substr(CBO, 1, 3)) >= 61 & real(substr(CBO, 1, 3)) <= 79
	}
	else {
		replace aux_ocup = "_educ"		if real(substr(CBO, 1, 3)) >= 231 & real(substr(CBO, 1, 3)) <= 239
		replace aux_ocup = "_health"	if real(substr(CBO, 1, 3)) >= 221 & real(substr(CBO, 1, 3)) <= 226
	}
	*
	
	drop CBO
	keep if aux_ocup != ""
	collapse (sum) n_jobs_* wage_*, by(id_munic_6 aux_ocup)
	reshape wide n_jobs_* wage_*, i(id_munic_6) j(aux_ocup) string
	
	foreach g in educ health {
		
		if "`g'" == "educ"		local name Education
		if "`g'" == "health"	local name Health
	
		replace n_jobs_pub_fed_exec_`g'	= 0 if n_jobs_pub_fed_exec_`g' == .
		replace n_jobs_pub_fed_leg_`g'	= 0 if n_jobs_pub_fed_leg_`g' == .
		replace n_jobs_pub_fed_jud_`g'	= 0 if n_jobs_pub_fed_jud_`g' == .
		replace n_jobs_pub_stt_exec_`g'	= 0 if n_jobs_pub_stt_exec_`g' == .
		replace n_jobs_pub_stt_leg_`g'	= 0 if n_jobs_pub_stt_leg_`g' == .
		replace n_jobs_pub_stt_jud_`g'	= 0 if n_jobs_pub_stt_jud_`g' == .
		replace n_jobs_pub_mun_exec_`g'	= 0 if n_jobs_pub_mun_exec_`g' == .
		replace n_jobs_pub_mun_leg_`g'	= 0 if n_jobs_pub_mun_leg_`g' == .
		replace n_jobs_pub_mun_jud_`g'	= 0 if n_jobs_pub_mun_jud_`g' == .
		replace n_jobs_np_`g'			= 0 if n_jobs_np_`g' == .
		replace n_jobs_priv_`g'			= 0 if n_jobs_priv_`g' == .
		
		la var n_jobs_pub_fed_exec_`g'	"Federal Executive Public `name' Jobs"
		la var n_jobs_pub_fed_leg_`g'	"Federal Legislative Public `name' Jobs"
		la var n_jobs_pub_fed_jud_`g'	"Federal Judicial Public `name' Jobs"
		la var n_jobs_pub_stt_exec_`g'	"State Executive Public `name' Jobs"
		la var n_jobs_pub_stt_leg_`g'	"State Legislative Public `name' Jobs"
		la var n_jobs_pub_stt_jud_`g'	"State Judicial Public `name' Jobs"
		la var n_jobs_pub_mun_exec_`g'	"Municipal Executive Public `name' Jobs"
		la var n_jobs_pub_mun_leg_`g'	"Municipal Legislative Public `name' Jobs"
		la var n_jobs_pub_mun_jud_`g'	"Municipal Judicial Public `name' Jobs"
		la var n_jobs_priv_`g'			"Private `name' Jobs"
		la var n_jobs_np_`g'			"Non-Profit `name' Jobs"
		la var wage_pub_fed_exec_`g'	"Federal Executive Public `name' Wages (R$ 2018)"
		la var wage_pub_fed_leg_`g'		"Federal Legislative Public `name' Wages (R$ 2018)"
		la var wage_pub_fed_jud_`g'		"Federal Judiciary Public `name' Wages (R$ 2018)"
		la var wage_pub_stt_exec_`g'	"State Executive Public `name' Wages (R$ 2018)"
		la var wage_pub_stt_leg_`g'		"State Legislative Public `name' Wages (R$ 2018)"
		la var wage_pub_stt_jud_`g'		"State Judiciary Public `name' Wages (R$ 2018)"
		la var wage_pub_mun_exec_`g'	"Municipal Executive Public `name' Wages (R$ 2018)"
		la var wage_pub_mun_leg_`g'		"Municipal Legislative Public `name' Wages (R$ 2018)"
		la var wage_pub_mun_jud_`g'		"Municipal Judiciary Public `name' Wages (R$ 2018)"
		la var wage_priv_`g'			"Private `name' Wages (R$ 2018)"
		la var wage_np_`g'				"Non-Profit `name' Wages (R$ 2018)"
		
	}
	*
	
	tempfile munic_jobs_social_`year'
	save `munic_jobs_social_`year''
	
	//-----------------------//
	// jobs by sector
	//-----------------------//
	
	use "output/data/normalized/job/`year'.dta", clear
	
	ren wage_total_def wage
	
	merge m:1 id_estab id_munic_6 using "output/data/normalized/establishment/`year'.dta"
	drop if _merge == 2
	drop _merge
	
	gen n_jobs_agric		= (sector == 1)
	gen n_jobs_OMM			= (sector == 2)
	gen n_jobs_manuf		= (sector == 3)
	gen n_jobs_constr		= (sector == 4)
	gen n_jobs_retail		= (sector == 5)
	gen n_jobs_other_serv	= (sector == 6)
	gen n_jobs_gov			= (sector == 7)
	gen n_jobs_IO			= (sector == 8)
	gen n_jobs_missing		= (sector == .)
	
	gen wage_agric			= wage * (sector == 1)
	gen wage_OMM			= wage * (sector == 2)
	gen wage_manuf			= wage * (sector == 3)
	gen wage_constr			= wage * (sector == 4)
	gen wage_retail			= wage * (sector == 5)
	gen wage_other_serv		= wage * (sector == 6)
	gen wage_gov			= wage * (sector == 7)
	gen wage_IO				= wage * (sector == 8)
	gen wage_missing		= wage * (sector == .)
	
	collapse (sum) n_jobs_* wage_*, by(id_munic_6)
	
	la var n_jobs_agric			"Jobs: Agriculture"
	la var n_jobs_OMM			"Jobs: Oil, Mining and Metals"
	la var n_jobs_manuf			"Jobs: Manufacturing"
	la var n_jobs_constr		"Jobs: Construction"
	la var n_jobs_retail		"Jobs: Retail"
	la var n_jobs_other_serv	"Jobs: Other Services"
	la var n_jobs_gov			"Jobs: Goverment"
	la var n_jobs_IO			"Jobs: Information and Communication"
	la var n_jobs_missing		"Jobs: Missing"
	
	la var wage_agric			"Wages (R$ 2018): Agriculture"
	la var wage_OMM				"Wages (R$ 2018): Oil, Mining and Metals"
	la var wage_manuf			"Wages (R$ 2018): Manufacturing"
	la var wage_constr			"Wages (R$ 2018): Construction"
	la var wage_retail			"Wages (R$ 2018): Retail"
	la var wage_other_serv		"Wages (R$ 2018): Other Services"
	la var wage_gov				"Wages (R$ 2018): Goverment"
	la var wage_IO				"Wages (R$ 2018): Information and Communication"
	la var wage_missing			"Wages (R$ 2018): Missing"
	
	tempfile munic_jobs_sector_`year'
	save `munic_jobs_sector_`year''
	
	//-----------------------//
	// establishments
	//-----------------------//
	
	use "output/data/normalized/establishment/`year'.dta", clear
	
	gen n_estab				= 1
	gen n_estab_agric		= (sector == 1)
	gen n_estab_OMM			= (sector == 2)
	gen n_estab_manuf		= (sector == 3)
	gen n_estab_constr		= (sector == 4)
	gen n_estab_retail		= (sector == 5)
	gen n_estab_other_serv	= (sector == 6)
	gen n_estab_gov			= (sector == 7)
	gen n_estab_IO			= (sector == 8)
	gen n_estab_missing		= (sector == .)
	
	collapse (sum) n_estab*, by(id_munic_6)
	
	la var n_estab				"Establishments"
	la var n_estab_agric		"Establishments: Agriculture"
	la var n_estab_OMM			"Establishments: Oil, Mining and Metals"
	la var n_estab_manuf		"Establishments: Manufacturing"
	la var n_estab_constr		"Establishments: Construction"
	la var n_estab_retail		"Establishments: Retail"
	la var n_estab_other_serv	"Establishments: Other Services"
	la var n_estab_gov			"Establishments: Goverment"
	la var n_estab_IO			"Establishments: Information and Communication"
	la var n_estab_missing		"Establishments: Missing"
	
	tempfile munic_estab_`year'
	save `munic_estab_`year''
	
	//-----------------------//
	// merge
	//-----------------------//
	
	use `munic_jobs_`year'', clear
	
	merge 1:1 id_munic_6 using `munic_jobs_sector_`year''
	drop _merge
	
	merge 1:1 id_munic_6 using `munic_jobs_social_`year''
	drop _merge
	
	merge 1:1 id_munic_6 using `munic_estab_`year''
	drop _merge
	
	gen year = `year'
	la var year "Year"
	
	save "tmp/munic_`year'.dta", replace
	
}
*

//---------------------------------//
// append
//---------------------------------//

use "tmp/munic_1995.dta", clear
foreach year of numlist 1996(1)`LAST_YEAR' {
	append using "tmp/munic_`year'.dta"
}
*

order id_munic_6 year
sort  id_munic_6 year

compress

save "output/data/collapsed/RAIS_1995-`LAST_YEAR'_collapsed_municipality.dta", replace


//----------------------------------------------------------------------------//
// collapse: establishment-year level
//----------------------------------------------------------------------------//

if "`SAMPLE'" == "FALSE" {
	
	foreach year of numlist 1985(1)`LAST_YEAR' {
		
		use "output/data/normalized/job/`year'.dta", clear
		
		gen n_workers = 1
		
		gen churn = hired + laid_off
		
		if `year' <= 1993 {	// before inflation data starts
			
			collapse	(sum) n_workers hired laid_off churn wage_total ///
						(mean) wage_avg, by(id_estab year)
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
		}
		else if `year' >= 1994 {
			
			collapse	(sum) n_workers hired laid_off churn wage_total wage_total_def ///
						(mean) wage_avg wage_avg_def, by(id_estab year)
			
			la var wage_avg_def 	"Monthly Wage (R$ 2018)"
			la var wage_total_def	"Total Yearly Wage (R$ 2018)"
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
			gen wage_def_pw = wage_total_def / n_workers
			la var wage_def_pw "Wage per Worker (R$ 2018)"
			
		}
		*
		
		replace hired = . if year <= 2001	// series starts only in 2002
		replace churn = . if year <= 2001
		
		la var n_workers		"Number of Workers (Total)"
		la var hired			"Number of Hires"
		la var laid_off			"Number of Layoffs"
		la var churn			"Churn"
		la var wage_avg			"Monthly Wage (R$)"
		la var wage_total		"Total Yearly Wage (R$)"
		
		compress
		
		save "output/data/collapsed/RAIS_`year'_collapsed_estab.dta", replace
	
	}
	*
	
	use "output/data/collapsed/RAIS_1985_collapsed_estab.dta", clear
	foreach year of numlist 1986(1)`LAST_YEAR' {
		append using "output/data/collapsed/RAIS_`year'_collapsed_estab.dta"
	}
	*
	
	save "output/data/collapsed/RAIS_1985-`LAST_YEAR'_collapsed_establishment.dta", replace
	
}
*

//----------------------------------------------------------------------------//
// collapse: establishment-municipality-year level
//----------------------------------------------------------------------------//

if "`SAMPLE'" == "FALSE" {
	
	foreach year of numlist 1985(1)`LAST_YEAR' {
		
		use "output/data/normalized/job/`year'.dta", clear
		
		gen n_workers = 1
		
		gen churn = hired + laid_off
		
		if `year' <= 1993 {	// before inflation data starts
			
			collapse	(sum) n_workers hired laid_off churn wage_total ///
						(mean) wage_avg, by(id_estab id_munic_6 year)
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
		}
		else if `year' >= 1994 {
			
			collapse	(sum) n_workers hired laid_off churn wage_total wage_total_def ///
						(mean) wage_avg wage_avg_def, by(id_estab id_munic_6 year)
			
			la var wage_avg_def 	"Monthly Wage (R$ 2018)"
			la var wage_total_def	"Total Yearly Wage (R$ 2018)"
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
			gen wage_def_pw = wage_total_def / n_workers
			la var wage_def_pw "Wage per Worker (R$ 2018)"
			
		}
		*
		
		replace hired = . if year <= 2001	// series starts only in 2002
		replace churn = . if year <= 2001
		
		la var n_workers		"Number of Workers (Total)"
		la var hired			"Number of Hires"
		la var laid_off			"Number of Layoffs"
		la var churn			"Churn"
		la var wage_avg			"Monthly Wage (R$)"
		la var wage_total		"Total Yearly Wage (R$)"
		
		compress
		
		save "output/data/collapsed/RAIS_`year'_collapsed_establishment.dta", replace
	
	}
	*
	
	use "output/data/collapsed/RAIS_1985_collapsed_establishment.dta", clear
	foreach year of numlist 1986(1)`LAST_YEAR' {
		append using "output/data/collapsed/RAIS_`year'_collapsed_establishment.dta"
	}
	*
	
	save "output/data/collapsed/RAIS_1985-`LAST_YEAR'_collapsed_establishment.dta", replace
	
}
*
