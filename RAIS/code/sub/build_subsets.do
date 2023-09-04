
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "F://data/rais"

local SAMPLE		FALSE
local SAMPLE_SIZE	5

if "`SAMPLE'" == "TRUE" {
	!mkdir "output/data/identified/full_sample`SAMPLE_SIZE'"
	!mkdir "output/data/identified/normalized_sample`SAMPLE_SIZE'"
}
*

local FIRST_YEAR 1985
local LAST_YEAR  2018

local SECOND_YEAR = `FIRST_YEAR' + 1

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//------------------------------//
// unifying sectors
//------------------------------//

cap drop program estab_sector
program estab_sector
	
	local year `1'
	
	if `year' >= 1995 & `year' <= 2005 {
		
		gen     sector1 = ""
		replace sector1 = "A" if inlist(substr(CNAE1, 1, 2), "01", "02")
		replace sector1 = "B" if inlist(substr(CNAE1, 1, 2), "05")
		replace sector1 = "C" if inlist(substr(CNAE1, 1, 2), "10", "11", "13", "14")
		replace sector1 = "D" if inlist(substr(CNAE1, 1, 2), "15", "16", "17", "18", "19", "20", "21", "22", "23") | ///
								 inlist(substr(CNAE1, 1, 2), "24", "25", "26", "27", "28", "29", "30", "31", "32") | ///
								 inlist(substr(CNAE1, 1, 2), "33", "34", "35", "36", "37")
		replace sector1 = "E" if inlist(substr(CNAE1, 1, 2), "40", "41")
		replace sector1 = "F" if inlist(substr(CNAE1, 1, 2), "45")
		replace sector1 = "G" if inlist(substr(CNAE1, 1, 2), "50", "51", "52")
		replace sector1 = "H" if inlist(substr(CNAE1, 1, 2), "55")
		replace sector1 = "I" if inlist(substr(CNAE1, 1, 2), "60", "61", "62", "63", "64")
		replace sector1 = "J" if inlist(substr(CNAE1, 1, 2), "65", "66", "67")
		replace sector1 = "K" if inlist(substr(CNAE1, 1, 2), "70", "71", "72", "73", "74")
		replace sector1 = "L" if inlist(substr(CNAE1, 1, 2), "75")
		replace sector1 = "M" if inlist(substr(CNAE1, 1, 2), "80")
		replace sector1 = "N" if inlist(substr(CNAE1, 1, 2), "85")
		replace sector1 = "O" if inlist(substr(CNAE1, 1, 2), "90", "91", "92", "93")
		replace sector1 = "P" if inlist(substr(CNAE1, 1, 2), "95")
		replace sector1 = "Q" if inlist(substr(CNAE1, 1, 2), "99")
		la var  sector1 "Economic Sector 1.0 (IBGE)"
		
		la var  CNAE1 "CNAE 1.0"
		replace CNAE1 = subinstr(CNAE1, ".", "", .)
		replace CNAE1 = subinstr(CNAE1, "-", "", .)
		
		gen 	sector_IBGE = ""
		replace sector_IBGE = "agriculture"											if sector1 == "A"
		replace sector_IBGE = "fishing"												if sector1 == "B"
		replace sector_IBGE = "extractive industry" 								if sector1 == "C"
		replace sector_IBGE = "transformation industry"								if sector1 == "D"
		replace sector_IBGE = "electricity, gas, or water"							if sector1 == "E"
		replace sector_IBGE = "construction"										if sector1 == "F"
		replace sector_IBGE = "retail: vehicles, home objects"						if sector1 == "G"
		replace sector_IBGE = "lodging and food"									if sector1 == "H"
		replace sector_IBGE = "transportation, storage and communication"			if sector1 == "I"
		replace sector_IBGE = "finance"												if sector1 == "J"
		replace sector_IBGE = "real estate"											if sector1 == "K"
		replace sector_IBGE = "public administration, defense, or social security"	if sector1 == "L"
		replace sector_IBGE = "education"											if sector1 == "M"
		replace sector_IBGE = "health or social services"							if sector1 == "N"
		replace sector_IBGE = "other social services"								if sector1 == "O"
		replace sector_IBGE = "domestic services"									if sector1 == "P"
		replace sector_IBGE = "international organizations"							if sector1 == "Q"
		
		drop sector1
		
	}
	else if `year' >= 2006 & `year' <= 2018 {
		
		gen     sector2 = ""
		replace sector2 = "A" if inlist(substr(CNAE2, 1, 2), "01", "02", "03")
		replace sector2 = "B" if inlist(substr(CNAE2, 1, 2), "05", "06", "07", "08", "09")
		replace sector2 = "C" if inlist(substr(CNAE2, 1, 2), "10", "11", "13", "14", "15", "16", "17", "18", "19") | ///
								 inlist(substr(CNAE2, 1, 2), "20", "21", "22", "23", "24", "25", "26", "27", "28") | ///
								 inlist(substr(CNAE2, 1, 2), "29", "30", "31", "32", "33")
		replace sector2 = "D" if inlist(substr(CNAE2, 1, 2), "35")
		replace sector2 = "E" if inlist(substr(CNAE2, 1, 2), "36", "37", "38", "39")
		replace sector2 = "F" if inlist(substr(CNAE2, 1, 2), "41", "42", "43")
		replace sector2 = "G" if inlist(substr(CNAE2, 1, 2), "45", "46", "47")
		replace sector2 = "H" if inlist(substr(CNAE2, 1, 2), "49", "50", "51", "52", "53")
		replace sector2 = "I" if inlist(substr(CNAE2, 1, 2), "55", "56")
		replace sector2 = "J" if inlist(substr(CNAE2, 1, 2), "58", "59", "60", "61", "62", "63")
		replace sector2 = "K" if inlist(substr(CNAE2, 1, 2), "64", "65", "66")
		replace sector2 = "L" if inlist(substr(CNAE2, 1, 2), "68")
		replace sector2 = "M" if inlist(substr(CNAE2, 1, 2), "69", "70", "71", "72", "73", "74", "75")
		replace sector2 = "N" if inlist(substr(CNAE2, 1, 2), "77", "78", "79", "80", "81", "82")
		replace sector2 = "O" if inlist(substr(CNAE2, 1, 2), "84")
		replace sector2 = "P" if inlist(substr(CNAE2, 1, 2), "85")
		replace sector2 = "Q" if inlist(substr(CNAE2, 1, 2), "86", "87", "88")
		replace sector2 = "R" if inlist(substr(CNAE2, 1, 2), "90", "91", "92", "93")
		replace sector2 = "S" if inlist(substr(CNAE2, 1, 2), "94", "95", "96")
		replace sector2 = "T" if inlist(substr(CNAE2, 1, 2), "97")
		replace sector2 = "U" if inlist(substr(CNAE2, 1, 2), "99")
		la var sector2 "Economic Sector 2.0 (IBGE)"
		
		la var CNAE2 "CNAE 2.0"
		replace CNAE2 = subinstr(CNAE2, ".", "", .)
		replace CNAE2 = subinstr(CNAE2, "-", "", .)
		
		gen 	sector_IBGE = ""
		replace sector_IBGE = "agriculture" 										if sector2 == "A"
		replace sector_IBGE = "extractive industry"									if sector2 == "B"
		replace sector_IBGE = "transformation industry"								if sector2 == "C"
		replace sector_IBGE = "electricity, gas, or water"							if sector2 == "D"
		replace sector_IBGE = "electricity, gas, or water"							if sector2 == "E"
		replace sector_IBGE = "construction"										if sector2 == "F"
		replace sector_IBGE = "retail: vehicles, home objects"						if sector2 == "G"
		replace sector_IBGE = "transportation, storage and communication"			if sector2 == "H"
		replace sector_IBGE = "lodging and food"									if sector2 == "I"
		replace sector_IBGE = "information or communication"						if sector2 == "J"
		replace sector_IBGE = "finance"												if sector2 == "K"
		replace sector_IBGE = "real estate"											if sector2 == "L"
		replace sector_IBGE = "clerical, science or technical"						if sector2 == "M"
		replace sector_IBGE = "administrative"										if sector2 == "N"
		replace sector_IBGE = "public administration, defense, or social security"	if sector2 == "O"
		replace sector_IBGE = "education"											if sector2 == "P"
		replace sector_IBGE = "health or social services"							if sector2 == "Q"
		replace sector_IBGE = "arts, culture or sports"								if sector2 == "R"
		replace sector_IBGE = "other services"										if sector2 == "S"
		replace sector_IBGE = "domestic services"									if sector2 == "T"
		replace sector_IBGE = "international organizations"							if sector2 == "U"
		
		drop sector2
		
	}
	else {
	    
		gen sector_IBGE = ""
	}
	*
	
	la define la_sector_IBGE	1 "agriculture" ///
								2 "fishing" ///
								3 "extractive industry" ///
								4 "transformation industry" ///
								5 "electricity, gas, or water" ///
								6 "construction" ///
								7 "retail: vehicles, home objects" ///
								8 "transportation, storage and communication" ///
								9 "lodging and food" ///
								10 "information or communication" ///
								11 "finance" ///
								12 "real estate" ///
								13 "clerical, science or technical" ///
								14 "administrative" ///
								15 "public administration, defense, or social security" ///
								16 "education" ///
								17 "health or social services" ///
								18 "arts, culture or sports" ///
								19 "other services" ///
								20 "domestic services" ///
								21 "other social services" ///
								22 "international organizations", ///
		replace
	
	encode sector_IBGE, generate(enc_sector_IBGE) la(la_sector_IBGE)
	drop sector_IBGE
	ren enc_sector_IBGE sector_IBGE
	la var sector_IBGE "Sector (IBGE)"
	
	gen     sector = .
	replace sector = 1 if inlist(sector_IBGE, 1, 2)
	replace sector = 2 if inlist(sector_IBGE, 3)
	replace sector = 3 if inlist(sector_IBGE, 4, 5)
	replace sector = 4 if inlist(sector_IBGE, 6)
	replace sector = 5 if inlist(sector_IBGE, 7)
	replace sector = 6 if inlist(sector_IBGE, 8, 9, 10, 11, 12, 13, 14) | ///
						  inlist(sector_IBGE, 16, 17, 18, 19, 20, 21)
	replace sector = 7 if inlist(sector_IBGE, 15)
	replace sector = 8 if inlist(sector_IBGE, 22)
	
	la define la_sector	1 "agriculture" ///
						2 "oil, mining and metals" ///
						3 "manufacturing" ///
						4 "construction" ///
						5 "retail" ///
						6 "other services" ///
						7 "government" ///
						8 "international organizations", ///
		replace
	
	la val sector la_sector
	la var sector "Sector"
	
end

//------------------------------//
// mapping CBO1994 to CBO2002
// source: IBGE CONCLA
// https://concla.ibge.gov.br/
//------------------------------//

import delimited "extra/CBO/conversao 94-02/CBO94 - CBO2002 - Conversao.csv", clear delim(";") stringcols(_all) // com 90

ren cbo94	CBO1994
ren cbo2002	CBO2002

la var CBO1994 "CBO 1994"
la var CBO2002 "CBO 2002"

replace CBO1994 = subinstr(CBO1994, "X", "0", .)
replace CBO1994 = subinstr(CBO1994, "-", "",  .)
replace CBO1994 = subinstr(CBO1994, ".", "",  .)

drop if CBO1994 == ""

duplicates drop CBO1994, force

save "tmp/CBO1994_to_CBO2002.dta", replace

//------------------------------//
// mapping CBO1994 to ISCO1988
// Source: Muendler et al. (2004)
// https://econweb.ucsd.edu/muendler/html/brazil.html
// https://econweb.ucsd.edu/muendler/docs/brazil/cbo2isco.pdf
//------------------------------//

import delimited "extra/CBO/conversao 94-ISCO88/cbo-isco-conc.csv", clear stringcols(_all)

keep cboid iscoid

ren cboid	CBO1994
ren iscoid	ISCO1988

la var CBO1994  "CBO 1994"
la var ISCO1988 "ISCO 1988"

replace CBO1994 = subinstr(CBO1994, "X", "0", .)
replace CBO1994 = subinstr(CBO1994, "-", "",  .)
replace CBO1994 = subinstr(CBO1994, ".", "",  .)

drop if CBO1994  == ""
drop if ISCO1988 == ""

save "tmp/CBO1994_to_ISCO1988.dta", replace

gen WC              = inlist(substr(ISCO1988, 1, 1), "1", "2", "3", "4", "5")
gen WC_manager      = inlist(substr(ISCO1988, 1, 1), "1"                    )
gen WC_professional = inlist(substr(ISCO1988, 1, 1),      "2"               )
gen WC_technician   = inlist(substr(ISCO1988, 1, 1),           "3"          )
gen WC_others       = inlist(substr(ISCO1988, 1, 1),                "4", "5")
gen BC              = inlist(substr(ISCO1988, 1, 1), "6", "7", "8", "9")
gen BC_skilled      = inlist(substr(ISCO1988, 1, 1), "6", "7", "8"     )
gen BC_unskilled    = inlist(substr(ISCO1988, 1, 1),                "9")

la var WC              "White Collar"
la var WC_manager      "White Collar Manager"
la var WC_professional "White Collar Professional"
la var WC_technician   "White Collar Technician"
la var WC_others       "White Collar Others"
la var BC              "Blue Collar"
la var BC_skilled      "Blue Collar Skilled"
la var BC_unskilled    "Blue Collar Unskilled"

drop ISCO1988

save "tmp/CBO1994_dummies.dta", replace

//------------------------------//
// mapping CBO2002 dummies
//------------------------------//

import delimited "extra/CBO/estrutura/CBO2002 - Ocupacao.csv", clear stringcols(_all)

keep codigo
ren  codigo CBO2002

gen WC              = inlist(substr(CBO2002, 1, 1), "1", "2", "3", "4")      if CBO2002 != ""
gen WC_manager      = inlist(substr(CBO2002, 1, 1), "1"               )      if CBO2002 != ""
gen WC_professional = inlist(substr(CBO2002, 1, 1),      "2"          )      if CBO2002 != ""
gen WC_technician   = inlist(substr(CBO2002, 1, 1),           "3"     )      if CBO2002 != ""
gen WC_others       = inlist(substr(CBO2002, 1, 1),                "4")      if CBO2002 != ""
gen BC              = inlist(substr(CBO2002, 1, 1), "5", "6", "7", "8", "9") if CBO2002 != ""

la var WC              "White Collar"
la var WC_manager      "White Collar Manager"
la var WC_professional "White Collar Professional"
la var WC_technician   "White Collar Technician"
la var WC_others       "White Collar Others"
la var BC              "Blue Collar"

/*
gen     occup_cat = .
replace occup_cat = 0                           if length(CBO2002) == 5
replace occup_cat = real(substr(CBO2002, 1, 1)) if length(CBO2002) == 6
la var occup_cat "Occupation Category (CBO2002)"

order occup_cat, a(ISCO1988)

la define la_occup_cat	0 "military or police" ///
						1 "manager or upper politician" ///
						2 "professional: science and arts" ///
						3 "technician: mid-level" ///
						4 "worker: clerical" ///
						5 "worker: services or sales" ///
						6 "worker: agriculture, forestry or fishing" ///
						7 "worker: industry" ///
						8 "worker: industry" ///
						9 "worker: repair or maintenance", ///
	replace

la val occup_cat la_occup_cat
*/

save "tmp/CBO2002_dummies.dta", replace

/*

//------------------------------//
// mapping CBO1994 and CBO2002 to ISCO1988
//------------------------------//

use "tmp/CBO1994_to_ISCO1988.dta", clear

/*
gen occup_gener =	inlist(substr(CBO1994, -2, .), "01", "02", "03", "04", "05") | /// // Note: this is unrelated to French Anatomy classification, and independent, but could be useful
					inlist(substr(CBO1994, -2, .), "06", "07", "08", "09", "10")
la var occup_gener "Generalist (CBO 1994)"

gen occup_WC = inlist(substr(ISCO1988, 1, 1), "2", "3", "4", "5")
la var occup_WC "White Collar (ISCO 1988)"

gen occup_WC_superv = (inlist(substr(ISCO1988, 1, 1), "2", "3") & occup_gener == 1)
la var occup_WC_superv "White Collar Supervisor (ISCO 1988)"

gen occup_WC_notsuperv = inlist(substr(ISCO1988, 1, 1), "4", "5")
replace occup_WC_notsuperv = 1 if inlist(substr(ISCO1988, 1, 1), "2", "3") & occup_gener == 0
la var occup_WC_notsuperv "White Collar Supervisor (ISCO 1988)"

gen occup_WC_top = inlist(substr(ISCO1988, 1, 1), "2", "3")
la var occup_WC_top "White Collar Top (ISCO 1988)"

gen occup_WC_others = inlist(substr(ISCO1988, 1, 1), "4", "5")
la var occup_WC_others "White Collar Others (ISCO 1988)"

gen occup_man = inlist(substr(ISCO1988, 2, 4), "121", "122", "123", "131")	// Note: ISCO88 makes distinction between Corporate Manager (121-122-123) and General Manager (131).
la var occup_man "Manager (ISCO 1988)"										// However, it's a distinction that is not clear about layer, but rather about firm size. 
																			// Therefore consider them equal for this.

gen occup_BC = inlist(substr(ISCO1988, 1, 1), "6", "7", "8", "9")
replace occup_BC = 1 if occup_WC_superv == 0 & occup_WC_notsuperv == 0 & occup_WC_top == 0 & occup_WC_others == 0 & occup_WC == 0 & occup_BC == 0 & occup_man == 0
la var occup_BC "Blue Collar (ISCO 1988)"
*/

merge 1:m CBO1994 using "tmp/CBO1994_to_CBO2002.dta"
drop if _merge == 2
drop _merge

foreach k in occup_gener occup_BC occup_WC occup_WC_superv occup_WC_notsuperv occup_WC_top occup_WC_others occup_man {
	
	local lab: variable label `k'
	
	ren `k' `k'_1994
	
	gen `k' = `k'_1994
	la var `k' "`lab'"
	
	bys CBO2002: egen aux_`k' = max(`k') if CBO2002 != ""
	
}
*

replace occup_gener = 1			if aux_occup_gener == 1
replace occup_BC = 0			if aux_occup_man == 1 | aux_occup_WC_superv == 1 | aux_occup_WC_notsuperv == 1 | aux_occup_WC_top == 1 | aux_occup_WC_others == 1 | aux_occup_WC == 1
replace occup_BC = 0			if aux_occup_man == 1 | aux_occup_WC_superv == 1 | aux_occup_WC_notsuperv == 1 | aux_occup_WC_top == 1 | aux_occup_WC_others == 1
replace occup_WC = 0			if aux_occup_man == 1 
replace occup_WC_others = 0		if aux_occup_man == 1 | aux_occup_WC_top == 1
replace occup_WC_top = 0		if aux_occup_man == 1 
replace occup_WC_notsuperv = 0	if aux_occup_man == 1 | aux_occup_WC_superv == 1
replace occup_WC_superv = 0		if aux_occup_man == 1
replace occup_man = 1			if aux_occup_man == 1

replace occup_BC = 1 if occup_WC_superv == 0 & occup_WC_notsuperv == 0 & occup_WC_top == 0 & occup_WC_others == 0 & occup_WC == 0 & occup_BC == 0 & occup_man == 0

drop aux*

preserve
	
	keep CBO1994 occup_gener_1994 - occup_BC_1994
	
	foreach k in occup_gener occup_WC occup_WC_superv occup_WC_notsuperv occup_WC_top occup_WC_others occup_man occup_BC {
		
		ren `k'_1994 `k'
		
	}
	*
	
	drop if CBO1994 == ""
	duplicates drop
	
	save "tmp/CBO1994_categories.dta", replace
	
restore

preserve
	
	keep CBO2002 occup_gener - occup_man
	
	drop if CBO2002 == ""
	duplicates drop
	
	duplicates drop CBO2002, force	// TODO: there should be no duplicates at this stage!
	
	save "tmp/CBO2002_categories.dta", replace
	
restore
*/

//------------------------------//
// minimum wage
//------------------------------//

use "extra/minimum_wage/data_minimum_wage_1940-2019.dta", clear

keep if month == 12
drop month ym

save "tmp/minimum_wage.dta", replace


//------------------------------//
// inflation
//------------------------------//

use "extra/inflation/data_IBGE_IPCA_1994-2018.dta", clear

keep if month == 12

keep year index

gen aux_index_2018 = index if year == 2018
egen index_2018 = max(aux_index_2018)

gen price_index_b2018 = index / index_2018
la var price_index_b2018 "Price Index (Base 2018)"

keep year price_index_b2018

save "tmp/inflation.dta", replace


//----------------------------------------------------------------------------//
// subsets
//----------------------------------------------------------------------------//

foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
	
	if "`SAMPLE'" == "TRUE" {
		use "output/data/identified/full/`year'.dta", clear
		sample `SAMPLE_SIZE', by(municipio)
		save "output/data/identified/full_sample`SAMPLE_SIZE'/`year'.dta", replace
	}
	*
	
	//------------------------------------//
	// job
	//------------------------------------//
	
	if "`SAMPLE'" == "TRUE" {
		!mkdir "output/data/identified/normalized_sample`SAMPLE_SIZE'/job"
		use "output/data/identified/full_sample`SAMPLE_SIZE'/`year'.dta", clear
	}
	else {
		!mkdir "output/data/identified/normalized/job"
		use "output/data/identified/full/`year'.dta", clear
	}
	*
	
	    ren PIS			id_worker_PIS
	cap ren CPF	        id_worker_CPF
	    ren identificad	id_establishment
	    ren municipio	id_municipality_6
	
	if `year' >= 1985 & `year' <= 2001 local IDs id_worker_PIS    			 id_establishment id_municipality_6
	if `year' >= 2002 & `year' <= 2018 local IDs id_worker_PIS id_worker_CPF id_establishment id_municipality_6
	
	if `year' >= 1994 & `year' <= 2018 & `year' != 2002	local tipoadm tipoadm
	if `year' == 2002									local tipoadm
	
	if `year' >= 1985 & `year' <= 1993 local vars empem3112 tpvinculo			mesadmissao causadesli mesdesli ocupacao94			remdezembro remmedia				 tempempr
	if `year' >= 1994 & `year' <= 1998 local vars empem3112 tpvinculo `tipoadm' mesadmissao causadesli mesdesli ocupacao94			remdezembro remmedia				 tempempr horascontr
	if `year' >= 1999 & `year' <= 2001 local vars empem3112 tpvinculo `tipoadm' mesadmissao causadesli mesdesli ocupacao94			remdezembro remmedia remdezr remmedr tempempr horascontr
	if `year' == 2002				   local vars empem3112 tpvinculo `tipoadm' dtadmissao  causadesli mesdesli ocupacao94			remdezembro remmedia remdezr remmedr tempempr horascontr tiposal salcontr ultrem
	if `year' >= 2003 & `year' <= 2009 local vars empem3112 tpvinculo `tipoadm' dtadmissao  causadesli mesdesli ocupacao94 ocup2002 remdezembro remmedia remdezr remmedr tempempr horascontr tiposal salcontr ultrem
	if `year' >= 2010 & `year' <= 2018 local vars empem3112 tpvinculo `tipoadm' dtadmissao  causadesli mesdesli            ocup2002 remdezembro remmedia remdezr remmedr tempempr horascontr tiposal salcontr ultrem
	
	keep `IDs' `vars'
	
	duplicates drop
	
	// cleaning observations that (1) have missing ID info or (2) are duplicates.
	drop if id_worker_PIS == "0" | id_worker_PIS == "00000000000"
	duplicates tag id_worker_PIS id_establishment id_municipality_6, gen(dup)
	drop if dup > 0
	drop dup
	
	gen year = `year'
	la var year "Year"
	
	gen employed_3112 = empem3112
	drop empem3112
	la var employed_3112 "Employed on December 31"
	
	gen year_admission = .
	if `year' >= 2002 replace year_admission = real(substr(dtadmissao, 5, 4))
	la var year_admission "Admission Year"
	
	gen month_admission = .
	if `year' <= 2001 replace month_admission = mesadmissao
	if `year' >= 2002 replace month_admission = real(substr(dtadmissao, 3, 2))
	la var month_admission "Admission Month"
	
	gen month_separation = mesdesli
	la var month_separation "Separation Month"
	
	gen ym_admission = ym(year_admission, month_admission) 
	format ym_admission %tm
	la var ym_admission "Year-Month Admission"
	
	gen ym_separation = ym(year, month_separation) if month_separation != 0
	format ym_separation %tm
	la var ym_separation "Year-Month Separation"
	
	gen hired = (year_admission == year)
	la var hired "Hired During Year"
	
	gen laid_off = (month_separation != 0)
	la var laid_off "Laid Off During Year"
	
	gen     n_months = .
	replace n_months = 12									if hired == 0 & laid_off == 0
	replace n_months = 12 - month_admission					if hired == 1 & laid_off == 0
	replace n_months = month_separation						if hired == 0 & laid_off == 1
	replace n_months = month_separation - month_admission	if hired == 1 & laid_off == 1
	replace n_months = 0 if n_months < 0
	la var n_months "Number of Months Worked"
	
	recode tpvinculo (10 = 10 "CLT U/PJ IND") (15 = 15 "CLT U/PF IND") (20 = 20 "CLT R/PJ IND") ///
					 (25 = 25 "CLT R/PF IND") (30 = 30 "ESTATUTARIO") (31 = 31 "ESTAT RGPS") ///
					 (35 = 35 "ESTAT N/EFET") (40 = 40 "AVULSO") (50 = 50 "TEMPORARIO") ///
					 (55 = 55 "APRENDIZ CONTR") (60 = 60 "CLT U/PJ DET") (65 = 65 "CLT U/PF DET") ///
					 (70 = 70 "CLT R/PJ DET") (75 = 75 "CLT R/PF DET") (80 = 80 "DIRETOR") ///
					 (90 = 90 "CONT PRZ DET") (95 = 95 "CONT TMP DET") (96 = 96 "CONT LEI EST") ///
					 (97 = 97 "CONT LEI MUN"), pre(n)label(tpvinculo)
	drop tpvinculo
	ren ntpvinculo type_contract
	la var type_contract "Contract Type"
	
	recode causadesli (0 = 0 "Nao desligado") (10 = 10 "Rescisao com justa causa por iniciativa do empregador") ///
					  (11 = 11 "Rescisao sem justa causa por iniciativa do empregador") ///
					  (12 = 12 "Termino do contrato de trabalho") ///
					  (20 = 20 "Rescisao com justa causa por iniciativa do empregado (rescisao indireta)") ///
					  (21 = 21 "Rescisao sem justa causa por iniciativa do empregado") ///
					  (22 = 22 "Possui outro cargo") ///
					  (30 = 30 "Transferencia/movimentacao do empregado/servidor, com onus para a cedente") ///
					  (31 = 31 "Transferencia/movimentacao do empregado/servidor, sem onus para a cedente") ///
					  (32 = 32 "Readaptacao ou redistribuicao (especifico para servidor publico)") ///
					  (33 = 33 "Cessao") (40 = 40 "Mudanca de regime trabalhista") ///
					  (50 = 50 "Reforma de militar para a reserva remunerada") (60 = 60 "Falecimento") ///
					  (62 = 62 "Falecimento decorrente de acidente do trabalho") ///
					  (63 = 63 "Falecimento decorrente de acidente do trabalho de trajeto (trajeto residencia-trabalho-residencia)") ///
					  (64 = 64 "Falecimento decorrente de doenca profissional") ///
					  (70 = 70 "Aposentadoria por tempo de servico, com rescisao contratual") ///
					  (71 = 71 "Aposentadoria por tempo de servico, sem rescisao contratual") ///
					  (72 = 72 "Aposentadoria por idade, com rescisao contratual") ///
					  (73 = 73 "Aposentadoria por invalidez, decorrente de acidente do trabalho") ///
					  (74 = 74 "Aposentadoria por invalidez, decorrente de doenca profissional") ///
					  (75 = 75 "Aposentadoria compulsoria") ///
					  (76 = 76 "Aposentadoria por invalidez, exceto a decorrente de doenca profissional ou acidente do trabalho") ///
					  (78 = 78 "Aposentadoria por idade, sem rescisao contratual") ///
					  (79 = 79 "Aposentadoria especial, com rescisao contratual") ///
					  (80 = 80 "Aposentadoria especial, sem rescisao contratual"), pre(n) label(causadesli)
	drop causadesli
	ren ncausadesli cause_separation
	la var cause_separation "Separation Cause"
	
	cap ren tipoadm type_admission
	cap la var type_admission "Admission Type"
	
	cap ren horascontr hours
	cap la var hours "Hours Hired"
	
	cap ren tiposal type_wage
	cap la var type_wage "Wage Type"
	
	cap ren salcontr hired_wage
	cap la var hired_wage "Wage Hired"
	
	cap ren ultrem last_wage
	cap la var last_wage "Last Wage"
	
	cap ren tempempr time_emp
	cap la var time_emp "Time Employed"
	
	cap drop dtadmissao
	cap drop mesadmissao
	cap drop mesdesli
	
	
	//save "tmp/`year'_job.dta", replace
	
	//-------------------------//
	// wage variables
	//-------------------------//
	
	//foreach k of numlist 0/15 {
		
	//	use "tmp/`year'_job.dta" if type_admission == `k', clear
		
	merge m:1 year using "tmp/minimum_wage.dta", keep(1 3) nogenerate
	merge m:1 year using "tmp/inflation.dta",    keep(1 3) nogenerate
	
	gen wage_avg = remmedia * minimum_wage_nom		// using minimum wage data to inpute missing values for year<=1998
	la var wage_avg "Monthly Wage (R$)"				// generates some noise from original remmedr variable
	
	gen wage_dec = remdezembro * minimum_wage_nom	// using minimum wage data to inpute missing values for year<=1998
	la var wage_dec "December Wage (R$)"			// generates some noise from original remmedr variable
	
	gen wage_total = n_months * wage_avg
	la var wage_total "Total Yearly Wage (R$)"
	
	if `year' >= 1994 {
		
		gen wage_avg_def = wage_avg / price_index_b2018
		la var wage_avg_def "Monthly Wage (R$ 2018)"
		
		gen wage_dec_def = wage_dec / price_index_b2018
		la var wage_dec_def "December Wage (R$ 2018)"
		
		gen wage_total_def = wage_total / price_index_b2018
		la var wage_total_def "Total Yearly Wage (R$ 2018)"
		
	}
	*
	
	cap drop remdezembro remmedia
	cap drop remdezr remmedr 
	drop minimum_wage_* price_index_b2018
	
	//-------------------------//
	// occupation dummies
	//-------------------------//
	
	cap ren ocupacao94	CBO1994
	cap ren ocup2002	CBO2002
	
	foreach y in 1994 2002 {
		cap gen CBO`y' = ""
		cap replace CBO`y' = subinstr(CBO`y', "CBO", "", .)
		cap replace CBO`y' = "" if CBO`y' == "000-1" | CBO`y' == "IGNORADO"
		cap replace CBO`y' = trim(CBO`y')
	}
	order CBO1994, b(CBO2002)
	order CBO2002, a(CBO1994)
	
	if `year' <= 2002 {
		merge m:1 CBO1994 using "tmp/CBO1994_dummies.dta", keep(1 3) nogenerate
	}
	else {
		merge m:1 CBO2002 using "tmp/CBO2002_dummies.dta", keep(1 3) nogenerate
	}
	
	
	//save "tmp/`year'_job_`k'.dta", replace
	
	//}
	
	
	//use "tmp/`year'_job_0.dta", clear
	//foreach k of numlist 1/15 {
	//	append using "tmp/`year'_job_`k'.dta"
	//}
	
	order `IDs' year
	
	if "`SAMPLE'" == "TRUE" {
		save "output/data/identified/normalized_sample`SAMPLE_SIZE'/job/`year'.dta", replace
	}
	else {
		save "output/data/identified/normalized/job/`year'.dta", replace
	}
	*
	
	//------------------------------------//
	// worker
	//------------------------------------//
	
	if "`SAMPLE'" == "TRUE" {
		!mkdir "output/data/identified/normalized_sample`SAMPLE_SIZE'/worker"
		use "output/data/identified/full_sample`SAMPLE_SIZE'/`year'.dta"
	}
	else {
		!mkdir "output/data/identified/normalized/worker"
		use "output/data/identified/full/`year'.dta", clear
	}
	*
	
	    ren PIS       id_worker_PIS
	cap ren CPF		  id_worker_CPF
	    ren municipio id_municipality_6
	
	if `year' >= 1985 & `year' <= 2001 local IDs id_worker_PIS				 id_municipality_6
	if `year' >= 2002 & `year' <= 2018 local IDs id_worker_PIS id_worker_CPF id_municipality_6
	
	if (`year' >= 1994 & `year' <= 2001) | (`year' >= 2011 & `year' <= 2018)	local age_var idade
	if (`year' >= 2002 & `year' <= 2010)										local age_var dtnascimento
	
	if `year' >= 1985 & `year' <= 1993 local vars grinstrucao genero nacionalidad
	if `year' >= 1994 & `year' <= 2001 local vars grinstrucao genero nacionalidad `age_var'
	if `year' >= 2002 & `year' <= 2002 local vars grinstrucao genero nacionalidad `age_var' numectps nome
	if `year' >= 2003 & `year' <= 2005 local vars grinstrucao genero nacionalidad `age_var' numectps nome raca_cor portdefic
	if `year' >= 2006 & `year' <= 2018 local vars grinstrucao genero nacionalidad `age_var' numectps nome raca_cor portdefic tpdef
	
	keep `IDs' `vars'
	
	duplicates drop
	
	// cleaning observations that (1) have missing ID info or (2) are duplicates.
	drop if id_worker_PIS == "0" | id_worker_PIS == "00000000000"
	duplicates tag id_worker_PIS id_municipality_6, gen(dup)
	drop if dup > 0
	drop dup
	
	gen year = `year'
	la var year "Year"
	
	if (`year' >= 2002 & `year' <= 2010) {
		
		gen aux_nasc = date(dtnascimento, "DMY")
		format aux_nasc %td
		
		gen aux_`year' = date("3112`year'", "DMY")
		format aux_`year' %td
		
		gen idade = round((aux_`year' - aux_nasc) / 365.25)
		
		drop dtnascimento aux*
		
	}
	*
	
	cap ren grinstrucao education
	cap la var education "Education Level"
	
	cap ren genero gender
	cap la var gender "Gender"
	
	cap ren nacionalidad nationality
	cap la var nationality "Nationality"
	
	cap ren idade age
	cap la var age "Age"
	
	cap ren numectps id_worker_CTPS
	cap la var id_worker_CTPS "ID Worker - CTPS"
	
	cap ren nome name
	cap la var name "Name"
	
	cap ren raca_cor race
	cap la var race "Race"
	
	cap ren portdefic has_disability
	cap la var has_disability "Has Disability"
	
	cap ren tpdefic disability
	cap la var disability "Disability"
	
	order `IDs' year
	
	if "`SAMPLE'" == "TRUE" {
		save "output/data/identified/normalized_sample`SAMPLE_SIZE'/worker/`year'.dta", replace
	}
	else {
		save "output/data/identified/normalized/worker/`year'.dta", replace
	}
	*
	
	//------------------------------------//
	// establishment
	//------------------------------------//
	
	if "`SAMPLE'" == "TRUE" {
		!mkdir "output/data/identified/normalized_sample`SAMPLE_SIZE'/establishment"
		use "output/data/identified/full_sample`SAMPLE_SIZE'/`year'.dta"
	}
	else {
		!mkdir "output/data/identified/normalized/establishment"
		use "output/data/identified/full/`year'.dta", clear
	}
	*
	
	ren identificad	id_establishment
	ren radiccnpj	id_firm
	ren municipio	id_municipality_6
	
	local IDs id_establishment id_firm id_municipality_6
	
	if `year' >= 1985 & `year' <= 1994 local vars tamestab tipoestbl
	if `year' >= 1995 & `year' <= 1998 local vars tamestab tipoestbl clascnae95 natjuridica				// ATTENTION: dropping variables which vary within id_establishment-year level. [generating duplicates]
	if `year' >= 1999 & `year' <= 2002 local vars tamestab tipoestbl clascnae95 natjuridica				// indceivinc ceivinc
	if `year' >= 2003 & `year' <= 2005 local vars tamestab tipoestbl clascnae95 natjuridica				// indceivinc ceivinc ocup2002
	if `year' >= 2006 & `year' <= 2018 local vars tamestab tipoestbl  	    	natjuridica clascnae20	// indceivinc ceivinc
	
	keep `IDs' `vars'
	
	duplicates drop
	
	// cleaning observations that (1) have missing ID info or (2) are duplicates.
	drop if id_establishment == "00000000000000"
	duplicates tag id_establishment id_municipality_6, gen(dup)
	drop if dup > 0
	drop dup
	
	gen year = `year'
	la var year "Year"
	
	cap ren tamestab size
	cap la var size "Establishment Size"
	
	cap ren tipoestbl type
	cap la var type "Establishment Type"
	
	cap ren natjuridica legal_nature
	cap la var legal_nature "Legal Nature"
	
	//-------------------------//
	// establishment's sector
	//-------------------------//
	
	cap ren clascnae95 CNAE1	// years 1995-2005
	cap ren clascnae20 CNAE2	// years 2006+
	foreach y in 1 2 {
		cap gen CNAE`y' = ""
		cap replace CNAE`y' = subinstr(CNAE`y', "CLASSE ", "", .)
		cap replace CNAE`y' = trim(CNAE`y')
	}
	order CNAE1, b(CNAE2)
	order CNAE2, a(CNAE1)
	
	estab_sector `year'
		
	order sector_IBGE sector, a(CNAE2)
	
	if `year' >= 1995 {
		
		//-------------------------//
		// types of establishment
		//-------------------------//
		
		gen public =	inlist(legal_nature, 1015, 1023, 1031, 1040, 1058, 1066, 1074, 1082, 1104, 1112) | ///
						inlist(legal_nature, 1120, 1139, 1147, 1155, 1163, 1171, 1180, 1198, 1210, 1228) | ///
						inlist(legal_nature, 1236, 1244, 1252, 1260, 1279, 1287, 1295, 1309, 1317, 1325) | ///
						inlist(legal_nature, 1333, 1341)
		la var public "Public"
		
		gen public_federal = inlist(legal_nature, 1015, 1040, 1074, 1104, 1139, 1163, 1252, 1287, 1317, 1341)
		la var public_federal "Public Federal"
		
		gen public_state = inlist(legal_nature, 1023, 1058, 1082, 1112, 1147, 1171, 1236, 1260, 1295, 1325)
		la var public_state "Public State"
		
		gen public_municipal = inlist(legal_nature, 1031, 1066, 1120, 1155, 1180, 1244, 1279, 1309, 1333)
		la var public_municipal "Public Municipal"
		
		gen public_exec = inlist(legal_nature, 1015, 1023, 1031)
		la var public_exec "Public Executive"
		
		gen public_leg = inlist(legal_nature, 1040, 1058, 1066)
		la var public_leg "Public Legislative"
		
		gen public_jud = inlist(legal_nature, 1074, 1082, 1120)
		la var public_jud "Public Judiciary"
		
		gen company =	inlist(legal_nature, 2011, 2038, 2046, 2054, 2062, 2070, 2089, 2097, 2127, 2135) | ///
						inlist(legal_nature, 2143, 2151, 2160, 2178, 2194, 2216, 2224, 2232, 2240, 2259) | ///
						inlist(legal_nature, 2267, 2275, 2283, 2291, 2305, 2313, 2321, 2330)
		la var company "Company"
		
		gen company_public = inlist(legal_nature, 2011)
		la var company_public "Public Company"
		
		gen nonprofit =	inlist(legal_nature, 3034, 3069, 3077, 3085, 3107, 3115, 3131, 3204, 3212, 3220) | ///
						inlist(legal_nature, 3239, 3247, 3255, 3263, 3271, 3280, 3298, 3301, 3310, 3999)
		la var nonprofit "Non-Profit"
		
	}
	*
	
	order `IDs' year
	
	if "`SAMPLE'" == "TRUE" {
		save "output/data/identified/normalized_sample`SAMPLE_SIZE'/establishment/`year'.dta", replace
	}
	else {
		save "output/data/identified/normalized/establishment/`year'.dta", replace
	}
	*
	
}
*

/*
//----------------------------------------------------------------------------//
// reconstructs CPF backwards (for before 2003)
//----------------------------------------------------------------------------//

// goal: leave CPF empty for any PIS which is part of duplicate PIS-CPF node

//---------------------------------//
// select unique PIS-CPF pairs
//---------------------------------//

foreach year of numlist 2003(1)`LAST_YEAR' {
	
	use "output/data/identified/normalized/worker/`year'.dta", clear
	keep id_worker_PIS id_worker_CPF
	save "tmp/mapping_PIS_CPF_`year'.dta", replace
}
*

use "tmp/mapping_PIS_CPF_2003.dta", clear
foreach year of numlist 2004(1)`LAST_YEAR' {
	append using "tmp/mapping_PIS_CPF_`year'.dta"
}
*

keep if id_worker_CPF != ""

duplicates drop
duplicates tag id_worker_PIS, gen(dup_PIS)
duplicates tag id_worker_CPF, gen(dup_CPF)
drop if dup_PIS > 0 | dup_CPF > 0
drop dup_*

save "tmp/mapping_PIS_CPF.dta", replace

//foreach year of numlist 2003(1)`LAST_YEAR' {
//	erase "tmp/mapping_PIS_CPF_`year'.dta"
//}
*/
//---------------------------------//
// add/replace CPF into yearly data
//---------------------------------//

foreach year of numlist `FIRST_YEAR'(1)2002 {
	
	foreach k in job worker {
		
		if "`SAMPLE'" == "TRUE"	 use "output/data/identified/normalized_sample`SAMPLE_SIZE'/`k'/`year'.dta", clear
		if "`SAMPLE'" == "FALSE" use "output/data/identified/normalized/`k'/`year'.dta", clear
		
		cap drop id_worker_CPF
		
		merge m:1 id_worker_PIS using "tmp/mapping_PIS_CPF.dta", keep(1 3)
		drop if _merge == 2
		drop _merge

		order id_worker_CPF, a(id_worker_PIS)
		
		if "`SAMPLE'" == "TRUE"	 save "output/data/identified/normalized_sample`SAMPLE_SIZE'/`k'/`year'.dta", replace
		if "`SAMPLE'" == "FALSE" save "output/data/identified/normalized/`k'/`year'.dta", replace
		
	}
}
*

/*
//----------------------------------------------------------------------------//
// appends and save
//----------------------------------------------------------------------------//

if "`SAMPLE'" == "TRUE" {

	foreach k in job establishment worker {
		
		use "output/data/identified/normalized_sample`SAMPLE_SIZE'/`k'/`FIRST_YEAR'.dta", clear
		
		foreach year of numlist `SECOND_YEAR'(1)`LAST_YEAR' {
			append using "output/data/identified/normalized_sample`SAMPLE_SIZE'/`k'/`year'.dta"
		}
		*
		
		if "`k'" == "job"			local IDs id_worker_PIS id_worker_CPF id_establishment id_municipality_6
		if "`k'" == "establishment"	local IDs                             id_establishment id_municipality_6
		if "`k'" == "worker"		local IDs id_worker_PIS id_worker_CPF                  id_municipality_6
		
		sort `IDs' year
		
		cap drop aux*
		
		compress
		
		save "output/data/identified/normalized_sample`SAMPLE_SIZE'/`k'/`FIRST_YEAR'-`LAST_YEAR'.dta", replace
		
	}
}
*/
