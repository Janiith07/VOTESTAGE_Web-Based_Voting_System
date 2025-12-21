package com.voting.dao;

import com.voting.model.Content;
import com.voting.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContentDAO {

    // Fetch pending content (e.g., unreviewed or unapproved)
    public List<Content> fetchPendingContent() throws SQLException {
        List<Content> contents = new ArrayList<>();
        String sql = "SELECT * FROM Content WHERE status = 'PENDING'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Content content = new Content();
                content.setId(rs.getInt("id"));
                content.setUserId(rs.getString("user_id"));
                content.setContentType(rs.getString("content_type"));
                content.setContentText(rs.getString("content_text"));
                content.setCreatedAt(rs.getTimestamp("created_at"));
                content.setFlagged(rs.getBoolean("flagged"));
                content.setStatus(rs.getString("status"));
                contents.add(content);
            }
        }
        return contents;
    }

    // Flag content (mark inappropriate)
    public boolean flagContent(int contentId, String reason, String adminId) throws SQLException {
        String sql = "UPDATE Content SET flagged = 1, status = 'FLAGGED' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, contentId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Remove content
    public boolean removeContent(int contentId, String adminId) throws SQLException {
        String sql = "DELETE FROM Content WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, contentId);
            return stmt.executeUpdate() > 0;
        }
    }
}
