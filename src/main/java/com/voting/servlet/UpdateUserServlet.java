package com.voting.servlet;

import com.voting.dao.PersonDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/update-user")
public class UpdateUserServlet extends HttpServlet {

    // Helper method to check if role can manage users
    private boolean canManageUsers(String role) {
        return "Admin".equals(role) || "ITSupporter".equals(role);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String userRole = (String) session.getAttribute("user_role");
            if (userRole == null || !canManageUsers(userRole)) {
                response.sendRedirect("manage-users?error=Access+Denied:+Insufficient+privileges");
                return;
            }

            // Get parameters
            String idParam = request.getParameter("id");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (idParam == null || idParam.trim().isEmpty() ||
                    name == null || name.trim().isEmpty() ||
                    email == null || email.trim().isEmpty()) {
                response.sendRedirect("manage-users?error=Missing+required+fields");
                return;
            }

            String userId = idParam.trim();

            // Update based on whether password is provided
            boolean updated;
            if (password != null && !password.trim().isEmpty()) {
                updated = PersonDAO.updateVoterDetails(userId, name, email, password);
            } else {
                updated = PersonDAO.updateVoterNameEmail(userId, name, email);
            }

            if (updated) {
                response.sendRedirect("manage-users?message=User+updated+successfully!");
            } else {
                response.sendRedirect("manage-users?error=Failed+to+update+user");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users?error=Database+error");
        }
    }
}