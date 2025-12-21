<!-- src/main/webapp/delete-user.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String userRole = (String) session.getAttribute("user_role");
  if (userRole == null || !userRole.equals("Admin")) {
    response.sendRedirect("login.jsp");
    return;
  }

  String id = request.getParameter("id");
  if (id == null) {
    response.sendRedirect("manage-users");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>🗑️ Delete User</title>
  <style>
    body { font-family: Arial; text-align: center; margin-top: 100px; background: #f8d7da; }
    .container { max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { color: #721c24; }
    .btn { padding: 10px 20px; margin: 10px; text-decoration: none; border-radius: 5px; }
    .delete { background: #dc3545; color: white; }
    .cancel { background: #6c757d; color: white; }
  </style>
</head>
<body>
<div class="container">
  <h2>⚠️ Confirm Deletion</h2>
  <p>Are you sure you want to delete user ID: <strong><%= id %></strong>?</p>
  <p>This action cannot be undone.</p>

  <a href="confirm-delete?id=<%= id %>" class="btn delete">🗑️ Yes, Delete</a>
  <a href="manage-users" class="btn cancel">❌ Cancel</a>
</div>
</body>
</html>
