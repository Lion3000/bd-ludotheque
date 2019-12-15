<%-- 
    Document   : home
    Created on : 14 déc. 2019, 23:01:23
    Author     : Alex Zarzitski
--%>

<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.8.0/css/bulma.min.css">
        <script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
        <title>Liste des abonnes</title>
    </head>
    <body>
        <section class="section">
            <div class="container">
                <h1 class="title">
                  Liste des abonnes
                </h1>
                <table class="table">
                    <thead>
                      <tr>
                        <th>Id</th>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Âge</th>
                        <th>Sexe</th>
                        <th>Adresse</th>
                        <th>Date d'inscription</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tfoot>
                      <tr>
                        <th>Id</th>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Âge</th>
                        <th>Sexe</th>
                        <th>Adresse</th>
                        <th>Date d'inscription</th>
                        <th></th>
                      </tr>
                    </tfoot>
                    <tbody>
                        <% 
                        ResultSet listeAbonnes = (ResultSet)request.getAttribute("listeAbonnes");
                        while ( listeAbonnes != null && listeAbonnes.next()) {
                        %>
                        <tr>
                            <td><% out.println(listeAbonnes.getString("ABONNEID")); %></td>
                            <td><% out.println(listeAbonnes.getString("ABNOM")); %></td>
                            <td><% out.println(listeAbonnes.getString("ABPRENOM")); %></td>
                            <td><% out.println(listeAbonnes.getString("ABAGE")); %></td>
                            <td><% out.println(listeAbonnes.getString("ABSEXE")); %></td>
                            <td><% out.println(listeAbonnes.getString("ABADRESSE")); %></td>
                            <td><% out.println(listeAbonnes.getString("DATE_INSCRIPTION")); %></td>
                            <td><a href="./abonnes?id=<% out.println(listeAbonnes.getString("ABONNEID")); %>" class="button">Résumé</a></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </body>
</html>
