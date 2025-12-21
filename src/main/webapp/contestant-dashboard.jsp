<%@ page import="java.sql.*" %>
<%@ page import="com.voting.util.DBConnection" %>
<%@ page import="com.voting.dao.JudgeDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("user_name");
    String userId = (String) session.getAttribute("user_id");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get golden votes for this contestant
    ResultSet goldenVotes = null;
    try {
        goldenVotes = JudgeDAO.getGoldenVotesByContestant(userId);
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Contestant Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #8A2BE2;
            --primary-light: #9d45e5;
            --secondary: #FF6B9D;
            --accent: #00D4AA;
            --dark: #1A1A2E;
            --light: #F8F9FF;
            --gray: #6C757D;
            --success: #28a745;
            --warning: #FFC107;
            --danger: #E63946;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #1A1A2E 0%, #16213E 50%, #0F3460 100%);
            color: var(--light);
            min-height: 100vh;
            line-height: 1.6;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 2.8rem;
            font-weight: 700;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .header h2 {
            font-weight: 400;
            font-size: 1.4rem;
            color: var(--light);
            opacity: 0.9;
        }

        .welcome-badge {
            display: inline-block;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            padding: 8px 20px;
            border-radius: 50px;
            margin-top: 15px;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(138, 43, 226, 0.4);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        .panel {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 25px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .panel:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
        }

        .panel h3 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: var(--accent);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .panel h3 i {
            font-size: 1.3rem;
        }

        .contestants-panel {
            grid-column: 1 / -1;
            text-align: center;
            border: 2px solid var(--success);
        }

        .contestants-wrapper {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 30px;
            margin-top: 20px;
        }

        .contestant-card {
            text-align: center;
            width: 120px;
            transition: transform 0.4s ease, filter 0.4s ease;
        }

        .contestant-card a {
            text-decoration: none;
            color: inherit;
        }

        .contestant-card img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid transparent;
            transition: all 0.4s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .contestant-card:hover {
            transform: translateY(-10px);
        }

        .contestant-card:hover img {
            transform: scale(1.15) rotate(5deg);
            border-color: var(--accent);
            box-shadow: 0 10px 25px rgba(0, 212, 170, 0.4);
        }

        .contestant-card:hover p {
            color: var(--accent);
            font-weight: 600;
        }

        .contestant-card p {
            margin-top: 10px;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .chart-container {
            grid-column: 1 / -1;
        }

        .schedule {
            background: linear-gradient(135deg, rgba(0, 212, 170, 0.1) 0%, rgba(138, 43, 226, 0.1) 100%);
            border: 1px solid rgba(0, 212, 170, 0.3);
        }

        .schedule p {
            margin-bottom: 20px;
            font-size: 1.1rem;
        }

        .schedule strong {
            color: var(--accent);
        }

        .btn-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 1rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn.logout {
            background: linear-gradient(90deg, var(--danger), #FF4D6D);
            color: white;
        }

        .btn.logout:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(230, 57, 70, 0.4);
        }

        .btn.judge {
            background: linear-gradient(90deg, var(--warning), #FFD166);
            color: var(--dark);
        }

        .btn.judge:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 193, 7, 0.4);
        }

        .btn.schedule {
            background: linear-gradient(90deg, var(--accent), #2AFCB2);
            color: var(--dark);
        }

        .btn.schedule:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 212, 170, 0.4);
        }

        /* Back Link Box */
        .back-box {
            margin-top: 30px;
            text-align: center;
        }

        .back-box a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: linear-gradient(90deg, var(--primary), var(--primary-light));
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(138, 43, 226, 0.4);
        }

        .back-box a:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(138, 43, 226, 0.5);
        }

        /* Notification System Styles */
        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }

        .header-left {
            flex: 1;
        }

        .header-right {
            position: relative;
        }

        .notification-bell {
            position: relative;
            display: inline-block;
            cursor: pointer;
            color: var(--light);
            font-size: 1.5rem;
            padding: 15px;
            border-radius: 50%;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
        }

        .notification-bell:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.1);
        }

        .notification-badge {
            position: absolute;
            top: 5px;
            right: 5px;
            background: var(--danger);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .notification-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            min-width: 300px;
            max-height: 400px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
            color: var(--dark);
            margin-top: 10px;
        }

        .notification-dropdown.show {
            display: block;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-header h3 {
            margin: 0;
            color: var(--dark);
        }

        .mark-all-read {
            background: var(--primary);
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.8rem;
        }

        .notification-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background 0.3s ease;
        }

        .notification-item:hover {
            background: #f8f9fa;
        }

        .notification-item.unread {
            background: #fff3cd;
            border-left: 4px solid var(--warning);
        }

        .notification-message {
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 0.8rem;
            color: var(--gray);
        }

        .notification-details {
            margin-top: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .no-notifications {
            padding: 20px;
            text-align: center;
            color: var(--gray);
        }

        /* Golden Votes Section Styles */
        .golden-votes-panel {
            background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
            border-radius: 20px;
            padding: 25px;
            color: var(--dark);
            box-shadow: 0 10px 30px rgba(255, 215, 0, 0.3);
            position: relative;
            overflow: hidden;
        }

        .golden-votes-panel::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { transform: rotate(0deg) scale(1); }
            50% { transform: rotate(180deg) scale(1.1); }
        }

        .golden-votes-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            position: relative;
            z-index: 1;
        }

        .golden-votes-header h3 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--dark);
        }

        .golden-votes-icon {
            font-size: 2rem;
            margin-right: 15px;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }

        .golden-vote-item {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-left: 5px solid #FFD700;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
        }

        .golden-vote-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .golden-vote-item:last-child {
            margin-bottom: 0;
        }

        .golden-vote-judge {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 8px;
        }

        .golden-vote-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .golden-vote-id {
            background: var(--primary);
            color: white;
            padding: 4px 8px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .golden-vote-date {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .golden-vote-performance {
            color: var(--dark);
            font-style: italic;
            margin-top: 8px;
        }

        .no-golden-votes {
            text-align: center;
            padding: 30px;
            color: var(--gray);
            font-size: 1.1rem;
        }

        .golden-votes-count {
            background: rgba(255, 255, 255, 0.2);
            color: var(--dark);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: auto;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .header h1 {
                font-size: 2.2rem;
            }

            .btn-container {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div class="header-top">
            <div class="header-left">
                <h1><i class="fas fa-microphone-alt"></i> Vote Stage</h1>
                <h2>Your Performance Hub</h2>
            </div>
            <div class="header-right">
                <div class="notification-bell" onclick="toggleNotifications()">
                    <i class="fas fa-bell"></i>
                    <span class="notification-badge" id="notificationBadge" style="display: none;">0</span>
                </div>
                <div class="notification-dropdown" id="notificationDropdown">
                    <div class="notification-header">
                        <h3>Notifications</h3>
                        <button class="mark-all-read" onclick="markAllAsRead()">Mark All Read</button>
                    </div>
                    <div class="notification-content" id="notificationContent">
                        <div class="no-notifications" id="loadingMessage">Loading notifications...</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="welcome-badge">
            Welcome!
        </div>
    </div>

    <div class="dashboard-grid">
        <!-- Contestants Gallery -->
        <div class="panel contestants-panel">
            <h3><i class="fas fa-users"></i> Meet the Contestants</h3>
            <div class="contestants-wrapper">
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=DJ Nova">
                        <img src="img/bg-img/dj_nova.jpg" alt="DJ Nova">
                        <p>DJ Nova</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=MC Blaze">
                        <img src="img/bg-img/mc_blaze.jpg" alt="MC Blaze">
                        <p>MC Blaze</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=Luna Star">
                        <img src="img/bg-img/luna_star.jpg" alt="Luna Star">
                        <p>Luna Star</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=Beat King">
                        <img src="img/bg-img/beat_king.jpg" alt="Beat King">
                        <p>Beat King</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=Rhythm Queen">
                        <img src="img/bg-img/rhythm_queen.jpg" alt="Rhythm Queen">
                        <p>Rhythm Queen</p>
                    </a>
                </div>
            </div>
        </div>

        <!-- Votes Chart -->
        <div class="panel chart-container">
            <h3><i class="fas fa-chart-bar"></i> Votes Comparison</h3>
            <canvas id="votesChart"></canvas>
        </div>

        <!-- Performance Schedule -->
        <div class="panel schedule">
            <h3><i class="fas fa-clock"></i> Performance Schedule</h3>
            <a href="schedule.jsp" class="btn schedule"><i class="fas fa-calendar-alt"></i> View Full Schedule</a>
        </div>

        <!-- Golden Votes Received -->
        <div class="panel golden-votes-panel">
            <div class="golden-votes-header">
                <i class="fas fa-trophy golden-votes-icon"></i>
                <h3>Golden Votes Received</h3>
                <span class="golden-votes-count" id="goldenVotesCount">0</span>
            </div>
            
            <div class="golden-votes-content">
                <%
                    int goldenVoteCount = 0;
                    if (goldenVotes != null) {
                        while (goldenVotes.next()) {
                            goldenVoteCount++;
                            String judgeId = goldenVotes.getString("judge_id");
                            String judgeName = goldenVotes.getString("judge_name");
                            String contestantId = goldenVotes.getString("contestant_id");
                            String performance = goldenVotes.getString("performance");
                            String voteDate = goldenVotes.getString("vote_date");
                %>
                <div class="golden-vote-item">
                    <div class="golden-vote-judge">
                        <i class="fas fa-user-tie"></i> <%= judgeName %>
                    </div>
                    <div class="golden-vote-details">
                        <div>
                            <span class="golden-vote-id">Judge ID: <%= judgeId %></span>
                            <span class="golden-vote-id" style="margin-left: 10px;">Contestant ID: <%= contestantId %></span>
                        </div>
                        <div class="golden-vote-date">
                            <i class="fas fa-calendar"></i> <%= voteDate %>
                        </div>
                    </div>
                    <% if (performance != null && !performance.isEmpty()) { %>
                    <div class="golden-vote-performance">
                        <i class="fas fa-music"></i> Performance: <%= performance %>
                    </div>
                    <% } %>
                </div>
                <%
                        }
                    }
                    
                    if (goldenVoteCount == 0) {
                %>
                <div class="no-golden-votes">
                    <i class="fas fa-trophy" style="font-size: 3rem; color: #ccc; margin-bottom: 15px;"></i>
                    <p>No golden votes received yet.</p>
                    <p style="font-size: 0.9rem; margin-top: 10px;">Keep performing and judges might give you a golden vote! 🏆</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <!-- Buttons -->
    <div class="btn-container">
        <a href="judge-vote.jsp" class="btn judge"><i class="fas fa-eye"></i> View Judge Votes</a>
        <a href="index.jsp" class="btn logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        <a href="voter-dashboard.jsp" class="btn logout"><i class="fas fa-account"></i> Account</a>
    </div>

    <!-- Back Link Box -->
    <div class="back-box">
        <a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
    </div>
</div>

<script>
    const ctx = document.getElementById('votesChart').getContext('2d');
    const data = {
        labels: ['DJ Nova', 'MC Blaze', 'Luna Star', 'Beat King', 'Rhythm Queen'],
        datasets: [{
            label: 'Votes Received',
            data: [1247, 980, 870, 650, 430],
            backgroundColor: [
                'rgba(138, 43, 226, 0.8)',
                'rgba(255, 107, 157, 0.8)',
                'rgba(0, 212, 170, 0.8)',
                'rgba(255, 193, 7, 0.8)',
                'rgba(230, 57, 70, 0.8)'
            ],
            borderColor: [
                'rgba(138, 43, 226, 1)',
                'rgba(255, 107, 157, 1)',
                'rgba(0, 212, 170, 1)',
                'rgba(255, 193, 7, 1)',
                'rgba(230, 57, 70, 1)'
            ],
            borderWidth: 2,
            borderRadius: 8,
            borderSkipped: false,
        }]
    };
    const config = {
        type: 'bar',
        data: data,
        options: {
            indexAxis: 'y',
            scales: {
                x: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: 'rgba(255, 255, 255, 0.7)'
                    }
                },
                y: {
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: 'rgba(255, 255, 255, 0.7)'
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    };
    const votesChart = new Chart(ctx, config);

    // Notification System JavaScript
    let notifications = [];
    let unreadCount = 0;

    // Load notifications on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Register as observer for notifications
        registerAsObserver();
        
        loadNotifications();
        loadUnreadCount();
        
        // Update golden votes count
        updateGoldenVotesCount();
        
        // Refresh notifications every 30 seconds
        setInterval(loadUnreadCount, 30000);
        
        // Refresh golden votes every 60 seconds
        setInterval(updateGoldenVotesCount, 60000);
    });

    function registerAsObserver() {
        fetch('register-contestant-observer', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                console.log('✅ Successfully registered as observer for notifications');
            } else {
                console.log('⚠️ Could not register as observer:', data.message);
            }
        })
        .catch(error => {
            console.error('❌ Error registering as observer:', error);
        });
    }

    function toggleNotifications() {
        const dropdown = document.getElementById('notificationDropdown');
        dropdown.classList.toggle('show');
        
        if (dropdown.classList.contains('show')) {
            loadNotifications();
        }
    }

    function loadNotifications() {
        console.log('🔔 Loading notifications...');
        
        // Show loading message
        const content = document.getElementById('notificationContent');
        if (content) {
            content.innerHTML = '<div class="no-notifications">Loading notifications...</div>';
        }
        
        fetch('notifications?action=getAll')
            .then(response => {
                console.log('🔔 Response status:', response.status);
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('🔔 Notifications data received:', data);
                notifications = data;
                displayNotifications(data);
            })
            .catch(error => {
                console.error('❌ Error loading notifications:', error);
                if (content) {
                    content.innerHTML = 
                        '<div class="no-notifications">Error loading notifications: ' + error.message + 
                        '<br><button onclick="loadNotifications()" style="margin-top: 10px; padding: 5px 10px;">Retry</button></div>';
                }
            });
    }

    function loadUnreadCount() {
        console.log('🔔 Loading unread count...');
        fetch('notifications?action=getCount')
            .then(response => {
                console.log('🔔 Unread count response status:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('🔔 Unread count data received:', data);
                unreadCount = data.unreadCount;
                updateBadge(unreadCount);
            })
            .catch(error => {
                console.error('❌ Error loading unread count:', error);
            });
    }

    function updateBadge(count) {
        console.log('🔔 Updating badge with count:', count);
        const badge = document.getElementById('notificationBadge');
        if (count > 0) {
            badge.textContent = count;
            badge.style.display = 'flex';
            console.log('🔔 Badge shown with count:', count);
        } else {
            badge.style.display = 'none';
            console.log('🔔 Badge hidden');
        }
    }

    function displayNotifications(notifications) {
        console.log('🔔 Displaying notifications:', notifications);
        const content = document.getElementById('notificationContent');
        
        if (!notifications || notifications.length === 0) {
            console.log('🔔 No notifications to display');
            content.innerHTML = '<div class="no-notifications">No notifications yet</div>';
            return;
        }

        let html = '';
        notifications.forEach((notification, index) => {
            console.log('🔔 Processing notification ' + index + ':', notification);
            
            const timeAgo = getTimeAgo(notification.createdAt);
            const unreadClass = notification.isRead ? '' : 'unread';
            
            // Add recipient and sender IDs to the display
            const recipientSenderInfo = `From: ${notification.senderId} | To: ${notification.recipientId}`;
            
            html += `
                <div class="notification-item ${unreadClass}" onclick="markAsRead(${notification.id})">
                    <div class="notification-message">${notification.message}</div>
                    <div class="notification-details">
                        <small style="color: #666; font-size: 0.8rem;">${recipientSenderInfo}</small>
                        <div class="notification-time">${timeAgo}</div>
                    </div>
                </div>
            `;
        });
        
        console.log('🔔 Generated HTML:', html);
        content.innerHTML = html;
    }

    function markAsRead(notificationId) {
        fetch('notifications', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=markAsRead&notificationId=${notificationId}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Remove unread styling
                const notificationItem = event.target.closest('.notification-item');
                if (notificationItem) {
                    notificationItem.classList.remove('unread');
                }
                
                // Update unread count
                unreadCount = Math.max(0, unreadCount - 1);
                updateBadge(unreadCount);
            }
        })
        .catch(error => {
            console.error('Error marking notification as read:', error);
        });
    }

    function markAllAsRead() {
        fetch('notifications', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=markAllAsRead'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Remove unread styling from all notifications
                document.querySelectorAll('.notification-item.unread').forEach(item => {
                    item.classList.remove('unread');
                });
                
                // Update unread count
                unreadCount = 0;
                updateBadge(unreadCount);
            }
        })
        .catch(error => {
            console.error('Error marking all notifications as read:', error);
        });
    }

    function getTimeAgo(dateString) {
        const now = new Date();
        const date = new Date(dateString);
        const diffInSeconds = Math.floor((now - date) / 1000);
        
        if (diffInSeconds < 60) {
            return 'Just now';
        } else if (diffInSeconds < 3600) {
            const minutes = Math.floor(diffInSeconds / 60);
            return `${minutes} minute${minutes > 1 ? 's' : ''} ago`;
        } else if (diffInSeconds < 86400) {
            const hours = Math.floor(diffInSeconds / 3600);
            return `${hours} hour${hours > 1 ? 's' : ''} ago`;
        } else {
            const days = Math.floor(diffInSeconds / 86400);
            return `${days} day${days > 1 ? 's' : ''} ago`;
        }
    }

    // Close notification dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const dropdown = document.getElementById('notificationDropdown');
        const bell = document.querySelector('.notification-bell');
        
        if (!bell.contains(event.target) && !dropdown.contains(event.target)) {
            dropdown.classList.remove('show');
        }
    });

    // Golden Votes Functions
    function updateGoldenVotesCount() {
        console.log('🏆 Updating golden votes count...');
        
        // Count the golden vote items on the page
        const goldenVoteItems = document.querySelectorAll('.golden-vote-item');
        const count = goldenVoteItems.length;
        
        const countElement = document.getElementById('goldenVotesCount');
        if (countElement) {
            countElement.textContent = count;
            console.log('🏆 Golden votes count updated:', count);
        }
    }

    // Function to add a new golden vote item dynamically (for real-time updates)
    function addGoldenVoteItem(judgeId, judgeName, contestantId, performance, voteDate) {
        const goldenVotesContent = document.querySelector('.golden-votes-content');
        
        // Remove "no golden votes" message if it exists
        const noVotesMessage = goldenVotesContent.querySelector('.no-golden-votes');
        if (noVotesMessage) {
            noVotesMessage.remove();
        }
        
        // Create new golden vote item
        const goldenVoteItem = document.createElement('div');
        goldenVoteItem.className = 'golden-vote-item';
        goldenVoteItem.innerHTML = 
            '<div class="golden-vote-judge">' +
                '<i class="fas fa-user-tie"></i> ' + judgeName +
            '</div>' +
            '<div class="golden-vote-details">' +
                '<div>' +
                    '<span class="golden-vote-id">Judge ID: ' + judgeId + '</span>' +
                    '<span class="golden-vote-id" style="margin-left: 10px;">Contestant ID: ' + contestantId + '</span>' +
                '</div>' +
                '<div class="golden-vote-date">' +
                    '<i class="fas fa-calendar"></i> ' + voteDate +
                '</div>' +
            '</div>' +
            (performance ? '<div class="golden-vote-performance"><i class="fas fa-music"></i> Performance: ' + performance + '</div>' : '');
        
        // Add to the top of the list
        goldenVotesContent.insertBefore(goldenVoteItem, goldenVotesContent.firstChild);
        
        // Update count
        updateGoldenVotesCount();
        
        // Add animation
        goldenVoteItem.style.opacity = '0';
        goldenVoteItem.style.transform = 'translateY(-20px)';
        setTimeout(() => {
            goldenVoteItem.style.transition = 'all 0.5s ease';
            goldenVoteItem.style.opacity = '1';
            goldenVoteItem.style.transform = 'translateY(0)';
        }, 100);
        
        console.log('🏆 New golden vote added:', judgeName);
    }

    // Debug function to manually test notification display
    function debugNotifications() {
        console.log('🔍 Debug: Testing notification display...');
        
        // Test with sample data
        const testNotifications = [
            {
                id: 1,
                recipientId: 'P001',
                senderId: 'P002',
                message: 'Test notification message from Judge P002',
                type: 'GOLDEN_VOTE',
                createdAt: new Date().toISOString(),
                isRead: false
            },
            {
                id: 2,
                recipientId: 'P001',
                senderId: 'P003',
                message: 'Another test notification from Judge P003',
                type: 'REGULAR_VOTE',
                createdAt: new Date(Date.now() - 300000).toISOString(),
                isRead: true
            }
        ];
        
        console.log('🔍 Debug: Test notifications data:', testNotifications);
        displayNotifications(testNotifications);
        console.log('🔍 Debug: Notification display test completed');
    }

    // Make debug function available globally
    window.debugNotifications = debugNotifications;
</script>
</body>
</html>
