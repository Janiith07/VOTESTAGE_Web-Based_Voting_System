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
 * Test servlet to create notifications with detailed content for debugging
 */
@WebServlet("/test-notification-content")
public class TestNotificationContentServlet extends HttpServlet {
    
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
            // Create multiple test notifications with different content
            String[] testMessages = {
                "Judge John Doe (ID: P002) gave you a golden vote! 🏆",
                "Judge Sarah Smith (ID: P003) voted for your performance! ⭐",
                "System notification: Your performance was reviewed by Judge Mike (ID: P004)",
                "Welcome to the voting system! Good luck with your performance! 🎵"
            };
            
            String[] senderIds = {"P002", "P003", "P004", "P001"};
            
            response.getWriter().write("<h1>Creating Test Notifications</h1>");
            
            for (int i = 0; i < testMessages.length; i++) {
                Notification testNotification = new Notification(
                    userId, 
                    senderIds[i], 
                    testMessages[i], 
                    "TEST_NOTIFICATION"
                );
                
                NotificationDAO.addNotification(testNotification);
                response.getWriter().write("<p>✅ Created notification " + (i+1) + ": " + testMessages[i] + "</p>");
            }
            
            response.getWriter().write("<p><strong>Recipient ID:</strong> " + userId + "</p>");
            response.getWriter().write("<p><strong>User Name:</strong> " + userName + "</p>");
            response.getWriter().write("<p><a href='contestant-dashboard.jsp'>Go to Dashboard to see notifications</a></p>");
            
            System.out.println("🧪 TestNotificationContentServlet: Created " + testMessages.length + " test notifications for user " + userId);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("<h1>Error creating test notifications</h1>");
            response.getWriter().write("<p>Error: " + e.getMessage() + "</p>");
        }
    }
}
