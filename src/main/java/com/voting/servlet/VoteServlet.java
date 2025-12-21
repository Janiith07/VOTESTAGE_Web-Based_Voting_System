package com.voting.servlet;

import com.voting.service.VoterService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/VoteServlet")
public class VoteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== VOTE SERVLET STARTED ===");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String voterId = (String) session.getAttribute("user_id");
        String voterName = (String) session.getAttribute("user_name");

        // Get parameters
        String contestantId = request.getParameter("contestantId");
        if (contestantId == null) contestantId = request.getParameter("contextantId");

        String contestantName = request.getParameter("contestantName");
        if (contestantName == null) contestantName = request.getParameter("contextantName");

        String performance = request.getParameter("performance");
        String voteType = request.getParameter("voteType");

        System.out.println("Voter: " + voterId + " (" + voterName + ")");
        System.out.println("Contestant: " + contestantId + " (" + contestantName + ")");
        System.out.println("Performance: " + performance);
        System.out.println("Vote Type: " + voteType);

        try {
            if (contestantId != null) {

                if ("regular".equals(voteType)) {
                    System.out.println("Processing REGULAR vote...");

                    boolean success = VoterService.recordRegularVote(
                            voterId,
                            contestantId,
                            contestantName,
                            performance,
                            voterName
                    );

                    if (success) {
                        session.setAttribute("successMessage", "✅ Regular vote recorded for " + contestantName + "!");
                        System.out.println("Regular vote SUCCESS");
                    } else {
                        session.setAttribute("errorMessage", "❌ You have already voted for " + contestantName + " today!");
                        System.out.println("Regular vote FAILED - already voted today");
                    }

                } else if ("golden".equals(voteType)) {
                    System.out.println("Processing GOLDEN vote...");
                    // For now, just show a message that golden votes are coming soon
                    session.setAttribute("errorMessage", "⚠️ Golden votes feature coming soon!");
                } else {
                    session.setAttribute("errorMessage", "❌ Please select a vote type!");
                }
            } else {
                session.setAttribute("errorMessage", "❌ Missing contestant information!");
            }

            System.out.println("Redirecting to voter-dashboard.jsp");
            response.sendRedirect("voter-dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "❌ Error: " + e.getMessage());
            response.sendRedirect("voter-dashboard.jsp");
        }

        System.out.println("=== VOTE SERVLET COMPLETED ===");
    }
}