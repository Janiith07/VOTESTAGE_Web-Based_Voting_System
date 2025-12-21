<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("user_name");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Viewer Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #e2e3e5; }
        .container { max-width: 800px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #6c757d; }
        .btn { padding: 10px 20px; background: #6f42c1; color: white; text-decoration: none; border-radius: 5px; display: inline-block; margin: 5px; }
        .btn:hover { background: #5a32a3; }
        .logout { float: right; background: #6c757d; }
        .logout:hover { background: #545b62; }
    </style>
</head>
<body>
<div class="container">
    <h1>👀 Viewer Dashboard</h1>
    <h2>Welcome, <%= userName %>!</h2>
    <p>Enjoy the show! You can watch performances and see live results.</p>

    <a href="watch-show.jsp" class="btn">📺 Watch Live Show</a>
    <a href="leaderboard.jsp" class="btn">🏆 View Leaderboard</a>
    <a href="register-as-voter.jsp" class="btn">🗳️ Register as Voter</a>
    <a href="logout" class="btn logout">🚪 Logout</a>

    <hr>
    <h3>Note:</h3>
    <p>As a viewer, you can’t vote — but you can <strong>register as a voter</strong> to participate!</p>
</div>
</body>
</html>