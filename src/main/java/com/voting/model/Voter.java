package com.voting.model;

public class Voter extends Person {
    private int voteCount;

    public Voter() {
        this.role = "Voter";
    }

    public Voter(String id, String name, String email, String password, int voteCount) {
        super(id, name, email, password, "Voter");
        this.voteCount = voteCount;
    }

    public int getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }

    @Override
    public String toString() {
        return "Voter{" +
                "voteCount=" + voteCount +
                ", name='" + getName() + '\'' + // Fixed: use getName() instead of 'name'
                '}';
    }
}