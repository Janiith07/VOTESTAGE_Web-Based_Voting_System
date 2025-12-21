package com.voting.model;

public class ContestantManager extends Person {
    private String managerLevel;

    public ContestantManager() {
        this.role = "ContestantManager";
    }

    public ContestantManager(String id, String name, String email, String password, String managerLevel) {
        super(id, name, email, password, "ContestantManager");
        this.managerLevel = managerLevel;
    }

    public String getManagerLevel() {
        return managerLevel;
    }

    public void setManagerLevel(String managerLevel) {
        this.managerLevel = managerLevel;
    }

    @Override
    public String toString() {
        return "ContestantManager{" +
                "managerLevel='" + managerLevel + '\'' +
                ", name='" + getName() + '\'' +
                ", email='" + getEmail() + '\'' +
                '}';
    }
}
