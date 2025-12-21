package com.voting.observer;

import com.voting.model.Notification;

/**
 * Observer interface for the Observer Design Pattern
 * Implemented by classes that need to be notified of events
 */
public interface Observer {
    /**
     * Called when a notification is received
     * @param notification the notification object containing event details
     */
    void update(Notification notification);
}
