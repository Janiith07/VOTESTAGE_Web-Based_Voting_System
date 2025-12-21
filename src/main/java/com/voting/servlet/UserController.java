package com.voting.servlet;

import com.voting.dao.PersonDAO;
import com.voting.model.Person;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manage-users")
public class UserController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Optional: Check if user has admin or IT supporter role
        String userRole = (String) session.getAttribute("user_role");
        if (userRole != null) {
            userRole = userRole.trim().toLowerCase();
            if (!userRole.equals("admin") && !userRole.equals("itsupporter")) {
                response.sendRedirect("index.jsp?error=Access denied. Admin or IT Supporter role required.");
                return;
            }
        }
        
        try {
            // Fetch all users from database
            List<Person> allUsers = PersonDAO.getAllPersons();
            
            // Set users as request attribute
            request.setAttribute("users", allUsers);
            
            // Check for messages from URL parameters and set as attributes
            String message = request.getParameter("message");
            if (message != null) {
                request.setAttribute("message", message);
            }
            
            String error = request.getParameter("error");
            if (error != null) {
                request.setAttribute("error", error);
            }
            
            // Forward to JSP
            request.getRequestDispatcher("/manage-users.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/manage-users.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}