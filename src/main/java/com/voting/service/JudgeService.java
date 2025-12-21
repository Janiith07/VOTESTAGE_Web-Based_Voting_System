package com.voting.service;

import com.voting.dao.JudgeDAO;
import com.voting.model.Judge;
import com.voting.util.DBConnection;

import java.sql.ResultSet;
import java.sql.SQLException;

public class JudgeService {

    public static void registerJudge(Judge judge) throws SQLException {
        if (judge == null) {
            throw new IllegalArgumentException("Judge object cannot be null");
        }
        JudgeDAO.insertJudge(judge);
    }

    public static Judge getJudgeById(String id) throws SQLException {
        return JudgeDAO.getJudgeById(id);
    }

    // New method to handle golden vote
    public static boolean recordGoldenVote(String judgeId, String contestantId, String contestantName,
                                           String performance, String judgeName) throws SQLException {
        // Check if judge has already given golden vote to this contestant
        if (JudgeDAO.hasGivenGoldenVote(judgeId, contestantId)) {
            return false; // Already voted
        }

        JudgeDAO.recordGoldenVote(judgeId, contestantId, contestantName, performance, judgeName);
        return true;
    }

    // Get golden votes for display
    public static ResultSet getGoldenVotes() throws SQLException {
        return JudgeDAO.getGoldenVotes();
    }

    // Add this method to your JudgeService.java

    // New method to handle regular vote
    public static boolean recordRegularVote(String judgeId, String contestantId, String contestantName,
                                            String performance, String judgeName) throws SQLException {
        // Check if judge has already given regular vote to this contestant today
        if (JudgeDAO.hasGivenRegularVoteToday(judgeId, contestantId)) {
            return false; // Already voted today
        }

        JudgeDAO.recordRegularVote(judgeId, contestantId, contestantName, performance, judgeName);
        return true;
    }

    // Add this method to your existing JudgeService.java
    public static boolean hasGivenGoldenVote(String judgeId, String contestantId) throws SQLException {
        return JudgeDAO.hasGivenGoldenVote(judgeId, contestantId);
    }

    // Add this method to your existing JudgeService.java
    public static boolean revokeGoldenVote(String judgeId, String contestantId) throws SQLException {
        return JudgeDAO.revokeGoldenVote(judgeId, contestantId);
    }

    // Check if judge has already given any golden vote
    public static boolean hasGivenAnyGoldenVote(String judgeId) throws SQLException {
        return JudgeDAO.hasGivenAnyGoldenVote(judgeId);
    }

    // Get current golden vote details for judge
    public static ResultSet getJudgeGoldenVote(String judgeId) throws SQLException {
        return JudgeDAO.getJudgeGoldenVote(judgeId);
    }
}