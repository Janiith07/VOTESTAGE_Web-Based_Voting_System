<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Performance Videos</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .video-card {
            border: 1px solid #ccc;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
            width: 650px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        video { width: 100%; border-radius: 8px; }
        h3 { margin: 5px 0; }
    </style>
</head>
<body>
<h2>🎤 Contestant Performances</h2>

<%
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/votingsystem","root","password");
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM Videos ORDER BY uploaded_at DESC");

    while(rs.next()){
%>
<div class="video-card">
    <h3><%= rs.getString("title") %></h3>
    <p><b>Original Singer:</b> <%= rs.getString("original_singer") %></p>
    <p><b>Duration:</b> <%= rs.getString("duration") %></p>
    <p><%= rs.getString("description") %></p>

    <video controls>
        <source src="<%= rs.getString("file_path") %>" type="video/mp4">
        Your browser does not support the video tag.
    </video>
</div>
<%
    }
    conn.close();
%>

</body>
</html>
