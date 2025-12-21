package com.voting.dao;
import com.voting.model.Admin;
import com.voting.util.DBConnection;
import java.sql.*;
public class AdminDAO {
    public static void insertAdmin(Admin admin) throws SQLException {
        String personId = PersonDAO.insertPerson(admin);

        String sql = "INSERT INTO Admins (person_id, admin_level) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setString(2, admin.getAdminLevel());

            ps.executeUpdate();
        }
    }

    public static Admin getAdminById(String id) throws SQLException {
        Admin admin = new Admin();
        String sql = "SELECT p.*, a.admin_level FROM Persons p JOIN Admins a ON p.person_id = a.person_id WHERE p.person_id = ? ";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                admin.setId(rs.getString("person_id"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                admin.setRole(rs.getString("role"));
                admin.setAdminLevel(rs.getString("admin_level"));
            }
            return admin;
        }
    }
}
