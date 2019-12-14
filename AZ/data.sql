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

drop table LIVRE_O;
/
create table LIVRE_O of LIVRE_T(
	CONSTRAINT pk_LIVRE_O_livreNo PRIMARY KEY(livreNo),
	CONSTRAINT ck_LIVRE_O_nombreDePage CHECK(nombreDePage BETWEEN 1 AND 9999),
	CONSTRAINT ck_LIVRE_O_nombreDeChapitres CHECK(nombreDeChapitres BETWEEN 1 AND 99),
	CONSTRAINT nnl_LIVRE_O_livreNo livreNo NOT NULL,
	CONSTRAINT nnl_LIVRE_O_titre titre NOT NULL,
	CONSTRAINT nnl_LIVRE_O_nombreDePage nombreDePage NOT NULL,
	CONSTRAINT nnl_LIVRE_O_nombreDeChapitres nombreDeChapitres NOT NULL,
	CONSTRAINT nnl_LIVRE_O_dateDeParution dateDeParution NOT NULL
)LOB (couverture) STORE AS basicfile(STORAGE (NEXT 4M)
ENABLE STORAGE IN ROW
CHUNK 4);
/* ================================================
Definition de l'objet JEUVIDEO 
================================================ */

/* source PEGI : https://pegi.info/fr/page/que-signifient-les-logos */
/*create type PEGI_T (
	PEGI3, PEGI7, PEGI12, PEGI16, PEGI18, 
	VIOLENCE, FEAR, GAMBLING, DRUG, SEX, 
	BADLANGUAGE, DISCRIMINATION
);



create or replace type SymbolesPEGI_T as table of REF PEGI_T;
*/
create or replace type JEUVIDEO_T UNDER ARTICLE_T (
	support				varchar2(30),
	symbolesPEGI		varchar2(15) 		
);

ENUM('PEGI3', 'PEGI18', 'PEGI12','GAMBLING', 'VIOLENCE', 'BADLANGUAGE', 'DISCRIMINATION', 'FEAR', 'SEX', 'DRUG')
create table JEUSOCIETE_O of JEUSOCIETE_T (
	CONSTRAINT ck_JEUSOCIETE_O_nbJoueursMin CHECK(nombreDeJoueursMin BETWEEN 2 AND 9),
	CONSTRAINT ck_JEUSOCIETE_O_nbJoueursMax CHECK(nombreDeJoueursMax >= nombreDeJoueursMin),
	CONSTRAINT nnl_JEUSOCIETE_O_nbJoueursMin nombreDeJoueursMin NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_nbJoueursMax nombreDeJoueursMax NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_dureePartie dureePartie NOT NULL
);

/* ================================================
Definition de l'objet JEUSOCIETE 
================================================ */

create or replace type JEUSOCIETE_T UNDER ARTICLE_T (
	nombreDeJoueursMin	number(1),
	nombreDeJoueursMax	number(1),
	dureePartie			TIMESTAMP
);

create table JEUVIDEO_O of JEUVIDEO_T(
	CONSTRAINT chk_jvideo_o_symbolesPEGI CHECK (symbolesPEGI IN ('PEGI3', 'PEGI18', 'PEGI12','GAMBLING', 'VIOLENCE', 'BADLANGUAGE', 'DISCRIMINATION', 'FEAR', 'SEX', 'DRUG')),
	CONSTRAINT nnl_jvideo_O_support support NOT NULL,
	CONSTRAINT nnl_jvideo_O_symbolesPEGI symbolesPEGI NOT NULL
);

