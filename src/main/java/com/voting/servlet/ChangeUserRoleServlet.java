// com/voting/servlet/ChangeUserRoleServlet.java
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

@WebServlet("/change-user-role")
public class ChangeUserRoleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String id = request.getParameter("id");
            String newRole = request.getParameter("newRole");

            if (newRole == null || newRole.trim().isEmpty()) {
                request.setAttribute("error", "Please select a valid role.");
                request.getRequestDispatcher("/manage-users").forward(request, response);
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);

                // 1. Delete from all role tables
                String[] roleTables = {"Voters", "Admins", "Contestants", "ContestantManagers", "Judges", "ITSupporters"};
                for (String table : roleTables) {
                    String sql = "DELETE FROM " + table + " WHERE person_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, id);
                        ps.executeUpdate();
                    }
                }

                // 2. Update role in Persons table
                String sql = "UPDATE Persons SET role = ? WHERE person_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, newRole);
                    ps.setString(2, id);
                    ps.executeUpdate();
                }

                // 3. Insert into new role table (minimal data)
                insertIntoNewRoleTable(conn, id, newRole);

                conn.commit();
                request.setAttribute("message", "User role changed to " + newRole + " successfully!");
            }

            response.sendRedirect("manage-users");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/manage-users").forward(request, response);
        }
    }

    private void insertIntoNewRoleTable(Connection conn, String personId, String role) throws SQLException {
        String sql;
        PreparedStatement ps;

        switch (role) {
            case "Voter" -> {
                sql = "INSERT INTO Voters (person_id, vote_count) VALUES (?, 0)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, personId);
                ps.executeUpdate();
            }
            case "Admin" -> {
                sql = "INSERT INTO Admins (person_id, admin_level) VALUES (?, 'Support')";
                ps = conn.prepareStatement(sql);
                ps.setString(1, personId);
                ps.executeUpdate();
            }
            case "Contestant" -> {
                sql = "INSERT INTO Contestants (person_id, age, gender, total_votes_received) VALUES (?, 0, 'Not Specified', 0)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, personId);
                ps.executeUpdate();
            }
            case "ContestantManager" -> {
                sql = "INSERT INTO ContestantManagers (person_id, manager_level) VALUES (?, 'Standard')";
                ps = conn.prepareStatement(sql);
                ps.setString(1, personId);
                ps.executeUpdate();
            }
            case "Judge" -> {
                sql = "INSERT INTO Judges (person_id, judge_vote_count) VALUES (?, 0)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, personId);
                ps.executeUpdate();
            }
            case "ITSupporter" -> {
                sql = "INSERT INTO ITSupporters (person_id, supporter_level) VALUES (?, 'Support')";
                ps = conn.prepareStatement(sql);
                ps.setString(1, personId);
                ps.executeUpdate();
            }
            default -> {}
        }
    }
}