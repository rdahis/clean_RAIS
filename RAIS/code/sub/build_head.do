
//----------------------------------------------------------------------------//
// build: fake/sample RAIS data
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "F://data/rais"

foreach year of numlist 1985(1)2018 {
	
	foreach k in establishment worker job {
		
		use "output/data/identified/normalized/`k'/`year'.dta" if _n <= 1000, clear
		save "output/data/identified/normalized_head/`k'/`year'.dta", replace
		
	}
}
