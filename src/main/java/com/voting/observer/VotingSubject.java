package com.voting.observer;

import com.voting.model.Notification;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * VotingSubject class that implements the Subject interface
 * Manages observers and notifies them when golden votes are cast
 */
public class VotingSubject implements Subject {
    private final Map<String, List<Observer>> observers;

    public VotingSubject() {
        this.observers = new HashMap<>();
    }

    @Override
    public void registerObserver(Observer observer) {
        if (observer instanceof ContestantObserver) {
            ContestantObserver contestantObserver = (ContestantObserver) observer;
            String contestantId = contestantObserver.getContestantId();

            observers.computeIfAbsent(contestantId, k -> new ArrayList<>()).add(observer);
            System.out.println("✅ VotingSubject: Registered observer for contestant " + contestantId);
        }
    }

    @Override
    public void removeObserver(Observer observer) {
        if (observer instanceof ContestantObserver) {
            ContestantObserver contestantObserver = (ContestantObserver) observer;
            String contestantId = contestantObserver.getContestantId();

            List<Observer> contestantObservers = observers.get(contestantId);
            if (contestantObservers != null) {
                contestantObservers.remove(observer);
                if (contestantObservers.isEmpty()) {
                    observers.remove(contestantId);
                }
                System.out.println("✅ VotingSubject: Removed observer for contestant " + contestantId);
            }
        }
    }

    @Override
    public void notifyObservers(Notification notification) {
        String recipientId = notification.getRecipientId();
        List<Observer> contestantObservers = observers.get(recipientId);

        if (contestantObservers != null) {
            for (Observer observer : contestantObservers) {
                observer.update(notification);
            }
            System.out.println("✅ VotingSubject: Notified " + contestantObservers.size() + " observers for contestant " + recipientId);
        } else {
            System.out.println("⚠️ VotingSubject: No observers found for contestant " + recipientId);
        }
    }

    /**
     * Notify a specific contestant about a golden vote
     * @param contestantId the contestant who received the golden vote
     * @param judgeId the judge who gave the golden vote
     * @param judgeName the name of the judge
     */
    public void notifyGoldenVote(String contestantId, String judgeId, String judgeName) {
        String message = "Judge " + judgeName + " (ID: " + judgeId + ") gave you a golden vote! 🏆";
        Notification notification = new Notification(contestantId, judgeId, message, "GOLDEN_VOTE");

        notifyObservers(notification);
    }

    /**
     * Get the number of registered observers for a contestant
     * @param contestantId the contestant ID
     * @return number of observers
     */
    public int getObserverCount(String contestantId) {
        List<Observer> contestantObservers = observers.get(contestantId);
        return contestantObservers != null ? contestantObservers.size() : 0;
    }

    /**
     * Get all registered contestant IDs
     * @return list of contestant IDs
     */
    public List<String> getRegisteredContestants() {
        return new ArrayList<>(observers.keySet());
    }
}
