drop table ARTICLE_O cascade constraints;
drop table FILM_O cascade constraints;
drop type ACTEURSPRINC_T force;
drop type ARTICLE_T force;
drop type FILM_T force;
drop type LISTREFARTICLE_T force;
drop type LISTREFFILM_T force;

/* Types forward */
create or replace type ARTICLE_T;
create or replace type FILM_T;

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
create or replace type tabActeursPrinc_t as varray(5) of varchar2(50);

/* Création du type film */
create or replace type FILM_T UNDER ARTICLE_T (
    REALISATEUR   varchar2(30),
    ACTEURS_PRINC   tabActeursPrinc_t
);

/* Création de la liste de référence des films */
create or replace type listRefFilm_t as table of REF FILM_T;

/* Création de la table objet film avec ses contraintes */
create table film_o of film_t(
	CONSTRAINT nnl_film_o_realisateur REALISATEUR NOT NULL
);

/* ================================================= */
declare

begin
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
end;