package com.voting.servlet;

import com.voting.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteContestantManagerServlet")
public class DeleteContestantManagerServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM ContestantManagers WHERE person_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, id);
                ps.executeUpdate();
            }
            response.sendRedirect("contestant-dashboard.jsp?deleted=1");
        } catch (Exception e) {
            throw new ServletException("Error deleting contestant manager", e);
        }
    }
}
