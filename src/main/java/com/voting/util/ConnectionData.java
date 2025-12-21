package com.voting.util;

public class ConnectionData {
    public static final String DATABASE = "VotingDB3";
    public static final String USERNAME = "sa";
    
    // Try common SQL Server passwords
    public static final String[] PASSWORDS = {
        "12",           // Current password
        "",             // Empty password
        "sa",           // Username as password
        "password",     // Common default
        "123456",       // Common default
        "admin",        // Common default
        "root",         // Common default
        "123",          // Simple password
        "password123"   // Common variation
    };
    
    public static final String PASSWORD = PASSWORDS[0]; // Default to first password
}
