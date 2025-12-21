package com.voting.dao;

import com.voting.model.Notification;
import com.voting.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for handling Notification database operations
 */
public class NotificationDAO {
    
    /**
     * Add a new notification to the database
     * @param notification the notification to add
     * @throws SQLException if database error occurs
     */
    public static void addNotification(Notification notification) throws SQLException {
        String sql = "INSERT INTO Notifications (recipient_id, sender_id, message, type, created_at, is_read) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, notification.getRecipientId());
            ps.setString(2, notification.getSenderId());
            ps.setString(3, notification.getMessage());
            ps.setString(4, notification.getType());
            ps.setTimestamp(5, Timestamp.valueOf(notification.getCreatedAt()));
            ps.setBoolean(6, notification.isRead());
            
            ps.executeUpdate();
            System.out.println("✅ NotificationDAO: Notification added successfully");
        }
    }
    
    /**
     * Get all notifications for a specific recipient
     * @param recipientId the recipient's ID
     * @return list of notifications
     * @throws SQLException if database error occurs
     */
    public static List<Notification> getNotificationsByRecipient(String recipientId) throws SQLException {
        System.out.println("🔔 NotificationDAO: Getting notifications for recipient: " + recipientId);
        
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE recipient_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, recipientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Notification notification = mapRow(rs);
                notifications.add(notification);
                System.out.println("🔔 NotificationDAO: Found notification: " + notification.getMessage());
            }
        }
        
        System.out.println("🔔 NotificationDAO: Total notifications found: " + notifications.size());
        return notifications;
    }
    
    /**
     * Get unread notifications count for a specific recipient
     * @param recipientId the recipient's ID
     * @return count of unread notifications
     * @throws SQLException if database error occurs
     */
    public static int getUnreadNotificationCount(String recipientId) throws SQLException {
        System.out.println("🔔 NotificationDAO: Getting unread count for recipient: " + recipientId);
        
        String sql = "SELECT COUNT(*) FROM Notifications WHERE recipient_id = ? AND is_read = 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, recipientId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("🔔 NotificationDAO: Unread count for " + recipientId + ": " + count);
                return count;
            }
        }
        
        System.out.println("🔔 NotificationDAO: No unread notifications found for " + recipientId);
        return 0;
    }
    
    /**
     * Mark a notification as read
     * @param notificationId the notification ID to mark as read
     * @throws SQLException if database error occurs
     */
    public static void markNotificationAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE notification_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            ps.executeUpdate();
        }
    }
    
    /**
     * Mark all notifications as read for a specific recipient
     * @param recipientId the recipient's ID
     * @throws SQLException if database error occurs
     */
    public static void markAllNotificationsAsRead(String recipientId) throws SQLException {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE recipient_id = ? AND is_read = 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, recipientId);
            ps.executeUpdate();
        }
    }
    
    /**
     * Map ResultSet row to Notification object
     * @param rs the ResultSet
     * @return Notification object
     * @throws SQLException if database error occurs
     */
    private static Notification mapRow(ResultSet rs) throws SQLException {
        return new Notification(
            rs.getInt("notification_id"),
            rs.getString("recipient_id"),
            rs.getString("sender_id"),
            rs.getString("message"),
            rs.getString("type"),
            rs.getTimestamp("created_at").toLocalDateTime(),
            rs.getBoolean("is_read")
        );
    }
}
