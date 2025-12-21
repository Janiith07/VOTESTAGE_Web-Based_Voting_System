package com.voting.servlet;

import com.voting.dao.JudgeDAO;
import com.voting.observer.ContestantObserver;
import com.voting.observer.VotingSubject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet to register contestants as observers when they log in
 */
@WebServlet("/register-contestant-observer")
public class RegisterContestantObserverServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userId = (String) session.getAttribute("user_id");
        String userRole = (String) session.getAttribute("user_role");
        
        // Only register contestants and contestant managers as observers
        if (userRole != null && (userRole.toLowerCase().equals("contestant") || 
                                userRole.toLowerCase().equals("contestantmanager"))) {
            
            VotingSubject votingSubject = JudgeDAO.getVotingSubject();
            ContestantObserver observer = new ContestantObserver(userId);
            
            // Register the observer
            votingSubject.registerObserver(observer);
            
            System.out.println("✅ RegisterContestantObserverServlet: Registered observer for " + userRole + " " + userId);
            
            response.getWriter().write("{\"success\": true, \"message\": \"Observer registered successfully\"}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"User is not a contestant\"}");
        }
    }
}
