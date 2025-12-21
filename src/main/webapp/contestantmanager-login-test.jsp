<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.dao.PersonDAO" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>ContestantManager Login Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .info { color: blue; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .test-form { border: 1px solid #ccc; padding: 20px; margin: 20px 0; }
        .form-group { margin: 10px 0; }
        label { display: block; margin-bottom: 5px; }
        input { width: 300px; padding: 5px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>ContestantManager Login Test</h1>
    
    <%
    String testResult = "";
    String errorMessage = "";
    
    try {
        // Get all ContestantManagers from the database
        java.util.List<com.voting.model.Person> allUsers = PersonDAO.getAllPersons();
        java.util.List<com.voting.model.Person> contestantManagers = new java.util.ArrayList<>();
        
        for (com.voting.model.Person user : allUsers) {
            if ("ContestantManager".equals(user.getRole())) {
                contestantManagers.add(user);
            }
        }
        
        testResult += "✅ Found " + contestantManagers.size() + " ContestantManagers in database<br>";
        
        if (contestantManagers.isEmpty()) {
            testResult += "⚠️ No ContestantManagers found. Create one first via add-user.jsp<br>";
        } else {
            testResult += "✅ ContestantManagers available for login testing<br>";
        }
        
    } catch (SQLException e) {
        errorMessage += "❌ Database Error: " + e.getMessage() + "<br>";
    } catch (Exception e) {
        errorMessage += "❌ General Error: " + e.getMessage() + "<br>";
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
        <h3>ContestantManager Login Instructions:</h3>
        <ol>
            <li><strong>If you have ContestantManagers:</strong> Use their email and password to login</li>
            <li><strong>If you don't have any:</strong> Create one first via add-user.jsp</li>
            <li><strong>After login:</strong> You should be redirected to contestant-dashboard.jsp</li>
            <li><strong>Session data:</strong> user_role should be "ContestantManager"</li>
        </ol>
    </div>
    
    <div class="test-form">
        <h3>Test ContestantManager Login</h3>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" placeholder="Enter ContestantManager email" required>
            </div>
            
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" placeholder="Enter ContestantManager password" required>
            </div>
            
            <button type="submit">Login as ContestantManager</button>
        </form>
    </div>
    
    <div class="info">
        <h3>Quick Links:</h3>
        <ul>
            <li><a href="login.jsp">Go to Login Page</a></li>
            <li><a href="add-user.jsp">Create New ContestantManager</a></li>
            <li><a href="manage-users">Manage Users</a></li>
            <li><a href="contestant-dashboard.jsp">Contestant Dashboard</a></li>
        </ul>
    </div>
    
    <div class="info">
        <h3>Expected Login Flow:</h3>
        <ol>
            <li>Enter ContestantManager email and password</li>
            <li>Click "Login as ContestantManager"</li>
            <li>Should redirect to: <code>contestant-dashboard.jsp</code></li>
            <li>Session should contain: <code>user_role = "ContestantManager"</code></li>
        </ol>
    </div>
</body>
</html>
