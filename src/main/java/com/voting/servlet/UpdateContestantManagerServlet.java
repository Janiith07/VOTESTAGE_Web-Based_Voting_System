package com.voting.servlet;

import com.voting.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/UpdateContestantManagerServlet")
@MultipartConfig
public class UpdateContestantManagerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("contestant_id");
        String name = request.getParameter("name");
        String managerLevel = request.getParameter("managerLevel");

        if (idParam == null || idParam.equals("null") || idParam.isEmpty()) {
            response.sendRedirect("updateContestant.jsp?error=ContestantManager ID missing in request");
            return;
        }

        try {
            String id = idParam;
            
            if (managerLevel == null || managerLevel.trim().isEmpty()) {
                managerLevel = "Standard";
            }

            Part filePart = request.getPart("image");
            String fileName = filePart != null ? filePart.getSubmittedFileName() : null;
            String imagePath = null;

            // Handle file upload
            if (fileName != null && !fileName.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + "img" + File.separator + "bg-img";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // Generate unique filename
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "contestant_manager_" + id + "_" + System.currentTimeMillis() + fileExtension;
                File file = new File(uploadDir, uniqueFileName);
                filePart.write(file.getAbsolutePath());
                imagePath = "img/bg-img/" + uniqueFileName;
            }

            // Database update
            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);

                // Update Persons table
                String sqlPerson = "UPDATE Persons SET name = ? WHERE person_id = ?";
                try (PreparedStatement psPerson = con.prepareStatement(sqlPerson)) {
                    psPerson.setString(1, name);
                    psPerson.setString(2, id);
                    int personUpdated = psPerson.executeUpdate();

                    if (personUpdated == 0) {
                        con.rollback();
                        response.sendRedirect("updateContestant.jsp?id=" + id + "&error=Person not found with ID: " + id);
                        return;
                    }
                }

                // Update ContestantManagers table
                String sqlContestantManager = "UPDATE ContestantManagers SET manager_level = ? WHERE person_id = ?";

                try (PreparedStatement psContestantManager = con.prepareStatement(sqlContestantManager)) {
                    psContestantManager.setString(1, managerLevel);
                    psContestantManager.setString(2, id);

                    int contestantManagerUpdated = psContestantManager.executeUpdate();

                    if (contestantManagerUpdated == 0) {
                        con.rollback();
                        response.sendRedirect("updateContestant.jsp?id=" + id + "&error=ContestantManager not found with ID: " + id);
                        return;
                    }
                }

                con.commit();

                // Success - redirect with success message
                response.sendRedirect("updateContestant.jsp?id=" + id + "&success=ContestantManager updated successfully!");

            } catch (SQLException e) {
                response.sendRedirect("updateContestant.jsp?id=" + id + "&error=Database error: " + e.getMessage());
            }

        } catch (Exception e) {
            response.sendRedirect("updateContestant.jsp?error=Unexpected error: " + e.getMessage());
        }
    }
}
