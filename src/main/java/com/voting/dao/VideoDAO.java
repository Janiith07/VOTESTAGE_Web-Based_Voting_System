package com.voting.dao;

import com.voting.model.Video;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VideoDAO {

    private static final String URL =
            "jdbc:sqlserver://localhost:1433;databaseName=VotingDB3;encrypt=false;trustServerCertificate=true";
    private static final String USER = "sa";         // ✅ your SQL Server user
    private static final String PASS = "12";   // ✅ your SQL Server password

    // 🔹 Get a connection
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found.", e);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // 🔹 Insert new video (store relative path)
    public int insertVideo(String title, String description, String filePath,
                           String contestantId, String adminId, String singer, String duration) throws SQLException {
        String sql = "INSERT INTO Video " +
                "(title, description, file_path, contestant_id, admin_id, original_singer, duration) " +
                "OUTPUT INSERTED.video_id VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, filePath); // ✅ relative path like "videos/uuid.mp4"
            ps.setString(4, contestantId);
            ps.setString(5, adminId);
            ps.setString(6, singer);
            ps.setString(7, duration);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1); // return generated video_id
            }
        }
        return -1;
    }

    // 🔹 Get all videos
    public List<Video> getAllVideos() throws SQLException {
        List<Video> list = new ArrayList<>();
        String sql = "SELECT * FROM Video ORDER BY upload_date DESC";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // 🔹 Get one video
    public Video getVideo(int videoId) throws SQLException {
        String sql = "SELECT * FROM Video WHERE video_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, videoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    // 🔹 Update metadata
    public boolean updateVideoMetadata(int videoId, String title, String description) throws SQLException {
        String sql = "UPDATE Video SET title = ?, description = ? WHERE video_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, videoId);
            return ps.executeUpdate() > 0;
        }
    }

    // 🔹 Delete video
    public boolean deleteVideo(int videoId) throws SQLException {
        String sql = "DELETE FROM Video WHERE video_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, videoId);
            return ps.executeUpdate() > 0;
        }
    }

    // 🔹 Helper: map ResultSet → Video object
    private Video mapRow(ResultSet rs) throws SQLException {
        Video v = new Video();
        v.setVideoId(rs.getInt("video_id"));
        v.setTitle(rs.getString("title"));
        v.setDescription(rs.getString("description"));
        v.setFilePath(rs.getString("file_path")); // relative path "videos/uuid.mp4"
        v.setContestantId(rs.getString("contestant_id"));
        v.setAdminId(rs.getString("admin_id"));
        v.setSinger(rs.getString("original_singer"));
        v.setDuration(rs.getString("duration"));
        v.setUploadedAt(rs.getTimestamp("upload_date"));
        return v;
    }
}
