
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close

local FIRST_YEAR  ${FIRST_YEAR}
local SECOND_YEAR ${SECOND_YEAR}
local LAST_YEAR   ${LAST_YEAR}

//----------------------------------------------------------------------------//
// collapse: municipality level
//----------------------------------------------------------------------------//

foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
	
	//-----------------------//
	// jobs
	//-----------------------//

	use "output/data/normalized/job/`year'.dta", clear
	
	    ren wage_total     wage
	cap ren wage_total_def wage_def
	
	gen n_jobs = 1
	
	gen n_jobs_with_CBO = (CBO1994 != "" | CBO2002 != "")
	
	gen n_jobs_WC = WC
	gen n_jobs_BC = BC
	
	if `year' <= 1994 {
		
		gcollapse (sum) n_jobs* wage, by(id_municipality_6) fast
		
		la var n_jobs          "Jobs"
		la var n_jobs_with_CBO "Jobs with Non-Null CBO"
		la var n_jobs_WC       "White-Collar Jobs"
		la var n_jobs_BC       "Blue-Collar Jobs"
		la var wage	           "Wage (R$)"
		
	}
	else {
		
		keep id_establishment id_municipality_6 n_jobs* wage wage_def // to save RAM memory
		
		merge m:1 id_establishment id_municipality_6 using "output/data/normalized/establishment/`year'.dta", keep(1 3) nogenerate
		
		//save "tmp/tmp.dta", replace
		
		preserve
		//use "tmp/tmp.dta", clear
		
			gcollapse (sum) n_jobs* wage wage_def, by(id_municipality_6) fast
			
			la var n_jobs	       "Jobs"
			la var n_jobs_with_CBO "Jobs with Non-Null CBO"
			la var n_jobs_WC       "White-Collar Jobs"
			la var n_jobs_BC       "Blue-Collar Jobs"
			la var wage	           "Wage (R$)"
			la var wage_def	       "Wage (R$ 2020)"
			
			tempfile munic_`year'
			save `munic_`year''
			
		restore
		preserve
		//use "tmp/tmp.dta", clear
			
			gcollapse (sum) n_jobs wage wage_def, ///
				by(id_municipality_6 public public_federal public_state public_municipal public_exec public_leg public_jud company nonprofit) fast
			
			gen     x = ""
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
			
			ren n_jobs   n_jobs_
			ren wage     wage_
			ren wage_def wage_def_
			reshape wide n_jobs_ wage_ wage_def_, i(id_municipality_6) j(x) string
			
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
			
			la var wage_pub_fed_exec	"Federal Executive Public Wages (R$)"
			la var wage_pub_fed_leg		"Federal Legislative Public Wages (R$)"
			la var wage_pub_fed_jud		"Federal Judiciary Public Wages (R$)"
			la var wage_pub_stt_exec	"State Executive Public Wages (R$)"
			la var wage_pub_stt_leg		"State Legislative Public Wages (R$)"
			la var wage_pub_stt_jud		"State Judiciary Public Wages (R$)"
			la var wage_pub_mun_exec	"Municipal Executive Public Wages (R$)"
			la var wage_pub_mun_leg		"Municipal Legislative Public Wages (R$)"
			la var wage_pub_mun_jud		"Municipal Judiciary Public Wages (R$)"
			la var wage_priv			"Private Wages (R$)"
			la var wage_np				"Non-Profit Wages (R$)"
			
			la var wage_def_pub_fed_exec	"Federal Executive Public Wages (R$ 2020)"
			la var wage_def_pub_fed_leg		"Federal Legislative Public Wages (R$ 2020)"
			la var wage_def_pub_fed_jud		"Federal Judiciary Public Wages (R$ 2020)"
			la var wage_def_pub_stt_exec	"State Executive Public Wages (R$ 2020)"
			la var wage_def_pub_stt_leg		"State Legislative Public Wages (R$ 2020)"
			la var wage_def_pub_stt_jud		"State Judiciary Public Wages (R$ 2020)"
			la var wage_def_pub_mun_exec	"Municipal Executive Public Wages (R$ 2020)"
			la var wage_def_pub_mun_leg		"Municipal Legislative Public Wages (R$ 2020)"
			la var wage_def_pub_mun_jud		"Municipal Judiciary Public Wages (R$ 2020)"
			la var wage_def_priv			"Private Wages (R$ 2020)"
			la var wage_def_np				"Non-Profit Wages (R$ 2020)"
			
			tempfile munic_cat_`year'
			save `munic_cat_`year''
			
		restore
		
		//erase "tmp/tmp.dta"
		
		use `munic_`year'', clear
		
		merge 1:1 id_municipality_6 using `munic_cat_`year'', keep(1 3) nogenerate
			
	}
	*
	
	gen share_jobs_WC = 100 * n_jobs_WC / n_jobs_with_CBO
	la var share_jobs_WC "% Jobs White-Collar"
	
	tempfile munic_jobs
	save `munic_jobs'
	
	if `year' >= 1995 {
		
		//-----------------------//
		// job categories
		//-----------------------//
		
		use "output/data/normalized/job/`year'.dta", clear
		
			ren wage_total     wage
		cap ren wage_total_def wage_def
		
		keep id_establishment id_municipality_6 CBO1994 CBO2002 wage wage_def // to save RAM memory
		
		merge m:1 id_establishment id_municipality_6 using "output/data/normalized/establishment/`year'.dta", keep(1 3) nogenerate
		
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
		
		gcollapse (sum) n_jobs wage wage_def, ///
			by(id_municipality_6 CBO public public_federal public_state public_municipal public_exec public_leg public_jud company nonprofit) fast
		
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
		
		ren n_jobs   n_jobs_
		ren wage     wage_
		ren wage_def wage_def_
		reshape wide n_jobs_ wage_ wage_def_, i(id_municipality_6 CBO) j(x) string
		
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
		gcollapse (sum) n_jobs_* wage_*, by(id_municipality_6 aux_ocup) fast
		reshape wide n_jobs_* wage_*, i(id_municipality_6) j(aux_ocup) string
		
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
			
			la var wage_pub_fed_exec_`g'	"Federal Executive Public `name' Wages (R$)"
			la var wage_pub_fed_leg_`g'		"Federal Legislative Public `name' Wages (R$)"
			la var wage_pub_fed_jud_`g'		"Federal Judiciary Public `name' Wages (R$)"
			la var wage_pub_stt_exec_`g'	"State Executive Public `name' Wages (R$)"
			la var wage_pub_stt_leg_`g'		"State Legislative Public `name' Wages (R$)"
			la var wage_pub_stt_jud_`g'		"State Judiciary Public `name' Wages (R$)"
			la var wage_pub_mun_exec_`g'	"Municipal Executive Public `name' Wages (R$)"
			la var wage_pub_mun_leg_`g'		"Municipal Legislative Public `name' Wages (R$)"
			la var wage_pub_mun_jud_`g'		"Municipal Judiciary Public `name' Wages (R$)"
			la var wage_priv_`g'			"Private `name' Wages (R$)"
			la var wage_np_`g'				"Non-Profit `name' Wages (R$)"
			
			/*
			la var wage_def_pub_fed_exec_`g'	"Federal Executive Public `name' Wages (R$ 2020)"
			la var wage_def_pub_fed_leg_`g'		"Federal Legislative Public `name' Wages (R$ 2020)"
			la var wage_def_pub_fed_jud_`g'		"Federal Judiciary Public `name' Wages (R$ 2020)"
			la var wage_def_pub_stt_exec_`g'	"State Executive Public `name' Wages (R$ 2020)"
			la var wage_def_pub_stt_leg_`g'		"State Legislative Public `name' Wages (R$ 2020)"
			la var wage_def_pub_stt_jud_`g'		"State Judiciary Public `name' Wages (R$ 2020)"
			la var wage_def_pub_mun_exec_`g'	"Municipal Executive Public `name' Wages (R$ 2020)"
			la var wage_def_pub_mun_leg_`g'		"Municipal Legislative Public `name' Wages (R$ 2020)"
			la var wage_def_pub_mun_jud_`g'		"Municipal Judiciary Public `name' Wages (R$ 2020)"
			la var wage_def_priv_`g'			"Private `name' Wages (R$ 2020)"
			la var wage_def_np_`g'				"Non-Profit `name' Wages (R$ 2020)"
			*/
			
		}
		*
		
		tempfile munic_jobs_social
		save `munic_jobs_social'
		
		//-----------------------//
		// bureaucratss' characteristics
		//-----------------------//
		
		use "output/data/normalized/worker/`year'.dta", clear
		keep id_worker_PIS id_municipality_6 education
		save "tmp/worker.dta", replace
		
		use "output/data/normalized/establishment/`year'.dta", clear
		keep id_estab id_municipality_6 public_municipal
		save "tmp/establishment.dta", replace
		
		use "output/data/normalized/job/`year'.dta", clear
		
		keep id_worker_PIS id_estab id_municipality_6
		
		merge m:1 id_worker_PIS id_municipality_6 using "tmp/worker.dta"
		drop if _merge == 2
		drop _merge
		
		merge m:1 id_estab id_municipality_6 using "tmp/establishment.dta"
		drop if _merge == 2
		drop _merge
		
		keep if public_municipal == 1 //& public_exec == 1
		
		gcollapse (max) education, by(id_worker_PIS id_municipality_6) fast
		
		gen n_workers_pub_mun         = (education != .)
		gen n_workers_pub_mun_college = (education >= 9)
		
		gcollapse (sum) n_workers*, by(id_municipality_6)
		
		gen share_workers_pub_mun_college = 100 * n_workers_pub_mun_college / n_workers_pub_mun
		la var share_workers_pub_mun_college "% College"
		
		tempfile munic_share_college
		save `munic_share_college'
	
	}
	
	//-----------------------//
	// establishments
	//-----------------------//
	
	use "output/data/normalized/establishment/`year'.dta", clear
	
	gen n_estab = 1
	
	gcollapse (sum) n_estab, by(id_municipality_6) fast
	
	la var n_estab "Establishments"
	
	tempfile munic_estab
	save `munic_estab'
	
	if `year' >= 1995 {
		
		//-----------------------//
		// jobs by sector
		//-----------------------//
		
		use "output/data/normalized/job/`year'.dta", clear
		
			ren wage_total     wage
		cap ren wage_total_def wage_def
		
		keep id_establishment id_municipality_6 wage wage_def
		
		merge m:1 id_establishment id_municipality_6 using "output/data/normalized/establishment/`year'.dta", keep(1 3) nogenerate
		
		gen n_jobs_agric		= (sector == 1) if sector != .
		gen n_jobs_OMM			= (sector == 2) if sector != .
		gen n_jobs_manuf		= (sector == 3) if sector != .
		gen n_jobs_constr		= (sector == 4) if sector != .
		gen n_jobs_retail		= (sector == 5) if sector != .
		gen n_jobs_other_serv	= (sector == 6) if sector != .
		gen n_jobs_gov			= (sector == 7) if sector != .
		gen n_jobs_IO			= (sector == 8) if sector != .
		
		gen wage_agric			= wage * (sector == 1) if sector != .
		gen wage_OMM			= wage * (sector == 2) if sector != .
		gen wage_manuf			= wage * (sector == 3) if sector != .
		gen wage_constr			= wage * (sector == 4) if sector != .
		gen wage_retail			= wage * (sector == 5) if sector != .
		gen wage_other_serv		= wage * (sector == 6) if sector != .
		gen wage_gov			= wage * (sector == 7) if sector != .
		gen wage_IO				= wage * (sector == 8) if sector != .
		
		gen wage_def_agric		= wage_def * (sector == 1) if sector != .
		gen wage_def_OMM		= wage_def * (sector == 2) if sector != .
		gen wage_def_manuf		= wage_def * (sector == 3) if sector != .
		gen wage_def_constr		= wage_def * (sector == 4) if sector != .
		gen wage_def_retail		= wage_def * (sector == 5) if sector != .
		gen wage_def_other_serv = wage_def * (sector == 6) if sector != .
		gen wage_def_gov		= wage_def * (sector == 7) if sector != .
		gen wage_def_IO			= wage_def * (sector == 8) if sector != .
		
		gcollapse (sum) n_jobs_* wage_*, by(id_municipality_6) fast
		
		la var n_jobs_agric			"Jobs: Agriculture"
		la var n_jobs_OMM			"Jobs: Oil, Mining and Metals"
		la var n_jobs_manuf			"Jobs: Manufacturing"
		la var n_jobs_constr		"Jobs: Construction"
		la var n_jobs_retail		"Jobs: Retail"
		la var n_jobs_other_serv	"Jobs: Other Services"
		la var n_jobs_gov			"Jobs: Goverment"
		la var n_jobs_IO			"Jobs: Information and Communication"
		
		la var wage_agric			"Wages (R$): Agriculture"
		la var wage_OMM				"Wages (R$): Oil, Mining and Metals"
		la var wage_manuf			"Wages (R$): Manufacturing"
		la var wage_constr			"Wages (R$): Construction"
		la var wage_retail			"Wages (R$): Retail"
		la var wage_other_serv		"Wages (R$): Other Services"
		la var wage_gov				"Wages (R$): Goverment"
		la var wage_IO				"Wages (R$): Information and Communication"
		
		la var wage_def_agric		"Wages (R$ 2020): Agriculture"
		la var wage_def_OMM			"Wages (R$ 2020): Oil, Mining and Metals"
		la var wage_def_manuf		"Wages (R$ 2020): Manufacturing"
		la var wage_def_constr		"Wages (R$ 2020): Construction"
		la var wage_def_retail		"Wages (R$ 2020): Retail"
		la var wage_def_other_serv	"Wages (R$ 2020): Other Services"
		la var wage_def_gov			"Wages (R$ 2020): Goverment"
		la var wage_def_IO			"Wages (R$ 2020): Information and Communication"
		
		tempfile munic_jobs_sector
		save `munic_jobs_sector'
		
		//-----------------------//
		// establishments by sector
		//-----------------------//
		
		use "output/data/normalized/establishment/`year'.dta", clear
		
		gen n_estab_agric		= (sector == 1) if sector != .
		gen n_estab_OMM			= (sector == 2) if sector != .
		gen n_estab_manuf		= (sector == 3) if sector != .
		gen n_estab_constr		= (sector == 4) if sector != .
		gen n_estab_retail		= (sector == 5) if sector != .
		gen n_estab_other_serv	= (sector == 6) if sector != .
		gen n_estab_gov			= (sector == 7) if sector != .
		gen n_estab_IO			= (sector == 8) if sector != .
		
		gen n_estab_pub     	= (public == 1)    if legal_nature != .
		gen n_estab_priv    	= (company == 1)   if legal_nature != .
		gen n_estab_np      	= (nonprofit == 1) if legal_nature != .
		
		gcollapse (sum) n_estab_*, by(id_municipality_6) fast
		
		la var n_estab_agric		"Establishments: Agriculture"
		la var n_estab_OMM			"Establishments: Oil, Mining and Metals"
		la var n_estab_manuf		"Establishments: Manufacturing"
		la var n_estab_constr		"Establishments: Construction"
		la var n_estab_retail		"Establishments: Retail"
		la var n_estab_other_serv	"Establishments: Other Services"
		la var n_estab_gov			"Establishments: Goverment"
		la var n_estab_IO			"Establishments: Information and Communication"
		
		la var n_estab_pub			"Establishments: Public"
		la var n_estab_priv			"Establishments: Private"
		la var n_estab_np			"Establishments: Nonprofit"
		
		tempfile munic_estab_sector
		save `munic_estab_sector'
		
	}
	
	//-----------------------//
	// merge
	//-----------------------//
	
	use `munic_jobs', clear
	
	merge 1:1 id_municipality_6 using `munic_estab', nogenerate
	
	if `year' >= 1995 {
		merge 1:1 id_municipality_6 using `munic_jobs_social', nogenerate
		merge 1:1 id_municipality_6 using `munic_share_college', nogenerate
		merge 1:1 id_municipality_6 using `munic_jobs_sector', nogenerate
		merge 1:1 id_municipality_6 using `munic_estab_sector', nogenerate
	}
	
	gen year = `year'
	la var year "Year"
	
	save "tmp/munic_`year'.dta", replace
	
}
*

//---------------------------------//
// append
//---------------------------------//

use "tmp/munic_`FIRST_YEAR'.dta", clear
foreach year of numlist `SECOND_YEAR'(1)`LAST_YEAR' {
	append using "tmp/munic_`year'.dta"
}
*

order id_municipality_6 year
sort  id_municipality_6 year

order n_estab_pub n_estab_priv n_estab_np, a(n_estab_IO)

compress

save "output/data/collapsed/RAIS_`FIRST_YEAR'-`LAST_YEAR'_municipality.dta", replace

//----------------------------------------------------------------------------//
// collapse: establishment-year level
//----------------------------------------------------------------------------//

if "${SAMPLE}" == "FALSE" {
	
	foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
		
		use "output/data/normalized/job/`year'.dta", clear
		
		gen n_workers = 1
		
		gen churn = hired + laid_off
		
		if `year' <= 1993 {	// before inflation data starts
			
			collapse	(sum) n_workers hired laid_off churn wage_total ///
						(mean) wage_avg, by(id_establishment year)
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
		}
		else if `year' >= 1994 {
			
			collapse	(sum) n_workers hired laid_off churn wage_total wage_total_def ///
						(mean) wage_avg wage_avg_def, by(id_establishment year)
			
			la var wage_avg_def 	"Monthly Wage (R$ 2020)"
			la var wage_total_def	"Total Yearly Wage (R$ 2020)"
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
			gen wage_def_pw = wage_total_def / n_workers
			la var wage_def_pw "Wage per Worker (R$ 2020)"
			
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
		
		save "output/data/collapsed/RAIS_`year'_establishment.dta", replace
	
	}
	*
	
	use "output/data/collapsed/RAIS_`FIRST_YEAR'_establishment.dta", clear
	foreach year of numlist `SECOND_YEAR'(1)`LAST_YEAR' {
		append using "output/data/collapsed/RAIS_`year'_establishment.dta"
	}
	*
	
	save "output/data/collapsed/RAIS_`FIRST_YEAR'-`LAST_YEAR'_establishment.dta", replace
	
}
*

//----------------------------------------------------------------------------//
// collapse: establishment-municipality-year level
//----------------------------------------------------------------------------//

if "${SAMPLE}" == "FALSE" {
	
	foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
		
		use "output/data/normalized/job/`year'.dta", clear
		
		gen n_workers = 1
		
		gen churn = hired + laid_off
		
		if `year' <= 1993 {	// before inflation data starts
			
			collapse	(sum) n_workers hired laid_off churn wage_total ///
						(mean) wage_avg, by(id_establishment id_municipality_6 year)
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
		}
		else if `year' >= 1994 {
			
			collapse	(sum) n_workers hired laid_off churn wage_total wage_total_def ///
						(mean) wage_avg wage_avg_def, by(id_establishment id_municipality_6 year)
			
			la var wage_avg_def 	"Monthly Wage (R$ 2020)"
			la var wage_total_def	"Total Yearly Wage (R$ 2020)"
			
			gen wage_pw = wage_total / n_workers
			la var wage_pw "Wage per Worker (R$)"
			
			gen wage_def_pw = wage_total_def / n_workers
			la var wage_def_pw "Wage per Worker (R$ 2020)"
			
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
		
		save "output/data/collapsed/RAIS_`year'_establishment.dta", replace
	
	}
	*
	
	use "output/data/collapsed/RAIS_`FIRST_YEAR'_establishment.dta", clear
	foreach year of numlist `SECOND_YEAR'(1)`LAST_YEAR' {
		append using "output/data/collapsed/RAIS_`year'_establishment.dta"
	}
	*
	
	save "output/data/collapsed/RAIS_`FIRST_YEAR'-`LAST_YEAR'_establishment.dta", replace
	
}
*
