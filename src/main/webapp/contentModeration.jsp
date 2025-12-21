<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Content Moderation</title></head>
<body>
<h2>Content Moderation</h2>
<table border="1">
    <tr><th>Comment ID</th><th>User</th><th>Comment</th><th>Status</th><th>Action</th></tr>
    <tr><td>1</td><td>Voter1</td><td>Great performance!</td><td>ACTIVE</td>
        <td><button>Flag</button> <button>Remove</button></td></tr>
    <tr><td>2</td><td>Voter2</td><td>Spam message</td><td>FLAGGED</td>
        <td><button>Remove</button></td></tr>
</table>
<a href="admin-dashboard.jsp">⬅ Back to Dashboard</a>
</body>
</html>
