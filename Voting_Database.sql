

CREATE DATABASE VotingDB3

USE VotingDB3;


------------------------------------------------
-- 2. Recreate schema
------------------------------------------------
CREATE TABLE Persons (
    person_id VARCHAR(10) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(50) NOT NULL,
    role NVARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Voter', 'ContestantManager', 'ITSupporter', 'Judge', 'Contestant'))
);

CREATE TABLE Admins (
    person_id VARCHAR(10) PRIMARY KEY,
	admin_level NVARCHAR(50) DEFAULT 'Support',
    FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE
);

CREATE TABLE Voters (
    person_id VARCHAR(10) PRIMARY KEY,
    vote_count INT DEFAULT 0,
    FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE
);

Create TABLE Contestants (
    person_id VARCHAR(10) PRIMARY KEY,
    age INT,
    gender NVARCHAR(50),
    total_votes_received INT DEFAULT 0 CHECK (total_votes_received >= 0),
    FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE
);




CREATE TABLE ContestantManagers (
    person_id VARCHAR(10) PRIMARY KEY,
    manager_level VARCHAR(50) DEFAULT 'Standard', -- e.g., Standard, Junior, Senior
    FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE
);

CREATE TABLE ITSupporters (
    person_id VARCHAR(10) PRIMARY KEY,
    supporter_level NVARCHAR(50) DEFAULT 'Support',
    FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE
);

CREATE TABLE Judges (
    person_id VARCHAR(10) PRIMARY KEY,
    judge_vote_count INT DEFAULT 0,
    FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE
);

CREATE TABLE RegularVotes (
    vote_id INT PRIMARY KEY IDENTITY(1,1),
    voter_id VARCHAR(10) NOT NULL,
    contestant_id VARCHAR(10) NOT NULL,
    contestant_name NVARCHAR(255),
    performance NVARCHAR(255),
    judge_id VARCHAR(10) NOT NULL,
    judge_name NVARCHAR(255),
    vote_date DATETIME DEFAULT GETDATE(),
    score INT DEFAULT 1,
    vote_type NVARCHAR(20) DEFAULT 'Regular' CHECK (vote_type IN ('Regular', 'Golden')),
    status NVARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Revoked')),
    FOREIGN KEY (judge_id) REFERENCES Persons(person_id) ON DELETE NO ACTION,
    FOREIGN KEY (voter_id) REFERENCES Persons(person_id) ON DELETE NO ACTION,
    FOREIGN KEY (contestant_id) REFERENCES Persons(person_id) ON DELETE NO ACTION
);


CREATE TABLE golden_votes (
    vote_id INT PRIMARY KEY IDENTITY(1,1),
    judge_id VARCHAR(10) NOT NULL,
    contestant_id VARCHAR(10) NOT NULL,
    contestant_name NVARCHAR(255) NOT NULL,
    performance NVARCHAR(255) NOT NULL,
    judge_name NVARCHAR(255) NOT NULL,
    vote_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Revoked')),
    FOREIGN KEY (judge_id) REFERENCES Persons(person_id),
    FOREIGN KEY (contestant_id) REFERENCES Persons(person_id)
);

CREATE TABLE JudgeVoteAllocations (
    allocation_id INT PRIMARY KEY IDENTITY(1,1),
    judge_id VARCHAR(10) NOT NULL UNIQUE,
    total_votes INT DEFAULT 30,
    votes_used INT DEFAULT 0,
    votes_remaining AS (total_votes - votes_used) PERSISTED,
    last_updated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (judge_id) REFERENCES Persons(person_id)
);

-- Video Table
CREATE TABLE Video (
    video_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    original_singer NVARCHAR(255),
    duration NVARCHAR(20),
    file_path NVARCHAR(500) NOT NULL,
    contestant_id VARCHAR(10) NOT NULL,
    admin_id VARCHAR(10) NOT NULL,
    uploaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (contestant_id) REFERENCES Contestants(person_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES Admins(person_id) ON DELETE NO ACTION
);




CREATE TABLE Viewer (
    name NVARCHAR(100) PRIMARY KEY
);

CREATE TABLE Event (
    event_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(200) NOT NULL,
    description NVARCHAR(1000) NULL,
    time_period NVARCHAR(100) NOT NULL,   -- or DATETIME if it’s a single timestamp
    created_at DATETIME DEFAULT GETDATE(),
    user_id VARCHAR(10) NOT NULL,                -- the admin who created the event
    CONSTRAINT fk_admin_event FOREIGN KEY (user_id) REFERENCES Admins(person_id)
);


CREATE TABLE EventViews (
    view_id INT PRIMARY KEY IDENTITY(1,1),
    viewer_name NVARCHAR(100) NOT NULL,  
    event_id INT NOT NULL,                
    view_date DATETIME DEFAULT GETDATE(), -- auto-fill current date/time
    FOREIGN KEY (viewer_name) REFERENCES Viewer(name),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
);



CREATE TABLE Comments (
    id INT IDENTITY(1,1) PRIMARY KEY, 
    judge_id VARCHAR(10) NOT NULL,
    contestant_id VARCHAR(10) NOT NULL,
    parent_id INT NULL, 
    comment_text NVARCHAR(MAX) NOT NULL,
    comment_date DATETIME DEFAULT GETDATE(),
    likes INT DEFAULT 0,
    status VARCHAR(10) DEFAULT 'ACTIVE' NOT NULL,
    FOREIGN KEY (judge_id) REFERENCES Persons(person_id), 
    FOREIGN KEY (contestant_id) REFERENCES Persons(person_id),
    FOREIGN KEY (parent_id) REFERENCES Comments(id)
);
GO

CREATE TABLE performanceSchedule (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    slot NVARCHAR(50) NOT NULL
);




------------------------------------------------
-- 5. Verify data
------------------------------------------------
SELECT * FROM Persons;
SELECT * FROM Admins;
SELECT * FROM Contestants;
SELECT * FROM ContestantManagers;
SELECT * FROM ITSupporters;
SELECT * FROM Judges;
SELECT * FROM Voters;
SELECT * FROM Video;
SELECT * FROM Comments;
SELECT * FROM Event;
SELECT * FROM Viewer;
SELECT * FROM EventViews;
SELECT * FROM RegularVotes;
SELECT * FROM golden_votes;
SELECT * FROM Notifications;

-- 1. Insert into Persons table
INSERT INTO Persons (person_id, name, email, password, role)
VALUES ('P001', 'Janith', 'janith@gmail.com', 'ja12', 'ITSupporter');

-- 1. Insert into Persons table
INSERT INTO Persons (person_id, name, email, password, role)
VALUES ('P001', 'ranil', 'ranil@gmail.com', 'ja12', 'Contestant');

-- Create Notifications table for Observer pattern implementation
-- This table stores notifications sent to contestants when they receive golden votes

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    recipient_id VARCHAR(10) NOT NULL,
    sender_id VARCHAR(10) NOT NULL,
    message NVARCHAR(500) NOT NULL,
    type NVARCHAR(50) NOT NULL DEFAULT 'GOLDEN_VOTE',
    created_at DATETIME DEFAULT GETDATE(),
    is_read BIT DEFAULT 0,
    FOREIGN KEY (recipient_id) REFERENCES Persons(person_id) ON DELETE NO ACTION,
    FOREIGN KEY (sender_id) REFERENCES Persons(person_id) ON DELETE NO ACTION
);

-- Create index for better performance on recipient queries
CREATE INDEX IX_Notifications_Recipient ON Notifications(recipient_id);
CREATE INDEX IX_Notifications_Read_Status ON Notifications(is_read);
CREATE INDEX IX_Notifications_Created_At ON Notifications(created_at);

-- Insert some sample data for testing (optional)
-- INSERT INTO Notifications (recipient_id, sender_id, message, type) 
-- VALUES ('P001', 'P002', 'Judge John Doe gave you a golden vote!', 'GOLDEN_VOTE');

PRINT 'Notifications table created successfully with indexes.';

INSERT INTO Contestants (person_id, age, gender, total_votes_received)
VALUES ('P003', 25, 'Female', 50);

-- 1. Insert into Persons table
INSERT INTO Persons (person_id, name, email, password, role)
VALUES ('P003', 'Sophia Turner', 'sophiaturner@gmail.com', 'sofi12345678', 'Contestant');



