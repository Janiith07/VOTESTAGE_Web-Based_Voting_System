package com.voting.servlet;

import com.voting.dao.NotificationDAO;
import com.voting.model.Notification;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Test servlet to manually create notifications for debugging
 */
@WebServlet("/test-notification")
public class TestNotificationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userId = (String) session.getAttribute("user_id");
        String userName = (String) session.getAttribute("user_name");
        
        try {
            // Create a test notification
            String message = "Test notification for " + userName + " (ID: " + userId + ") - This is a test message! 🧪";
            Notification testNotification = new Notification(userId, "P999", message, "TEST");
            
            // Add to database
            NotificationDAO.addNotification(testNotification);
            
            System.out.println("🧪 TestNotificationServlet: Created test notification for user " + userId);
            
            response.getWriter().write("<h1>Test Notification Created!</h1>");
            response.getWriter().write("<p>User ID: " + userId + "</p>");
            response.getWriter().write("<p>Message: " + message + "</p>");
            response.getWriter().write("<p><a href='contestant-dashboard.jsp'>Go to Dashboard</a></p>");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("<h1>Error creating test notification</h1>");
            response.getWriter().write("<p>Error: " + e.getMessage() + "</p>");
        }
    }
}
