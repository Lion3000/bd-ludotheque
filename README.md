# Projet de BD - M1
## Groupe :
- Camelia Zarzitski Benhmida
- Alex Zarzitski
- Maël Vaillant--Beuchot

## Contraintes
- Rendre le résultat dans un seul script. Ce script doit aussi contenir les tests et les résultat des tests
- Dernier délai : 15 décembre 2019

## Compte rendu
- Le script sql avec les résultats des tests est dans "fullProject.sql"
- le code du bonus Java EE est dans "java-ee-web-bonus"
- les photos avec les explications de l'applicatif web sont dans "img-web-bonus", à suivre dans l'ordre des numéros
- l'uml a été réalisé avec Bouml, le projet est dans "uml-ludotheque"
- la photo de l'uml est à la racine : "uml.png"

## Répartition des taches
- Camelia Zarzitski Benhmida 
  - Création des types et tables Abonne_t, reduction_t, reduction_o, abonne_o, avec les contraintes sur les tables
  - Sélection d'objets à travers les références
  - insertion d'objets dans les différentes tables et nested tables
  - suppression et update des objets, objets dans nested tables et références (listes de films, de livres et d'articles)
  
- Alex Zarzitski
   - Création des types et tables jeu video, jeu societe et livre 
   - gestion de l'héritage (jeuvideo et jeusociete héritant de article)
   - programmation de l'interface web avec Java JEE connecté à Oracle local
   - gestion du clob en collaboration avec Camelia
   
- Maël Vaillant--Beuchot
   - Création des types et tables articles et films
   - Gestion de l'héritage avec films qui hérite d'articles
   - Création des trois méthodes de films
   - Insertions des données de la table films
   - Aide à la création des VARRAY et NESTED TABLE utilisées dans le projet
   - Nettoyage et vérification du code final

## UML
- Vert - Camelia Zarzitski Benhmida
- Jaune - Alex Zarzitski
- Violet - Maël Vaillant--Beuchot

![Alt text](https://github.com/Lion3000/bd-ludotheque/blob/master/uml.png?raw=true "UML")
