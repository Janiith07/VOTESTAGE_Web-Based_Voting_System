package com.voting.servlet;

import com.voting.model.*;
import com.voting.service.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/add-user")
public class AddUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("GET request received for /add-user");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userRole = (String) session.getAttribute("user_role");
        if (userRole == null || !userRole.equals("Admin")) {
            response.sendRedirect("manage-users?error=Access+Denied");
            return;
        }

        request.getRequestDispatcher("/add-user.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("POST request received for /add-user");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Content Type: " + request.getContentType());
        System.out.println("Method: " + request.getMethod());

        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("Session invalid or user not logged in");
            response.sendRedirect("login.jsp");
            return;
        }


        String userRole = (String) session.getAttribute("user_role");
        if (userRole == null || (!"Admin".equals(userRole) && !"ITSupporter".equals(userRole))) {
            System.out.println("Access denied - role: " + userRole);
            response.sendRedirect("manage-users?error=Access+Denied:+Only+Admins+and+IT+Supporters+can+add+users.");
            return;
        }

        try {
            // Get parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            System.out.println("Received parameters: name=" + name + ", email=" + email + ", role=" + role);

            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    role == null || role.trim().isEmpty()) {
                throw new IllegalArgumentException("All fields are required.");
            }

            // Server-side password validation
            if (password.length() < 8) {
                throw new IllegalArgumentException("Password must be at least 8 characters long.");
            }

            // Additional password validation
            if (!password.matches(".*[a-zA-Z].*")) {
                throw new IllegalArgumentException("Password must contain at least one letter.");
            }

            if (!password.matches(".*\\d.*")) {
                throw new IllegalArgumentException("Password must contain at least one number.");
            }

            // Process based on role
            switch (role) {
                case "Admin" -> {
                    String adminLevel = request.getParameter("adminLevel");
                    if (adminLevel == null || adminLevel.trim().isEmpty()) adminLevel = "Support";
                    Admin admin = new Admin(null, name, email, password, adminLevel);
                    AdminService.createAdmin(admin);
                    System.out.println("Admin created successfully: " + name);
                }
                case "Voter" -> {
                    Voter voter = new Voter(null, name, email, password, 0);
                    VoterService.registerVoter(voter);
                    System.out.println("Voter created successfully: " + name);
                }
                case "ContestantManager" -> {
                    String managerLevel = request.getParameter("managerLevel");
                    if (managerLevel == null || managerLevel.trim().isEmpty()) managerLevel = "Standard";
                    System.out.println("Creating ContestantManager with managerLevel: " + managerLevel);
                    ContestantManager contestantManager = new ContestantManager(null, name, email, password, managerLevel);
                    System.out.println("ContestantManager object created: " + contestantManager);
                    ContestantManagerService.registerContestantManager(contestantManager);
                    System.out.println("ContestantManager created successfully: " + name);
                }
                case "Judge" -> {
                    Judge judge = new Judge(null, name, email, password);
                    JudgeService.registerJudge(judge);
                    System.out.println("Judge created successfully: " + name);
                }
                case "ITSupporter" -> {
                    String supporterLevel = request.getParameter("supporterLevel");
                    if (supporterLevel == null || supporterLevel.trim().isEmpty()) supporterLevel = "Support";
                    Supporter supporter = new Supporter(null, name, email, password, supporterLevel);
                    SupporterService.registerSupporter(supporter);
                    System.out.println("ITSupporter created successfully: " + name);
                }
                default -> throw new IllegalArgumentException("Invalid role selected: " + role);
            }

            // Redirect with success message
            String encodedName = java.net.URLEncoder.encode(name, "UTF-8");
            response.sendRedirect("manage-users?message=User+" + encodedName + "+created+successfully!");
            System.out.println("Redirecting to manage-users with success message");

        } catch (Exception e) {
            System.out.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/add-user.jsp").forward(request, response);
        }
    }
}