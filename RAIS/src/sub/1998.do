
//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

clear all
cap log close
set more off

cd "/path/RAIS"

log using "output/log/1998.log", replace

local states AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO

foreach state in `states' {
	
	cap import delimited "input/1998/`state'1998ID.txt", clear varn(1) delim(";") case(preserve) stringcols(_all)
	cap import delimited "input/1998/`state'1998id.txt", clear varn(1) delim(";") case(preserve) stringcols(_all)
	cap import delimited "input/1998/`state'1998ID.TXT", clear varn(1) delim(";") case(preserve) stringcols(_all)
	
	cap ren AnoAdmissão			anoadm
	ren CBO94Ocupação			ocupacao94
	ren CNPJCEI					identificad
	ren CNPJRaiz				radiccnpj
	ren BairrosSP				bairrossp
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
	ren Idade					idade
	ren NaturezaJurídica		natjuridica
	ren QtdHoraContr			horascontr
	ren TipoAdmissão			tipoadm
	ren CNAE95Classe			clascnae95
	
	//destring tpvinculo causadesli, replace force
	destring municipio uf clascnae95 tpvinculo causadesli empem3112 mesdesli grinstrucao sexotrabalhador tamestab tipoestbl mesadmissao idade natjuridica horascontr, replace force
	cap destring anoadm, replace force
	
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
	
	recode mesdesli (0 = 0 "Nao desligado"), pre(n)label(mesdesli)
	drop mesdesli
	ren nmesdesli mesdesli
	
	destring tipoadm, replace force
	recode tipoadm	(1 = 1 "PRIM EMPREGO") (2 = 2 "REEMPREGO") (3 = 3 "TRANSF C/ONUS") ///
					(4 = 4 "TRANSF S/ONUS") (5 = 5 "OUTROS") (6 = 6 "REINTEGRACAO") ///
					(7 = 7 "RECONDUCAO") (8 = 8 "REVERSAO") (9 = 9 "EXERC PROVISORIO") ///
					(10 = 10 "REQUISICAO") (0 = 0 "NAO ADMITIDO NO ANO"), pre(n)label(tipoadm)
	drop tipoadm
	ren ntipoadm tipoadm
	
	replace ocupacao94 = subinstr(ocupacao94, "CBO", "", .)
	replace ocupacao94 = "" if ocupacao94 == "000-1"
	destring ocupacao94, replace force
	
	destring grinstrucao, replace force
	recode grinstrucao	(1 = 1 "Analfabeto") (2 = 2 "Ate 5a Incompleto") (3 = 3 "5a Completo") ///
						(4 = 4 "6a a 9a Incompleto") (5 = 5 "9a Completo") (6 = 6 "Medio Incompleto") ///
						(7 = 7 "Medio Completo") (8 = 8 "Superior Incompleto") (9 = 9 "Superior Completo") ///
						(10 = 10 "Mestrado") (11 = 11 "Doutorado"), pre(n)label(grinstrucao)
	drop grinstrucao
	ren ngrinstrucao grinstrucao

	gen masc=1 if sexotrabalhador==1
	replace masc=0 if masc==.
	recode masc(1 = 1 "Masculino")(0 = 0 "Feminino"), pre(n)label(masc)
	drop masc sexotrabalhador
	ren nmasc genero
	
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
	
	recode idade (0 = 0 "Ignorado"), pre(n)label(idade)
	drop idade
	ren nidade idade
	
	destring tipoadm, replace force
	recode tipoadm	(1 = 1 "PRIM EMPREGO") (2 = 2 "REEMPREGO") (3 = 3 "TRANSF C/ONUS") ///
					(4 = 4 "TRANSF S/ONUS") (5 = 5 "OUTROS") (6 = 6 "REINTEGRACAO") ///
					(7 = 7 "RECONDUCAO") (8 = 8 "REVERSAO") (9 = 9 "EXERC PROVISORIO") ///
					(10 = 10 "REQUISICAO") (0 = 0 "NAO ADMITIDO NO ANO"), pre(n)label(tipoadm)
	drop tipoadm
	ren ntipoadm tipoadm
	
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
						(1210 = 1210 "ASSOC PUBLIC") (1998 = 1998 "ADM PUB OUTR") ///
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
	
	cap replace ibgesubsetor="26" if ibgesubsetor=="{ñ"|ibgesubsetor==""
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
	cap la var anoadm		"Ano de admissao do trabalhador"
	la var faixaetaria		"Faixa Etaria"
	la var idade			"Idade do trabalhador"
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
	la var natjuridica		"Natureza juridica do estabelecimento"
	la var mesadmissao		"Mes de admissao do trabalhador"
	la var remdezembro		"Remuneracao do trabalhador em dezembro, em salarios minimos"
	la var remmedia			"Remuneracao media do ano em salarios minimos"
	la var tempempr			"Tempo de emprego do trabalhador em meses (quando acumulada, representa a soma dos meses)"
	la var PIS				"Numero de inscricao do empregado no Cadastro PIS/PASEP"
	la var identificad		"CNPJ ou CEI do estabelecimento (sem zeros a esquerda)"
	la var radiccnpj		"Radical do CNPJ do estabelecimento (8 posicoes, sem zeros a esquerda)"
	la var ibgesubsetor		"Subsetor IBGE do estabelecimento"
	la var horascontr		"Quantidade de horas contratuais por semana"
	la var tipoadm			"Tipo de admissao"
	la var clascnae95		"Classe CNAE 1.0 (principal atividade do estabelecimento)"
	
	order PIS identificad radiccnpj municipio uf ///
		tpvinculo empem3112 mesadmissao causadesli mesdesli ///
		ocupacao94 grinstrucao genero idade faixaetaria nacionalidad ///
		remdezembro remmedia tempempr ///
		clascnae95 tamestab tipoestbl natjuridica ibgesubsetor
	
	save "tmp/1998/`state'.dta", replace

}
*

local first : word 1 of `states'
use "tmp/1998/`first'.dta", clear
foreach file in `states' {
	if "`file'" != "`first'" {
		qui append using "tmp/1998/`file'.dta", force
	}
}
*

save "output/data/full/RAIS_1998.dta", replace

log close



