<%@ page import="java.sql.*" %>
<%@ page import="com.voting.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null) {
        out.println("<h3 style='color:red;'>❌ Missing contestant id in request!</h3>");
        return;
    }

    String name = "", gender = "";
    int age = 0, votes = 0;
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");

    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement(
                "SELECT p.name, c.age, c.gender, c.total_votes_received " +
                        "FROM Persons p JOIN Contestants c ON p.person_id=c.person_id WHERE p.person_id=?"
        );
        ps.setInt(1, Integer.parseInt(id));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            age = rs.getInt("age");
            gender = rs.getString("gender");
            votes = rs.getInt("total_votes_received");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>DB Error: " + e.getMessage() + "</h3>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Contestant</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 20px;
        }

        .container {
            width: 400px;
            margin: 20px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .info-box {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
            font-size: 14px;
            color: #666;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #333;
        }

        input[type=text],
        input[type=number],
        input[type=file],
        select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }

        input[type=text]:focus,
        input[type=number]:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background 0.3s;
        }

        button:hover {
            background: #0056b3;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #007bff;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .current-values {
            background: #e9ecef;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
            font-size: 14px;
        }

        .current-values h4 {
            margin: 0 0 8px 0;
            color: #495057;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Update Contestant</h2>

    <!-- Success Message -->
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
    <div class="alert alert-success">
        ✅ <%= successMessage %>
    </div>
    <% } %>

    <!-- Error Message -->
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="alert alert-error">
        ❌ <%= errorMessage %>
    </div>
    <% } %>

    <div class="info-box">
        Contestant ID: <%= id %>
    </div>

    <!-- Current Values Display -->
    <div class="current-values">
        <h4>Current Details:</h4>
        <strong>Name:</strong> <%= name %><br>
        <strong>Age:</strong> <%= age %><br>
        <strong>Gender:</strong> <%= gender != null ? gender : "Not specified" %><br>
        <strong>Votes:</strong> <%= votes %>
    </div>

    <form action="UpdateContestantServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="contestant_id" value="<%= id %>">

        <label>Name:</label>
        <input type="text" name="name" value="<%= name %>" required>

        <label>Age:</label>
        <input type="number" name="age" value="<%= age %>" min="1" max="100" required>

        <label>Gender:</label>
        <select name="gender">
            <option value="">Select Gender</option>
            <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
            <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
            <option value="Other" <%= "Other".equals(gender) ? "selected" : "" %>>Other</option>
        </select>

        <label>Total Votes:</label>
        <input type="number" name="votes" value="<%= votes %>" min="0" required>

        <label>Upload New Image:</label>
        <input type="file" name="image" accept="image/*">

        <button type="submit">Update Profile</button>
    </form>

    <a href="contestantProfile.jsp?id=<%= person_id %>" class="back-link">
        ← Back to Contestant Profile
    </a>
</div>
</body>
</html>
