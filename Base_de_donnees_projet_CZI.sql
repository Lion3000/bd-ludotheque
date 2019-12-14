/*
Création du type Abonne_t
*/
create or replace type ABONNE_T AS OBJECT(
	ABONNEID			number(8),	
	ABNOM				varchar2(15), 	
	ABPRENOM			varchar2(15), 
	ABAGE				number(20),
	ABSEXE				char(1),	
	ABADRESSE			varchar2(50),
	DATE_INSCRIPTION	date,
	 	
	ORDER MEMBER function compAbonne (emp IN ABONNE_T) return number
);
/
/*
Création d'une liste de référence d'abonnés
*/
create or replace type listRefAbonne_t as table of REF ABONNE_T;
/
/*
Création de la table objet de type abonne_t 
et mise en place des contraintes
Définition des contraintes : 
- L'âge de l'abonné doit être en 0 et 15 ans
- Le sexe doit correspondre au caractère 'F' ou 'M'
- La date d'inscription ne peut être postérieure à la date du jour
- Aucun champ de doit être null
*/
create table abonne_o of abonne_t(
	CONSTRAINT pk_abonne_o_abonneid PRIMARY KEY(ABONNEID),
	CONSTRAINT chk_abonne_o_abage CHECK (ABAGE BETWEEN 0 AND 15),
	CONSTRAINT chk_abonne_o_absexe CHECK (ABSEXE IN ('F', 'M')),
	CONSTRAINT nnl_abonne_o_abnom ABNOM NOT NULL,
	CONSTRAINT nnl_abonne_o_abprenom ABPRENOM NOT NULL,
	CONSTRAINT nnl_abonne_o_abage ABAGE NOT NULL,
	CONSTRAINT nnl_abonne_o_absexe ABSEXE NOT NULL,
	CONSTRAINT nnl_abonne_o_abadresse ABADRESSE NOT NULL,
	CONSTRAINT nnl_abonne_o_date_insc DATE_INSCRIPTION NOT NULL
);
/
/*
Création du type reduction_t
*/
create or replace type REDUCTION_T AS OBJECT(
	REDUCTIONID			number(8),
	REDUCTIONNAME		varchar2(40), 	
	DATE_DEBUT			date, 	
	DATE_FIN			date
	 	
	ORDER MEMBER function compEmp (reduction IN REDUCTION_T) return number;
);
/


/*
Création de la table objet de type reduction_t 
et mise en place des contraintes
Définition des contraintes : 
- L'âge de l'abonné doit être en 0 et 15 ans
- Le sexe doit correspondre au caractère 'F' ou 'M'
- La date d'inscription ne peut être postérieure à la date du jour
- Aucun champ de doit être null
*/
create table reduction_o of reduction_t(
	CONSTRAINT pk_abonne_o_reductionid PRIMARY KEY(REDUCTIONID),
	CONSTRAINT chk_reduction_o_dates CHECK(DATE_DEBUT <= DATE_FIN),
	CONSTRAINT nnl_reduction_o_debut DATE_DEBUT NOT NULL,
	CONSTRAINT nnl_reduction_o_fin DATE_FIN NOT NULL
);
