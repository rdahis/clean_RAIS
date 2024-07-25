
//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

log using "output/log/1986.log", replace

local states AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP //TO

foreach state in `states' {
	
	import delimited "input/1986/`state'1986ID.txt", clear varn(1) delim(";") case(preserve) stringcols(_all)
	
	ren AnoAdmissão				anoadm
	ren BairrosSP				bairrossp
	ren CBOOcupação				ocupacao94
	ren CNPJCEI					identificad
	ren CNPJRaiz				radiccnpj
	ren DistritosSP				distritossp
	ren GrauInstrução20051985	grinstrucao
	ren IBGESubsetor			ibgesubsetor
	ren MêsAdmissão				mesadmissao
	ren MêsDesligamento			mesdesli
	ren MotivoDesligamento		causadesli
	ren Município				municipio
	ren Nacionalidade			nacionalidad
	ren PIS						PIS
	ren SexoTrabalhador			sexotrabalhador
	ren TamanhoEstabelecimento	tamestab
	ren TempoEmprego			tempempr
	ren TipoEstab				tipoestbl
	ren TipoVínculo				tpvinculo
	ren UF						uf
	ren VínculoAtivo3112		empem3112
	ren VlRemunDezembroSM		remdezembro
	ren VlRemunMédiaSM			remmedia
	ren FaixaEtária				faixaetaria
	ren IBGESubatividade		ibgeatividade
	ren SituaçãoVínculo 		sitvinculo
	
	destring municipio uf anoadm tpvinculo sitvinculo causadesli empem3112 mesdesli grinstrucao sexotrabalhador tamestab tipoestbl mesadmissao ibgeatividade, replace force
	
	replace PIS = trim(PIS)
	
	replace identificad	= trim(identificad)
	replace radiccnpj	= trim(radiccnpj)
	replace identificad = "00000000000"	+ identificad if length(identificad) == 3
	replace identificad = "0000000000"	+ identificad if length(identificad) == 4
	replace identificad = "000000000"	+ identificad if length(identificad) == 5
	replace identificad = "00000000"	+ identificad if length(identificad) == 6
	replace identificad = "0000000"		+ identificad if length(identificad) == 7
	replace identificad = "000000"		+ identificad if length(identificad) == 8
	replace identificad = "00000"		+ identificad if length(identificad) == 9
	replace identificad = "0000"		+ identificad if length(identificad) == 10
	replace identificad = "000"			+ identificad if length(identificad) == 11
	replace identificad = "00"			+ identificad if length(identificad) == 12
	replace identificad = "0"			+ identificad if length(identificad) == 13
	
	replace radiccnpj = "" if radiccnpj == "0"
	
	recode empem3112 (0 = 0 Nao) (1 = 1 Sim), pre(n)label(empem3112)
	drop empem3112
	ren nempem3112 empem3112
	
	recode mesdesli (0 = 0 "Nao desligado"), pre(n)label(mesdesli)
	drop mesdesli
	ren nmesdesli mesdesli
	
	destring grinstrucao, replace force
	recode grinstrucao	(1 = 1 "Analfabeto") (2 = 2 "Ate 5a Incompleto") (3 = 3 "5a Completo") ///
						(4 = 4 "6a a 9a Incompleto") (5 = 5 "9a Completo") (6 = 6 "Medio Incompleto") ///
						(7 = 7 "Medio Completo") (8 = 8 "Superior Incompleto") (9 = 9 "Superior Completo") ///
						(10 = 10 "Mestrado") (11 = 11 "Doutorado"), pre(n)label(grinstrucao)
	drop grinstrucao
	ren ngrinstrucao grinstrucao

	gen     masc = 1 if sexotrabalhador==1
	replace masc = 0 if masc==.
	recode masc(1 = 1 "Masculino")(0 = 0 "Feminino"), pre(n)label(masc)
	drop masc sexotrabalhador
	ren nmasc genero
	
	destring nacionalidad, replace force
	recode nacionalidad (10 = 10 "Brasileira") (20 = 20 "Natur Bras") (21 = 21 "Argentina") (22 = 22 "Boliviana") ///
						 (23 = 23 "Chilena") (24 = 24 "Paraguaia") (25 = 25 "Uruguaia") (26 = 26 "Venezuelano") ///
						 (27 = 27 "Colombiano") (28 = 28 "Peruano") (29 = 29 "Equatoriano") (30 = 30 "Alem„") ///
						 (31 = 31 "Belga") (32 = 32 "Britanica") (34 = 34 "Canadense") (35 = 35 "Espanhola") ///
						 (36 = 36 "Norte Americ.") (37 = 37 "Francesa") (38 = 38 "Suica") (39 = 39 "Italiana") ///
						 (40 = 40 "Haitiano") (41 = 41 "Japonesa") (42 = 42 "Chinesa") (43 = 43 "Coreana") ///
						 (44 = 44 "Russo") (45 = 45 "Portuguesa") (46 = 46 "Paquistanes") (47 = 47 "Indiano") ///
						 (48 = 48 "Out. Lat. Amer.") (49 = 49 "Outr. Asiatic.") (50 = 50 "Outras Nac.") ///
						 (51 = 51 "Outros Europeus") (60 = 60 "Angolano") (61 = 61 "Congoles") (62 = 62 "Sul-Africano") ///
						 (70 = 70 "Outros Africanos") (80 = 80 "Outros"), pre(n)label(nacionalidad)
	drop nacionalidad
	ren nnacionalidad nacionalidad
	
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
	
	replace tipoestbl=9 if tipoestbl==4
	recode tipoestbl (1 = 1 "CNPJ") (3 = 3 "CEI") (9 = 9 "Nao Identificado"), pre(n)label(tipoestbl)
	drop tipoestbl
	ren ntipoestbl tipoestbl
	
	recode mesadmissao (0 = 0 "Ignorado"), pre(n)label(mesadmissao)
	drop mesadmissao
	ren nmesadmissao mesadmissao
	
	gen remdezembro_=subinstr(remdezembro,",",".",.)
	destring remdezembro_, replace
	drop remdezembro
	ren remdezembro_ remdezembro
	
	gen remmedia_=subinstr(remmedia,",",".",.)
	destring remmedia_, replace
	drop remmedia
	ren remmedia_ remmedia
	
	gen tempempr_=subinstr(tempempr,",",".",.)
	destring tempempr_, replace
	drop tempempr
	ren tempempr_ tempempr
	
	replace ibgesubsetor="26" if ibgesubsetor=="{ñ"|ibgesubsetor==""
	destring ibgesubsetor, replace
	recode ibgesubsetor (1 = 1 "EXTR MINERAL") (2 = 2 "MIN NAO MET") (3 = 3 "IND METAL") ///
						(4 = 4 "IND MECANICA") (5 = 5 "ELET E COMUN") (6 = 6 "MAT TRANSP") ///
						(7 = 7 "MAD E MOBIL") (8 = 8 "PAPEL E GRAF") (9 = 9 "BOR FUN COUR") ///
						(10 = 10 "IND QUIMICA") (11 = 11 "IND TEXTIL") (12 = 12 "IND CALCADOS") ///
						(13 = 13 "ALIM E BEB") (14 = 14 "SERV UTIL PUB") (15 = 15 "CONSTR CIVIL") ///
						(16 = 16 "COM VAREJ") (17 = 17 "COM ATACAD") (18 = 18 "INST FINANC") ///
						(19 = 19 "ADM TEC PROF") (20 = 20 "TRAN E COMUN") (21 = 21 "ALOJ COMUNIC") ///
						(22 = 22 "MED ODON VET") (23 = 23 "ENSINO") (24 = 24 "ADM PUBLICA") ///
						(25 = 25 "AGRICULTURA") (26 = 26 "OUTROS/IGNORADOS"), pre(n)label(ibgesubsetor)
	drop ibgesubsetor 
	ren nibgesubsetor ibgesubsetor 
	
	destring faixaetaria, replace force
	
	la var municipio		"Municipio de localizacao do estabelecimento"
	la var uf				"Unidade da Federacao"
	la var empem3112		"Indicador de vinculo ativo em 31/12 (1 - sim; 0 - nao)"
	la var tpvinculo		"Tipo de vinculo empregaticio"
	la var causadesli		"Causa do desligamento"
	la var mesdesli			"Mes de desligamento do trabalhador"
	la var ocupacao94		"CBO (Classificacao Brasileira de Ocupacoes), criada em 1994"
	la var grinstrucao		"Grau de instrucao"
	la var genero			"Genero"
	la var nacionalidad		"Nacionalidade"
	la var tamestab			"Tamanho do estabelecimento - Empregados ativos em 31/12"
	la var tipoestbl		"Tipo do estabelecimento informante (CNPJ, CEI, Nao Idenitificado ou Ignorado)"
	la var mesadmissao		"Mes de admissao do trabalhador"
	la var remdezembro		"Remuneracao do trabalhador em dezembro, em salarios minimos"
	la var remmedia			"Remuneracao media do ano em salarios minimos"
	la var tempempr			"Tempo de emprego do trabalhador em meses (quando acumulada, representa a soma dos meses)"
	la var PIS				"Numero de inscricao do empregado no Cadastro PIS/PASEP"
	la var identificad		"CNPJ ou CEI do estabelecimento (sem zeros a esquerda)"
	la var radiccnpj		"Radical do CNPJ do estabelecimento (8 posicoes, sem zeros a esquerda)"
	la var ibgesubsetor		"Subsetor IBGE do estabelecimento"
	la var ibgeatividade	"Atividade IBGE do estabelecimento"

	order PIS identificad radiccnpj municipio uf ///
		tpvinculo sitvinculo empem3112 anoadm mesadmissao causadesli mesdesli ///
		ocupacao94 grinstrucao genero faixaetaria nacionalidad ///
		remdezembro remmedia tempempr ///
		tamestab tipoestbl ibgesubsetor ibgeatividade
	
	save "tmp/1986_`state'.dta", replace

}
*

local first : word 1 of `states'
use "tmp/1986_`first'.dta", clear
foreach state in `states' {
	if "`state'" != "`first'" {
		qui append using "tmp/1986_`state'.dta", force
	}
}
*

compress

save "output/data/identified/full/1986.dta", replace

foreach state in `states' {
	erase "tmp/1986_`state'.dta"
}

log close
