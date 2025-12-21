<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.ContestantManager" %>
<%@ page import="com.voting.service.ContestantManagerService" %>
<%@ page import="com.voting.dao.PersonDAO" %>
<%@ page import="com.voting.dao.ContestantManagerDAO" %>
<%@ page import="com.voting.util.DBConnection" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>ContestantManager Creation Step-by-Step Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .info { color: blue; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .step { background: #f8f9fa; padding: 15px; border-left: 4px solid #007bff; margin: 10px 0; }
        .test-form { border: 1px solid #ccc; padding: 20px; margin: 20px 0; }
        .form-group { margin: 10px 0; }
        label { display: block; margin-bottom: 5px; }
        input, select { width: 300px; padding: 5px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h1>ContestantManager Creation Step-by-Step Test</h1>
    
    <%
    String testResults = "";
    String errorMessage = "";
    
    try {
        // Step 1: Test database connection
        testResults += "<div class='step'><strong>Step 1:</strong> Testing database connection...<br>";
        java.sql.Connection conn = DBConnection.getConnection();
        testResults += "✅ Database connection successful!</div>";
        
        // Step 2: Check if ContestantManagers table exists
        testResults += "<div class='step'><strong>Step 2:</strong> Checking ContestantManagers table...<br>";
        java.sql.Statement stmt = conn.createStatement();
        java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ContestantManagers'");
        
        if (rs.next() && rs.getInt(1) > 0) {
            testResults += "✅ ContestantManagers table exists!</div>";
            
            // Step 3: Test PersonDAO.insertPerson
            testResults += "<div class='step'><strong>Step 3:</strong> Testing PersonDAO.insertPerson...<br>";
            ContestantManager testManager = new ContestantManager(null, "Test Manager", "test@example.com", "Test123456", "Standard");
            String personId = PersonDAO.insertPerson(testManager);
            testResults += "✅ PersonDAO.insertPerson successful! Person ID: " + personId + "</div>";
            
            // Step 4: Test ContestantManagerDAO.insertContestantManager
            testResults += "<div class='step'><strong>Step 4:</strong> Testing ContestantManagerDAO.insertContestantManager...<br>";
            ContestantManagerDAO.insertContestantManager(testManager);
            testResults += "✅ ContestantManagerDAO.insertContestantManager successful!</div>";
            
            // Step 5: Test ContestantManagerService.registerContestantManager
            testResults += "<div class='step'><strong>Step 5:</strong> Testing ContestantManagerService.registerContestantManager...<br>";
            ContestantManager testManager2 = new ContestantManager(null, "Test Manager 2", "test2@example.com", "Test123456", "Junior");
            ContestantManagerService.registerContestantManager(testManager2);
            testResults += "✅ ContestantManagerService.registerContestantManager successful!</div>";
            
            // Step 6: Verify data was inserted
            testResults += "<div class='step'><strong>Step 6:</strong> Verifying data insertion...<br>";
            rs = stmt.executeQuery("SELECT COUNT(*) FROM ContestantManagers");
            if (rs.next()) {
                testResults += "✅ ContestantManagers count: " + rs.getInt(1) + "</div>";
            }
            
            // Step 7: Test retrieval
            testResults += "<div class='step'><strong>Step 7:</strong> Testing data retrieval...<br>";
            ContestantManager retrieved = ContestantManagerService.getContestantManagerById(personId);
            if (retrieved != null) {
                testResults += "✅ Data retrieval successful! Manager: " + retrieved.getName() + "</div>";
            }
            
            testResults += "<div class='success'><strong>🎉 ALL TESTS PASSED! ContestantManager creation is working!</strong></div>";
            
        } else {
            errorMessage += "<div class='error'><strong>❌ ContestantManagers table does NOT exist!</strong><br>";
            errorMessage += "You need to create the ContestantManagers table.<br>";
            errorMessage += "Run this SQL:<br>";
            errorMessage += "<code>CREATE TABLE ContestantManagers (<br>";
            errorMessage += "&nbsp;&nbsp;&nbsp;&nbsp;person_id VARCHAR(10) PRIMARY KEY,<br>";
            errorMessage += "&nbsp;&nbsp;&nbsp;&nbsp;manager_level VARCHAR(50) DEFAULT 'Standard',<br>";
            errorMessage += "&nbsp;&nbsp;&nbsp;&nbsp;FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE<br>";
            errorMessage += ");</code></div>";
        }
        
        conn.close();
        
    } catch (SQLException e) {
        errorMessage += "<div class='error'><strong>❌ SQL Error:</strong> " + e.getMessage() + "<br>";
        
        if (e.getMessage().contains("Invalid object name 'ContestantManagers'")) {
            errorMessage += "<strong>Root Cause:</strong> ContestantManagers table does not exist!<br>";
            errorMessage += "<strong>Solution:</strong> Create the ContestantManagers table</div>";
        } else if (e.getMessage().contains("Login failed")) {
            errorMessage += "<strong>Root Cause:</strong> Database connection failed!<br>";
            errorMessage += "<strong>Solution:</strong> Check SQL Server is running</div>";
        } else {
            errorMessage += "<strong>Other database error:</strong> " + e.getMessage() + "</div>";
        }
        
    } catch (Exception e) {
        errorMessage += "<div class='error'><strong>❌ General Error:</strong> " + e.getMessage() + "<br>";
        errorMessage += "<strong>Possible causes:</strong><br>";
        errorMessage += "• Missing imports or compilation errors<br>";
        errorMessage += "• ClassNotFoundException<br>";
        errorMessage += "• Application not deployed properly</div>";
    }
    %>
    
    <%= testResults %>
    <%= errorMessage %>
    
    <div class="info">
        <h3>Next Steps:</h3>
        <ol>
            <li><strong>If you see "ContestantManagers table does NOT exist":</strong> Create the table using the SQL provided</li>
            <li><strong>If you see "ALL TESTS PASSED":</strong> Try adding ContestantManager via add-user.jsp</li>
            <li><strong>If you see other errors:</strong> Check the specific error message</li>
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
            <li><a href="database-connection-test.jsp">Database Connection Test</a></li>
        </ul>
    </div>
</body>
</html>
