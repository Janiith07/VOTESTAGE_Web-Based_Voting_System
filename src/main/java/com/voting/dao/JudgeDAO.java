package com.voting.dao;
import com.voting.model.Judge;
import com.voting.observer.VotingSubject;
import com.voting.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class JudgeDAO {
    
    // Static instance of VotingSubject for Observer pattern
    private static final VotingSubject votingSubject = new VotingSubject();
    
    /**
     * Get the VotingSubject instance
     * @return VotingSubject instance
     */
    public static VotingSubject getVotingSubject() {
        return votingSubject;
    }

    public static void insertJudge(Judge judge) throws SQLException {
        String personId = PersonDAO.insertPerson(judge);

        String sql = "INSERT INTO Judges (person_id, judge_vote_count) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setInt(2, judge.getJudgeVoteCount());

            ps.executeUpdate();
        }
    }

    public static Judge getJudgeById(String id) throws SQLException {
        Judge judge = new Judge();
        String sql = "SELECT p.*, j.judge_vote_count FROM Persons p JOIN Judges j ON p.person_id = j.person_id WHERE p.person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                judge.setId(rs.getString("person_id"));
                judge.setName(rs.getString("name"));
                judge.setEmail(rs.getString("email"));
                judge.setPassword(rs.getString("password"));
                judge.setRole(rs.getString("role"));
                judge.setJudgeVoteCount(rs.getInt("judge_vote_count"));
                return judge; // Don't forget to return the judge
            }
        }
        return null; // Return null if not found
    }

    // New method to record golden vote
    public static void recordGoldenVote(String judgeId, String contestantId, String contestantName,
                                        String performance, String judgeName) throws SQLException {
        
        // First, verify that the contestant exists in Persons table
        String checkSql = "SELECT COUNT(*) FROM Persons WHERE person_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            
            checkPs.setString(1, contestantId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next() && rs.getInt(1) == 0) {
                throw new SQLException("Contestant with ID '" + contestantId + "' does not exist in Persons table. Please run the database migration script.");
            }
        }
        
        String sql = "INSERT INTO golden_votes (judge_id, contestant_id, contestant_name, performance, judge_name, vote_date) VALUES (?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ps.setString(2, contestantId);
            ps.setString(3, contestantName);
            ps.setString(4, performance);
            ps.setString(5, judgeName);

            ps.executeUpdate();
            
            // Notify observers about the golden vote using Observer pattern
            System.out.println("🏆 JudgeDAO: Golden vote recorded, notifying observers...");
            votingSubject.notifyGoldenVote(contestantId, judgeId, judgeName);
        }
    }

    // Get golden votes for dashboard
    public static ResultSet getGoldenVotes() throws SQLException {
        String sql = "SELECT * FROM golden_votes ORDER BY vote_date DESC";
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }

    // Get golden votes received by a specific contestant
    public static ResultSet getGoldenVotesByContestant(String contestantId) throws SQLException {
        String sql = "SELECT * FROM golden_votes WHERE contestant_id = ? ORDER BY vote_date DESC";
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, contestantId);
        return ps.executeQuery();
    }

    // Check if judge has already given golden vote to contestant
    public static boolean hasGivenGoldenVote(String judgeId, String contestantId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM golden_votes WHERE judge_id = ? AND contestant_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ps.setString(2, contestantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }


    // Check if judge has already given any golden vote (to any contestant)
    public static boolean hasGivenAnyGoldenVote(String judgeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM golden_votes WHERE judge_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }


    // Get current golden vote details for judge
    public static ResultSet getJudgeGoldenVote(String judgeId) throws SQLException {
        String sql = "SELECT * FROM golden_votes WHERE judge_id = ?";
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, judgeId);
        return ps.executeQuery();
    }

    // Method to revoke golden vote
    public static boolean revokeGoldenVote(String judgeId, String contestantId) throws SQLException {
        String sql = "DELETE FROM golden_votes WHERE judge_id = ? AND contestant_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ps.setString(2, contestantId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Method to record regular vote
    public static void recordRegularVote(String judgeId, String contestantId, String contestantName,
                                         String performance, String judgeName) throws SQLException {
        String sql = "INSERT INTO RegularVotes (voter_id, contestant_id, contestant_name, performance, judge_id, judge_name, vote_type, score) VALUES (?, ?, ?, ?, ?, ?, 'Regular', 10)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);        // voter_id
            ps.setString(2, contestantId);   // contestant_id
            ps.setString(3, contestantName); // contestant_name
            ps.setString(4, performance); // performance
            ps.setString(5, judgeId);        // judge_id (same as voter_id for judges)
            ps.setString(6, judgeName);   // judge_name

            ps.executeUpdate();
        }
    }

    // Check if judge has already given regular vote to contestant today
    public static boolean hasGivenRegularVoteToday(String judgeId, String contestantId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM RegularVotes WHERE judge_id = ? AND contestant_id = ? AND CONVERT(DATE, vote_date) = CONVERT(DATE, GETDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ps.setString(2, contestantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }
}