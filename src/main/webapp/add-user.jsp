<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add New User</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    #togglePassword:hover {
      color: #7F1DFF !important;
    }
  </style>
</head>
<body class="bg-[#A777E3FF] font-roboto min-h-screen flex items-center justify-center">

<div class="bg-white p-10 rounded-2xl shadow-lg w-full max-w-lg">
  <h2 class="text-2xl font-bold text-purple-700 mb-6 text-center">Add New User</h2>

  <form action="${pageContext.request.contextPath}/add-user" method="post" class="space-y-5" id="userForm">

    <!-- Name -->
    <div>
      <label class="block font-semibold mb-1">Name</label>
      <input type="text" name="name" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300">
    </div>

    <!-- Email -->
    <div>
      <label class="block font-semibold mb-1">Email</label>
      <input type="email" name="email" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300">
    </div>

    <!-- Password with Error Message -->
    <div class="relative">
      <label class="block font-semibold mb-1">Password</label>
      <input type="password" id="password" name="password" required
             class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300 pr-12"
             style="padding-right: 3rem !important;">
      <span id="passwordError" class="text-red-500 text-sm hidden">Password must be at least 8 characters long.</span>

      <!-- Eye Toggle -->
      <button type="button" id="togglePassword" aria-label="Show password" title="Show password"
              style="position: absolute; right: 12px; top: 0; bottom: 0; margin: auto 0; background: transparent; border: none; cursor: pointer; color: #666; padding: 0; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; transform: translateY(8px);">
        <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" width="14" height="14"
             viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z"></path>
          <circle cx="12" cy="12" r="3"></circle>
        </svg>
        <svg id="eyeClose" xmlns="http://www.w3.org/2000/svg" width="14" height="14"
             viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             style="display:none;">
          <path d="M17.94 17.94A10.94 10.94 0 0112 20c-7 0-11-8-11-8a21.3 21.3 0 015.14-6.08"></path>
          <path d="M1 1l22 22"></path>
        </svg>
      </button>
    </div>

    <!-- Role Selection -->
    <div>
      <label class="block font-semibold mb-1">Role</label>
      <select name="role" required onchange="toggleFields()"
              class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300">
        <option value="">-- Select Role --</option>
        <option value="Admin">Admin</option>
        <option value="ContestantManager">ContestantManager</option>
        <option value="ITSupporter">IT Supporter</option>
        <option value="Judge">Judge</option>
        <option value="Contestant">Contestant</option>
        <option value="Voter">Voter</option>
      </select>
    </div>

    <!-- Admin Level -->
    <div id="adminLevelGroup" class="hidden">
      <label class="block font-semibold mb-1">Admin Level</label>
      <select name="adminLevel" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300">
        <option value="Support">Support</option>
        <option value="Moderator">Moderator</option>
        <option value="Super">Super</option>
      </select>
    </div>

    <!-- Buttons -->
    <div class="flex justify-between items-center">
      <button type="submit" class="bg-purple-700 text-white font-semibold px-6 py-2 rounded-lg hover:bg-purple-800 transition duration-200">
        Create User
      </button>
      <a href="manage-users" class="bg-gray-400 text-white font-semibold px-6 py-2 rounded-lg hover:bg-gray-500 transition duration-200">Cancel</a>
    </div>

  </form>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('userForm');
    const password = document.getElementById('password');
    const passwordError = document.getElementById('passwordError');
    const toggleBtn = document.getElementById('togglePassword');
    const eyeOpen = document.getElementById('eyeOpen');
    const eyeClose = document.getElementById('eyeClose');

    // Password Toggle
    toggleBtn.addEventListener('click', function () {
      if (password.type === 'password') {
        password.type = 'text';
        eyeOpen.style.display = 'none';
        eyeClose.style.display = 'inline';
      } else {
        password.type = 'password';
        eyeOpen.style.display = 'inline';
        eyeClose.style.display = 'none';
      }
    });

    // Password Validation on Submit
    form.addEventListener('submit', function (e) {
      if (password.value.length < 8) {
        e.preventDefault();
        passwordError.classList.remove('hidden');
        password.classList.add('border-red-500');
      } else {
        passwordError.classList.add('hidden');
        password.classList.remove('border-red-500');
      }
    });
  });
</script>

</body>
</html>
