<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.dao.PersonDAO" %>
<%@ page import="com.voting.model.Person" %>
<%
    String userName = (String) session.getAttribute("user_name");
    String userId = (String) session.getAttribute("user_id");
    if (userName == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean success = request.getParameter("success") != null;
    boolean error = request.getParameter("error") != null;
    Person voter = null;
    try {
        voter = PersonDAO.getPersonById(userId);
    } catch (Exception e) {
        voter = null;
    }
%>
<%
    // Get messages from session
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    // Clear messages from session after displaying
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>
<%
    // Get success message for new registrations
    String successMessage1 = request.getParameter("success");
    if (successMessage1 != null) {
%>

<%
    }
%>
<!-- Then display messages somewhere in the page -->
<% if (successMessage != null) { %>
<div class="alert alert-success">
    <i class="fas fa-check-circle"></i> <%= successMessage %>
</div>
<% } %>

<% if (errorMessage != null) { %>
<div class="alert alert-error">
    <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
</div>
<% } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Voting System</title>
    <link href="https://fonts.googleapis.com/css?family=Archivo+Narrow:400,500,600,700" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Archivo Narrow', sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            margin: 0;
            padding: 0;
            color: #fff;
        }
        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
            background: rgba(20, 30, 60, 0.95);
            border-radius: 8px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.3);
        }
        .glass-card {
            background: rgba(40, 60, 120, 0.2);
            border-radius: 10px;
            padding: 20px;
            margin: 10px 0;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .dashboard-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .dashboard-header h1 {
            font-size: 28px;
            margin: 0;
            color: #fff;
            letter-spacing: 2px;
        }
        .dashboard-header p {
            font-size: 16px;
            color: #b0c4de;
        }
        .success-message {
            padding: 10px 20px;
            margin: 10px 0;
            border-radius: 5px;
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .card-header i {
            font-size: 24px;
            color: #b0c4de;
            margin-right: 10px;
        }
        .card-header h2 {
            color: #b0c4de;
        }
        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 15px;
            display: block;
        }
        .user-info {
            text-align: center;
            margin-bottom: 15px;
        }
        .info-item {
            margin: 10px 0;
        }
        .info-label {
            font-weight: bold;
            color: #b0c4de;
        }
        .info-value {
            color: #fff;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 5px 0;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-align: center;
            text-decoration: none;
        }
        .btn-primary {
            background-color: #302b63;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #0f0c29;
        }
        .btn-danger {
            background-color: #dc3545;
            color: #fff;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #fff;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            color: #333;
        }
        .action-buttons {
            text-align: right;
        }
    </style>
</head>
<body>
<% if (voter != null) { %>
<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>User Dashboard</h1>
        <p>Manage your account information and settings</p>
    </div>

    <% if (success) { %>
    <div id="successMessage" class="success-message" style="display:block;">
        Your profile has been updated successfully!
    </div>
    <% } %>

    <% if (error) { %>
    <div class="success-message" style="background:rgba(220,53,69,0.2);border-left:4px solid #dc3545;display:block;">
        <%
            String errorMsg = request.getParameter("message");
            if (errorMsg != null) {
                out.print(errorMsg.replace("+", " "));
            } else {
                out.print("There was an error updating your profile. Please try again.");
            }
        %>
    </div>
    <% } %>

    <div class="dashboard-content">
        <!-- Profile Information -->
        <div class="glass-card">
            <div class="card-header">
                <i class="fas fa-user-circle"></i>
                <h2>Profile Information</h2>
            </div>
            <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEyMCIgdmlld0JveD0iMCAwIDEyMCAxMjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPGNpcmNsZSBjeD0iNjAiIGN5PSI2MCIgcj0iNjAiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4xKSIvPgogIDxjaXJjbGUgY3g9IjYwIiBjeT0iNDUiIHI9IjE4IiBmaWxsPSJyZ2JhKDI1NSwyNTUsMjU1LDAuMykiLz4KICA8cGF0aCBkPSJNNTAgODVDNTAgNzguOTIzNSA1NC45MjM1IDc0IDYxIDc0QzY3LjA3NjUgNzQgNzIgNzguOTIzNSA3MiA4NUg1MFoiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4zKSIvPgo8L3N2Zz4K"
                 alt="Profile" class="profile-image">
            <div class="user-info">
                <div class="info-item">
                    <span class="info-label">Username:</span>
                    <span class="info-value"><%= voter.getName() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Email:</span>
                    <span class="info-value"><%= voter.getEmail() %></span>
                </div>
            </div>
            <form method="post" action="DeleteVoterServlet">
                <button class="btn btn-danger" type="submit">
                    <i class="fas fa-trash-alt"></i> Delete Account
                </button>
            </form>
        </div>

        <!-- Edit Profile -->
        <div class="glass-card">
            <div class="card-header">
                <i class="fas fa-edit"></i>
                <h2>Edit Profile</h2>
            </div>
            <form method="post" action="EditVoterServlet">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="name" class="form-control"
                           value="<%= voter.getName() %>" required>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control"
                           value="<%= voter.getEmail() %>" required>
                </div>
                <div class="form-group">
                    <label for="password">New Password</label>
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="Enter new password (min 8 characters)">
                    <div id="passwordStrength" style="margin-top: 5px; font-size: 12px; color: #b0c4de;"></div>
                    <div id="passwordError" style="color: #ff6b6b; font-size: 12px; margin-top: 5px; display: none;"></div>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           class="form-control" placeholder="Confirm new password">
                    <div id="confirmPasswordError" style="color: #ff6b6b; font-size: 12px; margin-top: 5px; display: none;"></div>
                </div>
                <div class="action-buttons">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } else { %>
<div class="dashboard-container">
    <h2>Error loading voter details.</h2>
    <p>Please try again later or contact support.</p>
</div>
<% } %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordError = document.getElementById('passwordError');
        const confirmPasswordError = document.getElementById('confirmPasswordError');
        const form = document.querySelector('form[action="EditVoterServlet"]');

        if (passwordInput && form) {
            // Password strength indicator
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                const length = password.length;

                // Clear previous errors
                passwordError.style.display = 'none';
                confirmPasswordError.style.display = 'none';

                if (length === 0) {
                    passwordStrength.textContent = '';
                    passwordStrength.style.color = '#b0c4de';
                } else if (length < 8) {
                    passwordStrength.textContent = `Password too short (${length}/8 characters)`;
                    passwordStrength.style.color = '#ff6b6b';
                } else if (length < 12) {
                    passwordStrength.textContent = `Good password (${length} characters)`;
                    passwordStrength.style.color = '#ffa726';
                } else {
                    passwordStrength.textContent = `Strong password (${length} characters)`;
                    passwordStrength.style.color = '#66bb6a';
                }

                // Check password confirmation if confirm field has value
                if (confirmPasswordInput.value) {
                    validatePasswordConfirmation();
                }
            });

            // Password confirmation validation
            confirmPasswordInput.addEventListener('input', validatePasswordConfirmation);

            function validatePasswordConfirmation() {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;

                if (confirmPassword && password !== confirmPassword) {
                    confirmPasswordError.textContent = 'Passwords do not match.';
                    confirmPasswordError.style.display = 'block';
                    return false;
                } else {
                    confirmPasswordError.style.display = 'none';
                    return true;
                }
            }

            // Form validation
            form.addEventListener('submit', function(e) {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;

                // Clear previous errors
                passwordError.style.display = 'none';
                confirmPasswordError.style.display = 'none';

                // Only validate if password is provided
                if (password && password.length > 0) {
                    // Validate password length
                    if (password.length < 8) {
                        e.preventDefault();
                        passwordError.textContent = 'Password must be at least 8 characters long.';
                        passwordError.style.display = 'block';
                        passwordInput.focus();
                        return false;
                    }

                    // Additional password validation
                    if (!/(?=.*[a-zA-Z])/.test(password)) {
                        e.preventDefault();
                        passwordError.textContent = 'Password must contain at least one letter.';
                        passwordError.style.display = 'block';
                        passwordInput.focus();
                        return false;
                    }

                    if (!/(?=.*\d)/.test(password)) {
                        e.preventDefault();
                        passwordError.textContent = 'Password must contain at least one number.';
                        passwordError.style.display = 'block';
                        passwordInput.focus();
                        return false;
                    }

                    // Validate password confirmation
                    if (password !== confirmPassword) {
                        e.preventDefault();
                        confirmPasswordError.textContent = 'Passwords do not match.';
                        confirmPasswordError.style.display = 'block';
                        confirmPasswordInput.focus();
                        return false;
                    }
                }

                return true;
            });
        }
    });
</script>

</body>
</html>