package com.voting.model;


public class Admin extends Person {
    private String adminLevel; // e.g., "Super", "Moderator", "Support"

    public Admin() {
        this.role = "Admin";
    }

    public Admin(String id, String name, String email, String password, String adminLevel) {
        super(id, name, email, password, "Admin");
        this.adminLevel = adminLevel;
    }

    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }

    @Override
    public String toString() {
        return "Admin{" +
                "adminLevel='" + adminLevel + '\'' +
                ", name='" + getName() + '\'' +
                '}';
    }
}
