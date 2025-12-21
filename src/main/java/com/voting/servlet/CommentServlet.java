package com.voting.servlet;

import com.voting.model.Comment;
import com.voting.service.CommentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String judgeId = (String) session.getAttribute("user_id");
        String contestantId = request.getParameter("contestantId");
        String action = request.getParameter("action");

        if (judgeId == null || contestantId == null || action == null) {
            response.sendRedirect("error.jsp?message=InvalidSessionOrParameters");
            return;
        }

        boolean success = false;
        String message = "";

        // --- Handle Actions ---
        if ("add".equals(action) || "reply".equals(action)) {
            String commentText = request.getParameter("commentText");
            String parentIdParam = request.getParameter("parentId");

            if (commentText != null && !commentText.trim().isEmpty()) {
                Comment comment = new Comment();
                comment.setJudgeId(judgeId);
                comment.setContestantId(contestantId);
                comment.setCommentText(commentText);
                comment.setCommentDate(new Timestamp(System.currentTimeMillis()));

                if ("reply".equals(action) && parentIdParam != null && !parentIdParam.isEmpty()) {
                    try {
                        comment.setParentId(Integer.parseInt(parentIdParam));
                    } catch (NumberFormatException e) { }
                }

                success = CommentService.addComment(comment);
                message = success ? "addSuccess" : "addError";
            }

        } else if ("edit".equals(action)) {
            String commentIdParam = request.getParameter("commentId");
            String newText = request.getParameter("newCommentText");

            if (commentIdParam != null && newText != null) {
                try {
                    int commentId = Integer.parseInt(commentIdParam);
                    success = CommentService.updateComment(commentId, newText);
                    message = success ? "editSuccess" : "editError";
                } catch (NumberFormatException e) {
                    message = "InvalidCommentIDForEdit";
                }
            }

        } else if ("delete".equals(action)) {
            String commentIdParam = request.getParameter("commentId");

            if (commentIdParam != null) {
                try {
                    int commentId = Integer.parseInt(commentIdParam);
                    success = CommentService.deleteComment(commentId);
                    message = success ? "deleteSuccess" : "deleteError";
                } catch (NumberFormatException e) {
                    message = "InvalidCommentIDForDelete";
                }
            }

        } else if ("react".equals(action)) {
            String commentIdParam = request.getParameter("commentId");

            if (commentIdParam != null) {
                try {
                    int commentId = Integer.parseInt(commentIdParam);
                    success = CommentService.reactComment(commentId);
                    message = success ? "reactSuccess" : "reactError";
                } catch (NumberFormatException e) {
                    message = "InvalidCommentIDForReact";
                }
            }

        } else {
            message = "UnknownAction";
        }

        // --- FINAL REDIRECT ---
        String status = success ? "success" : "error";
        // FIX: If you renamed comment-dashboard.jsp to comment.jsp, use comment.jsp here.
        // If you did NOT rename it, but your entry button/link is still broken, use comment-dashboard.jsp

        // අපි comment.jsp වලට rename කල බව සිතා redirect කරමු:
        response.sendRedirect("comment.jsp?contestantId=" + contestantId + "&status=" + status + "&message=" + message);
    }
}