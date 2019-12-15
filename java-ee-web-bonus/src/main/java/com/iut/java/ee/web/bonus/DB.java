/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iut.java.ee.web.bonus;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;



/**
 *
 * @author Alex Zarzitski
 */
public class DB {
    private Connection conn;
    public void connect(){
        try {
            DriverManager.registerDriver (new oracle.jdbc.OracleDriver());
            this.conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "alex", "123");
            if (conn != null) {
                System.out.println("Connected to the database!");
            } else {
                System.out.println("Failed to make connection!");
            }
        } catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception e) {
        }
    }
    
    public void desconnect(){
        try {
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public ResultSet select(String request){
        ResultSet result = null;
        try {
            Statement stmt = conn.createStatement();
            result = stmt.executeQuery(request);
        } catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }
    
    public void execut(String request){
        try {
            Statement stmt = conn.createStatement();
            stmt.execute(request);
        } catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
