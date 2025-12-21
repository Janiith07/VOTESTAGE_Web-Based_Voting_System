<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.ContestantManager" %>
<%@ page import="com.voting.service.ContestantManagerService" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>ContestantManager Creation Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; }
        .error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; }
        .info { color: blue; background: #d1ecf1; padding: 10px; border-radius: 5px; }
        .test-form { border: 1px solid #ccc; padding: 20px; margin: 20px 0; }
        .form-group { margin: 10px 0; }
        label { display: block; margin-bottom: 5px; }
        input, select { width: 300px; padding: 5px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h1>ContestantManager Creation Test</h1>
    
    <%
    String testResult = "";
    String errorMessage = "";
    
    try {
        // Test 1: Create ContestantManager object
        ContestantManager testManager = new ContestantManager(null, "Test Manager", "test@example.com", "Test123456", "Standard");
        testResult += "✅ ContestantManager object created successfully<br>";
        
        // Test 2: Try to register the manager
        ContestantManagerService.registerContestantManager(testManager);
        testResult += "✅ ContestantManager registered successfully!<br>";
        testResult += "✅ Database connection and ContestantManagers table are working!<br>";
        
    } catch (SQLException e) {
        errorMessage = "❌ SQL Error: " + e.getMessage() + "<br>";
        
        if (e.getMessage().contains("Invalid object name 'ContestantManagers'")) {
            errorMessage += "🔍 <strong>Root Cause:</strong> ContestantManagers table does not exist!<br>";
            errorMessage += "💡 <strong>Solution:</strong> Run the database migration script<br>";
            errorMessage += "📁 <strong>File:</strong> VoteStage/src/main/resources/contestant_to_contestantmanager_migration.sql<br>";
        } else if (e.getMessage().contains("Login failed")) {
            errorMessage += "🔍 <strong>Root Cause:</strong> Database connection failed!<br>";
            errorMessage += "💡 <strong>Solution:</strong> Check SQL Server is running and credentials are correct<br>";
        } else {
            errorMessage += "🔍 <strong>Other database error:</strong> " + e.getMessage() + "<br>";
        }
        
    } catch (Exception e) {
        errorMessage = "❌ General Error: " + e.getMessage() + "<br>";
        errorMessage += "🔍 <strong>Possible causes:</strong><br>";
        errorMessage += "• Missing imports or compilation errors<br>";
        errorMessage += "• ClassNotFoundException<br>";
        errorMessage += "• Application not deployed properly<br>";
    }
    %>
    
    <% if (!testResult.isEmpty()) { %>
    <div class="success">
        <h3>Test Results:</h3>
        <%= testResult %>
    </div>
    <% } %>
    
    <% if (!errorMessage.isEmpty()) { %>
    <div class="error">
        <h3>Error Details:</h3>
        <%= errorMessage %>
    </div>
    <% } %>
    
    <div class="info">
        <h3>Next Steps:</h3>
        <ol>
            <li><strong>If you see SQL errors:</strong> Run the database migration script</li>
            <li><strong>If you see connection errors:</strong> Check SQL Server is running</li>
            <li><strong>If you see class errors:</strong> Redeploy your application</li>
            <li><strong>If test passes:</strong> Try adding ContestantManager via add-user.jsp</li>
        </ol>
    </div>
    
    <div class="test-form">
        <h3>Test ContestantManager Creation via Form</h3>
        <form action="${pageContext.request.contextPath}/add-user" method="post">
            <div class="form-group">
                <label>Name:</label>
                <input type="text" name="name" value="Test Manager" required>
            </div>
            
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" value="testmanager@example.com" required>
            </div>
            
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" value="Test123456" required>
                <small>Must be at least 8 characters with letters and numbers</small>
            </div>
            
            <div class="form-group">
                <label>Role:</label>
                <select name="role" required>
                    <option value="">-- Select Role --</option>
                    <option value="ContestantManager" selected>ContestantManager</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Manager Level:</label>
                <select name="managerLevel">
                    <option value="Standard" selected>Standard</option>
                    <option value="Junior">Junior</option>
                    <option value="Senior">Senior</option>
                </select>
            </div>
            
            <button type="submit">Create ContestantManager</button>
        </form>
    </div>
    
    <div class="info">
        <h3>Quick Links:</h3>
        <ul>
            <li><a href="add-user.jsp">Go to Add User Page</a></li>
            <li><a href="manage-users">Go to Manage Users</a></li>
            <li><a href="itsupporter-dashboard.jsp">IT Supporter Dashboard</a></li>
        </ul>
    </div>
</body>
</html>
