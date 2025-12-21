<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.service.JudgeService" %>
<%@ page import="java.sql.ResultSet" %>
<%
    String userName = (String) session.getAttribute("user_name");
    String judgeId = (String) session.getAttribute("user_id");

    if (userName == null || judgeId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ResultSet goldenVotes = null;
    try {
        goldenVotes = JudgeService.getGoldenVotes();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<%
    String role = (String) session.getAttribute("role");  // You must have set this at login
    String votePage = "#"; // default

    if ("Judge".equalsIgnoreCase(role)) {
        votePage = "judge-vote.jsp";
    } else if ("Voter".equalsIgnoreCase(role)) {
        votePage = "voter-vote.jsp";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VotesStage - Score Contestants</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%);
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px 0;
            background: linear-gradient(135deg, #2c3e50, #3498db);
            color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .tagline {
            font-size: 1.2rem;
            opacity: 0.9;
            font-weight: 300;
        }

        .page-title {
            text-align: center;
            margin-bottom: 40px;
        }

        .page-title h1 {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 10px;
            position: relative;
            display: inline-block;
        }

        .page-title h1:after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(to right, #3498db, #2c3e50);
            border-radius: 2px;
        }

        .page-title p {
            color: #7f8c8d;
            font-size: 1.1rem;
            max-width: 600px;
            margin: 20px auto 0;
        }

        .contestants-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }

        .contestant-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .contestant-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .performance-image {
            height: 200px;
            background-size: cover;
            background-position: center;
            position: relative;
        }

        .performance-image:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 60%;
            background: linear-gradient(to bottom, transparent, rgba(0,0,0,0.7));
        }

        .performance-title {
            position: absolute;
            bottom: 15px;
            left: 20px;
            color: white;
            font-size: 1.4rem;
            font-weight: 600;
            z-index: 2;
        }

        .contestant-info {
            padding: 25px;
        }

        .contestant-name {
            font-size: 1.3rem;
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .contestant-name i {
            margin-right: 10px;
            color: #3498db;
        }

        .performance-details {
            margin-bottom: 20px;
        }

        .detail-item {
            display: flex;
            margin-bottom: 8px;
            color: #555;
        }

        .detail-item i {
            margin-right: 10px;
            color: #7f8c8d;
            width: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
        }

        .btn {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 0.95rem;
            text-decoration: none;
        }

        .btn-vote {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-vote:hover {
            background: linear-gradient(135deg, #2980b9, #2573a7);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
        }

        .btn-comment {
            background: #f8f9fa;
            color: #2c3e50;
            border: 1px solid #e9ecef;
        }

        .btn-comment:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        .golden-votes {
            background: linear-gradient(135deg, #ffd700, #ffb700);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(255, 215, 0, 0.2);
        }

        .golden-votes h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .golden-votes-list {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }

        .golden-vote-item {
            background: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        footer {
            text-align: center;
            padding: 30px 0;
            color: #7f8c8d;
            border-top: 1px solid #e9ecef;
            margin-top: 50px;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: #fff;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            max-width: 450px;
            width: 90%;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            animation: modalAppear 0.3s ease;
        }

        @keyframes modalAppear {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .modal-icon {
            font-size: 4rem;
            color: #27ae60;
            margin-bottom: 1rem;
        }

        .modal h3 {
            color: #2c3e50;
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }

        .modal p {
            color: #555;
            margin-bottom: 1.5rem;
        }

        .modal-btn {
            padding: 0.8rem 1.5rem;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .modal-btn:hover {
            background-color: #2980b9;
        }

        @media (max-width: 768px) {
            .contestants-grid { grid-template-columns: 1fr; }
            .action-buttons { flex-direction: column; }
            .golden-votes-list { flex-direction: column; }
            .page-title h1 { font-size: 2rem; }
            .logo { font-size: 2.2rem; }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .contestant-card {
            animation: fadeInUp 0.6s ease forwards;
        }
        .contestant-card:nth-child(2) { animation-delay: 0.1s; }
        .contestant-card:nth-child(3) { animation-delay: 0.2s; }
        .contestant-card:nth-child(4) { animation-delay: 0.3s; }
    </style>
</head>
<body>
<div class="container">
    <header style="display: flex; justify-content: space-between; align-items: center; padding: 0 20px;">
        <!-- Left side (Logo + tagline) -->
        <div style="display: flex; align-items: center; gap: 12px;">
            <span class="logo">VotesStage</span>
            <span class="tagline">Score Contestants</span>
            <button class="btn btn-primary" id="logoutBtn"
                    style="padding: 8px 16px; font-size: 0.9rem; border-radius: 6px; background: #3498db; color: white; border: none; cursor: pointer;">
                Logout
            </button>
        </div>

        <!-- Right side (Account Button) -->
        <div>
            <button class="btn btn-primary" id="accountBtn"
                    style="padding: 8px 16px; font-size: 0.9rem; border-radius: 6px; background: #3498db; color: white; border: none; cursor: pointer;">
                Account
            </button>

        </div>
    </header>

    <div class="page-title">
        <h1>Score Contestants</h1>
        <p>Evaluate performances and cast your votes for the most talented contestants</p>
    </div>

    <!-- Golden Votes Section -->
    <div class="golden-votes">
        <h2><i class="fas fa-crown"></i> Recent Golden Votes</h2>
        <div class="golden-votes-list">
            <%
                if (goldenVotes != null) {
                    try {
                        while (goldenVotes.next()) {
            %>
            <div class="golden-vote-item">
                <i class="fas fa-star" style="color: #ffd700;"></i>
                <%= goldenVotes.getString("judge_name") %> → <%= goldenVotes.getString("contestant_name") %>
                <br><small><%= goldenVotes.getString("performance") %></small>
            </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
            %>
            <div class="golden-vote-item">
                <i class="fas fa-star" style="color: #ffd700;"></i>
                No golden votes recorded yet.
            </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- Contestants Grid -->
    <div class="contestants-grid">
        <!-- Contestant 1 -->
        <div class="contestant-card">
            <div class="performance-image" style="background-image: url('https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80');">
                <div class="performance-title">Noon Dreams</div>
            </div>
            <div class="contestant-info">
                <div class="contestant-name">
                    <i class="fas fa-user"></i> Emma Watson
                </div>
                <div class="performance-details">
                    <div class="detail-item">
                        <i class="far fa-calendar-alt"></i> Performance Date: 2024-03-15
                    </div>
                    <div class="detail-item">
                        <i class="far fa-clock"></i> Duration: 3:45
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="judge-vote.jsp?contestantId=P001&contestantName=Emma Watson&performance=Noon Dreams" class="btn btn-vote">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </a>
                    <a href="comment.jsp?contestantId=P001" class="btn btn-comment">
                        <i class="far fa-comment"></i> Comment
                    </a>
                </div>
            </div>
        </div>

        <!-- Contestant 2 -->
        <div class="contestant-card">
            <div class="performance-image" style="background-image: url('https://images.unsplash.com/photo-1508700929628-666bc8bd84ea?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80');">
                <div class="performance-title">Urban Rhythm</div>
            </div>
            <div class="contestant-info">
                <div class="contestant-name">
                    <i class="fas fa-user"></i> Tom Holland
                </div>
                <div class="performance-details">
                    <div class="detail-item">
                        <i class="far fa-calendar-alt"></i> Performance Date: 2024-03-16
                    </div>
                    <div class="detail-item">
                        <i class="far fa-clock"></i> Duration: 4:20
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="judge-vote.jsp?contestantId=P002&contestantName=Tom Holland&performance=Urban Rhythm" class="btn btn-vote">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </a>
                    <a href="comment.jsp?contestantId=P002" class="btn btn-comment">
                        <i class="far fa-comment"></i> Comment
                    </a>
                </div>
            </div>
        </div>

        <!-- Contestant 3 -->
        <div class="contestant-card">
            <div class="performance-image" style="background-image: url('https://images.unsplash.com/photo-1511379938547-c1f69419868d?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80');">
                <div class="performance-title">Piano Symphony</div>
            </div>
            <div class="contestant-info">
                <div class="contestant-name">
                    <i class="fas fa-user"></i> Sophia Turner
                </div>
                <div class="performance-details">
                    <div class="detail-item">
                        <i class="far fa-calendar-alt"></i> Performance Date: 2024-03-17
                    </div>
                    <div class="detail-item">
                        <i class="far fa-clock"></i> Duration: 5:15
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="judge-vote.jsp?contestantId=P003&contestantName=Sophia Turner&performance=Piano Symphony" class="btn btn-vote">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </a>
                    <a href="comment.jsp?contestantId=P003" class="btn btn-comment">
                        <i class="far fa-comment"></i> Comment
                    </a>
                </div>
            </div>
        </div>

        <!-- Contestant 4 -->
        <div class="contestant-card">
            <div class="performance-image" style="background-image: url('https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80');">
                <div class="performance-title">Acoustic Melody</div>
            </div>
            <div class="contestant-info">
                <div class="contestant-name">
                    <i class="fas fa-user"></i> Chris Evans
                </div>
                <div class="performance-details">
                    <div class="detail-item">
                        <i class="far fa-calendar-alt"></i> Performance Date: 2024-03-18
                    </div>
                    <div class="detail-item">
                        <i class="far fa-clock"></i> Duration: 4:05
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="judge-vote.jsp?contestantId=P004&contestantName=Chris Evans&performance=Acoustic Melody" class="btn btn-vote">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </a>
                    <a href="comment.jsp?contestantId=P004" class="btn btn-comment">
                        <i class="far fa-comment"></i> Comment
                    </a>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>VotesStage &copy; 2024. All rights reserved.</p>
    </footer>
</div>

<!-- Success Modal -->
<div class="modal" id="successModal">
    <div class="modal-content">
        <div class="modal-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <h3>Successfully Voted!</h3>
        <p>Your Golden Vote has been recorded for this contestant.</p>
        <button class="modal-btn" onclick="closeModal()">Continue</button>
    </div>
</div>

<script>


    function showSuccessModal() {
        document.getElementById('successModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('successModal').style.display = 'none';
    }

    window.onclick = function(event) {
        const modal = document.getElementById('successModal');
        if (event.target === modal) {
            closeModal();
        }
    };

    // Redirect to voter dashboard when Account button is clicked
    document.getElementById('accountBtn').onclick = function() {
        window.location.href = 'voter-dashboard.jsp';
    };
    document.getElementById('logoutBtn').onclick = function() {
        window.location.href = 'index.jsp';
    };
</script>
</body>
</html>

