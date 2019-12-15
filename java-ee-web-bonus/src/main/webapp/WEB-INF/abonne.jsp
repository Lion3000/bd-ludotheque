<%-- 
    Document   : abonne
    Created on : 15 déc. 2019, 12:52:22
    Author     : Alex Zarzitski
--%>

<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
ResultSet abonne = (ResultSet)request.getAttribute("abonne");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.8.0/css/bulma.min.css">
        <script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
        <title>Info Abonne</title>
    </head>
    <body>
        
        <section class="section">
            <div class="container">
                <div class="card">
                    <div class="card-content">
                        <a href="./" class="button">Home</a>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                      <div class="media">
                        <div class="media-content">
                          <p class="title is-4"><% out.print(abonne.getString("ABNOM") + " " + abonne.getString("ABPRENOM")); %></p>
                          <p class="subtitle is-5">ID : <% out.print(abonne.getString("ABONNEID")); %></p>
                        </div>
                      </div>

                      <div class="content">
                        <table class="table">
                            <tr>
                                <th>Âge</th>
                                <td><% out.println(abonne.getString("ABAGE")); %></td>
                            </tr>
                            <tr>
                                <th>Sexe</th>
                                <td><% out.println(abonne.getString("ABSEXE")); %></td>
                            </tr>
                            <tr>
                                <th>Adresse</th>
                                <td><% out.println(abonne.getString("ABADRESSE")); %></td>
                            </tr>
                            <tr>
                                <th>Date d'inscription</th>
                                <td><time datetime="<% out.println(abonne.getString("DATE_INSCRIPTION")); %>"><% out.println(abonne.getString("DATE_INSCRIPTION")); %></time></td>
                            </tr>
                            <tr>
                                <th>Reduction</th>
                                <% if(abonne.getString("REDUCTIONNAME") != null && !abonne.getString("REDUCTIONNAME").isEmpty()){ %>
                                <td class="is-success"><% out.println(abonne.getString("REDUCTIONNAME")); %></td>
                                <% } else { %>
                                <td></td>
                                <% } %>
                            </tr>
                        </table>
                      </div>
                    </div>
                </div>
            </div> 
            <div class="container">
                <div class="card">
                    <div class="card-content">
                        <div class="media">
                            <div class="media-content">
                                <p class="title is-6">Liste des livres emprunter :</p>
                                <table class="table">
                                    <thead>
                                      <tr>
                                        <th>Id</th>
                                        <th>Titre</th>
                                        <th>Genre</th>
                                        <th></th>
                                      </tr>
                                    </thead>
                                    <tfoot>
                                      <tr>
                                        <th>Id</th>
                                        <th>Titre</th>
                                        <th>Genre</th>
                                        <th></th>
                                      </tr>
                                    </tfoot>
                                    <tbody>
                                        <% 
                                        ResultSet listeLivresAbonne = (ResultSet)request.getAttribute("listeLivresAbonne");
                                        while (listeLivresAbonne != null && listeLivresAbonne.next()) {
                                        %>
                                        <tr>
                                            <td><% out.println(listeLivresAbonne.getString("id")); %></td>
                                            <td><% out.println(listeLivresAbonne.getString("titre")); %></td>
                                            <td><% out.println(listeLivresAbonne.getString("genre")); %></td>
                                            <td>
                                                <form action="" method="POST">
                                                    <button class="button" name="id_rendre" value="<% out.println(listeLivresAbonne.getString("id")); %>">Rendre</button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div> 
            <div class="container">
                <div class="card">
                    <div class="card-content">
                        <div class="media">
                            <div class="media-content">
                                <p class="title is-6">Liste des livres disponibles :</p>
                                <table class="table">
                                    <thead>
                                      <tr>
                                        <th>Id</th>
                                        <th>Titre</th>
                                        <th>Genre</th>
                                        <th></th>
                                      </tr>
                                    </thead>
                                    <tfoot>
                                      <tr>
                                        <th>Id</th>
                                        <th>Titre</th>
                                        <th>Genre</th>
                                        <th></th>
                                      </tr>
                                    </tfoot>
                                    <tbody>
                                        <% 
                                        ResultSet listeLivresDisponible = (ResultSet)request.getAttribute("listeLivresDisponible");
                                        while (listeLivresDisponible != null && listeLivresDisponible.next()) {
                                        %>
                                        <tr>
                                            <td><% out.println(listeLivresDisponible.getString("id")); %></td>
                                            <td><% out.println(listeLivresDisponible.getString("titre")); %></td>
                                            <td><% out.println(listeLivresDisponible.getString("genre")); %></td>
                                            <td>
                                                <form action="" method="POST">
                                                    <button class="button" name="id_emprunter" value="<% out.println(listeLivresDisponible.getString("id")); %>">Emprunter</button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </body>
</html>
