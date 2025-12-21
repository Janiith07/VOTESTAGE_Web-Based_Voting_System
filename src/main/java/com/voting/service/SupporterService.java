package com.voting.service;

import com.voting.dao.SupporterDAO;
import com.voting.model.Supporter;

import java.sql.SQLException;

public class SupporterService {

    public static void registerSupporter(Supporter supporter) throws SQLException {
        if (supporter.getSupporterLevel() == null || supporter.getSupporterLevel().trim().isEmpty()) {
            supporter.setSupporterLevel("Support"); // Default
        }

        SupporterDAO.insertSupporter(supporter);
    }

    public static Supporter getSupporterById(String id) throws SQLException {
        return SupporterDAO.getSupporterById(id);
    }

    public static void handleSupportTicket(String supporterId) throws SQLException {
        Supporter supporter = getSupporterById(supporterId);
        if (supporter == null) {
            throw new IllegalArgumentException("Supporter not found");
        }

        supporter.handleSupportTicket(); // Call model method
        // ➤ Later: add logging or ticket system integration
    }
}