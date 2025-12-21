// com/voting/servlet/ForgotPasswordServlet.java
package com.voting.servlet;

import com.voting.dao.PersonDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");

        if (email == null || email.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        // Server-side password validation
        if (newPassword.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        // Additional password validation
        if (!newPassword.matches(".*[a-zA-Z].*")) {
            request.setAttribute("error", "Password must contain at least one letter.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.matches(".*\\d.*")) {
            request.setAttribute("error", "Password must contain at least one number.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            // Update password directly (no security answer)
            boolean updated = PersonDAO.updatePassword(email, newPassword);
            if (updated) {
                request.setAttribute("message", "✅ Password updated successfully! You can now login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to update password. Please check your email.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}