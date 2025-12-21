<%@ page import="com.voting.model.Contestant" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");   // ✅ add this
    String name = request.getParameter("name");
%>

<input type="hidden" name="contestant_id" value="<%= request.getParameter("id") %>">

<!DOCTYPE html>
<html>
<head>
    <title><%= name != null ? name : "Contestant Profile" %></title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6a11cb;
            --primary-light: #8a2be2;
            --secondary: #ff6b9d;
            --accent: #00d4aa;
            --dark: #1a1a2e;
            --light: #f8f9ff;
            --success: #28a745;
            --warning: #ffc107;
            --danger: #e63946;
            --card-bg: rgba(255, 255, 255, 0.95);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
            min-height: 100vh;
            line-height: 1.6;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            width: 100%;
            max-width: 420px;
            margin: 0 auto;
        }

        .profile-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
        }

        .profile-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }

        .profile-image-container {
            position: relative;
            margin-bottom: 20px;
        }

        .profile-card img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .profile-card:hover img {
            transform: scale(1.02);
        }

        .profile-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.8rem;
            font-weight: 700;
            margin: 15px 0;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
        }

        .profile-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin: 15px 0;
        }

        .info-item {
            background: rgba(106, 17, 203, 0.05);
            padding: 10px;
            border-radius: 10px;
            text-align: center;
        }

        .info-label {
            font-size: 0.8rem;
            color: var(--primary);
            font-weight: 600;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--dark);
        }

        .votes {
            background: linear-gradient(90deg, var(--accent), #2afcb2);
            color: white;
            padding: 12px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.2rem;
            margin: 20px 0;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 212, 170, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        form {
            margin-top: 20px;
            text-align: left;
        }

        .form-section {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        .form-section:last-of-type {
            border-bottom: none;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: var(--dark);
            font-size: 0.9rem;
        }

        input[type="text"], input[type="number"], input[type="file"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.8);
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            margin-top: 5px;
        }

        input[type="text"]:focus, input[type="number"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(106, 17, 203, 0.2);
            background: white;
        }

        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
            margin-top: 5px;
        }

        .file-input-wrapper input[type=file] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-input-custom {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px 15px;
            border: 1px dashed #ccc;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.8);
            color: #666;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }

        .file-input-wrapper:hover .file-input-custom {
            border-color: var(--primary);
            color: var(--primary);
            background: white;
        }

        .btn {
            margin-top: 15px;
            padding: 12px 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .btn-update {
            background: linear-gradient(90deg, var(--primary), var(--primary-light));
            color: white;
        }

        .btn-update:hover {
            background: linear-gradient(90deg, var(--primary-light), var(--primary));
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(106, 17, 203, 0.3);
        }

        .btn-delete {
            background: linear-gradient(90deg, var(--danger), #ff4d6d);
            color: white;
        }

        .btn-delete:hover {
            background: linear-gradient(90deg, #ff4d6d, var(--danger));
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(230, 57, 70, 0.3);
        }

        .back-box {
            margin-top: 25px;
            text-align: center;
        }

        .back-box a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            background: linear-gradient(90deg, var(--warning), #ffd166);
            color: var(--dark);
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.3);
        }

        .back-box a:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 193, 7, 0.4);
        }

        .no-contestant {
            text-align: center;
            padding: 40px 20px;
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .no-contestant h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.8rem;
            margin-bottom: 15px;
            color: var(--secondary);
        }

        @media (max-width: 480px) {
            .container {
                padding: 10px;
            }

            .profile-card {
                padding: 20px;
            }

            h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <% if(name != null) { %>
    <%
        String imgPath = "";
        int age = 0;
        int votes = 0;
        String gender = "";

        if("DJ Nova".equals(name)) {
            imgPath = "img/bg-img/dj_nova.jpg"; age = 25; votes = 1247; gender="Male";
        } else if("MC Blaze".equals(name)) {
            imgPath = "img/bg-img/mc_blaze.jpg"; age = 27; votes = 980; gender="Male";
        } else if("Luna Star".equals(name)) {
            imgPath = "img/bg-img/luna_star.jpg"; age = 23; votes = 870; gender="Female";
        } else if("Beat King".equals(name)) {
            imgPath = "img/bg-img/beat_king.jpg"; age = 26; votes = 650; gender="Male";
        } else if("Rhythm Queen".equals(name)) {
            imgPath = "img/bg-img/rhythm_queen.jpg"; age = 24; votes = 430; gender="Female";
        }
    %>

    <div class="profile-card">
        <div class="profile-image-container">
            <img src="<%= imgPath %>" alt="<%= name %>" onerror="this.style.display='none'; this.parentNode.innerHTML += '<div style=\'width:100%; height:220px; background:linear-gradient(135deg, var(--primary), var(--secondary)); border-radius:15px; display:flex; align-items:center; justify-content:center; color:white; font-size:1.5rem; font-weight:bold;\'><i class=\'fas fa-user\'></i> <%= name %></div>'">
            <div class="profile-badge">CONTESTANT</div>
        </div>

        <h2><%= name %></h2>

        <div class="profile-info">
            <div class="info-item">
                <div class="info-label">AGE</div>
                <div class="info-value"><%= age %></div>
            </div>
            <div class="info-item">
                <div class="info-label">GENDER</div>
                <div class="info-value"><%= gender %></div>
            </div>
        </div>

        <div class="votes">
            <i class="fas fa-trophy"></i>
            <%= votes %> Votes Received
        </div>

        <!-- ✅ Update Form -->
        <form action="UpdateContestantServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="contestant_id" value="<%= id %>">

            <div class="form-section">
                <h3 style="font-family: 'Montserrat', sans-serif; color: var(--primary); margin-bottom: 15px; font-size: 1.2rem;">Update Profile</h3>

                <label>Name:</label>
                <input type="text" name="name" value="<%= name %>">

                <label>Age:</label>
                <input type="number" name="age" value="<%= age %>">

                <label>Votes:</label>
                <input type="number" name="votes" value="<%= votes %>">

                <label>Upload New Image:</label>
                <div class="file-input-wrapper">
                    <div class="file-input-custom">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <span>Choose an image file</span>
                    </div>
                    <input type="file" name="image">
                </div>

                <button type="submit" class="btn btn-update">
                    <i class="fas fa-save"></i> Update Profile
                </button>
            </div>
        </form>

        <!-- ✅ Delete Button -->
        <form action="DeleteContestantServlet" method="post">
            <input type="hidden" name="name" value="<%= name %>">
            <button type="submit" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete <%= name %>? This action cannot be undone.')">
                <i class="fas fa-trash-alt"></i> Delete Contestant
            </button>
        </form>
    </div>
    <% } else { %>
    <div class="no-contestant">
        <h2>No Contestant Selected!</h2>
        <p>Please select a contestant from the dashboard to view their profile.</p>
    </div>
    <% } %>

    <div class="back-box">
        <a href="contestant-dashboard.jsp">
            <i class="fas fa-arrow-left"></i> Back to Contestants
        </a>
    </div>
</div>
</body>
</html>

