// Cr�ation du type article
create or replace type ARTICLE_T AS OBJECT (
    ARTICLEID	number(8),
    TITRE   varchar2(15),
    GENRE   varchar2(15),
    AGEMINIMAL   number(3),
    EDITEUR varchar2(15),
    DATEPARUTION date,
    
    ORDER MEMBER function compArticle (article IN ARTICLE_T) return number
);

// Cr�ation de la liste de r�f�rence des articles
create or replace type listRefArticle_t as table of REF ARTICLE_T;

// Cr�ation de la table objet article avec ses contraintes
create table article_o of article_t(
	CONSTRAINT pk_article_o_articleid PRIMARY KEY(ARTICLEID),
	CONSTRAINT nnl_article_o_titre TITRE NOT NULL,
	CONSTRAINT nnl_article_o_genre GENRE NOT NULL,
	CONSTRAINT nnl_article_o_ageminimal AGEMINIMAL NOT NULL,
	CONSTRAINT nnl_article_o_editeur EDITEUR NOT NULL,
	CONSTRAINT nnl_article_o_dateparution DATEPARUTION NOT NULL,
	CONSTRAINT chk_article_o_dateparution CHECK(DATEPARUTION <= NOW())
);

// ----------------------
create or replace type nested_table_film_type IS TABLE OF varchar2(15);

// Cr�ation du type film
create or replace type FILM_T UNDER ARTICLE_T (
    REALISATEUR   varchar2(15),
    ACTEURS_PRINC   nested_table_film_type,
    
    ORDER MEMBER function compFilm (film IN FILM_T) return number
);

// Cr�ation de la liste de r�f�rence des films
create or replace type listRefFilm_t as table of REF FILM_T;

// Cr�ation de la table objet film avec ses contraintes
create table film_o of film_t(
	CONSTRAINT nnl_film_o_realisateur REALISATEUR NOT NULL,
	CONSTRAINT nnl_film_o_acteurs_princ ACTEURS_PRINC NOT NULL
);