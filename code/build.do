
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

global PATH <PATH> // substitute in your folder path

cd "${PATH}"

!mkdir "output/data/full"
!mkdir "output/data/normalized"
!mkdir "output/data/collapsed"

global FIRST_YEAR 1985
global LAST_YEAR  2020

global SECOND_YEAR = ${FIRST_YEAR} + 1

local FIRST_YEAR  ${FIRST_YEAR}
local SECOND_YEAR ${SECOND_YEAR}
local LAST_YEAR   ${LAST_YEAR}

global SAMPLE		FALSE // build a normalized sample? FALSE/TRUE
global SAMPLE_SIZE	5     // sample size in %

if "${SAMPLE}" == "TRUE" {
	!mkdir "output/data/full_sample${SAMPLE_SIZE}"
	!mkdir "output/data/normalized_sample${SAMPLE_SIZE}"
}
*

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

foreach year of numlist `FIRST_YEAR'(1)`LAST_YEAR' {
	do "code/sub/`year'.do"
}

do "code/sub/build_subsets.do"
do "code/sub/build_head.do"
do "code/sub/build_collapses.do"
