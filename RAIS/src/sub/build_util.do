
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

//cd "/Users/ricardodahis/Downloads/RAIS"
cd "/kellogg/proj/rdv438/RAIS"



//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

//------------------------------//
// clean variable id_estab
//------------------------------//

cap program drop clean_id_estab
program clean_id_estab
	
	replace id_estab = trim(id_estab)
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

end


//------------------------------//
// label variable values
//------------------------------//

cap program drop label_tamestab
program label_tamestab

	replace tamestab=0 if tamestab==1
	replace tamestab=1 if tamestab==2
	replace tamestab=2 if tamestab==3
	replace tamestab=3 if tamestab==4
	replace tamestab=4 if tamestab==5
	replace tamestab=5 if tamestab==6
	replace tamestab=6 if tamestab==7
	replace tamestab=7 if tamestab==8
	replace tamestab=8 if tamestab==9
	replace tamestab=9 if tamestab==10
	recode tamestab (0 = 0 "Zero") (1 = 1 "Ate 4") (2 = 2 "De 5 a 9") (3 = 3 "De 10 a 19") ///
					(4 = 4 "De 20 a 49") (5 = 5 "De 50 a 99") (6 = 6 "De 100 a 249") (7 = 7 "De 250 a 499") ///
					(8 = 8 "De 500 a 999") (9 = 9 "1000 ou mais"), pre(n)label(tamestab)
	drop tamestab
	ren ntamestab tamestab

end

cap program drop label_tipoestbl
program label_tipoestbl

	replace tipoestbl=9 if tipoestbl==4
	recode tipoestbl (1 = 1 "CNPJ") (3 = 3 "CEI") (9 = 9 "Nao Identificado"), pre(n)label(tipoestbl)
	drop tipoestbl
	ren ntipoestbl tipoestbl
	
end

cap program drop label_natjuridica
program label_natjuridica

	destring natjuridica, replace force
	recode natjuridica	(1015 = 1015 "POD EXEC FED") (1023 = 1023 "POD EXEC EST") ///
						(1031 = 1031 "POD EXEC MUN") (1040 = 1040 "POD LEG FED") ///
						(1058 = 1058 "POD LEG EST") (1066 = 1066 "POD LEG MUN") ///
						(1074 = 1074 "POD JUD FED") (1082 = 1082 "POD JUD EST") ///
						(1090 = 1090 "ORG AUT DPB") (1104 = 1104 "AUTARQ FED") ///
						(1112 = 1112 "AUTARQ EST") (1120 = 1120 "AUTARQ MUN") ///
						(1139 = 1139 "FUNDAC FED") (1147 = 1147 "FUNDAC EST") ///
						(1155 = 1155 "FUNDAC MUN") (1163 = 1163 "ORG AUT FED") ///
						(1171 = 1171 "ORG AUT EST") (1180 = 1180 "ORG AUT MUN") ///
						(1198 = 1198 "COM POLINAC") (1201 = 1201 "FUNDO PUBLIC") ///
						(1210 = 1210 "ASSOC PUBLIC") (2007 = 2007 "ADM PUB OUTR") ///
						(2011 = 2011 "EMP PUB") (2020 = 2020 "EMP PB SA CP") ///
						(2038 = 2038 "SOC MISTA") (2046 = 2046 "SA ABERTA") ///
						(2054 = 2054 "SA FECH") (2062 = 2062 "SOC QT LTDA") ///
						(2070 = 2070 "SOC COLETV") (2076 = 2076 "SOC COLETV07") ///
						(2089 = 2089 "SOC COMD SM") (2097 = 2097 "SOC COMD AC") ///
						(2100 = 2100 "SOC CAP IND") (2119 = 2119 "SOC CIVIL") ///
						(2127 = 2127 "SOC CTA PAR") (2135 = 2135 "FRM MER IND") ///
						(2143 = 2143 "COOPERATIVA") (2151 = 2151 "CONS EMPRES") ///
						(2160 = 2160 "GRUP SOC") (2178 = 2178 "FIL EMP EXT") ///
						(2194 = 2194 "FIL ARG-BRA") (2208 = 2208 "ENT ITAIPU") ///
						(2216 = 2216 "EMP DOM EXT") (2224 = 2224 "FUN INVEST") ///
						(2232 = 2232 "SOC SIMP PUR") (2240 = 2240 "SOC SIMP LTD") ///
						(2259 = 2259 "SOC SIMP COL") (2267 = 2267 "SOC SIMP COM") ///
						(2275 = 2275 "EMPR BINAC") (2283 = 2283 "CONS EMPREG") ///
						(2291 = 2291 "CONS SIMPLES") (2992 = 2992 "OUTR ORG EMP") ///
						(3018 = 3018 "FUND REC PRV") (3026 = 3026 "ASSOCIACAO") ///
						(3034 = 3034 "CARTORIO") (3042 = 3042 "ORG SOCIAL") ///
						(3050 = 3050 "OSCIP") (3069 = 3069 "OUT FUND PR") ///
						(3077 = 3077 "SERV SOC AU") (3085 = 3085 "CONDOMIN") ///
						(3093 = 3093 "UNID EXEC") (3107 = 3107 "COM CONC") ///
						(3115 = 3115 "ENT MED ARB") (3123 = 3123 "PART POLIT") ///
						(3130 = 3130 "ENT SOCIAL") (3131 = 3131 "ENT SOCIAL07") ///
						(3204 = 3204 "FIL FUN EXT") (3212 = 3212 "FUN DOM EXT") ///
						(3220 = 3220 "ORG RELIG") (3239 = 3239 "COMUN INDIG") ///
						(3247 = 3247 "FUNDO PRIVAD") (3999 = 3999 "OUTR ORG") ///
						(4014 = 4014 "EMP IND IMO") (4022 = 4022 "SEG ESPEC") ///
						(4030 = 4030 "AUTONOMO") (4049 = 4049 "AUTON C/ EMPR") ///
						(4057 = 4057 "EMPDOR DOM") (4065 = 4065 "CCIVIL PFIS") ///
						(4073 = 4073 "EMPRESARIO") (4080 = 4080 "CONTR IND") ///
						(4081 = 4081 "CONTR IND07") (4090 = 4090 "CAN CARG POL") ///
						(4111 = 4111 "LEILOEIRO") (4995 = 4995 "OUTR ORG") ///
						(5002 = 5002 "ORG INTERN") (5010 = 5010 "ORG INTERNAC") ///
						(5029 = 5029 "REPR DIPL ES") (5037 = 5037 "OUT INST EXT") ///
						(-1 = -1 "IGNORADO"), pre(n)label(natjuridica)
	drop natjuridica
	ren nnatjuridica natjuridica
	
end


cap program drop label_tpvinculo
program label_tpvinculo
	
	recode tpvinculo (10 = 10 "CLT U/PJ IND") (15 = 15 "CLT U/PF IND") (20 = 20 "CLT R/PJ IND") ///
					 (25 = 25 "CLT R/PF IND") (30 = 30 "ESTATUTARIO") (31 = 31 "ESTAT RGPS") ///
					 (35 = 35 "ESTAT N/EFET") (40 = 40 "AVULSO") (50 = 50 "TEMPORARIO") ///
					 (55 = 55 "APRENDIZ CONTR") (60 = 60 "CLT U/PJ DET") (65 = 65 "CLT U/PF DET") ///
					 (70 = 70 "CLT R/PJ DET") (75 = 75 "CLT R/PF DET") (80 = 80 "DIRETOR") ///
					 (90 = 90 "CONT PRZ DET") (95 = 95 "CONT TMP DET") (96 = 96 "CONT LEI EST") ///
					 (97 = 97 "CONT LEI MUN"), pre(n)label(tpvinculo)
	drop tpvinculo
	ren ntpvinculo tpvinculo
	
end


//------------------------------//
// dictionary clascnae95
//------------------------------//

import excel "extra/Variables_RAIS_2015.xlsx", clear sheet("clascnae95")

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
	
	if `year' >= 1995 & `year' <= 2009 {
		
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
		replace sector = "realty"												if `sector' == "K"
		replace sector = "public administration, defense, or social security"	if `sector' == "L"
		replace sector = "education"											if `sector' == "M"
		replace sector = "health or social services"							if `sector' == "N"
		replace sector = "other social services"								if `sector' == "O"
		replace sector = "domestic services"									if `sector' == "P"
		replace sector = "international organizations"							if `sector' == "Q"
		
	}
	else if `year' >= 2010 & `year' <= 2017 {
		
		replace sector = "agriculture" 											if `sector' == "A"
		replace sector = "extractive industry"									if `sector' == "B"
		replace sector = "transformation industry"								if `sector' == "C"
		replace sector = "electricity or gas"									if `sector' == "D"
		replace sector = "water"												if `sector' == "E"
		replace sector = "construction"											if `sector' == "F"
		replace sector = "commerce: vehicles"									if `sector' == "G"
		replace sector = "transportation or storage"							if `sector' == "H"
		replace sector = "lodging and food"										if `sector' == "I"
		replace sector = "information or communication"							if `sector' == "J"
		replace sector = "finance"												if `sector' == "K"
		replace sector = "realty"												if `sector' == "L"
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
	
	
end


cap program drop cnae2sector
program cnae2sector
	
	local year	`1'
	
	if `year' >= 1995 & `year' <= 2009 {
		
		gen cnae1 = clascnae95
		
		merge m:1 cnae1 using "tmp/cnae1_to_sector.dta"
		drop if _merge == 2
		drop _merge
		
		estab_sector sector1 `year'
		
	}
	*
	
	if `year' >= 2010 & `year' <= 2017 {
		
		gen cnae2 = .
		replace cnae2 = real(substr(string(sbclas20), 1, 4)) if length(string(sbclas20)) == 6
		replace cnae2 = real(substr(string(sbclas20), 1, 5)) if length(string(sbclas20)) == 7
		
		merge m:1 cnae2 using "tmp/cnae2_to_sector.dta"
		drop if _merge == 2
		drop _merge
		
		estab_sector sector2 `year'
		
	}
	*
	
	cap drop clascnae95
	cap drop clascnae20
	cap drop sbclas20
	
end







