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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VoteStage - Judge Dashboard</title>
    <style>
        /* Previous CSS styles remain the same */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        .header {
            background: linear-gradient(135deg, #2c3e50, #4a6491);
            color: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            font-size: 2.2rem;
            font-weight: 600;
        }

        .navbar {
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 0 2rem;
        }

        .navbar ul {
            display: flex;
            list-style: none;
        }

        .navbar li {
            padding: 0;
        }

        .navbar a {
            display: block;
            padding: 1rem 1.5rem;
            text-decoration: none;
            color: #555;
            font-weight: 500;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
        }

        .navbar a:hover {
            background-color: #f8f9fa;
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        .welcome-section {
            background: linear-gradient(to right, #3498db, #2c3e50);
            color: white;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .welcome-section h2 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .welcome-section p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .card h2 {
            color: #2c3e50;
            margin-bottom: 1.2rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #f0f0f0;
        }

        .evaluation-item {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 4px solid #3498db;
        }

        .evaluation-item h3 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .evaluation-item p {
            margin-bottom: 0.3rem;
            color: #555;
        }

        .status-pending {
            color: #e74c3c;
            font-weight: 600;
        }

        .status-completed {
            color: #27ae60;
            font-weight: 600;
        }

        .judge-btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 0.5rem;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }

        .judge-btn:hover {
            background-color: #2980b9;
        }

        .judge-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }

        .judge-stat {
            text-align: center;
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .stat-number {
            display: block;
            font-size: 2rem;
            font-weight: 700;
            color: #3498db;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #777;
        }

        .judge-actions {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.8rem;
        }

        .action-btn {
            display: block;
            background-color: #2c3e50;
            color: white;
            text-align: center;
            padding: 0.8rem;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }

        .action-btn:hover {
            background-color: #3498db;
        }

        .activity-item {
            padding: 0.8rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-time {
            font-size: 0.85rem;
            color: #777;
            display: block;
            margin-bottom: 0.2rem;
        }

        .golden-vote-item {
            background-color: #fff8e1;
            border-left: 4px solid #ffd700;
            padding: 0.8rem;
            margin-bottom: 0.5rem;
            border-radius: 4px;
        }

        @media (max-width: 768px) {
            .navbar ul {
                flex-direction: column;
            }
            .dashboard {
                grid-template-columns: 1fr;
            }
            .judge-stats, .judge-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <h1>Judge Dashboard</h1>
</div>

<div class="navbar">
    <ul>
        <li><a href="judge-dashboard.jsp">Dashboard</a></li>
        <li><a href="contestant-performance.jsp">View Performance</a></li>
        <li><a href="view-scores.jsp">Scoreboard</a></li>
        <li><a href="contestant-profiles.jsp">Contestants</a></li>
        <li><a href="voter-dashboard.jsp">Account</a></li>
        <li><a href="index.jsp">Logout</a></li>
    </ul>
</div>

<div class="container">
    <div class="welcome-section">
        <h2>Welcome, Judge <%= userName %>!</h2>
        <p>Your expert evaluations help determine the best performers.</p>
    </div>

    <div class="dashboard">
        <div class="card">
            <h2>Pending Evaluations</h2>
            <div class="pending-evaluations">
                <div class="evaluation-item">
                    <h3>Noon Dreams</h3>
                    <p>Contestant: Emma Watson</p>
                    <p>Performance Date: 2024-03-15</p>
                    <p>Status: <span class="status-pending">Not Rated</span></p>
                    <a href="contestant-performance.jsp" class="judge-btn">Evaluate Now</a>
                </div>

                <div class="evaluation-item">
                    <h3>Urban Rhythm</h3>
                    <p>Contestant: Tom Holland</p>
                    <p>Performance Date: 2024-03-16</p>
                    <p>Status: <span class="status-completed">Rated: 85/100</span></p>
                    <a href="contestant-performance.jsp" class="judge-btn">Update Score</a>
                </div>
            </div>
        </div>

        <div class="card">
            <h2>Recent Golden Votes</h2>
            <div class="golden-votes-list">
                <%
                    if (goldenVotes != null) {
                        try {
                            while (goldenVotes.next()) {
                %>
                <div class="golden-vote-item">
                    <strong><%= goldenVotes.getString("judge_name") %></strong>
                    → <%= goldenVotes.getString("contestant_name") %>
                    <br><small>Performance: <%= goldenVotes.getString("performance") %></small>
                    <br><small>Date: <%= goldenVotes.getString("vote_date") %></small>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                %>
                <div class="golden-vote-item">
                    No golden votes recorded yet.
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <div class="card">
            <h2>Judging Statistics</h2>
            <div class="judge-stats">
                <div class="judge-stat">
                    <span class="stat-number">8</span>
                    <span class="stat-label">Performances Judged</span>
                </div>
                <div class="judge-stat">
                    <span class="stat-number">4</span>
                    <span class="stat-label">Pending Evaluations</span>
                </div>
                <div class="judge-stat">
                    <span class="stat-number">82.5</span>
                    <span class="stat-label">Average Score Given</span>
                </div>
                <div class="judge-stat">
                    <span class="stat-number">12</span>
                    <span class="stat-label">Comments Written</span>
                </div>
            </div>
        </div>

        <div class="card">
            <h2>Quick Judge Actions</h2>
            <div class="judge-actions">
                <a href="contestant-performance.jsp" class="action-btn">Start Judging</a>
                <a href="my-scores.jsp" class="action-btn">My Scores</a>
                <a href="judging-guidelines.jsp" class="action-btn">Guidelines</a>
                <a href="contestant-feedback.jsp" class="action-btn">Give Feedback</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>