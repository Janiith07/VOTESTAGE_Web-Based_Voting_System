<%--
  Created by IntelliJ IDEA.
  User: faizamfairooz
  Date: 2025-09-20
  Time: 12:42
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Score Contestant - VoteStage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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

        /* Header Styles */
        .header {
            background: linear-gradient(135deg, #2c3e50, #4a6491);
            color: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 2.2rem;
            font-weight: 600;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info img {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            border: 2px solid #3498db;
        }

        /* Navigation Bar */
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

        .navbar a.active {
            background-color: #f8f9fa;
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
        }

        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        /* Page Title */
        .page-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title h2 {
            font-size: 1.8rem;
            color: #2c3e50;
        }

        .back-link {
            color: #3498db;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Video Grid */
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .video-card {
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .video-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .video-container {
            position: relative;
            padding-top: 56.25%; /* 16:9 Aspect Ratio */
            background-color: #000;
        }

        .video-container video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .video-info {
            padding: 1.2rem;
        }

        .video-info h3 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .video-info p {
            color: #555;
            margin-bottom: 0.3rem;
            font-size: 0.9rem;
        }

        .contestant-name {
            font-weight: 600;
            color: #3498db !important;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.8rem;
            margin-top: 1rem;
        }

        .btn {
            flex: 1;
            padding: 0.7rem 1rem;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        .btn-primary {
            background-color: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        .btn-secondary {
            background-color: #2c3e50;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #1e2a38;
        }

        /* Full Video View */
        .full-video-view {
            display: none;
            margin-bottom: 2rem;
        }

        .full-video-container {
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .full-video-header {
            padding: 1.2rem;
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
        }

        .full-video-header h3 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .full-video-player {
            position: relative;
            padding-top: 56.25%; /* 16:9 Aspect Ratio */
            background-color: #000;
        }

        .full-video-player video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .full-video-actions {
            padding: 1.2rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn-large {
            padding: 1rem 2rem;
            font-size: 1.1rem;
            min-width: 180px;
        }

        .btn-golden {
            background: linear-gradient(135deg, #ffd700, #ffb700);
            color: #2c3e50;
            font-weight: 600;
        }

        .btn-golden:hover {
            background: linear-gradient(135deg, #ffb700, #ffa000);
        }

        /* Golden Vote Indicator */
        .golden-vote-indicator {
            background-color: #fff8e1;
            border-left: 4px solid #ffd700;
            padding: 1rem;
            margin-top: 1.5rem;
            border-radius: 5px;
            display: none;
        }

        .golden-vote-indicator p {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #2c3e50;
            font-weight: 500;
        }

        /* Modal */
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
            border-radius: 10px;
            padding: 2rem;
            text-align: center;
            max-width: 450px;
            width: 90%;
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.2);
            animation: modalAppear 0.3s ease;
        }

        @keyframes modalAppear {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar ul {
                flex-direction: column;
            }

            .video-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .full-video-actions {
                flex-direction: column;
            }

            .btn-large {
                width: 100%;
            }

            .header {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <h1>VoteStage - Judge Panel</h1>
    <div class="user-info">
        <button class="btn btn-primary" id="accountBtn" style="margin-left: 25px; min-width: 120px;">Account</button>
    </div>
</div>

<div class="container">
    <div class="page-title">
        <h2>Score Contestants</h2>
        <a href="judge-dashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <!-- Video Grid for Contestant Performances -->
    <div class="video-grid" id="videoGrid">
        <div class="video-card">
            <div class="video-container">
                <video controls>
                    <source src="https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            </div>
            <div class="video-info">
                <h3>Neon Dreams</h3>
                <p class="contestant-name">Emma Watson</p>
                <p>Performance Date: 2024-03-15</p>
                <p>Duration: 3:45</p>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="showFullVideo(1)">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </button>
                    <button class="btn btn-secondary">
                        <i class="fas fa-comment"></i> Comment
                    </button>
                </div>
            </div>
        </div>

        <div class="video-card">
            <div class="video-container">
                <video controls>
                    <source src="https://assets.mixkit.co/videos/preview/mixkit-breaking-dance-1230-large.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            </div>
            <div class="video-info">
                <h3>Urban Rhythm</h3>
                <p class="contestant-name">Tom Holland</p>
                <p>Performance Date: 2024-03-16</p>
                <p>Duration: 4:20</p>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="showFullVideo(2)">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </button>
                    <button class="btn btn-secondary">
                        <i class="fas fa-comment"></i> Comment
                    </button>
                </div>
            </div>
        </div>

        <div class="video-card">
            <div class="video-container">
                <video controls>
                    <source src="https://assets.mixkit.co/videos/preview/mixkit-hands-of-a-woman-playing-a-piano-1233-large.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            </div>
            <div class="video-info">
                <h3>Piano Symphony</h3>
                <p class="contestant-name">Sophia Turner</p>
                <p>Performance Date: 2024-03-17</p>
                <p>Duration: 5:15</p>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="showFullVideo(3)">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </button>
                    <button class="btn btn-secondary">
                        <i class="fas fa-comment"></i> Comment
                    </button>
                </div>
            </div>
        </div>

        <div class="video-card">
            <div class="video-container">
                <video controls>
                    <source src="https://assets.mixkit.co/videos/preview/mixkit-woman-singing-while-playing-guitar-1234-large.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            </div>
            <div class="video-info">
                <h3>Acoustic Melody</h3>
                <p class="contestant-name">Chris Evans</p>
                <p>Performance Date: 2024-03-18</p>
                <p>Duration: 4:05</p>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="showFullVideo(4)">
                        <i class="fas fa-vote-yea"></i> Vote Now
                    </button>
                    <button class="btn btn-secondary">
                        <i class="fas fa-comment"></i> Comment
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Full Video View for Voting -->
    <div class="full-video-view" id="fullVideoView">
        <div class="full-video-container">
            <div class="full-video-header">
                <h3 id="fullVideoTitle">Neon Dreams</h3>
                <p>Contestant: <span id="fullVideoContestant">Emma Watson</span></p>
            </div>
            <div class="full-video-player">
                <video controls id="fullVideoPlayer">
                    <source src="https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            </div>
            <div class="full-video-actions">
                <button class="btn btn-primary btn-large">
                    <i class="fas fa-vote-yea"></i> Vote
                </button>
                <button class="btn btn-golden btn-large" onclick="castGoldenVote()">
                    <i class="fas fa-crown"></i> Golden Vote
                </button>
            </div>
        </div>

        <div class="golden-vote-indicator" id="goldenVoteIndicator">
            <p>
                <i class="fas fa-crown" style="color: #ffd700;"></i>
                Golden Vote - Judge John Doe
            </p>
        </div>
    </div>
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
    // Show full video when Vote Now is clicked
    function showFullVideo(videoId) {
        document.getElementById('videoGrid').style.display = 'none';
        document.getElementById('fullVideoView').style.display = 'block';

        // Scroll to the full video view
        document.getElementById('fullVideoView').scrollIntoView({ behavior: 'smooth' });
    }

    // Cast Golden Vote
    function castGoldenVote() {
        // Show the golden vote indicator
        document.getElementById('goldenVoteIndicator').style.display = 'block';

        // Show success modal
        document.getElementById('successModal').style.display = 'flex';
    }

    // Close modal
    function closeModal() {
        document.getElementById('successModal').style.display = 'none';
    }

    // Close modal if clicked outside of modal content
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
</script>
</body>
</html>
