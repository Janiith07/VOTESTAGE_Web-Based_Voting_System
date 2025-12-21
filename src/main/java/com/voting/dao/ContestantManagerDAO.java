package com.voting.dao;
import com.voting.model.ContestantManager;
import com.voting.dao.PersonDAO;
import com.voting.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ContestantManagerDAO {

    public static void insertContestantManager(ContestantManager contestantManager) throws SQLException {
        System.out.println("ContestantManagerDAO.insertContestantManager called with: " + contestantManager);
        
        String personId = PersonDAO.insertPerson(contestantManager);
        System.out.println("PersonDAO.insertPerson returned personId: " + personId);

        String sql = "INSERT INTO ContestantManagers (person_id, manager_level) VALUES (?, ?)";
        System.out.println("Executing SQL: " + sql);
        System.out.println("Parameters: personId=" + personId + ", managerLevel=" + contestantManager.getManagerLevel());

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setString(2, contestantManager.getManagerLevel());

            int rowsAffected = ps.executeUpdate();
            System.out.println("ContestantManagers insert completed. Rows affected: " + rowsAffected);
        }
    }

    public static ContestantManager getContestantManagerById(String id) throws SQLException {
        ContestantManager contestantManager = new ContestantManager();
        String sql = "SELECT p.*, cm.manager_level FROM Persons p JOIN ContestantManagers cm ON p.person_id = cm.person_id WHERE p.person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                contestantManager.setId(rs.getString("person_id"));
                contestantManager.setName(rs.getString("name"));
                contestantManager.setEmail(rs.getString("email"));
                contestantManager.setPassword(rs.getString("password"));
                contestantManager.setRole(rs.getString("role"));
                contestantManager.setManagerLevel(rs.getString("manager_level"));
            }
            return contestantManager;
        }
    }

    public static void updateContestantManager(ContestantManager contestantManager) throws SQLException {
        String sql = "UPDATE ContestantManagers SET manager_level = ? WHERE person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, contestantManager.getManagerLevel());
            ps.setString(2, contestantManager.getId());

            ps.executeUpdate();
        }
    }

    public static boolean deleteContestantManager(String id) throws SQLException {
        // Delete from ContestantManagers table first (due to foreign key)
        String sql = "DELETE FROM ContestantManagers WHERE person_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            int rowsAffected = ps.executeUpdate();
            
            // Then delete from Persons table (this will cascade)
            if (rowsAffected > 0) {
                return PersonDAO.deletePersonById(id);
            }
            return false;
        }
    }

    public static java.util.List<ContestantManager> getAllContestantManagers() throws SQLException {
        java.util.List<ContestantManager> managers = new java.util.ArrayList<>();
        String sql = "SELECT p.*, cm.manager_level FROM Persons p JOIN ContestantManagers cm ON p.person_id = cm.person_id ORDER BY p.person_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ContestantManager manager = new ContestantManager();
                manager.setId(rs.getString("person_id"));
                manager.setName(rs.getString("name"));
                manager.setEmail(rs.getString("email"));
                manager.setPassword(rs.getString("password"));
                manager.setRole(rs.getString("role"));
                manager.setManagerLevel(rs.getString("manager_level"));
                managers.add(manager);
            }
        }
        return managers;
    }
}
