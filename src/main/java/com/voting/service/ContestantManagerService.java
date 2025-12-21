package com.voting.service;

import com.voting.dao.ContestantManagerDAO;
import com.voting.dao.VoterDAO;
import com.voting.model.ContestantManager;
import com.voting.model.Voter;

import java.sql.SQLException;

import static com.voting.dao.VoterDAO.getVoterById;

public class ContestantManagerService {

    public static void registerContestantManager(ContestantManager contestantManager) throws SQLException {
        ContestantManagerDAO.insertContestantManager(contestantManager);
    }

    public static ContestantManager getContestantManagerById(String id) throws SQLException {
        return ContestantManagerDAO.getContestantManagerById(id);
    }

    public static void updateContestantManager(ContestantManager contestantManager) throws SQLException {
        ContestantManagerDAO.updateContestantManager(contestantManager);
    }

    public static boolean deleteContestantManager(String id) throws SQLException {
        return ContestantManagerDAO.deleteContestantManager(id);
    }

    public static java.util.List<ContestantManager> getAllContestantManagers() throws SQLException {
        return ContestantManagerDAO.getAllContestantManagers();
    }

    // Note: ContestantManagers don't receive votes like contestants did
    // This service focuses on manager functionality rather than voting
    public static void castVote(String voterId, String contestantManagerId) throws SQLException {
        Voter voter = getVoterById(voterId);
        if (voter == null) {
            throw new IllegalArgumentException("Voter not found");
        }

        ContestantManager contestantManager = ContestantManagerDAO.getContestantManagerById(contestantManagerId);
        if (contestantManager == null) {
            throw new IllegalArgumentException("ContestantManager not found");
        }

        // ContestantManagers can receive votes (similar to contestants)
        // Note: This maintains compatibility with existing voting system
        voter.setVoteCount(voter.getVoteCount() + 1);
        VoterDAO.updateVoter(voter);

        System.out.println("✅ Vote cast successfully by " + voter.getName() +
                " for contestant manager " + contestantManager.getName());
    }
}
