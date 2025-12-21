package com.voting.dao;

import com.voting.model.Comment;
import com.voting.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    // Add comment (Handles parent_id for replies and initializes likes)
    public static void addComment(Comment comment) throws SQLException {
        String sql = "INSERT INTO Comments (judge_id, contestant_id, comment_text, comment_date, parent_id, likes) VALUES (?, ?, ?, ?, ?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, comment.getJudgeId());
            ps.setString(2, comment.getContestantId());
            ps.setString(3, comment.getCommentText());
            ps.setTimestamp(4, comment.getCommentDate());

            // Set parentId or NULL
            if (comment.getParentId() != null) {
                ps.setInt(5, comment.getParentId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.executeUpdate();
        }
    }

    // Get all comments for a contestant - FIX: Retrieves ID, likes, and parent_id, filtered by contestantId
    public static List<Comment> getCommentsByContestant(String contestantId) throws SQLException {
        List<Comment> comments = new ArrayList<>();
        // FIX: Ensure all fields, including the ID (primary key), are selected and filtered by contestant_id
        String sql = "SELECT id, judge_id, contestant_id, comment_text, comment_date, COALESCE(likes, 0) AS likes, parent_id FROM Comments WHERE contestant_id = ? ORDER BY comment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contestantId); // Filters by the requested contestant ID
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Comment c = new Comment();
                c.setId(rs.getInt("id"));
                c.setJudgeId(rs.getString("judge_id"));
                c.setContestantId(rs.getString("contestant_id"));
                c.setCommentText(rs.getString("comment_text"));
                c.setCommentDate(rs.getTimestamp("comment_date"));
                c.setLikes(rs.getInt("likes"));

                // Handle parent_id which can be null
                int parentId = rs.getInt("parent_id");
                if (rs.wasNull()) {
                    c.setParentId(null);
                } else {
                    c.setParentId(parentId);
                }

                comments.add(c);
            }
        }
        return comments;
    }

    // Update comment - FIX: Use comment ID
    public static void updateComment(Comment comment) throws SQLException {
        String sql = "UPDATE Comments SET comment_text = ?, comment_date = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, comment.getCommentText());
            ps.setTimestamp(2, comment.getCommentDate());
            ps.setInt(3, comment.getId()); // Using the comment's ID
            ps.executeUpdate();
        }
    }

    // Delete comment - FIX: Use comment ID
    public static void deleteComment(int commentId) throws SQLException {
        String sql = "DELETE FROM Comments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId); // Using the comment's ID
            ps.executeUpdate();
        }
    }

    // React/Like Comment
    public static void reactComment(int commentId) throws SQLException {
        String sql = "UPDATE Comments SET likes = COALESCE(likes, 0) + 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ps.executeUpdate();
        }
    }
}