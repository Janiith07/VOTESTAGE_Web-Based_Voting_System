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

@WebServlet("/UpdateContestantServlet")
@MultipartConfig
public class UpdateContestantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("contestant_id");
        String name = request.getParameter("name");
        String ageParam = request.getParameter("age");
        String votesParam = request.getParameter("votes");

        if (idParam == null || idParam.equals("null") || idParam.isEmpty()) {
            response.sendRedirect("updateContestant.jsp?error=Contestant ID missing in request");
            return;
        }

        try {
            String id = idParam;
            int age = Integer.parseInt(ageParam);
            int votes = Integer.parseInt(votesParam);
            String gender = request.getParameter("gender");

            if (gender != null && gender.trim().isEmpty()) {
                gender = null;
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
                String uniqueFileName = "contestant_" + id + "_" + System.currentTimeMillis() + fileExtension;
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

                // Update Contestants table
                String sqlContestant;
                if (imagePath != null) {
                    sqlContestant = "UPDATE Contestants SET age = ?, gender = ?, total_votes_received = ?, image_path = ? WHERE person_id = ?";
                } else {
                    sqlContestant = "UPDATE Contestants SET age = ?, gender = ?, total_votes_received = ? WHERE person_id = ?";
                }

                try (PreparedStatement psContestant = con.prepareStatement(sqlContestant)) {
                    psContestant.setInt(1, age);
                    psContestant.setString(2, gender);

                    if (imagePath != null) {
                        psContestant.setInt(3, votes);
                        psContestant.setString(4, imagePath);
                        psContestant.setString(5, id);
                    } else {
                        psContestant.setInt(3, votes);
                        psContestant.setString(4, id);
                    }

                    int contestantUpdated = psContestant.executeUpdate();

                    if (contestantUpdated == 0) {
                        con.rollback();
                        response.sendRedirect("updateContestant.jsp?id=" + id + "&error=Contestant not found with ID: " + id);
                        return;
                    }
                }

                con.commit();

                // Success - redirect with success message
                response.sendRedirect("updateContestant.jsp?id=" + id + "&success=Contestant updated successfully!");

            } catch (SQLException e) {
                response.sendRedirect("updateContestant.jsp?id=" + id + "&error=Database error: " + e.getMessage());
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("updateContestant.jsp?error=Invalid number format in age or votes");
        } catch (Exception e) {
            response.sendRedirect("updateContestant.jsp?error=Unexpected error: " + e.getMessage());
        }
    }
}
