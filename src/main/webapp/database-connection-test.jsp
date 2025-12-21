<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.util.DBConnection" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; }
        .error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; }
        .info { color: blue; background: #d1ecf1; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <%
    String result = "";
    String error = "";
    
    try {
        // Test database connection
        java.sql.Connection conn = DBConnection.getConnection();
        result += "✅ Database connection successful!<br>";
        
        // Test if ContestantManagers table exists
        java.sql.Statement stmt = conn.createStatement();
        java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ContestantManagers'");
        
        if (rs.next() && rs.getInt(1) > 0) {
            result += "✅ ContestantManagers table exists!<br>";
            
            // Test if we can query the table
            rs = stmt.executeQuery("SELECT COUNT(*) FROM ContestantManagers");
            if (rs.next()) {
                result += "✅ ContestantManagers table is accessible!<br>";
                result += "📊 Current ContestantManagers count: " + rs.getInt(1) + "<br>";
            }
        } else {
            error += "❌ ContestantManagers table does NOT exist!<br>";
            error += "💡 You need to run the database migration script<br>";
            error += "📁 File: VoteStage/src/main/resources/contestant_to_contestantmanager_migration.sql<br>";
        }
        
        // Test if Contestants table still exists
        rs = stmt.executeQuery("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Contestants'");
        if (rs.next() && rs.getInt(1) > 0) {
            error += "⚠️ Contestants table still exists - Migration not completed!<br>";
        } else {
            result += "✅ Contestants table removed - Migration completed!<br>";
        }
        
        conn.close();
        
    } catch (SQLException e) {
        error += "❌ Database Error: " + e.getMessage() + "<br>";
        
        if (e.getMessage().contains("Login failed")) {
            error += "🔍 <strong>Root Cause:</strong> Database authentication failed<br>";
            error += "💡 <strong>Solution:</strong> Check SQL Server is running and credentials are correct<br>";
        } else if (e.getMessage().contains("Invalid object name")) {
            error += "🔍 <strong>Root Cause:</strong> Table does not exist<br>";
            error += "💡 <strong>Solution:</strong> Run the database migration script<br>";
        } else {
            error += "🔍 <strong>Other database error:</strong> " + e.getMessage() + "<br>";
        }
    } catch (Exception e) {
        error += "❌ General Error: " + e.getMessage() + "<br>";
    }
    %>
    
    <% if (!result.isEmpty()) { %>
    <div class="success">
        <h3>Test Results:</h3>
        <%= result %>
    </div>
    <% } %>
    
    <% if (!error.isEmpty()) { %>
    <div class="error">
        <h3>Error Details:</h3>
        <%= error %>
    </div>
    <% } %>
    
    <div class="info">
        <h3>Next Steps:</h3>
        <ol>
            <li><strong>If you see "ContestantManagers table does NOT exist":</strong> Run the migration script</li>
            <li><strong>If you see "Login failed":</strong> Check SQL Server is running</li>
            <li><strong>If you see "ContestantManagers table exists":</strong> The issue is elsewhere</li>
        </ol>
    </div>
    
    <div class="info">
        <h3>Quick Links:</h3>
        <ul>
            <li><a href="add-user.jsp">Go to Add User Page</a></li>
            <li><a href="manage-users">Go to Manage Users</a></li>
            <li><a href="contestantmanager-debug.jsp">ContestantManager Debug Test</a></li>
        </ul>
    </div>
</body>
</html>
