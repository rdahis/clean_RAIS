
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "/path/RAIS"

local SAMPLE		FALSE
local SAMPLE_SIZE	5

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//------------------------------//
// dictionary clascnae95
//------------------------------//

import excel "extra/Variables_RAIS_1985-2018.xlsx", clear sheet("clascnae95")

drop in 1
drop in 615/620

split A, parse(":") destring
ren A1 clascnae95
gen clascnae95_name = A2 + A3
drop A A2 A3

save "tmp/clascnae95_dict.dta", replace

//------------------------------//
// mapping cnae 1.0 to cnae 2.0
//------------------------------//

import excel "extra/mappings/CNAE20_Correspondencia10x20.xls", clear sheet("CNAE 1.0 x CNAE 2")

drop in 1/8

keep B D

ren B cnae1
ren D cnae2

la var cnae1 "CNAE 1.0"
la var cnae2 "CNAE 2.0"

replace cnae1 = subinstr(cnae1, ".", "", .)
replace cnae1 = subinstr(cnae1, "-", "", .)
replace cnae2 = subinstr(cnae2, ".", "", .)
replace cnae2 = subinstr(cnae2, "-", "", .)

destring, replace force

drop if cnae1 == .

duplicates drop	// OBS: it's m:m

save "tmp/cnae1_to_cnae2.dta", replace

//------------------------------//
// mapping cnae 1.0 to sectors
//------------------------------//

import excel "extra/mappings/CNAE20_Correspondencia10x20.xls", clear sheet("CNAE 1.0 x CNAE 2")

drop in 1/8

keep B

ren B cnae1

gen sector1 = ""
replace sector1 = "A" if inlist(substr(cnae1, 1, 2), "01", "02")
replace sector1 = "B" if inlist(substr(cnae1, 1, 2), "05")
replace sector1 = "C" if inlist(substr(cnae1, 1, 2), "10", "11", "13", "14")
replace sector1 = "D" if inlist(substr(cnae1, 1, 2), "15", "16", "17", "18", "19", "20", "21", "22", "23") | ///
						 inlist(substr(cnae1, 1, 2), "24", "25", "26", "27", "28", "29", "30", "31", "32") | ///
						 inlist(substr(cnae1, 1, 2), "33", "34", "35", "36", "37")
replace sector1 = "E" if inlist(substr(cnae1, 1, 2), "40", "41")
replace sector1 = "F" if inlist(substr(cnae1, 1, 2), "45")
replace sector1 = "G" if inlist(substr(cnae1, 1, 2), "50", "51", "52")
replace sector1 = "H" if inlist(substr(cnae1, 1, 2), "55")
replace sector1 = "I" if inlist(substr(cnae1, 1, 2), "60", "61", "62", "63", "64")
replace sector1 = "J" if inlist(substr(cnae1, 1, 2), "65", "66", "67")
replace sector1 = "K" if inlist(substr(cnae1, 1, 2), "70", "71", "72", "73", "74")
replace sector1 = "L" if inlist(substr(cnae1, 1, 2), "75")
replace sector1 = "M" if inlist(substr(cnae1, 1, 2), "80")
replace sector1 = "N" if inlist(substr(cnae1, 1, 2), "85")
replace sector1 = "O" if inlist(substr(cnae1, 1, 2), "90", "91", "92", "93")
replace sector1 = "P" if inlist(substr(cnae1, 1, 2), "95")
replace sector1 = "Q" if inlist(substr(cnae1, 1, 2), "99")
la var sector1 "Economic Sector 1.0 (IBGE)"

la var cnae1 "CNAE 1.0"

replace cnae1 = subinstr(cnae1, ".", "", .)
replace cnae1 = subinstr(cnae1, "-", "", .)

destring cnae1, replace force

drop if cnae1 == .

duplicates drop

save "tmp/cnae1_to_sector.dta", replace

//------------------------------//
// mapping cnae 2.0 to sectors
//------------------------------//

import excel "extra/mappings/CNAE20_Correspondencia20x10.xls", clear sheet("CNAE 2.0 x CNAE 1.0")

drop in 1/12

keep B

ren B cnae2

gen sector2 = ""
replace sector2 = "A" if inlist(substr(cnae2, 1, 2), "01", "02", "03")
replace sector2 = "B" if inlist(substr(cnae2, 1, 2), "05", "06", "07", "08", "09")
replace sector2 = "C" if inlist(substr(cnae2, 1, 2), "10", "11", "13", "14", "15", "16", "17", "18", "19") | ///
						 inlist(substr(cnae2, 1, 2), "20", "21", "22", "23", "24", "25", "26", "27", "28") | ///
						 inlist(substr(cnae2, 1, 2), "29", "30", "31", "32", "33")
replace sector2 = "D" if inlist(substr(cnae2, 1, 2), "35")
replace sector2 = "E" if inlist(substr(cnae2, 1, 2), "36", "37", "38", "39")
replace sector2 = "F" if inlist(substr(cnae2, 1, 2), "41", "42", "43")
replace sector2 = "G" if inlist(substr(cnae2, 1, 2), "45", "46", "47")
replace sector2 = "H" if inlist(substr(cnae2, 1, 2), "49", "50", "51", "52", "53")
replace sector2 = "I" if inlist(substr(cnae2, 1, 2), "55", "56")
replace sector2 = "J" if inlist(substr(cnae2, 1, 2), "58", "59", "60", "61", "62", "63")
replace sector2 = "K" if inlist(substr(cnae2, 1, 2), "64", "65", "66")
replace sector2 = "L" if inlist(substr(cnae2, 1, 2), "68")
replace sector2 = "M" if inlist(substr(cnae2, 1, 2), "69", "70", "71", "72", "73", "74", "75")
replace sector2 = "N" if inlist(substr(cnae2, 1, 2), "77", "78", "79", "80", "81", "82")
replace sector2 = "O" if inlist(substr(cnae2, 1, 2), "84")
replace sector2 = "P" if inlist(substr(cnae2, 1, 2), "85")
replace sector2 = "Q" if inlist(substr(cnae2, 1, 2), "86", "87", "88")
replace sector2 = "R" if inlist(substr(cnae2, 1, 2), "90", "91", "92", "93")
replace sector2 = "S" if inlist(substr(cnae2, 1, 2), "94", "95", "96")
replace sector2 = "T" if inlist(substr(cnae2, 1, 2), "97")
replace sector2 = "U" if inlist(substr(cnae2, 1, 2), "99")
la var sector2 "Economic Sector 2.0 (IBGE)"

la var cnae2 "CNAE 2.0"

replace cnae2 = subinstr(cnae2, ".", "", .)
replace cnae2 = subinstr(cnae2, "-", "", .)

destring cnae2, replace force

drop if cnae2 == .

duplicates drop

save "tmp/cnae2_to_sector.dta", replace


//------------------------------//
// unifying sectors
//------------------------------//

cap drop program estab_sector
program estab_sector
	
	local sector	`1'
	local year		`2'
	
	gen sector = ""
	
	if `year' >= 1995 & `year' <= 2005 {
		
		replace sector = "agriculture"											if `sector' == "A"
		replace sector = "fishing"												if `sector' == "B"
		replace sector = "extractive industry" 									if `sector' == "C"
		replace sector = "transformation industry"								if `sector' == "D"
		replace sector = "electricity, gas, or water"							if `sector' == "E"
		replace sector = "construction"											if `sector' == "F"
		replace sector = "commerce: vehicles, home objects"						if `sector' == "G"
		replace sector = "lodging and food"										if `sector' == "H"
		replace sector = "transportation, storage and communication"			if `sector' == "I"
		replace sector = "finance"												if `sector' == "J"
		replace sector = "real estate"											if `sector' == "K"
		replace sector = "public administration, defense, or social security"	if `sector' == "L"
		replace sector = "education"											if `sector' == "M"
		replace sector = "health or social services"							if `sector' == "N"
		replace sector = "other social services"								if `sector' == "O"
		replace sector = "domestic services"									if `sector' == "P"
		replace sector = "international organizations"							if `sector' == "Q"
		
	}
	else if `year' >= 2006 & `year' <= 2018 {
		
		replace sector = "agriculture" 											if `sector' == "A"
		replace sector = "extractive industry"									if `sector' == "B"
		replace sector = "transformation industry"								if `sector' == "C"
		replace sector = "electricity, gas, or water"							if `sector' == "D"
		replace sector = "electricity, gas, or water"							if `sector' == "E"
		replace sector = "construction"											if `sector' == "F"
		replace sector = "commerce: vehicles, home objects"						if `sector' == "G"
		replace sector = "transportation, storage and communication"			if `sector' == "H"
		replace sector = "lodging and food"										if `sector' == "I"
		replace sector = "information or communication"							if `sector' == "J"
		replace sector = "finance"												if `sector' == "K"
		replace sector = "real estate"											if `sector' == "L"
		replace sector = "clerical, science or technical"						if `sector' == "M"
		replace sector = "administrative"										if `sector' == "N"
		replace sector = "public administration, defense, or social security"	if `sector' == "O"
		replace sector = "education"											if `sector' == "P"
		replace sector = "health or social services"							if `sector' == "Q"
		replace sector = "arts, culture or sports"								if `sector' == "R"
		replace sector = "other services"										if `sector' == "S"
		replace sector = "domestic services"									if `sector' == "T"
		replace sector = "international organizations"							if `sector' == "U"
		
	}
	*
	
	la define la_sector	1 "agriculture" ///
						2 "extractive industry" ///
						3 "transformation industry" ///
						4 "electricity, gas, or water" ///
						5 "construction" ///
						6 "commerce: vehicles, home objects" ///
						7 "transportation, storage and communication" ///
						8 "lodging and food" ///
						9 "information or communication" ///
						10 "finance" ///
						11 "real estate" ///
						12 "clerical, science or technical" ///
						13 "administrative" ///
						14 "public administration, defense, or social security" ///
						15 "education" ///
						16 "health or social services" ///
						17 "arts, culture or sports" ///
						18 "other services" ///
						19 "domestic services" ///
						20 "international organizations", ///
		replace
	
	encode sector, generate(enc_sector) la(la_sector)
	drop sector
	ren enc_sector sector
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
replace CBO1994 = subinstr(CBO1994, "-", "", .)
replace CBO1994 = subinstr(CBO1994, ".", "", .)

drop if CBO1994 == ""

destring, replace

duplicates drop CBO1994, force

save "tmp/CBO1994_to_CBO2002.dta", replace


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

foreach year of numlist 1985(1)2018 {
	
	//------------------------------------------------------------------------//
	// cleaning
	//------------------------------------------------------------------------//
	
	use "output/data/full/RAIS_`year'.dta", clear
	
	ren PIS			id_worker_PIS
	ren identificad	id_estab
	ren radiccnpj	id_firm
	ren municipio	id_munic_6
	
	replace id_worker_PIS = trim(id_worker_PIS)
	
	if `year' >= 2002 & `year' <= 2018 {
		
		ren CPF id_worker_CPF
		replace id_worker_CPF = trim(id_worker_CPF)
		replace id_worker_CPF = "00000"		+ id_worker_CPF if length(id_worker_CPF) == 6
		replace id_worker_CPF = "0000"		+ id_worker_CPF if length(id_worker_CPF) == 7
		replace id_worker_CPF = "000"		+ id_worker_CPF if length(id_worker_CPF) == 8
		replace id_worker_CPF = "00"		+ id_worker_CPF if length(id_worker_CPF) == 9
		replace id_worker_CPF = "0"			+ id_worker_CPF if length(id_worker_CPF) == 10
		replace id_worker_CPF = "" 			if length(id_worker_CPF) <= 5
		
		replace nome = trim(nome)
		
	}
	*
	
	replace id_estab = trim(id_estab)
	replace id_firm	 = trim(id_firm)
	replace id_estab = "00000000000"	+ id_estab if length(id_estab) == 3
	replace id_estab = "0000000000"		+ id_estab if length(id_estab) == 4
	replace id_estab = "000000000"		+ id_estab if length(id_estab) == 5
	replace id_estab = "00000000"		+ id_estab if length(id_estab) == 6
	replace id_estab = "0000000"		+ id_estab if length(id_estab) == 7
	replace id_estab = "000000"			+ id_estab if length(id_estab) == 8
	replace id_estab = "00000"			+ id_estab if length(id_estab) == 9
	replace id_estab = "0000"			+ id_estab if length(id_estab) == 10
	replace id_estab = "000"			+ id_estab if length(id_estab) == 11
	replace id_estab = "00"				+ id_estab if length(id_estab) == 12
	replace id_estab = "0"				+ id_estab if length(id_estab) == 13
	
	replace id_firm = "" if id_firm == "0"
	
	cap ren ocupacao94	CBO1994
	cap ren ocup2002	CBO2002
	
	if "`SAMPLE'" == "TRUE" {
		sample `SAMPLE_SIZE', by(id_munic_6)
		save "output/data/samples/RAIS_sample`SAMPLE_SIZE'_`year'.dta", replace
	}
	else {
		save "output/data/clean/RAIS_`year'_clean.dta", replace
	}
	*
	
	//------------------------------------------------------------------------//
	// normalized
	//------------------------------------------------------------------------//
	
	//------------------------------------//
	// worker-estab-munic
	//------------------------------------//
	
	if "`SAMPLE'" == "TRUE" {
		use "output/data/samples/RAIS_sample`SAMPLE_SIZE'_`year'.dta"
	}
	else {
		use "output/data/clean/RAIS_`year'_clean.dta", clear
	}
	*
	
	if `year' >= 1985 & `year' <= 2001 local IDs id_worker_PIS    			 id_estab id_munic_6
	if `year' >= 2002 & `year' <= 2018 local IDs id_worker_PIS id_worker_CPF id_estab id_munic_6
	
	if `year' >= 1994 & `year' <= 2018 & `year' != 2002	local tipoadm tipoadm
	if `year' == 2002									local tipoadm
	
	if `year' >= 1985 & `year' <= 1993 local vars empem3112 tpvinculo			mesadmissao causadesli mesdesli CBO1994			remdezembro remmedia				 tempempr
	if `year' >= 1994 & `year' <= 1998 local vars empem3112 tpvinculo `tipoadm' mesadmissao causadesli mesdesli CBO1994			remdezembro remmedia				 tempempr horascontr
	if `year' >= 1999 & `year' <= 2001 local vars empem3112 tpvinculo `tipoadm' mesadmissao causadesli mesdesli CBO1994			remdezembro remmedia remdezr remmedr tempempr horascontr
	if `year' == 2002				   local vars empem3112 tpvinculo `tipoadm' dtadmissao  causadesli mesdesli CBO1994			remdezembro remmedia remdezr remmedr tempempr horascontr tiposal salcontr ultrem
	if `year' >= 2003 & `year' <= 2009 local vars empem3112 tpvinculo `tipoadm' dtadmissao  causadesli mesdesli CBO1994 CBO2002 remdezembro remmedia remdezr remmedr tempempr horascontr tiposal salcontr ultrem
	if `year' >= 2010 & `year' <= 2018 local vars empem3112 tpvinculo `tipoadm' dtadmissao  causadesli mesdesli 		CBO2002 remdezembro remmedia remdezr remmedr tempempr horascontr tiposal salcontr ultrem
	
	keep `IDs' `vars'
	
	duplicates drop
	
	// cleaning observations that (1) have missing ID info or (2) are duplicates.
	drop if id_worker_PIS == "0" | id_worker_PIS == "00000000000"
	duplicates tag id_worker_PIS id_estab id_munic_6, gen(dup)
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
	
	gen n_months = .
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
	
	//-------------------------//
	// wage variables
	//-------------------------//
	
	merge m:1 year using "tmp/minimum_wage.dta"
	drop if _merge == 2
	drop _merge
	
	merge m:1 year using "tmp/inflation.dta"
	drop if _merge == 2
	drop _merge
	
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
	// job categories
	//-------------------------//
	
	if `year' >= 1985 & `year' <= 2002 {
		
		merge m:1 CBO1994 using "tmp/CBO1994_to_CBO2002.dta" // "tmp/CBO1994_categories.dta"
		drop if _merge == 2
		drop _merge
		
	}
	*
	
	gen occup_cat = .
	replace occup_cat = 0 if length(string(CBO2002)) == 5
	replace occup_cat = real(substr(string(CBO2002), 1, 1)) if length(string(CBO2002)) == 6
	la var occup_cat "Occupation Category (CBO2002)"
	
	order occup_cat, a(CBO2002)
	
	la define la_occup_cat	0 "military or police" ///
							1 "manager or upper politician" ///
							2 "professional: science and arts" ///
							3 "technician: mid-level" ///
							4 "worker: clerical" ///
							5 "worker: services or sales" ///
							6 "worker: agriculture, forestry or fishing" ///
							7 "worker: industry" ///
							8 "worker: industry" ///
							9 "worker: repair or maintenance", replace
	la val occup_cat la_occup_cat
	
	//-------------------------//
	// types of job
	//-------------------------//
	
	if `year' >= 1995 {
	
		gen job_public = inlist(type_contract, 30, 31, 35)
		la var job_public "Public Job"
		
		gen job_public_com = (type_contract == 35)		// still not sure this is the correct/best classification
		la var job_public_com "Comissioned Public Job"
		
	}
	*
	
	order `IDs' year
	
	if "`SAMPLE'" == "TRUE" {
		save "output/data/normalized/worker_estab_munic/RAIS_sample`SAMPLE_SIZE'_`year'_normalized_worker_estab_munic.dta", replace
	}
	else {
		save "output/data/normalized/worker_estab_munic/RAIS_`year'_normalized_worker_estab_munic.dta", replace
	}
	*
	
	//------------------------------------//
	// worker-munic
	//------------------------------------//
	
	if "`SAMPLE'" == "TRUE" {
		use "output/data/samples/RAIS_sample`SAMPLE_SIZE'_`year'.dta"
	}
	else {
		use "output/data/clean/RAIS_`year'_clean.dta", clear
	}
	*
	
	if `year' >= 1985 & `year' <= 2001 local IDs id_worker_PIS				 id_munic_6
	if `year' >= 2002 & `year' <= 2018 local IDs id_worker_PIS id_worker_CPF id_munic_6
	
	if (`year' >= 1994 & `year' <= 2001) | (`year' >= 2011 & `year' <= 2018)	local age_var idade
	if (`year' >= 2002 & `year' <= 2010)										local age_var dtnascimento
	
	if `year' >= 1985 & `year' <= 1993 local vars grinstrucao genero nacionalidad
	if `year' >= 1994 & `year' <= 2001 local vars grinstrucao genero nacionalidad `age_var'
	if `year' >= 2002 & `year' <= 2002 local vars grinstrucao genero nacionalidad `age_var' numectps nome
	if `year' >= 2003 & `year' <= 2005 local vars grinstrucao genero nacionalidad `age_var' numectps nome raca_cor portdefic
	if `year' >= 2006 & `year' <= 2018 local vars grinstrucao genero nacionalidad `age_var' numectps nome raca_cor portdefic tpdef
	
	keep `IDs' `vars'
	
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
	
	duplicates drop
	
	// cleaning observations that (1) have missing ID info or (2) are duplicates.
	drop if id_worker_PIS == "0" | id_worker_PIS == "00000000000"
	cap duplicates drop id_worker_PIS id_munic_6, force	// keeping a random observation
	
	gen year = `year'
	la var year "Year"
	
	order `IDs' year
	
	if "`SAMPLE'" == "TRUE" {
		save "output/data/normalized/worker_munic/RAIS_sample`SAMPLE_SIZE'_`year'_normalized_worker_munic.dta", replace
	}
	else {
		save "output/data/normalized/worker_munic/RAIS_`year'_normalized_worker_munic.dta", replace
	}
	*
	
	//------------------------------------//
	// estab-munic
	//------------------------------------//
	
	if "`SAMPLE'" == "TRUE" {
		use "output/data/samples/RAIS_sample`SAMPLE_SIZE'_`year'.dta"
	}
	else {
		use "output/data/clean/RAIS_`year'_clean.dta", clear
	}
	*
	
	local IDs id_estab id_firm id_munic_6
	
	if `year' >= 1985 & `year' <= 1994 local vars tamestab tipoestbl
	if `year' >= 1995 & `year' <= 1998 local vars tamestab tipoestbl clascnae95 natjuridica				// ATTENTION: dropping variables which vary within id_estab-year level. [generating duplicates]
	if `year' >= 1999 & `year' <= 2002 local vars tamestab tipoestbl clascnae95 natjuridica				// indceivinc ceivinc
	if `year' >= 2003 & `year' <= 2005 local vars tamestab tipoestbl clascnae95 natjuridica				// indceivinc ceivinc ocup2002
	if `year' >= 2006 & `year' <= 2018 local vars tamestab tipoestbl  	    	natjuridica clascnae20	// indceivinc ceivinc
	
	keep `IDs' `vars'
	
	cap ren tamestab size_estab
	cap la var size_estab "Establishment Size"
	
	cap ren tipoestbl type_estab
	cap la var type_estab "Establishment Type"
	
	cap ren natjuridica legal_nature
	cap la var legal_nature "Legal Nature"
	
	duplicates drop
	
	// cleaning observations that (1) have missing ID info or (2) are duplicates.
	drop if id_estab == "00000000000000"
	cap duplicates drop id_estab id_munic_6, force	// keeping a random observation
	
	gen year = `year'
	la var year "Year"
	
	//-------------------------//
	// establishment's sector
	//-------------------------//
	
	if `year' >= 1995 & `year' <= 2005 {
		
		gen cnae1 = clascnae95
		la var cnae1 "CNAE 1.0"
		
		merge m:1 cnae1 using "tmp/cnae1_to_sector.dta"
		drop if _merge == 2
		drop _merge
		
		estab_sector sector1 `year'
		
	}
	*
	
	if `year' >= 2006 & `year' <= 2018 {
		
		gen cnae2 = clascnae20
		la var cnae2 "CNAE 2.0"
		
		merge m:1 cnae2 using "tmp/cnae2_to_sector.dta"
		drop if _merge == 2
		drop _merge
		
		estab_sector sector2 `year'
		
	}
	*
	
	cap drop clascnae95
	cap drop clascnae20
	
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
		save "output/data/normalized/estab_munic/RAIS_sample`SAMPLE_SIZE'_`year'_normalized_estab_munic.dta", replace
	}
	else {
		save "output/data/normalized/estab_munic/RAIS_`year'_normalized_estab_munic.dta", replace
	}
	*
	
}
*

//----------------------------------------------------------------------------//
// reconstructs CPF backwards (for before 2003)
//----------------------------------------------------------------------------//

// goal: leave CPF empty for any PIS which is part of duplicate PIS-CPF node

//---------------------------------//
// select unique PIS-CPF pairs
//---------------------------------//

foreach year of numlist 2003(1)2018 {
	
	if "`SAMPLE'" == "TRUE" {
		use "output/data/normalized/worker_munic/RAIS_sample`SAMPLE_SIZE'_`year'_normalized_worker_munic.dta", clear
		keep id_worker_PIS id_worker_CPF
		save "tmp/mapping_PIS_CPF_`year'.dta", replace	
	}
	else {	
		use "output/data/normalized/worker_munic/RAIS_`year'_normalized_worker_munic.dta", clear
		keep id_worker_PIS id_worker_CPF
		save "tmp/mapping_PIS_CPF_`year'.dta", replace
	}
}
*

use "tmp/mapping_PIS_CPF_2003.dta", clear
foreach year of numlist 2004(1)2018 {
	append using "tmp/mapping_PIS_CPF_`year'.dta"
}
*

keep id_worker_PIS id_worker_CPF
duplicates drop

duplicates tag id_worker_PIS, gen(dup_PIS)
duplicates tag id_worker_CPF, gen(dup_CPF)

drop if dup_PIS > 0 | dup_CPF > 0
drop dup_*

save "tmp/mapping_PIS_CPF.dta", replace

//---------------------------------//
// add/replace CPF into yearly data
//---------------------------------//

foreach year of numlist 1985(1)2018 {
	
	foreach k in worker_estab_munic worker_munic {
		
		if "`SAMPLE'" == "TRUE"	 use "output/data/normalized/`k'/RAIS_sample`SAMPLE_SIZE'_`year'_normalized_`k'.dta", clear
		if "`SAMPLE'" == "FALSE" use "output/data/normalized/`k'/RAIS_`year'_normalized_`k'.dta", clear
		
		if `year' >= 2002 drop id_worker_CPF
		
		merge m:1 id_worker_PIS using "tmp/mapping_PIS_CPF.dta"
		drop if _merge == 2
		drop _merge

		order id_worker_CPF, a(id_worker_PIS)
		
		if "`SAMPLE'" == "TRUE"	 save "output/data/normalized/`k'/RAIS_sample`SAMPLE_SIZE'_`year'_normalized_`k'.dta", replace
		if "`SAMPLE'" == "FALSE" save "output/data/normalized/`k'/RAIS_`year'_normalized_`k'.dta", replace
		
	}
}
*

//----------------------------------------------------------------------------//
// appends and save
//----------------------------------------------------------------------------//

if "`SAMPLE'" == "TRUE" {

	foreach k in worker_estab_munic estab_munic worker_munic {
		
		use "output/data/normalized/`k'/RAIS_sample`SAMPLE_SIZE'_1985_normalized_`k'.dta", clear
		
		foreach year of numlist 1986(1)2018 {
			append using "output/data/normalized/`k'/RAIS_sample`SAMPLE_SIZE'_`year'_normalized_`k'.dta"
		}
		*
		
		if "`k'" == "worker_estab_munic"	local IDs id_worker_PIS id_worker_CPF id_estab id_munic_6
		if "`k'" == "estab_munic"			local IDs                             id_estab id_munic_6
		if "`k'" == "worker_munic"			local IDs id_worker_PIS id_worker_CPF          id_munic_6
		
		sort `IDs' year
		
		cap drop aux*
		
		compress
		
		save "output/data/normalized/RAIS_sample`SAMPLE_SIZE'_1985-2018_normalized_`k'.dta", replace
		
	}
}
*

//----------------------------------------------------------------------------//
// collapses to establishment-year level
//----------------------------------------------------------------------------//

if "`SAMPLE'" == "FALSE" {
	
	foreach year of numlist 1985(1)2018 {
		
		use "output/data/normalized/worker_estab_munic/RAIS_`year'_normalized_worker_estab_munic.dta", clear
		
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
	foreach year of numlist 1986(1)2018 {
		append using "output/data/collapsed/RAIS_`year'_collapsed_estab.dta"
	}
	*
	
	save "output/data/collapsed/RAIS_1985-2018_collapsed_estab.dta", replace
	
}
*

//----------------------------------------------------------------------------//
// collapses to establishment-munic-year level
//----------------------------------------------------------------------------//

if "`SAMPLE'" == "FALSE" {
	
	foreach year of numlist 1985(1)2018 {
		
		use "output/data/normalized/worker_estab_munic/RAIS_`year'_normalized_worker_estab_munic.dta", clear
		
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
		
		save "output/data/collapsed/RAIS_`year'_collapsed_estab_munic.dta", replace
	
	}
	*
	
	use "output/data/collapsed/RAIS_1985_collapsed_estab_munic.dta", clear
	foreach year of numlist 1986(1)2018 {
		append using "output/data/collapsed/RAIS_`year'_collapsed_estab_munic.dta"
	}
	*
	
	save "output/data/collapsed/RAIS_1985-2018_collapsed_estab_munic.dta", replace
	
}
*



