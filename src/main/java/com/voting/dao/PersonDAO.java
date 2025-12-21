package com.voting.dao;
import com.voting.model.*;
import com.voting.util.DBConnection;
import java.sql.*;
public class PersonDAO {

    // Method to generate the next person_id in format P001, P002, etc.
    private static String generateNextPersonId() throws SQLException {
        String sql = "SELECT MAX(person_id) FROM Persons";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                String maxId = rs.getString(1);
                if (maxId == null) {
                    return "P001"; // First person
                }
                // Extract numeric part and increment
                int numericPart = Integer.parseInt(maxId.substring(1));
                numericPart++;
                return String.format("P%03d", numericPart);
            }
            return "P001";
        }
    }

    public static String insertPerson(Person person) throws SQLException {
        String personId = generateNextPersonId();
        String sql = "INSERT INTO Persons (person_id, name, email, password, role) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setString(2, person.getName());
            ps.setString(3, person.getEmail());
            ps.setString(4, person.getPassword());
            ps.setString(5, person.getRole());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return personId;
            }
            return null;
        }
    }

    public static Person getPersonById(String id) throws SQLException {
        String sql = "SELECT * FROM Persons WHERE person_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Person p = new Person();
                p.setId(rs.getString("person_id"));
                p.setName(rs.getString("name"));
                p.setEmail(rs.getString("email"));
                p.setPassword(rs.getString("password"));
                p.setRole(rs.getString("role"));
                return p;
            }
            return null;
        }
    }

    public static Person findByEmailAndPassword(String email, String password) throws SQLException {
        String sql = "SELECT * FROM Persons WHERE email = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            System.out.println("🔍 Executing SQL: " + sql);
            System.out.println("   ➤ Email: " + email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Person p = new Person();
                p.setId(rs.getString("person_id"));
                p.setName(rs.getString("name"));
                p.setEmail(rs.getString("email"));
                p.setPassword(rs.getString("password"));
                p.setRole(rs.getString("role"));
                return p;
            } else {
                System.out.println("❌ No person found with email=" + email);
                return null;
            }

        } catch (SQLException e) {
            System.err.println("❌ SQL Error in findByEmailAndPassword: " + e.getMessage());
            throw e;
        }
    }

    public static boolean updatePassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE Persons SET password = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public static boolean updateVoterDetails(String personId, String name, String email, String password) throws SQLException {
        String sql = "UPDATE Persons SET name = ?, email = ?, password = ? WHERE person_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, personId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public static boolean updateVoterNameEmail(String personId, String name, String email) throws SQLException {
        String sql = "UPDATE Persons SET name = ?, email = ? WHERE person_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, personId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public static boolean deletePersonById(String personId) throws SQLException {
        String sql = "DELETE FROM Persons WHERE person_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, personId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public static java.util.List<Person> getAllPersons() throws SQLException {
        java.util.List<Person> persons = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Persons ORDER BY person_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Person p = new Person();
                p.setId(rs.getString("person_id"));
                p.setName(rs.getString("name"));
                p.setEmail(rs.getString("email"));
                p.setPassword(rs.getString("password"));
                p.setRole(rs.getString("role"));
                persons.add(p);
            }
        }
        return persons;
    }
}
