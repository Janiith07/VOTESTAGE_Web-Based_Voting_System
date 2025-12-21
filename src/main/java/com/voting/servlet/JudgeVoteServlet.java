package com.voting.servlet;

import com.voting.service.JudgeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/vote")
public class JudgeVoteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,IOException {
        System.out.println("=== JUDGE VOTE SERVLET STARTED ===");
        
        HttpSession session = request.getSession();
        String judgeId = (String) session.getAttribute("user_id");
        String judgeName = (String) session.getAttribute("user_name");

        System.out.println("Judge ID: " + judgeId);
        System.out.println("Judge Name: " + judgeName);

        if (judgeId == null || judgeName == null) {
            System.out.println("Missing session data, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        String voteType = request.getParameter("voteType");
        String contestantId = request.getParameter("contestantId");
        String contestantName = request.getParameter("contestantName");
        String performance = request.getParameter("performance");

        System.out.println("Vote Type: " + voteType);
        System.out.println("Contestant ID: " + contestantId);
        System.out.println("Contestant Name: " + contestantName);
        System.out.println("Performance: " + performance);

        try {
            if ("regular".equals(voteType)) {
                boolean success = JudgeService.recordRegularVote(
                        judgeId,
                        contestantId,
                        contestantName,
                        performance,
                        judgeName
                );

                if (success) {
                    session.setAttribute("successMessage", "10 regular votes successfully recorded for " + contestantName + "!");
                } else {
                    session.setAttribute("errorMessage", "You have already given regular votes to " + contestantName + " today!");
                }

            } else if ("golden".equals(voteType)) {
                // Check if judge has already used golden vote
                boolean hasUsedGoldenVote = JudgeService.hasGivenAnyGoldenVote(judgeId);

                if (hasUsedGoldenVote) {
                    boolean hasGivenToThisContestant = JudgeService.hasGivenGoldenVote(judgeId, contestantId);

                    if (hasGivenToThisContestant) {
                        // Revoke golden vote
                        boolean success = JudgeService.revokeGoldenVote(judgeId, contestantId);
                        if (success) {
                            session.setAttribute("successMessage", "Golden vote successfully revoked from " + contestantName + "!");
                        } else {
                            session.setAttribute("errorMessage", "Error revoking golden vote from " + contestantName + "!");
                        }
                    } else {
                        session.setAttribute("errorMessage", "You have already used your golden vote on another contestant!");
                    }
                } else {
                    // Give golden vote
                    boolean success = JudgeService.recordGoldenVote(
                            judgeId,
                            contestantId,
                            contestantName,
                            performance,
                            judgeName
                    );

                    if (success) {
                        session.setAttribute("successMessage", "Golden vote successfully given to " + contestantName + "!");
                    } else {
                        session.setAttribute("errorMessage", "Error giving golden vote to " + contestantName + "!");
                    }
                }
            }

            // Redirect back to voting page with parameters
            String redirectUrl = String.format(
                    "judge-vote.jsp?contestantId=%s&contestantName=%s&performance=%s",
                    contestantId,
                    java.net.URLEncoder.encode(contestantName, "UTF-8"),
                    java.net.URLEncoder.encode(performance, "UTF-8")
            );
            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            System.out.println("ERROR in JudgeVoteServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error processing vote: " + e.getMessage());
            
            // Redirect back to judge-vote.jsp with parameters
            String redirectUrl = String.format(
                    "judge-vote.jsp?contestantId=%s&contestantName=%s&performance=%s",
                    contestantId,
                    java.net.URLEncoder.encode(contestantName, "UTF-8"),
                    java.net.URLEncoder.encode(performance, "UTF-8")
            );
            response.sendRedirect(redirectUrl);
        }
    }
}
