<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.service.JudgeService" %>
<%@ page import="com.voting.service.CommentService" %>
<%@ page import="com.voting.model.Comment" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Timestamp" %>
<%
    // --- 1. User Session Check ---
    String userName = (String) session.getAttribute("user_name");
    String judgeId = (String) session.getAttribute("user_id");

    if (userName == null || judgeId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- 2. Contestant ID Validation ---
    String contestantIdParam = request.getParameter("contestantId");
    String contestantId = null;

    // --- 3. Load Comments & Error Handling ---
    List<Comment> allComments = new ArrayList<>();
    String commentLoadError = null;

    if (contestantIdParam != null) {
        try {
            contestantId = contestantIdParam;

            if (contestantId != null && !contestantId.trim().isEmpty()) {
                allComments = CommentService.getCommentsByContestant(contestantId);

                if (allComments == null) {
                    commentLoadError = "Failed to load comments: Database communication error.";
                    allComments = new ArrayList<>();
                }
            } else {
                commentLoadError = "Invalid Contestant ID.";
            }

        } catch (NumberFormatException e) {
            commentLoadError = "Invalid Contestant ID format.";
        }
    } else {
        commentLoadError = "Contestant ID not specified. Please select a contestant.";
    }

    // --- 4. Optional: Load Golden Votes ---
    ResultSet goldenVotes = null;
    // try { goldenVotes = JudgeService.getGoldenVotes(); } catch (Exception e) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comment Dashboard - Contestant <%= contestantId %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #A777E3FF;
            --secondary: #A777E3FF;
            --success: #4cc9f0;
            --danger: #f72585;
            --warning: #f8961e;
            --info: #A777E3FF;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
            --light-gray: #e9ecef;
            --border-radius: 12px;
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #A777E3FF 0%, #A777E3FF 100%);
            color: var(--dark);
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px;
        }

        .dashboard-container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .dashboard-header {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            padding: 25px 30px;
            position: relative;
            overflow: hidden;
        }

        .dashboard-header::before {
            content: "";
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 200%;
            background: rgba(255, 255, 255, 0.1);
            transform: rotate(30deg);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .header-title h1 {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .header-title p {
            font-size: 1rem;
            opacity: 0.9;
        }

        .user-info {
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 15px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-icon {
            background: white;
            color: var(--primary);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .dashboard-body {
            padding: 30px;
        }

        .alert-message {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: var(--border-radius);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .success {
            background-color: rgba(76, 201, 240, 0.15);
            color: #0a7c9f;
            border-left: 4px solid var(--success);
        }

        .error {
            background-color: rgba(247, 37, 133, 0.15);
            color: #b5175c;
            border-left: 4px solid var(--danger);
        }

        .section {
            background: var(--light);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            font-size: 1.2rem;
        }

        .comment-form textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid var(--light-gray);
            border-radius: var(--border-radius);
            font-family: 'Poppins', sans-serif;
            font-size: 1rem;
            resize: vertical;
            min-height: 120px;
            transition: var(--transition);
        }

        .comment-form textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border: none;
            border-radius: 50px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--secondary);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-success:hover {
            background: #3ab0d6;
            transform: translateY(-2px);
        }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: #d1146a;
            transform: translateY(-2px);
        }

        .btn-outline {
            background: transparent;
            color: var(--gray);
            border: 1px solid var(--light-gray);
        }

        .btn-outline:hover {
            background: var(--light-gray);
            color: var(--dark);
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 0.85rem;
        }

        .comment-item {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            border: 1px solid var(--light-gray);
            transition: var(--transition);
        }

        .comment-item:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .comment-author {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .author-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--info));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .author-name {
            font-weight: 500;
            color: var(--dark);
        }

        .comment-date {
            font-size: 0.85rem;
            color: var(--gray);
        }

        .comment-text {
            margin-bottom: 15px;
            padding: 15px;
            background: var(--light);
            border-radius: 10px;
            line-height: 1.7;
        }

        .comment-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .reply-indicator {
            font-size: 0.8rem;
            color: var(--info);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .like-count {
            background: rgba(76, 201, 240, 0.15);
            color: #0a7c9f;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-left: 5px;
        }

        .reply-form, .edit-form {
            margin-top: 15px;
            padding: 15px;
            background: var(--light);
            border-radius: 10px;
            border: 1px dashed var(--info);
        }

        .reply-form textarea, .edit-form textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--light-gray);
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            resize: vertical;
            min-height: 80px;
            margin-bottom: 10px;
        }

        .form-actions {
            display: flex;
            gap: 10px;
        }

        .no-comments {
            text-align: center;
            padding: 40px 20px;
            color: var(--gray);
        }

        .no-comments i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: var(--light-gray);
        }

        .no-comments p {
            font-size: 1.1rem;
        }

        .comment-reply {
            margin-left: 30px;
            border-left: 3px solid var(--info);
            padding-left: 15px;
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .user-info {
                align-self: flex-end;
            }

            .comment-header {
                flex-direction: column;
                gap: 10px;
            }

            .comment-actions {
                justify-content: center;
            }

            .comment-reply {
                margin-left: 15px;
            }
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <div class="dashboard-header">
        <div class="header-content">
            <div class="header-title">
                <h1>Comment Dashboard</h1>
                <p>Contestant ID: <strong><%= contestantId %></strong></p>
            </div>
            <div class="user-info">
                <div class="user-icon">
                    <i class="fas fa-user"></i>
                </div>
                <div>
                    <div><strong><%= userName %></strong></div>
                    <div>Judge ID: <%= judgeId %></div>
                </div>
            </div>
        </div>
    </div>

    <div class="dashboard-body">
        <%-- Success/Error Messages Display --%>
        <%
            String status = request.getParameter("status");
            String message = request.getParameter("message");
            if ("success".equals(status)) {
        %>
        <div class="alert-message success">
            <i class="fas fa-check-circle"></i>
            <span>Operation successful! <%= message %></span>
        </div>
        <%
        } else if ("error".equals(status)) {
        %>
        <div class="alert-message error">
            <i class="fas fa-exclamation-circle"></i>
            <span>Error: <%= message %></span>
        </div>
        <%
            }
        %>

        <% if (commentLoadError != null) { %>
        <div class="alert-message error">
            <i class="fas fa-exclamation-triangle"></i>
            <span>Error loading comments: <%= commentLoadError %></span>
        </div>
        <% } %>

        <div class="section">
            <h2 class="section-title">
                <i class="fas fa-edit"></i>
                <span>Add New Comment</span>
            </h2>

            <%-- ADD COMMENT FORM --%>
            <form action="CommentServlet" method="POST" class="comment-form">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="contestantId" value="<%= contestantId %>">

                <textarea name="commentText" placeholder="Share your thoughts about this contestant..." required></textarea>

                <div style="margin-top: 15px;">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                        Submit Comment
                    </button>
                </div>
            </form>
        </div>

        <div class="section">
            <h2 class="section-title">
                <i class="fas fa-comments"></i>
                <span>Comments (<%= allComments != null ? allComments.size() : 0 %>)</span>
            </h2>

            <div id="comments-list">
                <%
                    if (commentLoadError == null && allComments != null && !allComments.isEmpty()) {
                        for (Comment c : allComments) {
                            String escapedText = c.getCommentText().replace("'", "\\'").replace("\n", "\\n");
                            boolean isReply = (c.getParentId() != null && c.getParentId() != 0);
                %>
                <div class="comment-item <%= isReply ? "comment-reply" : "" %>" data-comment-id="<%= c.getId() %>">
                    <div class="comment-header">
                        <div class="comment-author">
                            <div class="author-avatar">
                                <%= String.valueOf(c.getJudgeId()).substring(Math.max(0, String.valueOf(c.getJudgeId()).length() - 2)) %>
                            </div>
                            <div>
                                <div class="author-name">Judge <%= c.getJudgeId() %></div>
                                <div class="comment-date">
                                    <i class="far fa-clock"></i>
                                    <%= c.getCommentDate() %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (isReply) { %>
                    <div class="reply-indicator">
                        <i class="fas fa-reply"></i>
                        Replying to a comment
                    </div>
                    <% } %>

                    <div class="comment-text" id="text-<%= c.getId() %>">
                        <%= c.getCommentText() %>
                    </div>

                    <div class="comment-actions">
                        <%-- REACT FORM --%>
                        <form method="POST" action="CommentServlet" style="display:inline;">
                            <input type="hidden" name="action" value="react">
                            <input type="hidden" name="contestantId" value="<%= contestantId %>">
                            <input type="hidden" name="commentId" value="<%= c.getId() %>">
                            <button type="submit" class="btn btn-success btn-sm">
                                <i class="fas fa-thumbs-up"></i>
                                Like <span class="like-count"><%= c.getLikes() %></span>
                            </button>
                        </form>

                        <%-- REPLY BUTTON --%>
                        <button type="button" class="btn btn-outline btn-sm"
                                onclick="toggleReplyForm(<%= c.getId() %>)">
                            <i class="fas fa-reply"></i>
                            Reply
                        </button>

                        <% if (c.getJudgeId() == judgeId) { %>
                        <%-- EDIT BUTTON --%>
                        <button type="button" class="btn btn-outline btn-sm"
                                onclick="toggleEditForm(<%= c.getId() %>, '<%= escapedText %>')">
                            <i class="fas fa-edit"></i>
                            Edit
                        </button>

                        <%-- DELETE FORM --%>
                        <form method="POST" action="CommentServlet" style="display:inline;"
                              onsubmit="return confirm('Are you sure you want to delete this comment? This action cannot be undone.');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="contestantId" value="<%= contestantId %>">
                            <input type="hidden" name="commentId" value="<%= c.getId() %>">
                            <button type="submit" class="btn btn-danger btn-sm">
                                <i class="fas fa-trash"></i>
                                Delete
                            </button>
                        </form>
                        <% } %>
                    </div>

                    <%-- EDIT FORM --%>
                    <div id="edit-form-<%= c.getId() %>" class="edit-form" style="display:none;">
                        <form action="CommentServlet" method="POST">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="contestantId" value="<%= contestantId %>">
                            <input type="hidden" name="commentId" value="<%= c.getId() %>">
                            <textarea id="edit-textarea-<%= c.getId() %>" name="newCommentText" required></textarea>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary btn-sm">
                                    <i class="fas fa-save"></i>
                                    Save Changes
                                </button>
                                <button type="button" class="btn btn-outline btn-sm"
                                        onclick="toggleEditForm(<%= c.getId() %>, '')">
                                    <i class="fas fa-times"></i>
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>

                    <%-- REPLY FORM --%>
                    <div id="reply-form-<%= c.getId() %>" class="reply-form" style="display:none;">
                        <form action="CommentServlet" method="POST">
                            <input type="hidden" name="action" value="reply">
                            <input type="hidden" name="contestantId" value="<%= contestantId %>">
                            <input type="hidden" name="parentId" value="<%= c.getId() %>">
                            <textarea name="commentText" placeholder="Write your reply..." required></textarea>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary btn-sm">
                                    <i class="fas fa-paper-plane"></i>
                                    Post Reply
                                </button>
                                <button type="button" class="btn btn-outline btn-sm"
                                        onclick="toggleReplyForm(<%= c.getId() %>)">
                                    <i class="fas fa-times"></i>
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <%
                    }
                } else if (commentLoadError == null) {
                %>
                <div class="no-comments">
                    <i class="far fa-comments"></i>
                    <p>No comments yet for Contestant <%= contestantId %></p>
                    <p style="margin-top: 10px; font-size: 0.95rem;">Be the first to share your thoughts!</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>

<script>
    // Toggle edit form visibility
    function toggleEditForm(commentId, currentText) {
        const formDiv = document.getElementById('edit-form-' + commentId);
        const textarea = document.getElementById('edit-textarea-' + commentId);
        const displayDiv = document.getElementById('text-' + commentId);

        if (formDiv.style.display === 'none') {
            // Hide all other open forms before showing this one
            document.querySelectorAll('[id^="edit-form-"]').forEach(div => div.style.display = 'none');
            document.querySelectorAll('[id^="reply-form-"]').forEach(div => div.style.display = 'none');
            document.querySelectorAll('.comment-text').forEach(div => div.style.display = 'block');

            // Show the target form
            displayDiv.style.display = 'none';
            formDiv.style.display = 'block';
            textarea.value = currentText.replace(/\\n/g, '\n');
            textarea.focus();
        } else {
            // Hide form
            formDiv.style.display = 'none';
            displayDiv.style.display = 'block';
        }
    }

    // Toggle reply form visibility
    function toggleReplyForm(commentId) {
        const formDiv = document.getElementById('reply-form-' + commentId);

        if (formDiv.style.display === 'none') {
            // Hide all other open forms before showing this one
            document.querySelectorAll('[id^="edit-form-"]').forEach(div => div.style.display = 'none');
            document.querySelectorAll('[id^="reply-form-"]').forEach(div => div.style.display = 'none');
            document.querySelectorAll('.comment-text').forEach(div => div.style.display = 'block');

            // Show the target form
            formDiv.style.display = 'block';
            formDiv.querySelector('textarea').focus();
        } else {
            // Hide form
            formDiv.style.display = 'none';
        }
    }

    // Add smooth scrolling to comments after form submission
    window.addEventListener('load', function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('status')) {
            document.getElementById('comments-list').scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
</script>
</body>
</html>