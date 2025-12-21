package com.voting.servlet;

import com.voting.service.ContentService;
import com.voting.model.Content;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/content")
public class AdminContentModerationServlet extends HttpServlet {

    private ContentService contentService = new ContentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load all pending/flagged content
            List<Content> contents = contentService.getPendingContent();
            request.setAttribute("contents", contents);

            // Forward to JSP (e.g., /WEB-INF/views/admin/contentModeration.jsp)
            request.getRequestDispatcher("/WEB-INF/views/admin/contentModeration.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Error fetching content", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String contentIdStr = request.getParameter("contentId");
        HttpSession session = request.getSession(false);

        if (contentIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/content?error=missing_params");
            return;
        }

        try {
            int contentId = Integer.parseInt(contentIdStr);
            String adminId = (session != null && session.getAttribute("user_id") != null)
                    ? (String) session.getAttribute("user_id")
                    : "P001"; // fallback for testing

            boolean success = false;

            if ("flag".equalsIgnoreCase(action)) {
                String reason = request.getParameter("reason");
                success = contentService.flagContent(contentId, reason, adminId);
            } else if ("remove".equalsIgnoreCase(action)) {
                success = contentService.removeContent(contentId, adminId);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/content?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/content?error=action_failed");
            }

        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Error moderating content", e);
        }
    }
}
