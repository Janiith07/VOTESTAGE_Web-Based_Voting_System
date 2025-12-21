package com.voting.dao;
import com.voting.model.Contestant;
import com.voting.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ContestantDAO {

    public static void insertContestant(Contestant contestant) throws SQLException {
        String personId = PersonDAO.insertPerson(contestant);

        String sql = "INSERT INTO Contestants (person_id, age, gender, total_votes_received) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setInt(2, contestant.getAge());
            ps.setString(3, contestant.getGender());
            ps.setInt(4, contestant.getTotalVotesReceived());

            ps.executeUpdate();
        }
    }

    public static Contestant getContestantById(String id) throws SQLException {
        Contestant contestant = new Contestant();
        String sql = "SELECT p.*, c.age, c.gender, c.total_votes_received FROM Persons p JOIN Contestants c ON p.person_id = c.person_id WHERE p.person_id = ? ";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                contestant.setId(rs.getString("person_id"));
                contestant.setName(rs.getString("name"));
                contestant.setEmail(rs.getString("email"));
                contestant.setPassword(rs.getString("password"));
                contestant.setRole(rs.getString("role"));
                contestant.setAge(rs.getInt("age"));
                contestant.setGender(rs.getString("gender"));
                contestant.setTotalVotesReceived(rs.getInt("total_votes_received"));
            }
            return contestant;
        }
    }

    public static void updateContestant(Contestant contestant) throws SQLException {
        String sql = "UPDATE Contestants SET age = ?, gender = ?, total_votes_received = ? WHERE person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, contestant.getAge());
            ps.setString(2, contestant.getGender());
            ps.setInt(3, contestant.getTotalVotesReceived());
            ps.setString(4, contestant.getId());

            ps.executeUpdate();
        }
    }
}