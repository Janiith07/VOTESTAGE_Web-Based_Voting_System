<!-- src/main/webapp/forgot-password.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>🔑 Forgot Password</title>
  <style>
    body { font-family: Arial; margin: 40px; background: #f8f9fa; }
    .container { max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #dc3545; }
    .form-group { margin: 20px 0; }
    label { display: block; margin-bottom: 8px; font-weight: bold; }
    input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    button { width: 100%; padding: 12px; background: #fd7e14; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
    button:hover { background: #e07107; }
    .back { text-align: center; margin-top: 20px; }
    .error { color: red; background: #f8d7da; padding: 10px; border-radius: 4px; margin: 10px 0; }
    .success { color: green; background: #d4edda; padding: 10px; border-radius: 4px; margin: 10px 0; }
  </style>
</head>
<body>
<div class="container">
  <h2>🔑 Forgot Password</h2>

  <% if (request.getAttribute("error") != null) { %>
  <div class="error">
    <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <% if (request.getAttribute("message") != null) { %>
  <div class="success">
    <%= request.getAttribute("message") %>
  </div>
  <% } %>

  <form action="forgot-password" method="post">
    <div class="form-group">
      <label>Email:</label>
      <input type="email" name="email" required autofocus>
    </div>


    <div class="form-group">
      <label>New Password:</label>
      <input type="password" name="newPassword" id="newPassword" required placeholder="Minimum 8 characters">
      <div id="passwordStrength" style="margin-top: 5px; font-size: 12px;"></div>
      <div id="passwordError" style="color: red; font-size: 12px; margin-top: 5px; display: none;"></div>
    </div>

    <button type="submit">Reset Password</button>
  </form>

  <div class="back">
    <a href="login.jsp">← Back to Login</a>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('newPassword');
    const passwordStrength = document.getElementById('passwordStrength');
    const passwordError = document.getElementById('passwordError');
    const form = document.querySelector('form');

    // Password strength indicator
    passwordInput.addEventListener('input', function() {
        const password = this.value;
        const length = password.length;
        
        // Clear previous error
        passwordError.style.display = 'none';
        
        if (length === 0) {
            passwordStrength.textContent = '';
            passwordStrength.style.color = '';
        } else if (length < 8) {
            passwordStrength.textContent = `Password too short (${length}/8 characters)`;
            passwordStrength.style.color = 'red';
        } else if (length < 12) {
            passwordStrength.textContent = `Good password (${length} characters)`;
            passwordStrength.style.color = 'orange';
        } else {
            passwordStrength.textContent = `Strong password (${length} characters)`;
            passwordStrength.style.color = 'green';
        }
    });

    // Form validation
    form.addEventListener('submit', function(e) {
        const password = passwordInput.value;
        
        // Clear previous error
        passwordError.style.display = 'none';
        
        // Validate password length
        if (password.length < 8) {
            e.preventDefault();
            passwordError.textContent = 'Password must be at least 8 characters long.';
            passwordError.style.display = 'block';
            passwordInput.focus();
            return false;
        }
        
        // Additional password validation (optional)
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
        
        return true;
    });
});
</script>
</body>
</html>