/*
=====================================================
drop everything
=====================================================

*/
drop table ARTICLE_O cascade constraints;
drop table FILM_O cascade constraints;
drop table JEUSOCIETE_O cascade constraints;
drop table JEUVIDEO_O cascade constraints;
drop table LIVRE_O cascade constraints;
drop table ABONNE_O cascade constraints;
drop table REDUCTION_O cascade constraints;
drop type ACTEURSPRINC_T force;
drop type AUTEURS_T force;
drop type ARTICLE_T force;
drop type FILM_T force;
drop type JEUVIDEO_T force;
drop type JEUSOCIETE_T force;
drop type ABONNE_T force;
drop type REDUCTION_T force;
drop type LIVRE_T force;
drop type LISTREFARTICLE_T force;
drop type LISTREFFILM_T force;
drop type listRefAbonne_t force;
drop type tabActeursPrinc_t force;
drop type tableArticles force;
drop type tableReductions force;
drop type tableLivres force;


/*
=====================================================
CREATION DES TYPES 
=====================================================
*/

/* Types forward */
create or replace type ARTICLE_T;
/
create or replace type FILM_T;
/
create or replace type JEUVIDEO_T;
/
create or replace type JEUSOCIETE_T;
/
create or replace type LIVRE_T;
/
create or replace type ABONNE_T;
/
create or replace type REDUCTION_T;
/


/* Création des listes de référence */
create or replace type listRefArticle_t as table of REF ARTICLE_T;
/
create or replace type tabActeursPrinc_t as varray(5) of varchar2(70);
/
create or replace type AUTEURS_T as varray(5) of varchar2(70)
/
create or replace type listRefFilm_t as table of REF FILM_T;
/
create or replace type listRefAbonne_t as table of REF ABONNE_T;
/
create or replace type tableArticles IS TABLE OF REF ARTICLE_T;
/
create or replace type tableReductions IS TABLE OF REF REDUCTION_T;
/
create or replace type tableLivres IS TABLE OF REF LIVRE_T;
/

/* Création du type article */
create or replace type ARTICLE_T AS OBJECT (
    ARTICLEID	number(8),
    TITRE   varchar2(50),
    GENRE   varchar2(50),
    AGEMINIMAL   number(3),
    EDITEUR varchar2(50),
    DATEPARUTION date,
    
    ORDER MEMBER function compArticle (article IN ARTICLE_T) return number
)NOT FINAL;
/

/* Création du type film */
create or replace type FILM_T UNDER ARTICLE_T (
    REALISATEUR   varchar2(50),
    ACTEURS_PRINC   tabActeursPrinc_t
);
/

/*
Création du type jeuVideo_t
*/
create or replace type JEUVIDEO_T UNDER ARTICLE_T (
	support				varchar2(50),
	symbolesPEGI		varchar2(15)	
);
/

/*
Création du type jeuSociete_t
*/
create or replace type JEUSOCIETE_T UNDER ARTICLE_T (
	nombreDeJoueursMin	number(1),
	nombreDeJoueursMax	number(1),
	dureePartie			number(4)
);
/

/*
Création du type Abonne_t
*/
create or replace type ABONNE_T AS OBJECT(
	ABONNEID			number(8),	
	ABNOM				varchar2(50), 	
	ABPRENOM			varchar2(25), 
	ABAGE				number(20),
	ABSEXE				char(1),	
	ABADRESSE			varchar2(70),
	DATE_INSCRIPTION	date,
	NT_ARTICLES			tableArticles,
	NT_LIVRES			tableLivres,
	REDUCTION_REF			REF REDUCTION_T,
	 	
	ORDER MEMBER function compAbonne (emp IN ABONNE_T) return number
);
/

/*
Création du type reduction_t
*/
create or replace type REDUCTION_T AS OBJECT(
	REDUCTIONID			number(8),
	REDUCTIONNAME		varchar2(70), 	
	DATE_DEBUT			date, 	
	DATE_FIN			date,
	 	
	ORDER MEMBER function compReduc (reduction IN REDUCTION_T) return number
);
/

/*
Création du type livre_t
*/
create or replace type LIVRE_T AS OBJECT(
	livreNo				number(8),
	titre				varchar2(70),	
	genre				varchar2(15),	
	auteurs		 		AUTEURS_T, /* de 5 Max auteurs Max example encyclopédie */
	nombreDePage		number(4), /* de 1 & 9999 Pages Max*/
	nombreDeChapitres	number(2), /* de 1 & 99 Chapitres Max*/
	dateDeParution		date,
	couverture			CLOB,
	
	ORDER MEMBER function compLivre (livre IN LIVRE_T) return number
);
/

/*
=====================================================
CREATION DES TABLES 
=====================================================
*/

/* Création de la table objet article avec ses contraintes */
create table article_o of article_t(
	CONSTRAINT pk_article_o_articleid PRIMARY KEY(ARTICLEID),
	CONSTRAINT nnl_article_o_titre TITRE NOT NULL,
	CONSTRAINT nnl_article_o_genre GENRE NOT NULL,
	CONSTRAINT nnl_article_o_ageminimal AGEMINIMAL NOT NULL,
	CONSTRAINT nnl_article_o_editeur EDITEUR NOT NULL,
	CONSTRAINT nnl_article_o_dateparution DATEPARUTION NOT NULL
	/*CONSTRAINT chk_article_o_dateparution CHECK(DATEPARUTION <= NOW())*/
);
/

/* Création de la table objet film avec ses contraintes */
create table film_o of film_t(
	CONSTRAINT nnl_film_o_realisateur REALISATEUR NOT NULL
);
/

/*
Création de la table objet de type jeuSociete_t 
Définition des contraintes : 
- joueurMin doit être entre 2 et 9
- joueurMax doit être supérieur ou égal à joueurMin
- la durée doit être supérieure à 0
- Aucun champ ne doit être null
*/
create table JEUSOCIETE_O of JEUSOCIETE_T (
	CONSTRAINT ck_JEUSOCIETE_O_nbJoueursMin CHECK(nombreDeJoueursMin BETWEEN 2 AND 9),
	CONSTRAINT ck_JEUSOCIETE_O_nbJoueursMax CHECK(nombreDeJoueursMax >= nombreDeJoueursMin),
	CONSTRAINT ck_JEUSOCIETE_O_dureePartie CHECK(dureePartie > 0),
	CONSTRAINT nnl_JEUSOCIETE_O_nbJoueursMin nombreDeJoueursMin NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_nbJoueursMax nombreDeJoueursMax NOT NULL,
	CONSTRAINT nnl_JEUSOCIETE_O_dureePartie dureePartie NOT NULL
);
/

/*
Création de la table objet de type jeuVideo_t 
Définition des contraintes : 
- les symboles Pegi doivent faire partie de la liste 
- Aucun champ ne doit être null
*/
create table JEUVIDEO_O of JEUVIDEO_T(
	CONSTRAINT chk_jvideo_o_symbolesPEGI CHECK (symbolesPEGI IN ('PEGI3', 'PEGI16', 'PEGI18', 'PEGI12','GAMBLING', 'VIOLENCE', 'BADLANGUAGE', 'DISCRIMINATION', 'FEAR', 'SEX', 'DRUG')),
	CONSTRAINT nnl_jvideo_O_support support NOT NULL,
	CONSTRAINT nnl_jvideo_O_symbolesPEGI symbolesPEGI NOT NULL
);
/

/*
Création de la table objet de type livre_t 
Définition des contraintes : 
- le nombre de page doit être compris entre 1 et 9999 
- le nombre de chapitre doit être compris entre 1 et 99 
- Aucun champ cité ci-dessous ne doit être null
*/
create table LIVRE_O of LIVRE_T(
	CONSTRAINT pk_LIVRE_O_livreNo PRIMARY KEY(livreNo),
	CONSTRAINT ck_LIVRE_O_genres CHECK(genre IN ('BD', 'POLICIER', 'AVENTURE','FANTASTIQUE', 'CONTE', 'LUDIQUE', 'AUTRE')),
	CONSTRAINT ck_LIVRE_O_nbDePage CHECK(nombreDePage BETWEEN 1 AND 9999),
	CONSTRAINT ck_LIVRE_O_nbChapitres CHECK(nombreDeChapitres BETWEEN 1 AND 99),
	CONSTRAINT nnl_LIVRE_O_livreType genre NOT NULL,
	CONSTRAINT nnl_LIVRE_O_livreNo livreNo NOT NULL,
	CONSTRAINT nnl_LIVRE_O_titre titre NOT NULL,
	CONSTRAINT nnl_LIVRE_O_nbPage nombreDePage NOT NULL,
	CONSTRAINT nnl_LIVRE_O_nbChapitres nombreDeChapitres NOT NULL,
	CONSTRAINT nnl_LIVRE_O_dateDeParution dateDeParution NOT NULL
)LOB (couverture) STORE AS basicfile(STORAGE (NEXT 4M)
ENABLE STORAGE IN ROW
CHUNK 4);
/
/*
Création de la table objet de type abonne_t 
Définition des contraintes : 
- L'âge de l'abonné doit être en 0 et 15 ans
- Le sexe doit correspondre au caractère 'F' ou 'M'
- La date d'inscription ne peut être postérieure à la date du jour
- Aucun champ ne doit être null
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
)nested table NT_ARTICLES store as STORE_NT_ARTICLES, nested table NT_LIVRES store as STORE_NT_LIVRES
;
/

/*
Création de la table objet de type reduction_t 
Définition des contraintes : 
- la date de début doit être avant la date de fin
- Aucun champ ne doit être null
*/
create table reduction_o of reduction_t(
	CONSTRAINT pk_abonne_o_reductionid PRIMARY KEY(REDUCTIONID),
	CONSTRAINT chk_reduction_o_dates CHECK(DATE_DEBUT <= DATE_FIN),
	CONSTRAINT nnl_reduction_o_id REDUCTIONID NOT NULL,
	CONSTRAINT nnl_reduction_o_name REDUCTIONNAME NOT NULL,
	CONSTRAINT nnl_reduction_o_debut DATE_DEBUT NOT NULL,
	CONSTRAINT nnl_reduction_o_fin DATE_FIN NOT NULL
);
/

/* 
	CREATION DES INDEX
*/

/* Ajout du scope for pour pouvoir créer l'index */

ALTER TABLE ABONNE_O
ADD (SCOPE FOR (reduction_ref) IS REDUCTION_O);
/
/* Création d’un index sur la colonne reduction_ref dans abonne */

CREATE INDEX idx_o_vol_reduc_ref on
ABONNE_O(reduction_ref)
TABLESPACE USERS;

/*
INSERTION DANS LES TABLES
*/

/*
Insertion dans la table livre
*/

    INSERT INTO LIVRE_O VALUES (1, 'Le petit prince', 'FANTASTIQUE', AUTEURS_T('Antoine de Saint-Exupéry'), 110, 5, TO_DATE('06/04/1943', 'DD/MM/YYYY'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (2, 'Orgueil et Préjugés', 'AUTRE', AUTEURS_T('Jane Austen'), 200, 5, TO_DATE('1813', 'yyyy'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (3, 'Vingt Mille Lieues sous les mers', 'FANTASTIQUE', AUTEURS_T('Jules Verne'), 540, 15, TO_DATE('1869', 'yyyy'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (4, 'La cuisine pour les nuls', 'LUDIQUE', AUTEURS_T('Hélène Darroze', 'Marie Dupont'), 140, 20, TO_DATE('09/02/2012', 'DD/MM/YYYY'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (5, 'Apprendre à compter', 'LUDIQUE', AUTEURS_T('Luna Halusi', 'Sarah janet', 'Jules Harrison'), 27, 4, TO_DATE('16/07/2016', 'DD/MM/YYYY'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (5, 'Mon premier ', 'LUDIQUE', AUTEURS_T('Luna Halusi', 'Sarah janet', 'Jules Harrison'), 27, 4, TO_DATE('16/07/2016', 'DD/MM/YYYY'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (6, 'La fille de Vercingétorix', 'BD', AUTEURS_T('René Goscinny', 'Albert Uderzo'), 95, 8, TO_DATE('24/10/2019', 'DD/MM/YYYY'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (7, 'Naruto tome 1', 'BD', AUTEURS_T('Masashi Kishimoto'), 82, 9, TO_DATE('2002', 'yyyy'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (8, 'One piece tome 16', 'BD', AUTEURS_T('Eiichiro Oda'), 78, 7, TO_DATE('2001', 'yyyy'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (9, 'la ligne verte', 'AUTRE', AUTEURS_T('Stephen King'), 512, 14, TO_DATE('23/04/2008', 'DD/MM/YYYY'), EMPTY_CLOB());
    INSERT INTO LIVRE_O VALUES (10, 'apprenti épouventeur', 'AVENTURE', AUTEURS_T('Joseph Delaney'), 275, 12, TO_DATE('01/07/2004', 'DD/MM/YYYY'), EMPTY_CLOB());

/*
Insertion dans la table jeuSociete
*/	
	INSERT INTO JEUSOCIETE_O VALUES (1, 'Uno', 'CARTE', 6, 'Mattel Games', TO_DATE('01/07/2004', 'DD/MM/YYYY'), 2, 8, 15);
	INSERT INTO JEUSOCIETE_O VALUES (2, 'Cluedo', 'Enigme', 10, 'Hasbro', TO_DATE('07/01/1999', 'DD/MM/YYYY'), 2, 5, 30);
	INSERT INTO JEUSOCIETE_O VALUES (3, 'E=M6', 'Scientifique', 7, 'Ravensburger', TO_DATE('01/07/2001', 'DD/MM/YYYY'), 2, 4, 35);
	INSERT INTO JEUSOCIETE_O VALUES (4, 'Le désert interdit', 'stratégie', 10, 'Asmodee', TO_DATE('21/12/2005', 'DD/MM/YYYY'), 2, 5, 25);
	INSERT INTO JEUSOCIETE_O VALUES (5, 'Citadelles', 'stratégie', 10, 'Asmodee', TO_DATE('04/08/2016', 'DD/MM/YYYY'), 2, 6, 35);
	INSERT INTO JEUSOCIETE_O VALUES (6, 'Les Batisseurs - Antiquite', 'stratégie', 10, 'Asmodee', TO_DATE('14/10/2019', 'DD/MM/YYYY'), 2, 8, 35);
	INSERT INTO JEUSOCIETE_O VALUES (7, 'Croque Carotte', 'jeu de parcours', 3, 'Ravensburger', TO_DATE('27/06/2007', 'DD/MM/YYYY'), 2, 8, 10);
	INSERT INTO JEUSOCIETE_O VALUES (8, 'Sushi Go', 'jeu de parcours', 3, 'Ravensburger', TO_DATE('27/06/2007', 'DD/MM/YYYY'), 2, 8, 10);
	INSERT INTO JEUSOCIETE_O VALUES (9, 'Monopoly Classique', 'strategie', 3, 'Hasbro', TO_DATE('25/02/1995', 'DD/MM/YYYY'), 2, 5, 60);
	
/*
Insertion dans la table jeuVideo
*/
	
	INSERT INTO JEUVIDEO_O VALUES (1, 'Minecraft', 'RPG', 10, 'Mattel Games', TO_DATE('2014', 'YYYY'), 'PC', 'PEGI12');
	INSERT INTO JEUVIDEO_O VALUES (2, 'Lara croft', 'RPG', 12, 'Hasbro', TO_DATE('2002', 'YYYY'), 'XBOX', 'PEGI12');
	INSERT INTO JEUVIDEO_O VALUES (3, 'Fallout 4', 'RPG', 12, 'Bethesda Softworks', TO_DATE('2015', 'YYYY'),'PC', 'BADLANGUAGE');
	INSERT INTO JEUVIDEO_O VALUES (4, 'Mario Kart', 'course', 6, 'Asmodee', TO_DATE('2005', 'YYYY'), 'WII', 'PEGI3');
	INSERT INTO JEUVIDEO_O VALUES (5, 'Pokemon rubis', 'aventure', 6, 'Asmodee', TO_DATE('2016', 'YYYY'), 'NINTENDO DS', 'PEGI3');
	INSERT INTO JEUVIDEO_O VALUES (6, 'Along the Edge', 'aventure', 12, 'Asmodee', TO_DATE('2019', 'YYYY'), 'PC', 'PEGI12');
	INSERT INTO JEUVIDEO_O VALUES (7, 'Tetris', 'réflexion', 5, 'Ravensburger', TO_DATE('2007', 'YYYY'), 'GAMEBOY COLOR', 'PEGI3');
	INSERT INTO JEUVIDEO_O VALUES (8, 'Need for Speed', 'course', 6, 'Ravensburger', TO_DATE('2007', 'YYYY'), 'PS4', 'PEGI3');
	
/*
Insertion dans la table abonné
*/
	INSERT INTO ABONNE_O VALUES (1, 'JERRY', 'BOILLOT', 5, 'M', '12 rue du General Leclerc 06100 Nice',  TO_DATE('05/04/2019', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (2, 'SERGIO', 'RAMA', 14, 'M', '4 rue Vernier 06560 Valbonne',  TO_DATE('29/11/2018', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (3, 'LUNA', 'RAMA', 12, 'F', '4 rue Vernier 06560 Valbonne',  TO_DATE('08/11/2018', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (4, 'MATHILDE', 'TERAYAMA', 11, 'F', '41 rue des usages 06200 Nice',  TO_DATE('04/11/2014', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (5, 'TAHA', 'BAKER', 9, 'M', '62 rue du pont neuf 06500 Menton',  TO_DATE('24/11/2017', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (6, 'MOMO', 'CORY', 13, 'M', '74 Chemins des myrtilles 41000 Villerbon',  TO_DATE('04/11/2016', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (7, 'LAURA', 'FLORY', 8, 'F', '40 rue de la lune 06500 Menton',  TO_DATE('12/11/2018', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (8, 'LUCIEN', 'BOPOU', 7, 'M', '14 avenue des Canassons 06100 Nice',  TO_DATE('01/11/2018', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (9, 'ZEN', 'LEFUJI', 7, 'M', '74 rue de la mairie 06500 Menton',  TO_DATE('04/11/2016', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (10, 'THOMAS', 'BOILLOT', 11, 'M', '160 rue Garnier 06300 Nice',  TO_DATE('08/11/2016', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (11, 'MARY', 'INGILA', 9, 'F', '226 promenade des anglais 0600 Nice',  TO_DATE('26/11/2018', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (12, 'MAYA', 'LABEILLE', 14, 'F', '11 bd Gambetta 06000 Nice',  TO_DATE('22/11/2015', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (13, 'RAMI', 'ABDELLI', 13, 'M', '210 rue des luciole 06560 Valbonne',  TO_DATE('01/11/2011', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (14, 'HAKU', 'SHOU', 15, 'M', '12 rue du joyau 06100 Nice',  TO_DATE('28/11/2010', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);
	INSERT INTO ABONNE_O VALUES (15, 'KIRA', 'LEONI', 10, 'M', '21 rue St Jean 06200 Nice',  TO_DATE('28/11/2010', 'DD/MM/YYYY'), tableArticles(), tableLivres(), NULL);

/*
Insertion dans la table réduction
*/	

INSERT INTO REDUCTION_O VALUES (2, 'REDUCTION Black Friday', TO_DATE('01/12/2019', 'DD/MM/YYYY'), TO_DATE('15/12/2019', 'DD/MM/YYYY'));
INSERT INTO REDUCTION_O VALUES (3, 'REDUCTION Halloween', TO_DATE('25/10/2019', 'DD/MM/YYYY'), TO_DATE('05/11/2019', 'DD/MM/YYYY'));
INSERT INTO REDUCTION_O VALUES (4, 'REDUCTION PAQUES', TO_DATE('12/04/2020', 'DD/MM/YYYY'), TO_DATE('12/04/2020', 'DD/MM/YYYY'));

/*
Insertion dans la table abonné en utilisant PL/SQL
*/

declare
livre1 REF LIVRE_T:=NULL;
livre2 REF LIVRE_T:=NULL;
film1 REF FILM_T:=NULL;
jeuSociete1 REF JEUSOCIETE_T:=NULL;
jeuSociete2 REF JEUSOCIETE_T:=NULL;
jeuVideo1 REF JEUVIDEO_T:=NULL;
jeuVideo2 REF JEUVIDEO_T:=NULL;
reduction1 REF REDUCTION_T:=NULL;

begin

/* Creation des ref */
INSERT INTO LIVRE_O LO VALUES (11, 'Tom-Tom et Nana, Tome 2 : Tom-Tom et ses idées explosives', 'BD', AUTEURS_T('unbekannt'), 512, 14, TO_DATE('01/04/2004', 'DD/MM/YYYY'), EMPTY_CLOB())returning ref(LO) into livre1;
INSERT INTO LIVRE_O LO VALUES (12, 'Harry Potter et la chambre des secrets', 'FANTASTIQUE', AUTEURS_T('J. K. Rowling'), 368, 24, TO_DATE('02/07/1998', 'DD/MM/YYYY'), EMPTY_CLOB())returning ref(LO) into livre2;

INSERT INTO JEUSOCIETE_O JS VALUES (10, 'La Bonne Paye', 'jeu de parcours', 3, 'Hasbro', TO_DATE('14/11/2001', 'DD/MM/YYYY'), 2, 8, 10)returning ref(JS) into jeuSociete1;
INSERT INTO JEUSOCIETE_O JS VALUES (11, 'Pictionary', 'dessin', 3, 'Mattel Games', TO_DATE('16/08/2003', 'DD/MM/YYYY'), 2, 8, 10)returning ref(JS) into jeuSociete2;

INSERT INTO JEUVIDEO_O JV VALUES (9, 'Sonic Labyrinth', 'jeu de plateforme', 5, 'Hasbro', TO_DATE('2001', 'YYYY'), 'PC', 'PEGI3')returning ref(JV) into jeuVideo1;
INSERT INTO JEUVIDEO_O JV VALUES (10, 'Star Wars Jedi: Fallen Order', 'jeu de plateforme', 5, 'Hasbro', TO_DATE('2019', 'YYYY'), 'Xbox One', 'PEGI12')returning ref(JV) into jeuVideo2;

INSERT INTO REDUCTION_O RO VALUES(1, 'REDUCTION DE NOËL', TO_DATE('12/12/2019', 'DD/MM/YYYY'), TO_DATE('31/12/2019', 'DD/MM/YYYY'))returning ref(RO) into reduction1;

/* Insertions des ref crées */
INSERT INTO TABLE(SELECT a.NT_ARTICLES FROM ABONNE_O a
WHERE a.ABONNEID = 1)values (jeuSociete1);	

INSERT INTO TABLE(SELECT a.NT_ARTICLES FROM ABONNE_O a
WHERE a.ABONNEID = 2)values (jeuSociete2);	

INSERT INTO TABLE(SELECT a.NT_ARTICLES FROM ABONNE_O a
WHERE a.ABONNEID = 3)values (jeuVideo1);	

INSERT INTO TABLE(SELECT a.NT_ARTICLES FROM ABONNE_O a
WHERE a.ABONNEID = 4)values (jeuVideo2);	

INSERT INTO TABLE(SELECT a.NT_LIVRES FROM ABONNE_O a
WHERE a.ABONNEID = 5)values (livre1);

INSERT INTO TABLE(SELECT a.NT_LIVRES FROM ABONNE_O a
WHERE a.ABONNEID = 6)values (livre2);

/* ajout de réductions */

/* ajout de la reduction_ref reduction1 à l'abonné ayant l'id 4*/
UPDATE ABONNE_O a SET REDUCTION_REF = reduction1 
WHERE a.ABONNEID = 4;

/* ajout de la reduction_ref reduction1 à l'abonné ayant l'id 3*/
UPDATE ABONNE_O a SET REDUCTION_REF = reduction1 
WHERE a.ABONNEID = 3;

end;

/* Insertion indirecte dans la nested table NT_LIVRES */
INSERT INTO
TABLE(SELECT a.nt_livres FROM ABONNE_O a
WHERE a.ABONNEID = 14)SELECT REF(lo) FROM livre_o lo
WHERE lo.livreNo=1;

INSERT INTO
TABLE(SELECT a.nt_livres FROM ABONNE_O a
WHERE a.ABONNEID = 4)SELECT REF(lo) FROM livre_o lo
WHERE lo.livreNo=8;

INSERT INTO
TABLE(SELECT a.nt_livres FROM ABONNE_O a
WHERE a.ABONNEID = 12)SELECT REF(lo) FROM livre_o lo
WHERE lo.livreNo=9;

INSERT INTO
TABLE(SELECT a.nt_livres FROM ABONNE_O a
WHERE a.ABONNEID = 12)SELECT REF(lo) FROM livre_o lo
WHERE lo.livreNo=3;

INSERT INTO
TABLE(SELECT a.nt_livres FROM ABONNE_O a
WHERE a.ABONNEID = 12)SELECT REF(lo) FROM livre_o lo
WHERE lo.livreNo=5;

INSERT INTO
TABLE(SELECT a.nt_livres FROM ABONNE_O a
WHERE a.ABONNEID = 12)SELECT REF(lo) FROM livre_o lo
WHERE lo.livreNo=7;

/* Insertion indirecte dans la nested table NT_ARTICLES */
INSERT INTO
TABLE(SELECT a.NT_ARTICLES FROM ABONNE_O a
WHERE a.ABONNEID = 2)SELECT REF(jo) FROM jeuvideo_o jo
WHERE jo.ARTICLEID=7;

INSERT INTO
TABLE(SELECT a.NT_ARTICLES FROM ABONNE_O a
WHERE a.ABONNEID = 2)SELECT REF(jo) FROM jeuvideo_o jo
WHERE jo.ARTICLEID=8;

INSERT INTO
TABLE(SELECT a.NT_ARTICLES FROM ABONNE_O a
WHERE a.ABONNEID = 2)SELECT REF(jo) FROM jeuvideo_o jo
WHERE jo.ARTICLEID=9;

/* Mise à jour de la reduction_ref */

/*
	SELECTION SUR les tables livres_o, jeuvideo_o, jeusociete_o, abonne_o
*/

SELECT * FROM livre_o;
SELECT * FROM jeuvideo_o;
SELECT * FROM jeusociete_o;
SELECT * FROM abonne_o;

/*
	SELECTION SUR NESTED TABLE
	sélection des articles (titre, genre et id) de l'abonné avec l'id 2
*/
SELECT abArticles.column_value.titre as titre, abArticles.column_value.genre as genre, abArticles.column_value.ARTICLEID as id
FROM
TABLE(SELECT a.NT_ARTICLES
FROM ABONNE_O a
WHERE a.ABONNEID = 2) abArticles;

/*
	SELECTION SUR NESTED TABLE
	sélection des livres (titre, genre et id) de l'abonné avec l'id 12
*/
SELECT abl.column_value.titre as titre, abl.column_value.genre as genre, abl.column_value.dateDeParution as dateDeParution, abl.column_value.livreNo as id
FROM
TABLE(SELECT a.NT_LIVRES
FROM ABONNE_O a
WHERE a.ABONNEID = 12) abl;


/*
	SELECTION des abonnés ayant une reduction
*/
SELECT ABNOM, ABPRENOM, ABAGE, DEREF(REDUCTION_REF) as reduction
from ABONNE_O; 
WHERE reduction != null;



ABONNEID			number(8),	
	ABNOM				varchar2(50), 	
	ABPRENOM			varchar2(25), 
	ABAGE				number(20),
	ABSEXE				char(1),	
	ABADRESSE			varchar2(70),
	DATE_INSCRIPTION	date,
	NT_ARTICLES			tableArticles,
	NT_LIVRES			tableLivres,
	REDUCTION_REF			REF REDUCTION_T,


/*
Insertion dans la table film
*/

INSERT INTO FILM_O VALUES (1, 'Interstellar', 'Sci-fi', 10, 'Warner Bros.', TO_DATE('2014', 'yyyy'), 'Christopher Nolan', TABACTEURSPRINC_T('Matthew McConaughey','Anne Hathaway','Jessica Chastain','Michael Caine','Mackenzie Foy'));
INSERT INTO FILM_O VALUES (2, 'Pulp Fiction', 'Gangsters', 16, 'Jersey Films', TO_DATE('1994', 'yyyy'), 'Quentin Tarantino', TABACTEURSPRINC_T('John Travolta','Samuel L. Jackson','Bruce Willis','Uma Thurman'));
INSERT INTO FILM_O VALUES (3, 'The Revenant', 'Western', 16, 'New Regency Pictures', TO_DATE('2015', 'yyyy'), 'Alejandro Inarritu', TABACTEURSPRINC_T('Leonardo DiCaprio','Tom Hardy','Domhnall Gleeson','Will Poulter'));
INSERT INTO FILM_O VALUES (4, 'The Big Lebowski', 'Comedie', 16, 'PolyGram Filmed', TO_DATE('1998', 'yyyy'), 'Joel Coen', TABACTEURSPRINC_T('Jeff Bridges','John Goodman','Julianne Moore','Steve Buscemi'));
INSERT INTO FILM_O VALUES (5, 'Requiem for a dream', 'Drame', 16, 'Eric Watson', TO_DATE('2000', 'yyyy'), 'Darren Aronofsky', TABACTEURSPRINC_T('Ellen Burstyn','Jared Leto','Jennifer Connelly','Marlon Wayans'));
INSERT INTO FILM_O VALUES (6, 'Snatch', 'Gangsters', 16, 'Columbia Pictures', TO_DATE('2000', 'yyyy'), 'Guy Ritchie', TABACTEURSPRINC_T('Jason Statham','Stephen Graham','Brad Pitt','Dennis Farina','Alan Ford'));
INSERT INTO FILM_O VALUES (7, 'V for Vendetta', 'Anticipation', 16, 'Warner Bros.', TO_DATE('2006', 'yyyy'), 'James McTeigue', TABACTEURSPRINC_T('Natalie Portman','Hugo Weaving','Stephen Rea','John Hurt','Stephen Fry'));
INSERT INTO FILM_O VALUES (8, 'Will Hunting', 'Comedie dramatique', 13, 'Miramax Films', TO_DATE('1997', 'yyyy'), 'Gus Van Sant', TABACTEURSPRINC_T('Matt Damon','Robin Williams','Ben Affleck','Minnie Driver'));
INSERT INTO FILM_O VALUES (9, 'The Social Network', 'Drame biographique', 13, 'Michael De Luca', TO_DATE('2010', 'yyyy'), 'David Fincher', TABACTEURSPRINC_T('Jesse Eisenberg','Andrew Garfield','Justin Timberlake'));
INSERT INTO FILM_O VALUES (10, 'Shutter Island', 'Thriller psychologique', 16, 'Phoenix Pictures', TO_DATE('2010', 'yyyy'), 'Martin Scorsese', TABACTEURSPRINC_T('Leonardo DiCaprio','Mark Ruffalo','Ben Kingsley'));
