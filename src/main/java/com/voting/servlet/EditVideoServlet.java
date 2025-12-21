package com.voting.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class EditVideoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int videoId = Integer.parseInt(request.getParameter("video_id"));
        String title = request.getParameter("title");
        String singer = request.getParameter("singer");
        String duration = request.getParameter("duration");
        String description = request.getParameter("description");

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/votingsystem","root","password");
            String sql = "UPDATE Videos SET title=?, original_singer=?, duration=?, description=? WHERE video_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, singer);
            ps.setString(3, duration);
            ps.setString(4, description);
            ps.setInt(5, videoId);
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }

        response.sendRedirect("adminVideos.jsp");
    }
}

