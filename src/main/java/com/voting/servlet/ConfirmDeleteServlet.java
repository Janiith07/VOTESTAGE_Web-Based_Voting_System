// com/voting/servlet/ConfirmDeleteServlet.java
package com.voting.servlet;

import com.voting.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/confirm-delete")
public class ConfirmDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String id = request.getParameter("id");

            // First delete from role table, then from Persons
            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);

                // Delete from all possible role tables (safe)
                String[] roleTables = {"Voters", "Admins", "Contestants", "Judges", "ITSupporters"};
                for (String table : roleTables) {
                    String sql = "DELETE FROM " + table + " WHERE person_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, id);
                        ps.executeUpdate();
                    }
                }

                // Delete from Persons
                String sql = "DELETE FROM Persons WHERE person_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, id);
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        request.setAttribute("message", "User deleted successfully!");
                    } else {
                        request.setAttribute("message", "User not found!");
                    }
                }

                conn.commit();
            }

            response.sendRedirect("manage-users");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/manage-users").forward(request, response);
        }
    }
}