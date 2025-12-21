<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Voting System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --danger: #f72585;
            --warning: #f8961e;
            --light: #f8f9fa;
            --dark: #212529;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #f5f7fb; color: var(--dark); min-height: 100vh; display: flex; flex-direction: column; }

        .header { background: linear-gradient(90deg, var(--primary), var(--secondary)); color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }
        .header h1 { font-size: 1.8rem; display: flex; align-items: center; }
        .header h1 i { margin-right: 10px; }
        .user-info { display: flex; align-items: center; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background-color: rgba(255, 255, 255, 0.2); color: white; display: flex; align-items: center; justify-content: center; margin-right: 10px; font-weight: bold; }
        .logout-btn { background-color: rgba(255, 255, 255, 0.2); color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; margin-left: 15px; transition: background-color 0.3s; }
        .logout-btn:hover { background-color: rgba(255, 255, 255, 0.3); }

        .container { display: flex; flex: 1; }
        .sidebar { width: 250px; background-color: white; padding: 20px 0; box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05); }
        .menu-item { padding: 15px 25px; display: flex; align-items: center; cursor: pointer; transition: all 0.3s; border-left: 4px solid transparent; text-decoration: none; color: inherit; }
        .menu-item:hover, .menu-item.active { background-color: #f0f4ff; border-left: 4px solid var(--primary); color: var(--primary); }
        .menu-item i { margin-right: 10px; font-size: 1.2rem; width: 25px; text-align: center; }
        .menu-section { padding: 10px 25px; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; color: #6c757d; margin-top: 20px; }

        .main-content { flex: 1; padding: 30px; overflow-y: auto; }
        .welcome-section { background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; padding: 25px; border-radius: 10px; margin-bottom: 30px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); }
        .welcome-section h2 { font-size: 1.8rem; margin-bottom: 10px; }

        .dashboard-cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 25px; margin-bottom: 30px; }
        .card { background-color: white; border-radius: 10px; padding: 25px; box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08); transition: transform 0.3s, box-shadow 0.3s; border-top: 4px solid var(--primary); cursor: pointer; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .card-title { font-size: 1.3rem; font-weight: 600; }
        .card-icon { width: 50px; height: 50px; border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; }
        .card-content { margin-bottom: 20px; color: #6c757d; line-height: 1.5; }
        .stats { display: flex; justify-content: space-between; margin-top: 15px; }
        .stat-item { text-align: center; }
        .stat-value { font-size: 1.5rem; font-weight: bold; color: var(--dark); }
        .stat-label { font-size: 0.85rem; color: #6c757d; }

        .btn { padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; font-weight: 500; transition: all 0.3s; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; }
        .btn i { margin-right: 8px; }
        .btn-primary { background-color: var(--primary); color: white; }
        .btn-primary:hover { background-color: var(--secondary); }

        .content-section { background-color: white; border-radius: 10px; padding: 25px; box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08); margin-bottom: 30px; }
        .section-title { font-size: 1.4rem; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee; display: flex; align-items: center; }
        .section-title i { margin-right: 10px; color: var(--primary); }
        .activity-list { list-style: none; }
        .activity-item { padding: 15px 0; border-bottom: 1px solid #f0f0f0; display: flex; align-items: center; }
        .activity-item:last-child { border-bottom: none; }
        .activity-icon { width: 40px; height: 40px; border-radius: 50%; background-color: #f0f4ff; color: var(--primary); display: flex; align-items: center; justify-content: center; margin-right: 15px; font-size: 1.1rem; }
        .activity-content { flex: 1; }
        .activity-title { font-weight: 600; margin-bottom: 5px; }
        .activity-desc { color: #6c757d; font-size: 0.9rem; }
        .activity-time { color: #6c757d; font-size: 0.85rem; white-space: nowrap; }

        /* Dialog styles */
        .dialog-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        .dialog-box {
            background: white;
            width: 80%;
            max-width: 900px;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            max-height: 90vh;
            overflow-y: auto;
        }
        .dialog-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .dialog-header h2 { font-size: 1.3rem; }
        .close-btn {
            cursor: pointer;
            font-size: 1.5rem;
            color: var(--danger);
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background-color 0.3s;
        }
        .close-btn:hover { background-color: #f0f0f0; }
        .video-preview {
            background: #000;
            height: 300px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .comments-section {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 15px;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 10px;
        }
        .comment {
            border-bottom: 1px solid #f0f0f0;
            padding: 10px 0;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .comment:last-child { border-bottom: none; }
        .comment-content { flex: 1; }
        .comment-actions { display: flex; gap: 10px; margin-left: 10px; }
        .action-btn { padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer; font-size: 0.8rem; }
        .flag-btn { background-color: #f8961e; color: white; }
        .delete-btn { background-color: #f72585; color: white; }
        .reply-box { display: flex; gap: 10px; margin-top: 15px; }
        .reply-box input { flex: 1; padding: 8px; border-radius: 5px; border: 1px solid #ccc; }
        .reply-box button { background: var(--primary); color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; }

        /* Form styles */
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px; }
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }

        @media (max-width: 992px) { .dashboard-cards { grid-template-columns: 1fr 1fr; } }
        @media (max-width: 768px) {
            .container { flex-direction: column; }
            .sidebar { width: 100%; order: 2; }
            .main-content { order: 1; }
            .dashboard-cards { grid-template-columns: 1fr; }
            .header { padding: 15px; }
            .header h1 { font-size: 1.5rem; }
            .dialog-box { width: 95%; padding: 15px; }
        }
    </style>
</head>
<body>
<!-- Header -->
<div class="header">
    <h1><i class="fas fa-crown"></i> Admin Dashboard</h1>
    <div class="user-info">
        <div class="user-avatar">A</div>
        <div>Admin User</div>
        <a href="voter-dashboard.jsp" class="account btn">
            <i class="fas fa-user"></i> Account
        </a>
        <button class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </div>
</div>

<!-- Main Container -->
<div class="container">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="menu-section">Main Functions</div>
        <a href="admin-dashboard.jsp" class="menu-item active">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard Overview</span>
        </a>

        <div class="menu-section">Content Management</div>
        <a href="admin/video" class="menu-item">
            <i class="fas fa-video"></i>
            <span>Video Management</span>
        </a>
        <a href="admin/performance" class="menu-item">
            <i class="fas fa-star"></i>
            <span>Contestant Performance</span>
        </a>

        <div class="menu-section">Voting System</div>
        <a href="admin/voting-time" class="menu-item">
            <i class="fas fa-vote-yea"></i>
            <span>Voting Time Management</span>
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h2>Welcome back, Admin!</h2>
            <p>Manage your voting system efficiently with the tools below.</p>
        </div>

        <!-- Dashboard Cards -->
        <div class="dashboard-cards">

            <!-- Video Management Card -->
            <div class="card" onclick="window.location.href='adminVideos.jsp'">
            <div class="card-header">
                    <div class="card-title">Video Management</div>
                    <div class="card-icon" style="background-color: #f8961e;"><i class="fas fa-video"></i></div>
                </div>
                <div class="card-content">
                    <p>Upload, edit, or remove contestant videos.</p>
                </div>
                <a href="admin/video" class="btn btn-primary" style="width: 100%;">
                    <i class="fas fa-cog"></i> Manage Videos
                </a>

            </div>

            <!-- Voting Time Management Card -->
            <div class="card" onclick="openVotingTimeDialog()">
                <div class="card-header">
                    <div class="card-title">Voting Time Management</div>
                    <div class="card-icon" style="background-color: #4361ee;"><i class="fas fa-vote-yea"></i></div>
                </div>
                <div class="card-content">
                    <p>Set and manage voting periods for competitions.</p>
                </div>
                <button class="btn btn-primary" style="width: 100%;"><i class="fas fa-clock"></i> Set Voting Times</button>
            </div>

            <!-- Contestant Performance Card -->
            <div class="card" onclick="openPerformanceDialog()">
                <div class="card-header">
                    <div class="card-title">Contestant Performance</div>
                    <div class="card-icon" style="background-color: #06d6a0;">
                        <i class="fas fa-star"></i>
                    </div>
                </div>
                <div class="card-content">
                    <p>Preview performances and moderate comments from judges, contestants, and voters.</p>
                </div>
                <button class="btn btn-primary" style="width: 100%;">
                    <i class="fas fa-star"></i> View Performance
                </button>
            </div>
        </div>

        <!-- Recent Activity Section -->
        <div class="content-section">
            <h3 class="section-title"><i class="fas fa-history"></i> Recent Activity</h3>
            <ul class="activity-list">
                <li class="activity-item">
                    <div class="activity-icon"><i class="fas fa-comment-slash"></i></div>
                    <div class="activity-content">
                        <div class="activity-title">Comment Removed</div>
                        <div class="activity-desc">Removed inappropriate comment from user JohnDoe</div>
                    </div>
                    <div class="activity-time">10:25 AM</div>
                </li>
                <li class="activity-item">
                    <div class="activity-icon"><i class="fas fa-video"></i></div>
                    <div class="activity-content">
                        <div class="activity-title">Video Uploaded</div>
                        <div class="activity-desc">Contestant Sarah uploaded a new performance video</div>
                    </div>
                    <div class="activity-time">09:45 AM</div>
                </li>
                <li class="activity-item">
                    <div class="activity-icon"><i class="fas fa-vote-yea"></i></div>
                    <div class="activity-content">
                        <div class="activity-title">Voting Period Updated</div>
                        <div class="activity-desc">Extended voting period by 24 hours</div>
                    </div>
                    <div class="activity-time">Yesterday</div>
                </li>
            </ul>
        </div>
    </div>
</div>

<!-- Video Management Dialog -->
<div class="dialog-overlay" id="videoManagementDialog">
    <div class="dialog-box">
        <div class="dialog-header">
            <h2><i class="fas fa-video"></i> Video Management</h2>
            <span class="close-btn" onclick="closeVideoManagementDialog()">&times;</span>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
            <div>
                <h3>Upload New Video</h3>
                <div class="form-group">
                    <label for="contestantName">Contestant Name</label>
                    <input type="text" id="contestantName" placeholder="Enter contestant name">
                </div>
                <div class="form-group">
                    <label for="performanceTitle">Performance Title</label>
                    <input type="text" id="performanceTitle" placeholder="Enter performance title">
                </div>
                <div class="form-group">
                    <label for="videoDescription">Video Description</label>
                    <textarea id="videoDescription" placeholder="Enter video description" rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label for="videoFile">Video File</label>
                    <input type="file" id="videoFile" accept="video/*">
                </div>
                <button class="btn btn-primary" style="width: 100%;"><i class="fas fa-upload"></i> Upload Video</button>
            </div>
            <div>
                <h3>Existing Videos</h3>
                <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; max-height: 300px; overflow-y: auto;">
                    <div style="padding: 10px; border-bottom: 1px solid #ddd;">
                        <strong>Sarah Johnson - "Rise Up"</strong>
                        <div style="font-size: 0.9rem; color: #6c757d; margin: 5px 0;">Emotional ballad performance</div>
                        <div style="display: flex; gap: 10px; margin-top: 5px;">
                            <button class="action-btn" style="background-color: #4361ee; color: white;">Edit</button>
                            <button class="action-btn delete-btn">Delete</button>
                        </div>
                    </div>
                    <div style="padding: 10px; border-bottom: 1px solid #ddd;">
                        <strong>Mike Thompson - "Bohemian Rhapsody"</strong>
                        <div style="font-size: 0.9rem; color: #6c757d; margin: 5px 0;">Rock opera performance</div>
                        <div style="display: flex; gap: 10px; margin-top: 5px;">
                            <button class="action-btn" style="background-color: #4361ee; color: white;">Edit</button>
                            <button class="action-btn delete-btn">Delete</button>
                        </div>
                    </div>
                    <div style="padding: 10px;">
                        <strong>Emma Wilson - "Hallelujah"</strong>
                        <div style="font-size: 0.9rem; color: #6c757d; margin: 5px 0;">Acoustic cover performance</div>
                        <div style="display: flex; gap: 10px; margin-top: 5px;">
                            <button class="action-btn" style="background-color: #4361ee; color: white;">Edit</button>
                            <button class="action-btn delete-btn">Delete</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button class="btn btn-primary" onclick="closeVideoManagementDialog()">Save Changes</button>
        </div>
    </div>
</div>

<!-- Voting Time Management Dialog -->
<div class="dialog-overlay" id="votingTimeDialog">
    <div class="dialog-box">
        <div class="dialog-header">
            <h2><i class="fas fa-vote-yea"></i> Voting Time Management</h2>
            <span class="close-btn" onclick="closeVotingTimeDialog()">&times;</span>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
            <div>
                <h3>Current Voting Period</h3>
                <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                    <p><strong>Start:</strong> March 20, 2023 12:00 PM</p>
                    <p><strong>End:</strong> March 27, 2023 11:59 PM</p>
                    <p><strong>Status:</strong> <span style="color: #06d6a0;">Active</span></p>
                </div>
            </div>
            <div>
                <h3>Set New Voting Period</h3>
                <div class="form-group">
                    <label for="votingStart">Start Date & Time</label>
                    <input type="datetime-local" id="votingStart">
                </div>
                <div class="form-group">
                    <label for="votingEnd">End Date & Time</label>
                    <input type="datetime-local" id="votingEnd">
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button class="btn btn-primary" onclick="saveVotingPeriod()">Save Voting Period</button>
            <button class="btn" style="background-color: #6c757d; color: white;" onclick="closeVotingTimeDialog()">Cancel</button>
        </div>
    </div>
</div>

<!-- Contestant Performance Dialog -->
<div class="dialog-overlay" id="performanceDialog">
    <div class="dialog-box">
        <div class="dialog-header">
            <h2><i class="fas fa-star"></i> Contestant Performance</h2>
            <span class="close-btn" onclick="closePerformanceDialog()">&times;</span>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
            <div>
                <h3>Performance Info</h3>
                <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                    <p><strong>Contestant:</strong> Sarah Johnson</p>
                    <p><strong>Song:</strong> "Rise Up" by Andra Day</p>
                    <p><strong>Duration:</strong> 3:45</p>
                    <p><strong>Upload Date:</strong> March 15, 2023</p>
                </div>
            </div>
            <div>
                <h3>Performance Stats</h3>
                <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                    <p><strong>Views:</strong> 1,245</p>
                    <p><strong>Likes:</strong> 89%</p>
                    <p><strong>Comments:</strong> 47</p>
                    <p><strong>Rating:</strong> 4.7/5</p>
                </div>
            </div>
        </div>

        <div class="video-preview">
            <p>🎥 Full Performance Video</p>
        </div>

        <h3>Comments & Moderation</h3>
        <div class="comments-section" id="performanceCommentsList">
            <div class="comment">
                <div class="comment-content">
                    <strong>Judge_Michael:</strong> Excellent vocal control and emotional delivery.
                    <div style="font-size: 0.8rem; color: #6c757d; margin-top: 5px;">Posted: 2 days ago</div>
                </div>
                <div class="comment-actions">
                    <button class="action-btn flag-btn" onclick="flagComment(this)">Flag</button>
                    <button class="action-btn delete-btn" onclick="deleteComment(this)">Delete</button>
                </div>
            </div>
            <div class="comment">
                <div class="comment-content">
                    <strong>Voter_42:</strong> Love this performance! You have my vote.
                    <div style="font-size: 0.8rem; color: #6c757d; margin-top: 5px;">Posted: 1 day ago</div>
                </div>
                <div class="comment-actions">
                    <button class="action-btn flag-btn" onclick="flagComment(this)">Flag</button>
                    <button class="action-btn delete-btn" onclick="deleteComment(this)">Delete</button>
                </div>
            </div>
            <div class="comment">
                <div class="comment-content">
                    <strong>Contestant_Sarah:</strong> Thank you everyone for the support!
                    <div style="font-size: 0.8rem; color: #6c757d; margin-top: 5px;">Posted: 12 hours ago</div>
                </div>
                <div class="comment-actions">
                    <button class="action-btn flag-btn" onclick="flagComment(this)">Flag</button>
                    <button class="action-btn delete-btn" onclick="deleteComment(this)">Delete</button>
                </div>
            </div>
            <div class="comment" style="background-color: #fff3cd; border-radius: 5px; padding: 10px;">
                <div class="comment-content">
                    <strong>User_Anonymous:</strong> This is the worst performance I've ever seen!
                    <div style="font-size: 0.8rem; color: #856404; margin-top: 5px;">Posted: 1 hour ago • <span style="color: #f8961e;">Flagged as inappropriate</span></div>
                </div>
                <div class="comment-actions">
                    <button class="action-btn delete-btn" onclick="deleteComment(this)">Delete</button>
                </div>
            </div>
        </div>

        <div class="reply-box">
            <input type="text" id="performanceReplyInput" placeholder="Add a comment as admin...">
            <button onclick="addPerformanceComment()">Post Comment</button>
        </div>
    </div>
</div>

<script>
    // Dialog open/close functions
    function openVideoManagementDialog() {
        document.getElementById("videoManagementDialog").style.display = "flex";
    }

    function closeVideoManagementDialog() {
        document.getElementById("videoManagementDialog").style.display = "none";
    }

    function openVotingTimeDialog() {
        document.getElementById("votingTimeDialog").style.display = "flex";
    }

    function closeVotingTimeDialog() {
        document.getElementById("votingTimeDialog").style.display = "none";
    }

    function openPerformanceDialog() {
        document.getElementById("performanceDialog").style.display = "flex";
    }

    function closePerformanceDialog() {
        document.getElementById("performanceDialog").style.display = "none";
    }

    // Comment moderation functions
    function flagComment(button) {
        const comment = button.closest('.comment');
        comment.style.backgroundColor = '#fff3cd';
        const timeDiv = comment.querySelector('.comment-content div');
        const flagText = document.createElement('span');
        flagText.textContent = ' • Flagged as inappropriate';
        flagText.style.color = '#f8961e';
        timeDiv.appendChild(flagText);

        // Disable the flag button after flagging
        button.disabled = true;
        button.style.backgroundColor = '#6c757d';
        alert('Comment has been flagged for review');
    }

    function deleteComment(button) {
        const comment = button.closest('.comment');
        if (confirm('Are you sure you want to delete this comment?')) {
            comment.remove();
            alert('Comment has been deleted');
        }
    }

    // Voting time functions
    function saveVotingPeriod() {
        const start = document.getElementById('votingStart').value;
        const end = document.getElementById('votingEnd').value;

        if (!start || !end) {
            alert('Please set both start and end dates');
            return;
        }

        const startDate = new Date(start);
        const endDate = new Date(end);
        alert('Voting period set from ' + startDate.toLocaleString() + ' to ' + endDate.toLocaleString());
        closeVotingTimeDialog();
    }

    // Performance comment function
    function addPerformanceComment() {
        const input = document.getElementById("performanceReplyInput");
        const text = input.value.trim();
        if(text) {
            const commentList = document.getElementById("performanceCommentsList");
            const newComment = document.createElement("div");
            newComment.classList.add("comment");

            const commentContent = document.createElement("div");
            commentContent.classList.add("comment-content");

            const strong = document.createElement("strong");
            strong.textContent = "Admin: ";

            const textNode = document.createTextNode(text);

            const timeDiv = document.createElement("div");
            timeDiv.style.fontSize = "0.8rem";
            timeDiv.style.color = "#6c757d";
            timeDiv.style.marginTop = "5px";
            timeDiv.textContent = "Posted: Just now";

            commentContent.appendChild(strong);
            commentContent.appendChild(textNode);
            commentContent.appendChild(timeDiv);

            const commentActions = document.createElement("div");
            commentActions.classList.add("comment-actions");

            const flagBtn = document.createElement("button");
            flagBtn.classList.add("action-btn", "flag-btn");
            flagBtn.textContent = "Flag";
            flagBtn.onclick = function() { flagComment(this); };

            const deleteBtn = document.createElement("button");
            deleteBtn.classList.add("action-btn", "delete-btn");
            deleteBtn.textContent = "Delete";
            deleteBtn.onclick = function() { deleteComment(this); };

            commentActions.appendChild(flagBtn);
            commentActions.appendChild(deleteBtn);

            newComment.appendChild(commentContent);
            newComment.appendChild(commentActions);

            commentList.appendChild(newComment);
            input.value = "";
        }
    }

    // Menu activation
    document.querySelectorAll('.menu-item').forEach(item => {
        item.addEventListener('click', function() {
            document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // Logout functionality
    document.querySelector('.logout-btn').addEventListener('click', function() {
        if (confirm('Are you sure you want to logout?')) {
            window.location.href = 'login.jsp';
        }
    });

    // Close dialog when clicking outside
    document.querySelectorAll('.dialog-overlay').forEach(overlay => {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) {
                this.style.display = 'none';
            }
        });
    });

    // Add click handler for the Contestant Performance menu item
    document.querySelector('a[href="admin/performance"]').addEventListener('click', function(e) {
        e.preventDefault();
        openPerformanceDialog();
    });
</script>
</body>
</html>