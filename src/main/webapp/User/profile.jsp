<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.voting.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Only declare 'session' if not already defined
    HttpSession mySession = request.getSession(false);
    User user = null;
    String successMsg = null;
    String errorMsg = null;
    if (mySession != null) {
        user = (User) mySession.getAttribute("user");
        successMsg = (String) request.getAttribute("successMsg");
        errorMsg = (String) request.getAttribute("errorMsg");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <script>
        function showEditForm() {
            document.getElementById('editForm').style.display = 'block';
            document.getElementById('userDetails').style.display = 'none';
        }
        function hideEditForm() {
            document.getElementById('editForm').style.display = 'none';
            document.getElementById('userDetails').style.display = 'block';
        }
    </script>
</head>
<body>
<div class="container mt-5">
    <h2>User Profile</h2>
    <% if (successMsg != null) { %>
        <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="alert alert-danger"><%= errorMsg %></div>
    <% } %>
    <div id="userDetails">
        <table class="table table-bordered">
            <tr><th>Username</th><td><%= user != null ? user.getUsername() : "N/A" %></td></tr>
            <tr><th>Email</th><td><%= user != null ? user.getEmail() : "N/A" %></td></tr>
            <tr><th>User Type</th><td><%= user != null ? user.getUserType() : "N/A" %></td></tr>
        </table>
        <button class="btn btn-primary" onclick="showEditForm()">Edit</button>
        <a href="../index.jsp" class="btn btn-secondary">Home</a>
    </div>
    <div id="editForm" style="display:none;">
        <form action="../EditUserServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" class="form-control" id="username" name="username" value="<%= user != null ? user.getUsername() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= user != null ? user.getEmail() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" value="<%= user != null ? user.getPassword() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="userType">User Type</label>
                <input type="text" class="form-control" id="userType" name="userType" value="<%= user != null ? user.getUserType() : "" %>" readonly>
            </div>
            <button type="submit" class="btn btn-success">Save</button>
            <button type="button" class="btn btn-secondary" onclick="hideEditForm()">Cancel</button>
        </form>
    </div>
</div>
</body>
</html>
