package com.voting.dao;
import com.voting.model.Voter;
import com.voting.util.DBConnection;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class VoterDAO {

    public static void insertVoter(Voter voter) throws SQLException {
        // First, insert into Persons
        String personId = PersonDAO.insertPerson(voter);

        // ✅ FIXED: Define SQL string
        String sql = "INSERT INTO Voters (person_id, vote_count) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setInt(2, voter.getVoteCount());

            ps.executeUpdate();
        }
    }

    public static Voter getVoterById(String id) throws SQLException {
        Voter voter = null;
        String sql = "SELECT p.person_id, p.name, p.email, p.password, p.role, v.vote_count FROM Persons p JOIN Voters v ON p.person_id = v.person_id WHERE p.person_id = ? ";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                voter = new Voter();
                voter.setId(rs.getString("person_id"));
                voter.setName(rs.getString("name"));
                voter.setEmail(rs.getString("email"));
                voter.setPassword(rs.getString("password"));
                voter.setRole(rs.getString("role"));
                voter.setVoteCount(rs.getInt("vote_count"));
            }
            return voter;
        }
    }

    // ✅ Optional: Add update method for casting votes
    public static void updateVoter(Voter voter) throws SQLException {
        String sql = "UPDATE Voters SET vote_count = ? WHERE person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, voter.getVoteCount());
            ps.setString(2, voter.getId());

            System.out.println("Updating voter ID: " + voter.getId() + " with vote_count: " + voter.getVoteCount());
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            if (rowsAffected == 0) {
                System.err.println("❌ No rows updated. Voter ID " + voter.getId() + " may not exist in Voters table.");
            }
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in updateVoter: " + e.getMessage());
            throw e;
        }

    }

    // ✅ New method to save vote to RegularVotes table
    public static void saveVote(String voterId, String contestantId, String voteDate, int score, String voteType, String status) throws SQLException {
        String sql = "INSERT INTO RegularVotes (voter_id, contestant_id, vote_date, score, vote_type, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, voterId);
            ps.setString(2, contestantId);
            ps.setString(3, voteDate);
            ps.setInt(4, score);
            ps.setString(5, voteType);
            ps.setString(6, status);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                System.err.println("❌ No rows inserted. Vote for voter ID " + voterId + " may not have saved.");
            } else {
                System.out.println("✅ Vote saved for voter ID " + voterId + " and contestant ID " + contestantId);
            }
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in saveVote: " + e.getMessage());
            throw e;
        }
    }

    // Check if voter has already given regular vote to contestant today
    public static boolean hasGivenRegularVoteToday(String voterId, String contestantId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM RegularVotes WHERE voter_id = ? AND contestant_id = ? AND CONVERT(DATE, vote_date) = CONVERT(DATE, GETDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, voterId);
            ps.setString(2, contestantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    // Method to get current date time string
    public static String getCurrentDateTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date());
    }

    public static void recordRegularVote(String judgeId, String contestantId, String contestantName, String performance, String judgeName) {
    }
}