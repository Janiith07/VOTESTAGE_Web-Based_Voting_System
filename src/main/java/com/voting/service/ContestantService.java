package com.voting.service;

import com.voting.dao.ContestantDAO;
import com.voting.dao.VoterDAO;
import com.voting.model.Contestant;
import com.voting.model.Voter;

import java.sql.SQLException;

import static com.voting.dao.VoterDAO.getVoterById;

public class ContestantService {

    public static void registerContestant(Contestant contestant) throws SQLException {
        ContestantDAO.insertContestant(contestant);
    }

    public static Contestant getContestantById(String id) throws SQLException {
        return ContestantDAO.getContestantById(id);
    }

    public static void receiveVote(String contestantId) throws SQLException {
        Contestant contestant = getContestantById(contestantId);

        if (contestant == null) {
            throw new IllegalArgumentException("Contestant not found");
        }

        contestant.setTotalVotesReceived(contestant.getTotalVotesReceived() + 1);
        ContestantDAO.updateContestant(contestant);

        System.out.println(contestant.getName() + " received a vote! Total: " + contestant.getTotalVotesReceived());
    }

    // ❌ eliminateContestant() method REMOVED — no longer needed
    public static void castVote(String voterId, String contestantId) throws SQLException {
        Voter voter = getVoterById(voterId);
        if (voter == null) {
            throw new IllegalArgumentException("Voter not found");
        }

        Contestant contestant = ContestantDAO.getContestantById(contestantId);
        if (contestant == null) {
            throw new IllegalArgumentException("Contestant not found");
        }

        // ✅ NO ELIMINATION CHECK — contestants can always receive votes

        contestant.setTotalVotesReceived(contestant.getTotalVotesReceived() + 1);
        ContestantDAO.updateContestant(contestant);

        voter.setVoteCount(voter.getVoteCount() + 1);
        VoterDAO.updateVoter(voter);

        System.out.println("✅ Vote cast successfully by " + voter.getName() +
                " for contestant " + contestant.getName());
    }
}