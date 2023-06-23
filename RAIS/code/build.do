
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "F://data/rais"

!mkdir "output/data/identified"
!mkdir "output/data/identified/full"
!mkdir "output/data/identified/normalized"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

foreach year of numlist 1985(1)2018 {
	do "code/sub/`year'.do"
}

do "code/sub/build_subsets.do"
