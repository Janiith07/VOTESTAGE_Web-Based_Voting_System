<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("manage-users");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Change User Role | VOTESTAGE</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#A777E3FF] font-roboto min-h-screen flex items-center justify-center">

<div class="bg-white p-10 rounded-2xl shadow-lg w-full max-w-md">
    <h2 class="text-2xl font-bold text-purple-700 mb-6 text-center">Change Role for User #<%= id %></h2>

    <form action="change-user-role" method="post" class="space-y-5">
        <input type="hidden" name="id" value="<%= id %>">

        <div>
            <label class="block font-semibold mb-1">New Role:</label>
            <select name="newRole" required
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-300">
                <option value="">-- Select New Role --</option>
                <option value="Voter">Voter</option>
                <option value="Contestant">Contestant</option>
                <option value="ContestantManager">ContestantManager</option>
                <option value="Judge">Judge</option>
                <option value="Admin">Admin</option>
            </select>
        </div>

        <div class="flex justify-between items-center">
            <button type="submit" class="bg-purple-700 text-white font-semibold px-6 py-2 rounded-lg hover:bg-purple-800 transition duration-200">
                Change Role
            </button>
            <a href="manage-users" class="bg-gray-400 text-white font-semibold px-6 py-2 rounded-lg hover:bg-gray-500 transition duration-200">
                Cancel
            </a>
        </div>
    </form>
</div>

</body>
</html>
