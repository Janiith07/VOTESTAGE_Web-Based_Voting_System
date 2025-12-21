package com.voting.model;

public class Judge extends Person {
    private int judgeVoteCount; // Matches DB column "judge_vote_count"

    public Judge() {
        this.role = "Judge";
    }

    // Constructor WITHOUT expertise
    public Judge(String id, String name, String email, String password) {
        super(id, name, email, password, "Judge");
        this.judgeVoteCount = 0;
    }

    public int getJudgeVoteCount() {
        return judgeVoteCount;
    }

    public void setJudgeVoteCount(int judgeVoteCount) {
        this.judgeVoteCount = judgeVoteCount;
    }

    @Override
    public String toString() {
        return "Judge{" +
                "judgeVoteCount=" + judgeVoteCount +
                ", name='" + getName() + '\'' +
                '}';
    }
}