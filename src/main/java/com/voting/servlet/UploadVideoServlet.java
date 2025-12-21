package com.voting.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.sql.*;

@MultipartConfig
public class UploadVideoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String singer = request.getParameter("singer");
        String duration = request.getParameter("duration");

        Part filePart = request.getPart("videoFile");
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + "videos" + File.separator + fileName;
        filePart.write(uploadPath);

        String filePath = "videos/" + fileName;

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/votingsystem","root","password");
            String sql = "INSERT INTO Videos (title, description, original_singer, duration, file_path) VALUES (?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, singer);
            ps.setString(4, duration);
            ps.setString(5, filePath);
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }

        response.sendRedirect("adminVideos.jsp");
    }
}
