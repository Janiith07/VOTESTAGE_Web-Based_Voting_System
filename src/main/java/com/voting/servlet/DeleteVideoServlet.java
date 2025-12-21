package com.voting.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteVideoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int videoId = Integer.parseInt(request.getParameter("video_id"));

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/votingsystem","root","password");

            // Get file path first
            String getPath = "SELECT file_path FROM Videos WHERE video_id=?";
            PreparedStatement ps1 = conn.prepareStatement(getPath);
            ps1.setInt(1, videoId);
            ResultSet rs = ps1.executeQuery();
            String filePath = null;
            if (rs.next()) filePath = rs.getString("file_path");

            // Delete record
            String sql = "DELETE FROM Videos WHERE video_id=?";
            PreparedStatement ps2 = conn.prepareStatement(sql);
            ps2.setInt(1, videoId);
            ps2.executeUpdate();

            // Delete actual file
            if (filePath != null) {
                String absolutePath = getServletContext().getRealPath("") + filePath;
                File f = new File(absolutePath);
                if (f.exists()) f.delete();
            }

            conn.close();
        } catch (Exception e) { e.printStackTrace(); }

        response.sendRedirect("adminVideos.jsp");
    }
}

