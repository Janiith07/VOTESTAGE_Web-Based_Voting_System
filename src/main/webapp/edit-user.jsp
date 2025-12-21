<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.Person" %>
<%
    Person user = (Person) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("manage-users?error=User+not+found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User | VOTESTAGE</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        #togglePassword:hover {
            color: #7F1DFF !important;
        }
    </style>
</head>
<body class="bg-[#A777E3FF] font-roboto min-h-screen flex items-center justify-center">

<div class="bg-white p-10 rounded-2xl shadow-lg w-full max-w-md">
    <h2 class="text-2xl font-bold text-purple-700 mb-6 text-center">Edit User</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="bg-red-100 text-red-700 p-3 rounded mb-5 text-center"><%= error %></div>
    <% } %>

    <form action="update-user" method="post" class="space-y-5">
        <input type="hidden" name="id" value="<%= user.getId() %>">

        <!-- Name -->
        <div>
            <label class="block font-semibold mb-1" for="name">Name</label>
            <input type="text" id="name" name="name" value="<%= user.getName() %>" required
                   class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300">
        </div>

        <!-- Email -->
        <div>
            <label class="block font-semibold mb-1" for="email">Email</label>
            <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required
                   class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300">
        </div>

        <!-- Password -->
        <div class="relative">
            <label class="block font-semibold mb-1" for="password">Password (leave blank to keep current)</label>
            <input type="password" id="password" name="password"
                   class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300 pr-12"
            >
            <!-- Eye toggle -->
            <button type="button" id="togglePassword" aria-label="Show password" title="Show password"
                    style="position: absolute; right: 12px; top: 0; bottom: 0; margin: auto 0; background: transparent; border: none; cursor: pointer; color: #666; padding: 0; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; transform: translateY(8px);">
                <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                     viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z"></path>
                    <circle cx="12" cy="12" r="3"></circle>
                </svg>
                <svg id="eyeClose" xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                     viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                     style="display:none;">
                    <path d="M17.94 17.94A10.94 10.94 0 0112 20c-7 0-11-8-11-8a21.3 21.3 0 015.14-6.08"></path>
                    <path d="M1 1l22 22"></path>
                </svg>
            </button>
        </div>

        <!-- Buttons -->
        <div class="flex justify-between items-center">
            <button type="submit" class="bg-purple-700 text-white font-semibold px-6 py-2 rounded-lg hover:bg-purple-800 transition duration-200">Save Changes</button>
            <a href="manage-users" class="bg-gray-400 text-white font-semibold px-6 py-2 rounded-lg hover:bg-gray-500 transition duration-200">Cancel</a>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const toggleBtn = document.getElementById('togglePassword');
        const pwd = document.getElementById('password');
        const eyeOpen = document.getElementById('eyeOpen');
        const eyeClose = document.getElementById('eyeClose');
        const form = document.querySelector('form');

        // Password Eye Toggle
        toggleBtn.addEventListener('click', function () {
            if (pwd.type === 'password') {
                pwd.type = 'text';
                eyeOpen.style.display = 'none';
                eyeClose.style.display = 'inline';
            } else {
                pwd.type = 'password';
                eyeOpen.style.display = 'inline';
                eyeClose.style.display = 'none';
            }
        });

        // ✅ Password Validation
        form.addEventListener('submit', function (e) {
            const password = pwd.value.trim();
            if (password !== "" && password.length < 8) {
                e.preventDefault();
                alert("Password must be at least 8 characters long!");
                pwd.focus();
            }
        });
    });
</script>

</body>
</html>
