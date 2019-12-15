package com.iut.java.ee.web.bonus;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Alex Zarzitski
 */
@WebServlet(urlPatterns = {"/abonnes"})
public class Abonnes extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (PrintWriter out = response.getWriter()) {
            String idAbonne  = request.getParameter( "id" );
            if(!idAbonne.isEmpty()){
                DB db = new DB();
                db.connect();
                ResultSet abonne = db.select("SELECT "
                        + "ABONNEID, ABNOM, ABPRENOM, ABAGE, ABSEXE, "
                        + "ABADRESSE, DATE_INSCRIPTION, "
                        + "DEREF(REDUCTION_REF).REDUCTIONNAME as REDUCTIONNAME "
                        + "FROM ABONNE_O "
                        + "WHERE ABONNEID = " + idAbonne);
                if(abonne.next()){
                    removeBook(idAbonne, request, db);
                    addBook(idAbonne, request, db);
                    
                    ResultSet listeLivresAbonne = db.select("SELECT abl.titre as titre, abl.genre as genre, abl.dateDeParution as dateDeParution, abl.livreNo as id " +
                                                            "FROM " +
                                                            "TABLE(SELECT a.NT_LIVRES " +
                                                            "FROM ABONNE_O a " +
                                                            "WHERE a.ABONNEID = " + idAbonne + ") abl");
                    ResultSet listeLivresDisponible = db.select("SELECT abl.titre as titre, abl.genre as genre, abl.dateDeParution as dateDeParution, abl.livreNo as id " +
                                                            "FROM LIVRE_O abl");
                    request.setAttribute("abonne", abonne);
                    request.setAttribute("listeLivresAbonne", listeLivresAbonne);
                    request.setAttribute("listeLivresDisponible", listeLivresDisponible);
                    this.getServletContext().getRequestDispatcher("/WEB-INF/abonne.jsp").forward(request, response);
                }
                else{
                    throw new Exception("abonne not fond!");
                }
            }
            else{
                throw new Exception("id not fond!");
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    private void removeBook(String idAbonne, HttpServletRequest request, DB db){
        try{
            String id_rendre  = request.getParameter( "id_rendre" );
            if(!id_rendre.isEmpty()){
                db.execut(
                    "DELETE FROM TABLE( " +
                    "SELECT ab.NT_LIVRES FROM ABONNE_O ab " +
                    "WHERE ab.ABONNEID=" + idAbonne + " ) livres " +
                    "WHERE livres.livreno = " + id_rendre
                );
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    private void addBook(String idAbonne, HttpServletRequest request, DB db){
        try{
            String id_emprunter  = request.getParameter( "id_emprunter" );
            if(!id_emprunter.isEmpty()){
                db.execut(
                    "INSERT INTO " +
                    "TABLE(SELECT a.nt_livres FROM ABONNE_O a " +
                    "WHERE a.ABONNEID = " + idAbonne + ")SELECT * FROM livre_o lo " +
                    "WHERE lo.livreNo = " + id_emprunter
                );
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
