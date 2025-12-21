package com.voting.service;


import com.voting.dao.ContentDAO;
import com.voting.model.Content;

import java.sql.SQLException;
import java.util.List;

public class ContentService {

    private ContentDAO dao = new ContentDAO();

    public List<Content> getPendingContent() throws SQLException {
        return dao.fetchPendingContent();
    }

    public boolean flagContent(int contentId, String reason, String adminId) throws SQLException {
        return dao.flagContent(contentId, reason, adminId);
    }

    public boolean removeContent(int contentId, String adminId) throws SQLException {
        return dao.removeContent(contentId, adminId);
    }
}

