package com.voting.model;

import java.sql.Timestamp;

public class Comment {
    private int id;
    private String judgeId;
    private String contestantId;
    private String commentText;
    private Timestamp commentDate;
    private int likes;         // NEW: For the 'react' button
    private Integer parentId;  // NEW: For reply functionality

    // Constructor
    public Comment() {}

    public Comment(int id, String judgeId, String contestantId, String commentText, Timestamp commentDate, int likes, Integer parentId) {
        this.id = id;
        this.judgeId = judgeId;
        this.contestantId = contestantId;
        this.commentText = commentText;
        this.commentDate = commentDate;
        this.likes = likes;
        this.parentId = parentId;
    }

    // Getters and setters (Existing)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getJudgeId() { return judgeId; }
    public void setJudgeId(String judgeId) { this.judgeId = judgeId; }

    public String getContestantId() { return contestantId; }
    public void setContestantId(String contestantId) { this.contestantId = contestantId; }

    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }

    public Timestamp getCommentDate() { return commentDate; }
    public void setCommentDate(Timestamp commentDate) { this.commentDate = commentDate; }

    // Getters and setters (NEW)
    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }

    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }
}