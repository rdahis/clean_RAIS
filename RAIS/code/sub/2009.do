
//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

log using "output/log/2009.log", replace

local states AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP1 SP2 TO

foreach state in `states' {
	
	if "`state'" == "SP1" {
		import delimited "input/2009/SP2009ID1.txt", clear varn(1) delim(";") case(preserve) stringcols(_all)
	}
	else if "`state'" == "SP2" {
		import delimited "input/2009/SP2009ID2.txt", clear varn(1) delim(";") case(preserve) stringcols(_all)
	}
	else if "`state'" == "GO" {
		import delimited "input/2009/GO2009ID2.txt", clear varn(1) delim(";") case(preserve) stringcols(_all)
	}
	else {
		import delimited "input/2009/`state'2009ID.txt", clear varn(1) delim(";") case(preserve) stringcols(_all)
	}
	*
	
	ren MUNICIPIO		municipio
	ren CLASCNAE95		clascnae95
	ren EMPEM3112		empem3112
	ren TPVINCULO		tpvinculo
	ren CAUSADESLI		causadesli
	ren DIADESL			diadesli
	ren OCUP2002		ocup2002
	ren MESDESLIG		mesdesli
	ren INDALVARA		indalvara
	ren TIPOADM			tipoadm
	ren TIPOSAL			tiposal
	ren OCUPACAO		ocupacao94
	ren GRINSTRUCAO		grinstrucao
	ren GENERO			sexotrabalhador
	ren NACIONALIDAD	nacionalidad
	ren RACA_COR		raca_cor
	ren PORTDEFIC		portdefic
	ren TAMESTAB		tamestab
	ren NATJURIDICA		natjuridica
	ren INDCEIVINC		indceivinc
	ren TIPOESTBL		tipoestbl
	ren INDPAT			indpat
	ren INDSIMPLES		indsimples
	ren DTADMISSAO		dtadmissao
	ren REMDEZR			remdezr
	ren REMDEZEMBRO		remdezembro
	ren REMMEDR			remmedr
	ren REMMEDIA		remmedia
	ren TEMPEMPR		tempempr
	ren HORASCONTR		horascontr
	ren ULTREM			ultrem
	ren SALCONTR		salcontr
	ren PIS				PIS
	ren DTNASCIMENT		dtnascimento
	ren NUMECTPS		numectps
	ren CPF				CPF
	ren CEIVINC			ceivinc
	ren IDENTIFICAD		identificad
	ren RADICCNPJ		radiccnpj
	ren NOME			nome
	ren CLASCNAE20		clascnae20
	ren SBCLAS20		sbclas20
	ren TPDEFIC			tpdefic
	ren CAUSAFAST1		causafast1
	ren DIAINIAF1		diainiaf1
	ren MESINIAF1		mesiniaf1
	ren DIAFIMAF1		diafimaf1
	ren MESFIMAF1		mesfimaf1
	ren CAUSAFAST2		causafast2
	ren DIAINIAF2		diainiaf2
	ren MESINIAF2		mesiniaf2
	ren DIAFIMAF2		diafimaf2
	ren MESFIMAF2		mesfimaf2
	ren CAUSAFAST3		causafast3
	ren DIAINIAF3		diainiaf3
	ren MESINIAF3		mesiniaf3
	ren DIAFIMAF3		diafimaf3
	ren MESFIMAF3		mesfimaf3
	ren QTDIASAFAS		qtdiasafas
	
	drop TIPOESTBID // igual a tipoestbl
	
	destring municipio tipoadm tpvinculo causadesli empem3112 mesdesli grinstrucao tamestab tipoestbl horascontr indceivinc tiposal indalvara indpat indsimples portdefic tpdefic raca_cor qtdiasafas causafast*, replace force
	
	replace PIS = trim(PIS)
	
	replace CPF = trim(CPF)
	replace CPF = "" 				if length(CPF) <= 5
	replace CPF = "00000"	+ CPF	if length(CPF) == 6
	replace CPF = "0000"	+ CPF	if length(CPF) == 7
	replace CPF = "000"		+ CPF	if length(CPF) == 8
	replace CPF = "00"		+ CPF	if length(CPF) == 9
	replace CPF = "0"		+ CPF	if length(CPF) == 10
	
	replace nome = trim(nome)
	
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
	
	recode tpvinculo (10 = 10 "CLT U/PJ IND") (15 = 15 "CLT U/PF IND") (20 = 20 "CLT R/PJ IND") ///
					 (25 = 25 "CLT R/PF IND") (30 = 30 "ESTATUTARIO") (31 = 31 "ESTAT RGPS") ///
					 (35 = 35 "ESTAT N/EFET") (40 = 40 "AVULSO") (50 = 50 "TEMPORARIO") ///
					 (55 = 55 "APRENDIZ CONTR") (60 = 60 "CLT U/PJ DET") (65 = 65 "CLT U/PF DET") ///
					 (70 = 70 "CLT R/PJ DET") (75 = 75 "CLT R/PF DET") (80 = 80 "DIRETOR") ///
					 (90 = 90 "CONT PRZ DET") (95 = 95 "CONT TMP DET") (96 = 96 "CONT LEI EST") ///
					 (97 = 97 "CONT LEI MUN"), pre(n)label(tpvinculo)
	drop tpvinculo
	ren ntpvinculo tpvinculo
	
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
	ren ncausadesli causadesli
	
	cap replace diadesli="0" if diadesli=="NAO DESL ANO"
	destring diadesli, replace
	recode diadesli (0 = 0 "Nao desligado"), pre(n)label(diadesli)
	drop diadesli
	ren ndiadesli diadesli
	
	recode mesdesli (0 = 0 "Nao desligado"), pre(n)label(mesdesli)
	drop mesdesli
	ren nmesdesli mesdesli
	
	replace ocupacao94 = subinstr(ocupacao94, "CBO", "", .)
	replace ocupacao94="" if ocupacao94=="000-1"
	destring ocupacao94, replace force
	
	gen ocupacao1 = subinstr(ocup2002,"CBO","",.)
	destring ocupacao1, replace force
	replace ocupacao1 = 0 if ocupacao1 == .
	recode ocupacao1 (0 = 0 "IGNORADO"), pre(n)label(ocupacao1)
	drop ocup2002 ocupacao1
	ren nocupacao1 ocup2002
	
	destring tipoadm, replace force
	recode tipoadm	(1 = 1 "PRIM EMPREGO") (2 = 2 "REEMPREGO") (3 = 3 "TRANSF C/ONUS") ///
					(4 = 4 "TRANSF S/ONUS") (5 = 5 "OUTROS") (6 = 6 "REINTEGRACAO") ///
					(7 = 7 "RECONDUCAO") (8 = 8 "REVERSAO") (9 = 9 "EXERC PROVISORIO") ///
					(10 = 10 "REQUISICAO") (0 = 0 "NAO ADMITIDO NO ANO"), pre(n)label(tipoadm)
	drop tipoadm
	ren ntipoadm tipoadm
	
	recode tiposal	(1 = 1 "Mensal") (2 = 2 "Quinzenal") (3 = 3 "Semanal") (4 = 4 "Diario") ///
					(5 = 5 "Horario") (6 = 6 "Tarefa") (7 = 7 "Outros"), pre(n)label(tiposal)
	drop tiposal
	ren ntiposal tiposal
	la var tiposal "Tipo de Salario Contratual"
	
	recode indalvara (0 = 0 "Nao") (1 = 1 "Sim"), pre(n)label(indalvara)
	drop indalvara
	ren nindalvara indalvara

	recode indpat (0 = 0 "Nao") (1 = 1 "Sim"), pre(n)label(indpat)
	drop indpat
	ren nindpat indpat
	
	recode indsimples (0 = 0 "Nao") (1 = 1 "Sim"), pre(n)label(indsimples)
	drop indsimples
	ren nindsimples indsimples
	
	destring grinstrucao, replace force
	recode grinstrucao	(1 = 1 "Analfabeto") (2 = 2 "Ate 5a Incompleto") (3 = 3 "5a Completo") ///
						(4 = 4 "6a a 9a Incompleto") (5 = 5 "9a Completo") (6 = 6 "Medio Incompleto") ///
						(7 = 7 "Medio Completo") (8 = 8 "Superior Incompleto") (9 = 9 "Superior Completo") ///
						(10 = 10 "Mestrado") (11 = 11 "Doutorado"), pre(n)label(grinstrucao)
	drop grinstrucao
	ren ngrinstrucao grinstrucao
	
	replace dtadmissao = "0" + dtadmissao if length(dtadmissao) == 7
	replace dtnascimento = "0" + dtnascimento if length(dtnascimento) == 7
	
	gen genero = ""
	replace genero="1" if lower(sexotrabalhador) == "masculino"
	replace genero="0" if lower(sexotrabalhador) == "feminino"
	destring genero, replace
	recode genero(1 = 1 "Masculino")(0 = 0 "Feminino"), pre(n)label(genero)
	drop genero sexotrabalhador
	ren ngenero genero
	
	destring nacionalidad, replace force
	recode nacionalidad	(10 = 10 "Brasileira") (20 = 20 "Natur Bras") (21 = 21 "Argentina") (22 = 22 "Boliviana") ///
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
	
	recode raca_cor	(1 = 1 "Indigena") (2 = 2 "Branca") (4 = 4 "Preta") (6 = 6 "Amarela") ///
					(8 = 8 "Parda") (9 = 9 "Nao Ident."), pre(n)label(raca_cor)
	drop raca_cor
	ren nraca_cor raca_cor
	
	recode tpdefic (-1 = -1 "Nao Defic.") (1 = 1 "Fisica") (2 = 2 "Auditiva") (3 = 3 "Visual") (4 = 4 "Mental") (5 = 5 "Multipla") (6 = 6 "Reabilitado"), pre(n)label(tpdefic)
	drop tpdefic
	ren ntpdefic tpdefic
	
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
	
	foreach i of varlist remdezembro remmedia remdezr remmedr tempempr salcontr ultrem {
		gen `i'_ = subinstr(`i',",",".",.)
		destring `i'_, replace 
		drop `i'
		ren `i'_ `i'
	}
	*
	
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
						(1210 = 1210 "ASSOC PUBLIC") (2009 = 2009 "ADM PUB OUTR") ///
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
	rename nnatjuridica natjuridica
	
	destring clascnae95, replace force
	
	recode causafast1	(-1 = -1 "Nao se afastou")(10 = 10 "Acidente de trabalho tipico") ///
						(20 = 20 "Acidente do trabalho de trajeto")(30 = 30 "Doenca relacionada ao trabalho") ///
						(40 = 40 "Doenca nao relacionada ao trabalho")(50 = 50 "Licenca maternidade") ///
						(60 = 60 "Servico militar obrigatorio") ///
						(70 = 70 "Licenca sem vencimento/remuneracao"), pre(n)label(causafast1)
	drop causafast1
	ren ncausafast1 causafast1
	
	recode causafast2	(-1 = -1 "Nao se afastou")(10 = 10 "Acidente de trabalho tipico") ///
						(20 = 20 "Acidente do trabalho de trajeto")(30 = 30 "Doenca relacionada ao trabalho") ///
						(40 = 40 "Doenca nao relacionada ao trabalho")(50 = 50 "Licenca maternidade") ///
						(60 = 60 "Servico militar obrigatorio") ///
						(70 = 70 "Licenca sem vencimento/remuneracao"), pre(n)label(causafast2)
	drop causafast2
	ren ncausafast2 causafast2
	
	recode causafast3	(-1 = -1 "Nao se afastou")(10 = 10 "Acidente de trabalho tipico") ///
						(20 = 20 "Acidente do trabalho de trajeto")(30 = 30 "Doenca relacionada ao trabalho") ///
						(40 = 40 "Doenca nao relacionada ao trabalho")(50 = 50 "Licenca maternidade") ///
						(60 = 60 "Servico militar obrigatorio") ///
						(70 = 70 "Licenca sem vencimento/remuneracao"), pre(n)label(causafast3)
	drop causafast3
	ren ncausafast3 causafast3
	
	cap replace diainiaf1="-1" if diainiaf1=="IGNORADO"
	destring diainiaf1, replace
	cap replace diafimaf1="-1" if diafimaf1=="IGNORADO"
	destring diafimaf1, replace
	cap replace diainiaf2="-1" if diainiaf2=="IGNORADO"
	destring diainiaf2, replace
	cap replace diafimaf2="-1" if diafimaf2=="IGNORADO"
	destring diafimaf2, replace
	cap replace diainiaf3="-1" if diainiaf3=="IGNORADO"
	destring diainiaf3, replace
	cap replace diafimaf3="-1" if diafimaf3=="IGNORADO"
	destring diafimaf3, replace
	
	recode diainiaf1 (-1 = -1 "Nao se afastou"), pre(n)label(diainiaf1)
	drop diainiaf1
	ren ndiainiaf1 diainiaf1
	recode diainiaf2 (-1 = -1 "Nao se afastou"), pre(n)label(diainiaf2)
	drop diainiaf2
	ren ndiainiaf2 diainiaf2
	recode diainiaf3 (-1 = -1 "Nao se afastou"), pre(n)label(diainiaf3)
	drop diainiaf3
	ren ndiainiaf3 diainiaf3
	
	recode diafimaf1 (-1 = -1 "Nao se afastou"), pre(n)label(diafimaf1)
	drop diafimaf1
	ren ndiafimaf1 diafimaf1
	recode diafimaf2 (-1 = -1 "Nao se afastou"), pre(n)label(diafimaf2)
	drop diafimaf2
	ren ndiafimaf2 diafimaf2
	recode diafimaf3 (-1 = -1 "Nao se afastou"), pre(n)label(diafimaf3)
	drop diafimaf3
	ren ndiafimaf3 diafimaf3
	
	cap replace mesiniaf1="-1" if mesiniaf1 == "IGNORADO"
	destring mesiniaf1, replace
	cap replace mesfimaf1="-1" if mesfimaf1 == "IGNORADO"
	destring mesfimaf1, replace
	cap replace mesiniaf2="-1" if mesiniaf2 == "IGNORADO"
	destring mesiniaf2, replace
	cap replace mesfimaf2="-1" if mesfimaf2 == "IGNORADO"
	destring mesfimaf2, replace
	cap replace mesiniaf3="-1" if mesiniaf3 == "IGNORADO"
	destring mesiniaf3, replace
	cap replace mesfimaf3="-1" if mesfimaf3 == "IGNORADO"
	destring mesfimaf3, replace
	
	recode mesiniaf1 (-1 = -1 "Nao se afastou"), pre(n)label(mesiniaf1)
	drop mesiniaf1
	ren nmesiniaf1 mesiniaf1
	recode mesiniaf2 (-1 = -1 "Nao se afastou"), pre(n)label(mesiniaf2)
	drop mesiniaf2
	ren nmesiniaf2 mesiniaf2
	recode mesiniaf3 (-1 = -1 "Nao se afastou"), pre(n)label(mesiniaf3)
	drop mesiniaf3
	ren nmesiniaf3 mesiniaf3
	
	recode mesfimaf1 (-1 = -1 "Nao se afastou"), pre(n)label(mesfimaf1)
	drop mesfimaf1
	ren nmesfimaf1 mesfimaf1
	recode mesfimaf2 (-1 = -1 "Nao se afastou"), pre(n)label(mesfimaf2)
	drop mesfimaf2
	ren nmesfimaf2 mesfimaf2
	recode mesfimaf3 (-1 = -1 "Nao se afastou"), pre(n)label(mesfimaf3)
	drop mesfimaf3
	ren nmesfimaf3 mesfimaf3
	
	la var municipio		"Municipio de localizacao do estabelecimento"
	la var dtadmissao		"Data de admissao do trabalhador (completa)"
	la var empem3112		"Indicador de vinculo ativo em 31/12 (1 - sim; 0 - nao)"
	la var tpvinculo		"Tipo de vinculo empregaticio"
	la var causadesli		"Causa do desligamento"
	la var diadesli			"Dia de desligamento do trabalhador"
	la var mesdesli			"Mes de desligamento do trabalhador"
	la var ocupacao94		"CBO (Classificacao Brasileira de Ocupacoes), criada em 1994"
	la var ocup2002			"CBO (Classificacao Brasileira de Ocupacoes), criada em 2002 (6 digitos)"
	la var grinstrucao		"Grau de instrucao"
	la var genero			"Genero"
	la var nacionalidad		"Nacionalidade"
	la var raca_cor 		"Raca e cor do trabalhador"
	la var portdefic		"Nao e portador de deficiencia"
	la var tpdefic			"Tipo de deficiencia"
	la var tamestab			"Tamanho do estabelecimento - Empregados ativos em 31/12"
	la var tipoestbl		"Tipo do estabelecimento informante (CNPJ, CEI, Nao Idenitificado ou Ignorado)"
	la var natjuridica		"Natureza juridica do estabelecimento"
	la var remdezembro		"Remuneracao do trabalhador em dezembro, em salarios minimos"
	la var remmedia			"Remuneracao media do ano em salarios minimos"
	la var remmedr			"Remuneracao media do ano em valor nominal"
	la var remdezr			"Remuneracao media do trabalhador em dezembro, em valor nominal"
	la var salcontr			"Salario contratual do trabalhador, em valor nominal"
	la var tempempr			"Tempo de emprego do trabalhador em meses (quando acumulada, representa a soma dos meses)"
	la var PIS				"Numero de inscricao do empregado no Cadastro PIS/PASEP"
	la var CPF				"CPF do trabalhador"
	la var dtnascimento		"Data de nascimento do trabalhador"
	la var numectps			"Numero CTPS do trabalhador"
	la var identificad		"CNPJ ou CEI do estabelecimento (sem zeros a esquerda)"
	la var radiccnpj		"Radical do CNPJ do estabelecimento (8 posicoes, sem zeros a esquerda)"
	la var indalvara		"Indicador de trabalhador com Alvara Judicial"
	la var indpat			"Indicador de estabelecimento pertencente ao PAT"
	la var indsimples		"Indicador de optante pelo SIMPLES"
	la var horascontr		"Quantidade de horas contratuais por semana"
	la var clascnae95		"Classe CNAE 1.0 (principal atividade do estabelecimento)"
	la var ceivinc			"Numero do CEI vinculado, caso haja algum"
	la var indceivinc		"Indicador de estabelecimento com CEI vinculado"
	la var nome				"Nome do trabalhador"
	la var clascnae20		"Classe CNAE 2.0 (principal atividade do estabelecimento)"
	la var sbclas20			"Grupo de atividade economica, segunda a classificacao CNAE 2.0"
	la var causafast1		"Causa do primeiro afastamento do trabalhador no ano base"
	la var causafast2		"Causa do segundo afastamento do trabalhador no ano base"
	la var causafast3		"Causa do terceiro afastamento do trabalhador no ano base"
	la var diainiaf1		"Dia de inicio do primeiro afastamento"
	la var diainiaf2		"Dia de inicio do segundo afastamento"
	la var diainiaf3		"Dia de inicio do terceiro afastamento"
	la var diafimaf1		"Dia de fim do primeiro afastamento"
	la var diafimaf2		"Dia de fim do segundo afastamento"
	la var diafimaf3		"Dia de fim do terceiro afastamento"
	la var mesiniaf1		"Mes de inicio do primeiro afastamento"
	la var mesiniaf2		"Mes de inicio do segundo afastamento"
	la var mesiniaf3		"Mes de inicio do terceiro afastamento"
	la var mesfimaf1		"Mes de fim do primeiro afastamento"
	la var mesfimaf2		"Mes de fim do segundo afastamento"
	la var mesfimaf3		"Mes de fim do terceiro afastamento"
	la var qtdiasafas		"Quantidade de dias de afastamento"
	
	order PIS CPF numectps nome identificad radiccnpj municipio ///
		tpvinculo empem3112 tipoadm dtadmissao causadesli diadesli mesdesli ///
		ocupacao94 ocup2002 grinstrucao genero dtnascimento nacionalidad portdefic tpdefic raca_cor ///
		remdezembro remmedia remdezr remmedr tempempr tiposal salcontr ultrem horascontr ///
		clascnae95 clascnae20 sbclas20 tamestab natjuridica tipoestbl ///
		indceivinc ceivinc indalvara indpat indsimples
	
	tempfile f`state'
	save `f`state''

}
*

local first : word 1 of `states'
use `f`first'', clear
foreach state in `states' {
	if "`state'" != "`first'" {
		qui append using `f`state'', force
	}
}
*

compress

save "output/data/identified/full/2009.dta", replace

log close
