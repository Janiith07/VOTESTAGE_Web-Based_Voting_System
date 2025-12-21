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
import java.util.List;

/**
 * Servlet for handling notification operations
 */
@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    
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
        String action = request.getParameter("action");
        
        try {
            System.out.println("🔔 NotificationServlet: Request received - User: " + userId + ", Action: " + action);
            
            if ("getCount".equals(action)) {
                // Return unread notification count as JSON
                int unreadCount = NotificationDAO.getUnreadNotificationCount(userId);
                System.out.println("🔔 NotificationServlet: Unread count for " + userId + ": " + unreadCount);
                response.setContentType("application/json");
                response.getWriter().write("{\"unreadCount\": " + unreadCount + "}");
                
            } else if ("getAll".equals(action)) {
                // Return all notifications as JSON
                List<Notification> notifications = NotificationDAO.getNotificationsByRecipient(userId);
                System.out.println("🔔 NotificationServlet: Found " + notifications.size() + " notifications for " + userId);
                response.setContentType("application/json");
                
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < notifications.size(); i++) {
                    Notification notification = notifications.get(i);
                    System.out.println("🔔 NotificationServlet: Processing notification " + (i+1) + ": " + notification.getMessage());
                    
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"id\":").append(notification.getNotificationId()).append(",")
                        .append("\"recipientId\":\"").append(notification.getRecipientId()).append("\",")
                        .append("\"senderId\":\"").append(notification.getSenderId()).append("\",")
                        .append("\"message\":\"").append(notification.getMessage().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r")).append("\",")
                        .append("\"type\":\"").append(notification.getType()).append("\",")
                        .append("\"createdAt\":\"").append(notification.getCreatedAt()).append("\",")
                        .append("\"isRead\":").append(notification.isRead())
                        .append("}");
                }
                json.append("]");
                
                String jsonResponse = json.toString();
                System.out.println("🔔 NotificationServlet: JSON response: " + jsonResponse);
                response.getWriter().write(jsonResponse);
                
            } else {
                // Default: redirect to contestant dashboard with notifications
                response.sendRedirect("contestant-dashboard.jsp");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error occurred\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userId = (String) session.getAttribute("user_id");
        String action = request.getParameter("action");
        
        try {
            if ("markAsRead".equals(action)) {
                String notificationIdStr = request.getParameter("notificationId");
                if (notificationIdStr != null) {
                    int notificationId = Integer.parseInt(notificationIdStr);
                    NotificationDAO.markNotificationAsRead(notificationId);
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Notification ID required\"}");
                }
                
            } else if ("markAllAsRead".equals(action)) {
                NotificationDAO.markAllNotificationsAsRead(userId);
                response.getWriter().write("{\"success\": true}");
                
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action\"}");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error occurred\"}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid notification ID\"}");
        }
    }
}
