package com.voting.dao;

import com.voting.model.Supporter;
import com.voting.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SupporterDAO {

    /**
     * Inserts a new Supporter into the database.
     * First inserts into Persons, then into ITSupporters table.
     */
    public static void insertSupporter(Supporter supporter) throws SQLException {
        String personId = PersonDAO.insertPerson(supporter); // Uses supporter.getRole() → "ITSupporter"

        String sql = "INSERT INTO ITSupporters (person_id, supporter_level) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setString(2, supporter.getSupporterLevel());

            ps.executeUpdate();
        }
    }

    /**
     * Retrieves a Supporter by person_id.
     */
    public static Supporter getSupporterById(String id) throws SQLException {
        Supporter supporter = null;
        String sql = "SELECT p.*, s.supporter_level FROM Persons p JOIN ITSupporters s ON p.person_id = s.person_id WHERE p.person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                supporter = new Supporter();
                supporter.setId(rs.getString("person_id"));
                supporter.setName(rs.getString("name"));
                supporter.setEmail(rs.getString("email"));
                supporter.setPassword(rs.getString("password"));
                supporter.setRole(rs.getString("role")); // Should be "ITSupporter"
                supporter.setSupporterLevel(rs.getString("supporter_level"));
            }
        }
        return supporter;
    }

    /**
     * Updates an existing Supporter's supporter level.
     */
    public static void updateSupporter(Supporter supporter) throws SQLException {
        String sql = "UPDATE ITSupporters SET supporter_level = ? WHERE person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, supporter.getSupporterLevel());
            ps.setString(2, supporter.getId());

            ps.executeUpdate();
        }
    }

    /**
     * Deletes a Supporter by person_id.
     * Since ITSupporters has FK to Persons with ON DELETE CASCADE,
     * deleting from Persons will automatically delete from ITSupporters.
     */
    public static boolean deleteSupporter(String personId) throws SQLException {
        return PersonDAO.deletePersonById(personId);
    }

    /**
     * Gets all Supporters from the database.
     */
    public static List<Supporter> getAllSupporters() throws SQLException {
        List<Supporter> supporters = new ArrayList<>();
        String sql = "SELECT p.*, s.supporter_level FROM Persons p JOIN ITSupporters s ON p.person_id = s.person_id ORDER BY p.name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supporter s = new Supporter();
                s.setId(rs.getString("person_id"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                s.setRole(rs.getString("role"));
                s.setSupporterLevel(rs.getString("supporter_level"));
                supporters.add(s);
            }
        }
        return supporters;
    }

    /**
     * Checks if a Supporter exists by email.
     */
    public static boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Persons WHERE email = ? AND role = 'ITSupporter'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}