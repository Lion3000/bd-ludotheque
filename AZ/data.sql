/*
 * Alex Zarzitski
 * 23/10/2019
 */
 
 
/* ================================================
Definition de l'objet LIVRE 
================================================ */

create or replace type AUTEURS_T as varray(5) of varchar2(40)
 
create or replace type LIVRE_T AS OBJECT(
	livreNo				number(8),
	titre				varchar2(30),	
	auteurs		 		AUTEURS_T, /* de 5 Max auteurs Max example encyclopédie */
	nombreDePage		number(4), /* de 1 & 9999 Pages Max*/
	nombreDeChapitres	number(2), /* de 1 & 99 Chapitres Max*/
	dateDeParution		date,
	couverture			CLOB
);

create or replace table LIVRE_O of LIVRE_T(
	CONSTRAINT pk_LIVRE_O_livreNo PRIMARY KEY(livreNo),
	CONSTRAINT ck_LIVRE_O_nombreDePage CHECK(nombreDePage BETWEEN 1 AND 9999),
	CONSTRAINT ck_LIVRE_O_nombreDeChapitres CHECK(nombreDeChapitres BETWEEN 1 AND 99),
	CONSTRAINT nnl_LIVRE_O_livreNo NOT NULL,
	CONSTRAINT nnl_LIVRE_O_titre NOT NULL,
	CONSTRAINT nnl_LIVRE_O_auteurs NOT NULL,
	CONSTRAINT nnl_LIVRE_O_nombreDePage NOT NULL,
	CONSTRAINT nnl_LIVRE_O_nombreDeChapitres NOT NULL,
	CONSTRAINT nnl_LIVRE_O_dateDeParution NOT NULL
)
LOB(couverture) store as storeCouverture
/* ================================================
Definition de l'objet JEUVIDEO 
================================================ */

/* source PEGI : https://pegi.info/fr/page/que-signifient-les-logos */
create type PEGI_T (
	PEGI3, PEGI7, PEGI12, PEGI16, PEGI18, 
	VIOLENCE, FEAR, GAMBLING, DRUG, SEX, 
	BADLANGUAGE, DISCRIMINATION
);

create or replace type SymbolesPEGI_T as table of REF PEGI_T;

create or replace type JEUVIDEO_T UNDER ARTICLE_T (
	-- jeuvideoNo			number(8),
	support				varchar2(30),
	symbolesPEGI		SymbolesPEGI_T
);

/*create or replace table JEUSOCIETE_O of JEUVIDEO_T (
	-- CONSTRAINT pk_JEUSOCIETE_O_jeuSocieteNo PRIMARY KEY(jeuSocieteNo),
	-- CONSTRAINT nnl_JEUSOCIETE_O_jeuSocieteNo NOT NULL,
	CONSTRAINT ck_JEUSOCIETE_O_nombreDeJoueursMin CHECK(nombreDeJoueursMin BETWEEN 2 AND 9),
	CONSTRAINT ck_JEUSOCIETE_O_nombreDeJoueursMax CHECK(nombreDeJoueursMax >= nombreDeJoueursMin),
	CONSTRAINT nnl_JEUSOCIETE_O_nombreDeJoueursMin NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_nombreDeJoueursMax NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_dureePartie NOT NULL,
)
nested table listRefEmp store as storeListRefEmp*/

/* ================================================
Definition de l'objet JEUSOCIETE 
================================================ */

create or replace type JEUSOCIETE_T UNDER ARTICLE_T (
	-- jeuSocieteNo		number(8),
	nombreDeJoueursMin	number(1),
	nombreDeJoueursMax	number(1),
	dureePartie			TIMESTAMP
);

/*create or replace table JEUSOCIETE_O of JEUSOCIETE_T(
	-- CONSTRAINT pk_JEUSOCIETE_O_jeuSocieteNo PRIMARY KEY(jeuSocieteNo),
	-- CONSTRAINT nnl_JEUSOCIETE_O_jeuSocieteNo NOT NULL,
	CONSTRAINT ck_JEUSOCIETE_O_nombreDeJoueursMin CHECK(nombreDeJoueursMin BETWEEN 2 AND 9),
	CONSTRAINT ck_JEUSOCIETE_O_nombreDeJoueursMax CHECK(nombreDeJoueursMax >= nombreDeJoueursMin),
	CONSTRAINT nnl_JEUSOCIETE_O_nombreDeJoueursMin NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_nombreDeJoueursMax NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_dureePartie NOT NULL,
)*/

