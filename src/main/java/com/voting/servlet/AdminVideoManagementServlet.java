package com.voting.servlet;

import com.voting.dao.VideoDAO;
import com.voting.model.Video;
import org.apache.commons.io.FilenameUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/video")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 500,     // 500MB
        maxRequestSize = 1024 * 1024 * 600   // 600MB
)
public class AdminVideoManagementServlet extends HttpServlet {

    private VideoDAO dao = new VideoDAO();

    // Upload folder inside webapp (/videos)
    private String getUploadDir(HttpServletRequest req) {
        return req.getServletContext().getRealPath("/videos");
    }

    // 🔹 GET → list videos
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Video> videos = dao.getAllVideos();
            req.setAttribute("videos", videos);
            req.getRequestDispatcher("/adminVideos.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // 🔹 POST → upload/edit/delete
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String adminId = getAdminIdFromSession(req);

        try {
            if ("upload".equalsIgnoreCase(action)) {
                Part filePart = req.getPart("videoFile");
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String singer = req.getParameter("singer");
                String duration = req.getParameter("duration");
                String contestantId = req.getParameter("contestantId");

                String originalName = getSubmittedFileName(filePart);
                String ext = FilenameUtils.getExtension(originalName);
                String newName = UUID.randomUUID().toString() + "." + ext;

                // ✅ Save to webapp/videos folder
                String uploadDir = getUploadDir(req);
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();

                File outFile = new File(uploadFolder, newName);
                try (InputStream in = filePart.getInputStream()) {
                    Files.copy(in, outFile.toPath());
                }

                // ✅ Save relative path in DB
                String relativePath = "videos/" + newName;

                dao.insertVideo(title, description, relativePath,
                        contestantId, adminId, singer, duration);

                resp.sendRedirect("video"); // refresh list

            } else if ("edit".equalsIgnoreCase(action)) {
                int videoId = Integer.parseInt(req.getParameter("videoId"));
                String title = req.getParameter("title");
                String desc = req.getParameter("description");
                dao.updateVideoMetadata(videoId, title, desc);
                resp.sendRedirect("video");

            } else if ("delete".equalsIgnoreCase(action)) {
                int videoId = Integer.parseInt(req.getParameter("videoId"));
                Video v = dao.getVideo(videoId);
                if (dao.deleteVideo(videoId) && v != null) {
                    String uploadDir = getUploadDir(req);
                    File f = new File(uploadDir, new File(v.getFilePath()).getName());
                    if (f.exists()) f.delete();
                }
                resp.sendRedirect("video");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String cd : header.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private String getAdminIdFromSession(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("user_id") != null) {
            return (String) s.getAttribute("user_id");
        }
        return "P001"; // fallback admin ID
    }
}
