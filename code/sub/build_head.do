
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close

!mkdir "output/data/identified/normalized_head"

//----------------------------------------------------------------------------//
// build: head RAIS data
//----------------------------------------------------------------------------//

foreach year of numlist 1985(1)2018 {
	
	foreach k in establishment worker job {
		
		!mkdir "output/data/identified/normalized_head/`k'"
		
		use  "output/data/identified/normalized/`k'/`year'.dta" if _n <= 1000, clear
		save "output/data/identified/normalized_head/`k'/`year'.dta", replace
		
	}
}
