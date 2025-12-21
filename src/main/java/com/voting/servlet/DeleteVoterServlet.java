package com.voting.servlet;

import com.voting.dao.PersonDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteVoterServlet")
public class DeleteVoterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        deleteUser(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        deleteUser(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the user ID to delete from the request parameter
        String userIdToDelete = request.getParameter("user_id");
        
        if (userIdToDelete == null || userIdToDelete.trim().isEmpty()) {
            response.sendRedirect("manage-users?error=Invalid user ID");
            return;
        }

        try {
            boolean deleted = PersonDAO.deletePersonById(userIdToDelete);
            
            if (deleted) {
                // Check if the deleted user is the currently logged-in user
                String loggedInUserId = (String) session.getAttribute("user_id");
                if (userIdToDelete.equals(loggedInUserId)) {
                    // User deleted themselves, invalidate session and redirect to login
                    session.invalidate();
                    response.sendRedirect("index.jsp?message=Account deleted successfully");
                } else {
                    // Redirect back to manage users with success message
                    response.sendRedirect("manage-users?message=User deleted successfully");
                }
            } else {
                response.sendRedirect("manage-users?error=Failed to delete user");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users?error=Error: " + e.getMessage());
        }
    }
}
