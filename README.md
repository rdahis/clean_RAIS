# Cleaning the RAIS data set in Stata - Relação Anual de Informações Sociais

This repository contains Stata code that cleans and normalizes all RAIS for years 1985-2018.

## Basic Usage

1. Clone or download the repository.
2. Paste the raw RAIS data files into `/input`.
3. Run each year's dofile in `/src/sub`. Adjust the directory `path` to your own setup.
4. Run the dofile `/src/sub/build_subsets.do`.

## Tips

- Identified RAIS data is not public. To get access to it, one must (1) be in an university/institution that already has an agreement with the Ministério da Economia, or (2) apply for new access.
- Run this in a server with supercomputer capabilities. RAIS files are large.
