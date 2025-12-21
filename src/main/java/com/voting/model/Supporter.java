package com.voting.model;

public class Supporter extends Person {
    private String supporterLevel; // Matches DB column: supporter_level

    public Supporter() {
        this.role = "ITSupporter";
    }

    public Supporter(String id, String name, String email, String password, String supporterLevel) {
        super(id, name, email, password, "ITSupporter");
        this.supporterLevel = supporterLevel != null ? supporterLevel : "Support"; // Default
    }

    public String getSupporterLevel() {
        return supporterLevel;
    }

    public void setSupporterLevel(String supporterLevel) {
        this.supporterLevel = supporterLevel;
    }

    public void handleSupportTicket() {
        System.out.println(getName() + " (" + supporterLevel + ") is handling a support ticket.");
    }

    @Override
    public String toString() {
        return "ITSupporter{" +
                "supporterLevel='" + supporterLevel + '\'' +
                ", name='" + getName() + '\'' +
                '}';
    }
}