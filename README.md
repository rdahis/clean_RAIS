# Cleaning the Relação Anual de Informações Sociais (RAIS) dataset in Stata, 1985-2020

This repository contains Stata code that cleans and normalizes all RAIS for years 1985-2020.

More information about RAIS, the Brazilian matched employer-employee dataset:
- [Base dos Dados](https://basedosdados.org/dataset/3e7c4d58-96ba-448e-b053-d385a829ef00?table=dabe5ea8-3bb5-4a3e-9d5a-3c7003cd4a60)
- [Ministério do Trabalho](http://www.rais.gov.br/sitio/index.jsf)

## Requirements

- Stata (preferably version 14+)

## Basic Usage

1. Clone or download the repository.
2. Paste the raw RAIS data files into `/input`.
3. Run the dofile `/code/build.do`.

## Output

This repository outputs RAIS all cleaned and normalized. It generates three sets of main datasets: (1) at worker-establishment-municipality level, (2) at worker-municipality level, (3) at establishment-municipality level. It also builds collapsed data sets at establishment-municipality and establishment level.

It provides some cleaning fixes to the original data:
- It standardizes all variable names and labels.
- It fixes wage variables with missing values.
- It generates deflated wage variables, relative to 2020.
- It allows for sample output data sets, if one prefers to work with smaller files.
- It standardizes classification variables (CNAE and CBO), and builds IBGE's broad sectors variables.
- It classifies types of establishments, into public, private, nonprofit, and by sphere/branch of government.
- It reconstructs CPF data back to years before 2003, for workers who show up in prior years.

## Tips

- See the file `/extra/Variables_RAIS_1985-2018.xlsx` for a complete dictionary of variables, labels, values and availability year-by-year.
- Identified RAIS data is not public. To get access to it, one must (1) be in an university/institution that already has an agreement with the Ministério da Economia, or (2) apply for new access.
- Run this in a server with supercomputer capabilities. RAIS files are large.
- For advice on structuring directories and code, please refer to my [template repository](https://github.com/rdahis/paper_template).
- Prof. Marc Muendler (UCSD) has useful [material about RAIS](https://econweb.ucsd.edu/muendler/html/brazil.html).

## Credits

If you benefit from code in this repository, please cite it in your work as:

- Dahis, Ricardo (2024) Cleaning the _Relação Anual de Informações Sociais_ (RAIS) dataset, 1985-2020. Github repository - https://github.com/rdahis/clean_RAIS

## Bugs, Comments and Suggestions

If you find any issues in my code, or have any suggestions for improvements, please open an issue or just email me at [ricardo.dahis@monash.edu](mailto:ricardo.dahis@monash.edu).
