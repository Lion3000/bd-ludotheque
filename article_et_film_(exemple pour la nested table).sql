drop table ARTICLE_O;

/* Création du type article */
create or replace type ARTICLE_T AS OBJECT (
    ARTICLEID	number(8),
    TITRE   varchar2(15),
    GENRE   varchar2(15),
    AGEMINIMAL   number(3),
    EDITEUR varchar2(15),
    DATEPARUTION date,
    
    ORDER MEMBER function compArticle (article IN ARTICLE_T) return number
)NOT FINAL;

/* Création de la liste de référence des articles */
create or replace type listRefArticle_t as table of REF ARTICLE_T;

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

/* -------------------- */
create or replace type ActeursPrinc_t IS TABLE OF varchar2(75);

/* Création du type film */
create or replace type FILM_T UNDER ARTICLE_T (
    REALISATEUR   varchar2(30),
    ACTEURS_PRINC   ActeursPrinc_t
);

/* Création de la liste de référence des films */
create or replace type listRefFilm_t as table of REF FILM_T;

/* Création de la table objet film avec ses contraintes */
create table film_o of film_t(
	CONSTRAINT nnl_film_o_realisateur REALISATEUR NOT NULL
)
nested table ACTEURS_PRINC store as STOREACTEURS_PRINC;

/* ================================================= */

INSERT INTO FILM_O(TITRE, GENRE, AGEMINIMAL, EDITEUR, DATEPARUTION, REALISATEUR, ACTEURS_PRINC) VALUES ("Interstellar", "Sci-fi", "3", "Warner Bros.", TO_DATE('2014/11/05', 'yyyy/mm/dd'), "Christopher Nolan", ActeursPrinc_t('Matthew McConaughey','Anne Hathaway','Jessica Chastain','Michael Caine','Mackenzie Foy'))
INSERT INTO FILM_O(REALISATEUR, ACTEURS_PRINC) VALUES ("d", "ACTEURSPRINC_T('Matthew McConaughey','Anne Hathaway','Jessica Chastain','Michael Caine','Mackenzie Foy')")
/* voir l'insertion nested table dans le td */