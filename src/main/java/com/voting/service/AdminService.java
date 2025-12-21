package com.voting.service;


import com.voting.dao.AdminDAO;
import com.voting.model.*;
import com.voting.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminService {

    public static void createAdmin(Admin admin) throws SQLException {
        if (admin.getAdminLevel() == null || admin.getAdminLevel().trim().isEmpty()) {
            admin.setAdminLevel("Support"); // Default level
        }

        AdminDAO.insertAdmin(admin);
    }

    public static Admin getAdminById(String id) throws SQLException {
        return AdminDAO.getAdminById(id);
    }

    // com/voting/service/AdminService.java (add this method)
    public static List<Person> getAllUsers() throws SQLException {
        String sql = "SELECT * FROM Persons ORDER BY person_id";
        List<Person> users = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String role = rs.getString("role");
                Person person = createPersonByRole(rs, role);
                users.add(person);
            }
        }

        return users;
    }

    private static Person createPersonByRole(ResultSet rs, String role) throws SQLException {
        Person person;
        String id = rs.getString("person_id");
        String name = rs.getString("name");
        String email = rs.getString("email");
        String password = rs.getString("password");
        String roleValue = rs.getString("role");

        switch (role) {
            case "Voter" -> person = new Voter();
            case "Admin" -> person = new Admin();
            case "Contestant" -> person = new Contestant();
            case "Judge" -> person = new Judge();
            case "ITSupporter" -> person = new Supporter(); // ✅ Add this line
            default -> person = new Person();
        }

        person.setId(id);
        person.setName(name);
        person.setEmail(email);
        person.setPassword(password);
        person.setRole(roleValue);

        return person;
    }
}
