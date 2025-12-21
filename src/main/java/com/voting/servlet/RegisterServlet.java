package com.voting.servlet;
import com.voting.model.*;
import com.voting.service.*;
import com.voting.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to registration form
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Server-side password validation
        if (password == null || password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Additional password validation
        if (!password.matches(".*[a-zA-Z].*")) {
            request.setAttribute("error", "Password must contain at least one letter.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.matches(".*\\d.*")) {
            request.setAttribute("error", "Password must contain at least one number.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            // Register as Voter
            Voter voter = new Voter();
            voter.setName(name);
            voter.setEmail(email);
            voter.setPassword(password);
            voter.setRole("Voter");
            voter.setVoteCount(0);

            VoterService.registerVoter(voter);

            request.setAttribute("message", "Registration successful! You can now log in.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}