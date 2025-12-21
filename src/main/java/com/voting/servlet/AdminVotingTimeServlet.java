package com.voting.servlet;

import com.voting.dao.VotingDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/admin/voting")
public class AdminVotingTimeServlet extends HttpServlet {

    private VotingDAO dao = new VotingDAO();
    private final DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // expects params: action=set & eventId & start & end
        String action = req.getParameter("action");
        if (!"set".equalsIgnoreCase(action)) {
            resp.sendError(400, "only action=set supported");
            return;
        }
        String eventIdStr = req.getParameter("eventId");
        String start = req.getParameter("start");
        String end = req.getParameter("end");
        String adminId = getAdminIdFromSession(req);

        if (eventIdStr == null || start == null || end == null) {
            resp.sendError(400, "missing parameters");
            return;
        }
        try {
            int eventId = Integer.parseInt(eventIdStr);
            LocalDateTime s = LocalDateTime.parse(start, dtf);
            LocalDateTime e = LocalDateTime.parse(end, dtf);
            if (e.isBefore(s)) {
                resp.sendError(400, "end must be after start");
                return;
            }

            boolean ok = dao.setVotingWindow(eventId, s, e, adminId);
            resp.setContentType("application/json");
            resp.getWriter().print("{\"success\": " + ok + "}");
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private String getAdminIdFromSession(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("user_id") != null) {
            return (String) s.getAttribute("user_id");
        }
        return "P001"; // Default admin ID
    }
}
