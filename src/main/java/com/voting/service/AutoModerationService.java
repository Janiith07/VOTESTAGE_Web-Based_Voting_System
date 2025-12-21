package com.voting.service;

import java.util.Arrays;
import java.util.List;

public class AutoModerationService {

    // basic banned words list (extend as needed)
    private static final List<String> BANNED_WORDS = Arrays.asList(
            "ugly", "bad", "worst", "lack"
    );

    /**
     * Returns true if text contains any banned word.
     * Case-insensitive.
     */
    public static boolean containsBannedWords(String text) {
        if (text == null) return false;
        String low = text.toLowerCase();
        for (String w : BANNED_WORDS) {
            if (low.contains(w.toLowerCase())) {
                return true;
            }
        }
        return false;
    }
}