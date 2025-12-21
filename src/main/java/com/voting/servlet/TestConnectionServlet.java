package com.voting.servlet;

import com.voting.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/test-connection")
public class TestConnectionServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Connection Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        // Test 1: SQL Server Authentication
        out.println("<h2>Test 1: SQL Server Authentication (sa user)</h2>");
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<p style='color: green;'>✅ SQL Server Authentication: SUCCESS</p>");
                out.println("<p>Connection URL: " + conn.getMetaData().getURL() + "</p>");
                conn.close();
            }
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ SQL Server Authentication: FAILED</p>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("<p>Error Code: " + e.getErrorCode() + "</p>");
            out.println("<p>SQL State: " + e.getSQLState() + "</p>");
        }
        
        // Test 2: Windows Authentication
        out.println("<h2>Test 2: Windows Authentication</h2>");
        try {
            Connection conn = DBConnection.getAlternativeConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<p style='color: green;'>✅ Windows Authentication: SUCCESS</p>");
                out.println("<p>Connection URL: " + conn.getMetaData().getURL() + "</p>");
                conn.close();
            }
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ Windows Authentication: FAILED</p>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        
        out.println("<h2>Recommended Solutions:</h2>");
        out.println("<ol>");
        out.println("<li><strong>Check SQL Server Service:</strong> Make sure SQL Server service is running</li>");
        out.println("<li><strong>Verify SQL Server Authentication:</strong> Enable SQL Server and Windows Authentication mode</li>");
        out.println("<li><strong>Check sa password:</strong> Verify the password for 'sa' user is correct</li>");
        out.println("<li><strong>Enable TCP/IP:</strong> Make sure TCP/IP is enabled in SQL Server Configuration Manager</li>");
        out.println("<li><strong>Check Firewall:</strong> Ensure port 1433 is not blocked by firewall</li>");
        out.println("<li><strong>Verify Database:</strong> Make sure 'VotingDB3' database exists</li>");
        out.println("<li><strong>Reset sa password:</strong> Use SQL Server Management Studio to reset the sa password</li>");
        out.println("<li><strong>Use Windows Authentication:</strong> Try logging in with your Windows account instead</li>");
        out.println("</ol>");
        
        out.println("<h2>Quick Fix Commands:</h2>");
        out.println("<div style='background: #f5f5f5; padding: 15px; border-radius: 5px;'>");
        out.println("<h3>Option 1: Reset sa password via SQL Server Management Studio</h3>");
        out.println("<ol>");
        out.println("<li>Open SQL Server Management Studio</li>");
        out.println("<li>Connect using Windows Authentication</li>");
        out.println("<li>Expand Security → Logins → Right-click 'sa' → Properties</li>");
        out.println("<li>Set password to '12' or your preferred password</li>");
        out.println("<li>Ensure 'sa' login is enabled</li>");
        out.println("</ol>");
        
        out.println("<h3>Option 2: Enable SQL Server Authentication</h3>");
        out.println("<ol>");
        out.println("<li>Right-click server name → Properties → Security</li>");
        out.println("<li>Select 'SQL Server and Windows Authentication mode'</li>");
        out.println("<li>Restart SQL Server service</li>");
        out.println("</ol>");
        
        out.println("<h3>Option 3: Check SQL Server Configuration</h3>");
        out.println("<ol>");
        out.println("<li>Open SQL Server Configuration Manager</li>");
        out.println("<li>SQL Server Network Configuration → Protocols</li>");
        out.println("<li>Enable TCP/IP protocol</li>");
        out.println("<li>Restart SQL Server service</li>");
        out.println("</ol>");
        out.println("</div>");
        
        out.println("<h2>SQL Server Configuration Steps:</h2>");
        out.println("<ol>");
        out.println("<li>Open SQL Server Management Studio (SSMS)</li>");
        out.println("<li>Connect to your SQL Server instance</li>");
        out.println("<li>Right-click on server name → Properties → Security</li>");
        out.println("<li>Select 'SQL Server and Windows Authentication mode'</li>");
        out.println("<li>Restart SQL Server service</li>");
        out.println("<li>Check if 'sa' user is enabled (Security → Logins → sa)</li>");
        out.println("<li>Set password for 'sa' user if needed</li>");
        out.println("</ol>");
        
        out.println("</body></html>");
    }
}
