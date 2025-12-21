package com.voting.servlet;

import com.voting.model.ContestantManager;
import com.voting.service.ContestantManagerService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/test-contestantmanager")
public class TestContestantManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>ContestantManager Test</title></head><body>");
        out.println("<h2>ContestantManager Creation Test</h2>");
        
        try {
            // Test creating a ContestantManager
            ContestantManager testManager = new ContestantManager(null, "Test Manager", "test@example.com", "Test123456", "Standard");
            
            out.println("<p>✅ ContestantManager object created successfully</p>");
            out.println("<p>Manager Level: " + testManager.getManagerLevel() + "</p>");
            out.println("<p>Role: " + testManager.getRole() + "</p>");
            
            // Try to register the manager
            ContestantManagerService.registerContestantManager(testManager);
            
            out.println("<p>✅ ContestantManager registered successfully!</p>");
            out.println("<p>This means the ContestantManagers table exists and is working.</p>");
            
        } catch (SQLException e) {
            out.println("<p>❌ SQL Error: " + e.getMessage() + "</p>");
            out.println("<p><strong>Most likely cause:</strong> ContestantManagers table does not exist.</p>");
            out.println("<p><strong>Solution:</strong> Run the database migration script.</p>");
            out.println("<p>File: VoteStage/src/main/resources/contestant_to_contestantmanager_migration.sql</p>");
            
            // Print stack trace for debugging
            out.println("<details><summary>Full Error Details</summary><pre>");
            e.printStackTrace(out);
            out.println("</pre></details>");
            
        } catch (Exception e) {
            out.println("<p>❌ General Error: " + e.getMessage() + "</p>");
            out.println("<details><summary>Full Error Details</summary><pre>");
            e.printStackTrace(out);
            out.println("</pre></details>");
        }
        
        out.println("<hr>");
        out.println("<p><a href='add-user.jsp'>Go to Add User Page</a></p>");
        out.println("<p><a href='manage-users'>Go to Manage Users</a></p>");
        out.println("</body></html>");
    }
}
