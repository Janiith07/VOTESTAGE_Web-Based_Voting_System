<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.voting.util.DBConnection" %>
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement("SELECT * FROM PerformanceSchedule ORDER BY id");
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Performance Schedule</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8f9fa; padding: 30px; }
        .container { max-width: 700px; margin: auto; background: #fff; padding: 25px; border-radius: 12px; box-shadow:0 4px 8px rgba(0,0,0,0.1);}
        h1 { text-align: center; color: #28a745; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #dee2e6; padding: 12px; text-align: center; }
        th { background-color: #28a745; color: #fff; }
        input[type="text"] { width: 90%; padding: 6px; border-radius: 4px; border: 1px solid #ccc; }
        .btn { margin-top: 20px; padding: 10px 15px; border-radius: 8px; text-decoration: none; color: #fff; border:none; cursor:pointer; }
        .btn-update { background:#ffc107; }
        .btn-update:hover { background:#e0a800; }
        .btn-back { background:#007bff; }
        .btn-back:hover { background:#0056b3; }
    </style>
</head>
<body>
<div class="container">
    <h1>Update Performance Schedule</h1>
    <form action="UpdateScheduleServlet" method="post">
        <table>
            <tr>
                <th>Contestant</th>
                <th>Performance Slot</th>
            </tr>
            <%
                while(rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("contestant_name");
                    String slot = rs.getString("slot");
            %>
            <tr>
                <td><%= name %></td>
                <td>
                    <input type="text" name="slot_<%=id%>" value="<%=slot%>" required />
                </td>
            </tr>
            <% } %>
        </table>
        <div style="text-align:center;">
            <button type="submit" class="btn btn-update">Update Schedule</button>
            <a href="schedule.jsp" class="btn btn-back">← Back</a>
        </div>
    </form>
</div>
</body>
</html>


<%
    } catch(Exception e) {
        out.println("<h3>Error: "+e.getMessage()+"</h3>");
        e.printStackTrace();
    } finally {
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }
%>