<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get parameters from the URL - Handle both parameter names
    String contestantId = request.getParameter("contestantId");
    String contestantName = request.getParameter("contestantName");
    String performance = request.getParameter("performance");

    // Handle the typo in your current URLs
    if (contestantId == null) contestantId = request.getParameter("contextantId");
    if (contestantName == null) contestantName = request.getParameter("contextantName");

    // Get voter info from session
    String voterName = (String) session.getAttribute("user_name");
    String voterId = (String) session.getAttribute("user_id");

    if (voterName == null || voterId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (contestantId == null || contestantName == null) {
        response.sendRedirect("voter-dashboard.jsp?error=Missing contestant information");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote for <%= contestantName %> - VotesStage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%); color: #333; line-height: 1.6; min-height: 100vh; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }
        header { text-align: center; margin-bottom: 30px; padding: 20px 0; background: linear-gradient(135deg, #2c3e50, #3498db); color: white; border-radius: 12px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); }
        .logo { font-size: 2.5rem; font-weight: 700; margin-bottom: 5px; }
        .tagline { font-size: 1.1rem; opacity: 0.9; }
        .page-title { text-align: center; margin-bottom: 30px; }
        .page-title h1 { font-size: 2.2rem; color: #2c3e50; margin-bottom: 10px; }
        .page-title p { color: #7f8c8d; font-size: 1.1rem; }
        .video-container-large { background: #000; border-radius: 12px; overflow: hidden; margin-bottom: 30px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); }
        .video-container-large video { width: 100%; height: 400px; object-fit: cover; }
        .vote-form { margin-bottom: 30px; }
        .btn { padding: 20px; border: none; border-radius: 10px; font-size: 1.2rem; font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-vote-large { background: linear-gradient(135deg, #3498db, #2980b9); color: white; }
        .btn-vote-large:hover { background: linear-gradient(135deg, #2980b9, #2573a7); transform: translateY(-3px); box-shadow: 0 10px 25px rgba(52, 152, 219, 0.4); }
        .back-link { display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; background: #2c3e50; color: white; text-decoration: none; border-radius: 6px; transition: background 0.3s ease; }
        .back-link:hover { background: #3498db; }
        .voter-info { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center; }
    </style>
</head>
<body>
<div class="container">
    <header>
        <div class="logo">VotesStage</div>
        <div class="tagline">Voting Panel</div>
    </header>

    <div class="page-title">
        <h1>Vote for <%= contestantName %></h1>
        <p>Performance: <%= performance %></p>
    </div>

    <div class="voter-info">
        <strong>Voter:</strong> <%= voterName %> | <strong>Contestant:</strong> <%= contestantName %>
    </div>

    <div class="video-container-large">
        <div style="background: #333; color: white; height: 400px; display: flex; align-items: center; justify-content: center;">
            <i class="fas fa-play-circle" style="font-size: 3rem;"></i>
            <span style="margin-left: 10px;">Performance Video - <%= contestantName %></span>
        </div>
    </div>

    <form method="post" action="VoteServlet" class="vote-form">
        <input type="hidden" name="contestantId" value="<%= contestantId %>">
        <input type="hidden" name="contestantName" value="<%= contestantName %>">
        <input type="hidden" name="performance" value="<%= performance %>">
        <input type="hidden" name="voteType" value="regular">

        <div style="text-align: center;">
            <button type="submit" class="btn btn-vote-large">
                <i class="fas fa-vote-yea"></i> Regular Vote (10 points)
            </button>
        </div>
    </form>

    <div style="text-align: center; margin-top: 20px;">
        <a href="contestant-performance.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

<script>
    // Add confirmation for voting
    document.querySelector('.vote-form').addEventListener('submit', function(e) {
        const confirmed = confirm('Are you sure you want to vote for <%= contestantName %>?');
        if (!confirmed) {
            e.preventDefault();
        }
    });
</script>
</body>
</html>