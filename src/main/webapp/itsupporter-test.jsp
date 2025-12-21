<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>IT Supporter - ContestantManager Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
        .test-form { border: 1px solid #ccc; padding: 20px; margin: 20px 0; }
        .form-group { margin: 10px 0; }
        label { display: block; margin-bottom: 5px; }
        input, select { width: 300px; padding: 5px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
        button:hover { background: #0056b3; }
    </style>
</head>
<body>
    <h1>IT Supporter - ContestantManager Creation Test</h1>
    
    <div class="info">
        <h3>Your Role: IT Supporter</h3>
        <p>You have permission to add ContestantManagers for user management.</p>
    </div>

    <div class="test-form">
        <h3>Test ContestantManager Creation</h3>
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

    <div class="info">
        <h3>If ContestantManager creation fails:</h3>
        <ol>
            <li>Check Tomcat console logs for error messages</li>
            <li>Run the database check script: <code>itsupporter_database_check.sql</code></li>
            <li>If ContestantManagers table doesn't exist, run the migration script</li>
        </ol>
    </div>
</body>
</html>
