package com.voting.service;

import com.voting.dao.VoterDAO;
import com.voting.dao.ContestantDAO;
import com.voting.model.Voter;
import com.voting.model.Contestant;
import com.voting.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VoterService {

    public static void registerVoter(Voter voter) throws SQLException {
        // Validation
        if (voter.getEmail() == null || voter.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (voter.getName() == null || voter.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Name is required");
        }
        if (voter.getPassword() == null || voter.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }

        // Check if email already exists
        if (isEmailExists(voter.getEmail())) {
            throw new IllegalArgumentException("Email already registered");
        }

        // Set default vote count for new users
        voter.setVoteCount(0);

        // Insert into database
        VoterDAO.insertVoter(voter);

        System.out.println("New voter registered: " + voter.getName() + " (" + voter.getEmail() + ")");
    }

    public static Voter getVoterByEmail(String email) throws SQLException {
        String sql = "SELECT p.person_id, p.name, p.email, p.password, p.role, v.vote_count " +
                "FROM Persons p JOIN Voters v ON p.person_id = v.person_id " +
                "WHERE p.email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Voter voter = new Voter();
                voter.setId(rs.getString("person_id"));
                voter.setName(rs.getString("name"));
                voter.setEmail(rs.getString("email"));
                voter.setPassword(rs.getString("password"));
                voter.setRole(rs.getString("role"));
                voter.setVoteCount(rs.getInt("vote_count"));
                return voter;
            }
            return null;
        }
    }

    // Add this method to check if email exists
    public static boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Persons WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public static Voter getVoterById(String id) throws SQLException {
        return VoterDAO.getVoterById(id);
    }

    // ✅ IMPLEMENTED: Cast a vote for a contestant
    public static void castVote(String voterId, String contestantId) throws SQLException {
        // 1. Get the voter
        Voter voter = getVoterById(voterId);
        if (voter == null) {
            throw new IllegalArgumentException("Voter not found");
        }

        // 2. Get the contestant
        Contestant contestant = ContestantDAO.getContestantById(contestantId);
        if (contestant == null) {
            throw new IllegalArgumentException("Contestant not found");
        }

        // 3. Increment contestant's vote count
        contestant.setTotalVotesReceived(contestant.getTotalVotesReceived() + 1);
        ContestantDAO.updateContestant(contestant);

        // 4. Increment voter's vote count
        voter.setVoteCount(voter.getVoteCount() + 1);
        VoterDAO.updateVoter(voter);

        System.out.println("✅ Vote cast successfully by " + voter.getName() +
                " for contestant " + contestant.getName());
    }

    public static boolean recordRegularVote(String voterId, String contestantId, String contestantName,
                                            String performance, String voterName) throws SQLException {
        System.out.println("VoterService: Recording regular vote...");

        // Check if already voted today
        if (VoterDAO.hasGivenRegularVoteToday(voterId, contestantId)) {
            System.out.println("VoterService: Already voted today - returning false");
            return false;
        }

        // Save the vote
        String voteDate = VoterDAO.getCurrentDateTime();
        VoterDAO.saveVote(voterId, contestantId, voteDate, 10, "Regular", "Active");
        System.out.println("VoterService: Vote saved to database");

        // Update voter's vote count
        Voter voter = getVoterById(voterId);
        if (voter != null) {
            voter.setVoteCount(voter.getVoteCount() + 1);
            VoterDAO.updateVoter(voter);
            System.out.println("VoterService: Voter count updated");
        }

        return true;
    }

    // ✅ NEW: Check if regular vote was given today
    public static boolean hasGivenRegularVoteToday(String voterId, String contestantId) throws SQLException {
        return VoterDAO.hasGivenRegularVoteToday(voterId, contestantId);
    }

}