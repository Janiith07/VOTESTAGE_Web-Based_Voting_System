package com.voting.servlet;

import com.voting.dao.PersonDAO;
import com.voting.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("➡️ DEBUG: Login attempt - Email: " + email);

        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Find person by email + password
            Person person = PersonDAO.findByEmailAndPassword(email, password);

            if (person != null) {
                System.out.println("✅ DEBUG: Login successful for: " + person.getName());

                // Start session
                HttpSession session = request.getSession();
                session.setAttribute("user_id", person.getId());
                session.setAttribute("user_role", person.getRole()); // ✅ FIXED: Remove .toLowerCase()
                session.setAttribute("user_name", person.getName());

                // Redirect based on role (use lowercase for redirect logic only)
                String role = person.getRole();
                if (role != null) role = role.trim().toLowerCase();
                switch (role) {
                    case "admin" -> response.sendRedirect("admin-dashboard.jsp");
                    case "voter" -> response.sendRedirect("contestant-performance.jsp");
                    case "judge" -> response.sendRedirect("judge-dashboard.jsp");
                    case "contestant" -> response.sendRedirect("contestant-dashboard.jsp");
                    case "contestantmanager" -> response.sendRedirect("contestant-dashboard.jsp");
                    case "itsupporter" -> response.sendRedirect("manage-users.jsp");
                    default -> response.sendRedirect("index.jsp");
                }

            } else {
                System.out.println("❌ DEBUG: Invalid email or password");
                request.setAttribute("error", "Invalid email or password. Please try again.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("🔥 DATABASE ERROR: " + e.getMessage());
            request.setAttribute("error", "Database error. Please try again later.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}