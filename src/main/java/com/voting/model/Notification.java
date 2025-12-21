package com.voting.model;

import java.time.LocalDateTime;

/**
 * Notification model class for storing notification information
 */
public class Notification {
    private int notificationId;
    private String recipientId;
    private String senderId;
    private String message;
    private String type;
    private LocalDateTime createdAt;
    private boolean isRead;
    
    // Constructors
    public Notification() {}
    
    public Notification(String recipientId, String senderId, String message, String type) {
        this.recipientId = recipientId;
        this.senderId = senderId;
        this.message = message;
        this.type = type;
        this.createdAt = LocalDateTime.now();
        this.isRead = false;
    }
    
    public Notification(int notificationId, String recipientId, String senderId, String message, String type, LocalDateTime createdAt, boolean isRead) {
        this.notificationId = notificationId;
        this.recipientId = recipientId;
        this.senderId = senderId;
        this.message = message;
        this.type = type;
        this.createdAt = createdAt;
        this.isRead = isRead;
    }
    
    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }
    
    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }
    
    public String getRecipientId() {
        return recipientId;
    }
    
    public void setRecipientId(String recipientId) {
        this.recipientId = recipientId;
    }
    
    public String getSenderId() {
        return senderId;
    }
    
    public void setSenderId(String senderId) {
        this.senderId = senderId;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean read) {
        isRead = read;
    }
    
    @Override
    public String toString() {
        return "Notification{" +
                "notificationId=" + notificationId +
                ", recipientId='" + recipientId + '\'' +
                ", senderId='" + senderId + '\'' +
                ", message='" + message + '\'' +
                ", type='" + type + '\'' +
                ", createdAt=" + createdAt +
                ", isRead=" + isRead +
                '}';
    }
}
