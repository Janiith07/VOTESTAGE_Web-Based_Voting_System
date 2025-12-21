package com.voting.servlet;

import com.voting.dao.JudgeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Test servlet to manually create golden votes for testing the display
 */
@WebServlet("/test-golden-vote")
public class TestGoldenVoteServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userId = (String) session.getAttribute("user_id");
        String userName = (String) session.getAttribute("user_name");
        
        try {
            // Create a test golden vote for the current user
            String judgeId = "P999"; // Test judge ID
            String judgeName = "Test Judge";
            String performance = "Amazing Performance - Test";
            
            JudgeDAO.recordGoldenVote(judgeId, userId, userName, performance, judgeName);
            
            System.out.println("🧪 TestGoldenVoteServlet: Created test golden vote for user " + userId);
            
            response.getWriter().write("<h1>Test Golden Vote Created!</h1>");
            response.getWriter().write("<p>Contestant: " + userName + " (ID: " + userId + ")</p>");
            response.getWriter().write("<p>Judge: " + judgeName + " (ID: " + judgeId + ")</p>");
            response.getWriter().write("<p>Performance: " + performance + "</p>");
            response.getWriter().write("<p><a href='contestant-dashboard.jsp'>Go to Dashboard to see the golden vote</a></p>");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("<h1>Error creating test golden vote</h1>");
            response.getWriter().write("<p>Error: " + e.getMessage() + "</p>");
        }
    }
}
