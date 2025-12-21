package com.voting.model;

import java.sql.Timestamp;

public class Video {
    private int videoId;
    private String title;
    private String description;
    private String filePath;      // ✅ relative path like "videos/uuid.mp4"
    private String contestantId;
    private String adminId;
    private String singer;        // maps to original_singer
    private String duration;
    private Timestamp uploadedAt;

    // --- Getters & Setters ---
    public int getVideoId() {
        return videoId;
    }
    public void setVideoId(int videoId) {
        this.videoId = videoId;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getFilePath() {
        return filePath;
    }
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getContestantId() {
        return contestantId;
    }
    public void setContestantId(String contestantId) {
        this.contestantId = contestantId;
    }

    public String getAdminId() {
        return adminId;
    }
    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getSinger() {
        return singer;
    }
    public void setSinger(String singer) {
        this.singer = singer;
    }

    public String getDuration() {
        return duration;
    }
    public void setDuration(String duration) {
        this.duration = duration;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }
    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    // --- Optional: toString for debugging ---
    @Override
    public String toString() {
        return "Video{" +
                "videoId=" + videoId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", filePath='" + filePath + '\'' +
                ", contestantId=" + contestantId +
                ", adminId=" + adminId +
                ", singer='" + singer + '\'' +
                ", duration='" + duration + '\'' +
                ", uploadedAt=" + uploadedAt +
                '}';
    }
}
