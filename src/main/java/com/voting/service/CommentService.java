package com.voting.service; // Must be in the 'com/voting/service' folder

import com.voting.dao.CommentDAO;
import com.voting.model.Comment;

import java.util.List;

public class CommentService {
    // FIX: This package is required for the Servlet and JSP to import this class.

    // Get all comments for a contestant (Catches exception internally for JSP compatibility)
    public static List<Comment> getCommentsByContestant(String contestantId) {
        try {
            return CommentDAO.getCommentsByContestant(contestantId);
        } catch (Exception e) {
            e.printStackTrace();
            return null; // Returns null on failure, which the JSP handles
        }
    }

    // Add new comment
    public static boolean addComment(Comment comment) {
        try {
            CommentDAO.addComment(comment);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing comment
    public static boolean updateComment(int commentId, String newText) {
        try {
            Comment c = new Comment();
            c.setId(commentId);
            c.setCommentText(newText);
            c.setCommentDate(new java.sql.Timestamp(System.currentTimeMillis()));
            CommentDAO.updateComment(c);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete comment
    public static boolean deleteComment(int commentId) {
        try {
            CommentDAO.deleteComment(commentId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // React comment method
    public static boolean reactComment(int commentId) {
        try {
            CommentDAO.reactComment(commentId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}