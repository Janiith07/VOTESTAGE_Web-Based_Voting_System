package com.voting.model;

public class Contestant extends Person {
    private int age;
    private String gender;
    private int totalVotesReceived;

    public Contestant() {
        this.role = "Contestant";
    }

    public Contestant(String id, String name, String email, String password, int age, String gender) {
        super(id, name, email, password, "Contestant");
        this.age = age;
        this.gender = gender;
        this.totalVotesReceived = 0;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getTotalVotesReceived() {
        return totalVotesReceived;
    }

    public void setTotalVotesReceived(int totalVotesReceived) {
        if (totalVotesReceived < 0) {
            throw new IllegalArgumentException("Total votes cannot be negative");
        }
        this.totalVotesReceived = totalVotesReceived;
    }

    public void receiveVote() {
        this.totalVotesReceived++;
        System.out.println(getName() + " received a vote! Total: " + totalVotesReceived);
    }

    @Override
    public String toString() {
        return "Contestant{" +
                "age=" + age +
                ", gender='" + gender + '\'' +
                ", totalVotesReceived=" + totalVotesReceived +
                ", name='" + getName() + '\'' +
                '}';
    }
}