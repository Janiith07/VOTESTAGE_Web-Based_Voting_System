package com.voting.dao;

import com.voting.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;

public class VotingDAO {

    /**
     * Save voting window/start-end times for an event/competition.
     * Assumes an events table or competitions table exists with id = eventId.
     */
    public boolean setVotingWindow(int eventId, LocalDateTime start, LocalDateTime end, String adminId) throws Exception {
        String sql = "UPDATE events SET voting_start = ?, voting_end = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setObject(1, java.sql.Timestamp.valueOf(start));
            ps.setObject(2, java.sql.Timestamp.valueOf(end));
            ps.setInt(3, eventId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Checks whether voting is currently active for an event.
     */
    public boolean isVotingActive(int eventId) throws Exception {
        String sql = "SELECT voting_start, voting_end FROM events WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.sql.Timestamp s = rs.getTimestamp("voting_start");
                    java.sql.Timestamp e = rs.getTimestamp("voting_end");
                    if (s == null || e == null) return false;
                    java.time.Instant now = java.time.Instant.now();
                    return now.isAfter(s.toInstant()) && now.isBefore(e.toInstant());
                } else {
                    return false;
                }
            }
        }
    }
}
