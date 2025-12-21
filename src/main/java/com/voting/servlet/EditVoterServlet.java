package com.voting.servlet;

import com.voting.dao.PersonDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EditVoterServlet")
public class EditVoterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String personId = (String) session.getAttribute("user_id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            boolean updated = false;

            if (password != null && !password.trim().isEmpty()) {
                // Server-side password validation
                if (password.length() < 8) {
                    response.sendRedirect("voter-dashboard.jsp?error=1&message=Password+must+be+at+least+8+characters+long");
                    return;
                }

                // Additional password validation
                if (!password.matches(".*[a-zA-Z].*")) {
                    response.sendRedirect("voter-dashboard.jsp?error=1&message=Password+must+contain+at+least+one+letter");
                    return;
                }

                if (!password.matches(".*\\d.*")) {
                    response.sendRedirect("voter-dashboard.jsp?error=1&message=Password+must+contain+at+least+one+number");
                    return;
                }

                if (confirmPassword == null || !password.equals(confirmPassword)) {
                    response.sendRedirect("voter-dashboard.jsp?error=1&message=Passwords+do+not+match");
                    return;
                }
                // Update name, email, AND password
                updated = PersonDAO.updateVoterDetails(personId, name, email, password);
            } else {
                // Only update name and email
                updated = PersonDAO.updateVoterNameEmail(personId, name, email);
            }

            if (updated) {
                session.setAttribute("user_name", name);
                session.setAttribute("user_email", email);
                response.sendRedirect("voter-dashboard.jsp?success=1");
            } else {
                response.sendRedirect("voter-dashboard.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("voter-dashboard.jsp?error=1");
        }
    }
}
