package com.voting.observer;

/**
 * Subject interface for the Observer Design Pattern
 * Implemented by classes that need to notify observers of events
 */
public interface Subject {
    /**
     * Register an observer to receive notifications
     * @param observer the observer to register
     */
    void registerObserver(Observer observer);
    
    /**
     * Remove an observer from receiving notifications
     * @param observer the observer to remove
     */
    void removeObserver(Observer observer);
    
    /**
     * Notify all registered observers of an event
     * @param notification the notification to send
     */
    void notifyObservers(com.voting.model.Notification notification);
}
