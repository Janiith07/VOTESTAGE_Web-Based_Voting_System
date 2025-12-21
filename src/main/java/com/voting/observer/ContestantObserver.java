package com.voting.observer;

import com.voting.dao.NotificationDAO;
import com.voting.model.Notification;

/**
 * ContestantObserver class that implements the Observer pattern
 * Handles notifications for contestants when they receive golden votes
 */
public class ContestantObserver implements Observer {
    private final String contestantId;
    
    public ContestantObserver(String contestantId) {
        this.contestantId = contestantId;
    }
    
    @Override
    public void update(Notification notification) {
        try {
            // Store the notification in the database
            NotificationDAO.addNotification(notification);
            System.out.println("ContestantObserver: Notification sent to contestant " + contestantId +
                             " - " + notification.getMessage());
        } catch (Exception e) {
            System.err.println("ContestantObserver: Failed to send notification to contestant " + contestantId);
            e.printStackTrace();
        }
    }
    
    public String getContestantId() {
        return contestantId;
    }
}
