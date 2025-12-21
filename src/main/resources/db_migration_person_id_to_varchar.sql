-- =====================================================
-- Database Migration Script
-- Change person_id from INT to VARCHAR(10)
-- Format: P001, P002, P003, etc.
-- =====================================================
-- IMPORTANT: Backup your database before running this script!
-- =====================================================

-- Step 1: Drop all foreign key constraints that reference person_id
PRINT 'Step 1: Dropping foreign key constraints...'

-- Drop FK from Voters table
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Voters_Persons')
    ALTER TABLE Voters DROP CONSTRAINT FK_Voters_Persons;

-- Drop FK from Contestants table
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Contestants_Persons')
    ALTER TABLE Contestants DROP CONSTRAINT FK_Contestants_Persons;

-- Drop FK from Judges table
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Judges_Persons')
    ALTER TABLE Judges DROP CONSTRAINT FK_Judges_Persons;

-- Drop FK from Admins table
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Admins_Persons')
    ALTER TABLE Admins DROP CONSTRAINT FK_Admins_Persons;

-- Drop FK from ITSupporters table
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ITSupporters_Persons')
    ALTER TABLE ITSupporters DROP CONSTRAINT FK_ITSupporters_Persons;

-- Drop FK from Comments table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Comments_Judges')
    ALTER TABLE Comments DROP CONSTRAINT FK_Comments_Judges;

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Comments_Contestants')
    ALTER TABLE Comments DROP CONSTRAINT FK_Comments_Contestants;

-- Drop FK from Video table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Video_Contestants')
    ALTER TABLE Video DROP CONSTRAINT FK_Video_Contestants;

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Video_Admins')
    ALTER TABLE Video DROP CONSTRAINT FK_Video_Admins;

-- Drop FK from Content table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Content_Persons')
    ALTER TABLE Content DROP CONSTRAINT FK_Content_Persons;

-- Drop FK from RegularVotes table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RegularVotes_Voter')
    ALTER TABLE RegularVotes DROP CONSTRAINT FK_RegularVotes_Voter;

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RegularVotes_Contestant')
    ALTER TABLE RegularVotes DROP CONSTRAINT FK_RegularVotes_Contestant;

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RegularVotes_Judge')
    ALTER TABLE RegularVotes DROP CONSTRAINT FK_RegularVotes_Judge;

-- Drop FK from golden_votes table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_GoldenVotes_Judge')
    ALTER TABLE golden_votes DROP CONSTRAINT FK_GoldenVotes_Judge;

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_GoldenVotes_Contestant')
    ALTER TABLE golden_votes DROP CONSTRAINT FK_GoldenVotes_Contestant;

PRINT 'Step 1 completed: Foreign key constraints dropped.'

-- Step 2: Add temporary columns in all related tables
PRINT 'Step 2: Adding temporary columns...'

-- Add temp column to Persons
ALTER TABLE Persons ADD person_id_temp VARCHAR(10);

-- Add temp columns to child tables
ALTER TABLE Voters ADD person_id_temp VARCHAR(10);
ALTER TABLE Contestants ADD person_id_temp VARCHAR(10);
ALTER TABLE Judges ADD person_id_temp VARCHAR(10);
ALTER TABLE Admins ADD person_id_temp VARCHAR(10);
ALTER TABLE ITSupporters ADD person_id_temp VARCHAR(10);

-- Add temp columns to Comments table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'judge_id')
    ALTER TABLE Comments ADD judge_id_temp VARCHAR(10);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE Comments ADD contestant_id_temp VARCHAR(10);

-- Add temp columns to Video table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE Video ADD contestant_id_temp VARCHAR(10);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'admin_id')
    ALTER TABLE Video ADD admin_id_temp VARCHAR(10);

-- Add temp columns to Content table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Content' AND COLUMN_NAME = 'user_id')
    ALTER TABLE Content ADD user_id_temp VARCHAR(10);

-- Add temp columns to RegularVotes table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'voter_id')
    ALTER TABLE RegularVotes ADD voter_id_temp VARCHAR(10);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE RegularVotes ADD contestant_id_temp VARCHAR(10);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'judge_id')
    ALTER TABLE RegularVotes ADD judge_id_temp VARCHAR(10);

-- Add temp columns to golden_votes table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'judge_id')
    ALTER TABLE golden_votes ADD judge_id_temp VARCHAR(10);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE golden_votes ADD contestant_id_temp VARCHAR(10);

PRINT 'Step 2 completed: Temporary columns added.'

-- Step 3: Migrate data to new format (P001, P002, etc.)
PRINT 'Step 3: Migrating data to new format...'

-- Update Persons table with new IDs
UPDATE Persons 
SET person_id_temp = 'P' + RIGHT('000' + CAST(person_id AS VARCHAR), 3);

-- Update child tables with new person_id format
UPDATE Voters
SET person_id_temp = 'P' + RIGHT('000' + CAST(person_id AS VARCHAR), 3);

UPDATE Contestants
SET person_id_temp = 'P' + RIGHT('000' + CAST(person_id AS VARCHAR), 3);

UPDATE Judges
SET person_id_temp = 'P' + RIGHT('000' + CAST(person_id AS VARCHAR), 3);

UPDATE Admins
SET person_id_temp = 'P' + RIGHT('000' + CAST(person_id AS VARCHAR), 3);

UPDATE ITSupporters
SET person_id_temp = 'P' + RIGHT('000' + CAST(person_id AS VARCHAR), 3);

-- Update Comments table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'judge_id')
    UPDATE Comments
    SET judge_id_temp = 'P' + RIGHT('000' + CAST(judge_id AS VARCHAR), 3);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'contestant_id')
    UPDATE Comments
    SET contestant_id_temp = 'P' + RIGHT('000' + CAST(contestant_id AS VARCHAR), 3);

-- Update Video table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'contestant_id')
    UPDATE Video
    SET contestant_id_temp = 'P' + RIGHT('000' + CAST(contestant_id AS VARCHAR), 3);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'admin_id')
    UPDATE Video
    SET admin_id_temp = 'P' + RIGHT('000' + CAST(admin_id AS VARCHAR), 3);

-- Update Content table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Content' AND COLUMN_NAME = 'user_id')
    UPDATE Content
    SET user_id_temp = 'P' + RIGHT('000' + CAST(user_id AS VARCHAR), 3);

-- Update RegularVotes table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'voter_id')
    UPDATE RegularVotes
    SET voter_id_temp = 'P' + RIGHT('000' + CAST(voter_id AS VARCHAR), 3);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'contestant_id')
    UPDATE RegularVotes
    SET contestant_id_temp = 'P' + RIGHT('000' + CAST(contestant_id AS VARCHAR), 3);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'judge_id')
    UPDATE RegularVotes
    SET judge_id_temp = 'P' + RIGHT('000' + CAST(judge_id AS VARCHAR), 3);

-- Update golden_votes table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'judge_id')
    UPDATE golden_votes
    SET judge_id_temp = 'P' + RIGHT('000' + CAST(judge_id AS VARCHAR), 3);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'contestant_id')
    UPDATE golden_votes
    SET contestant_id_temp = 'P' + RIGHT('000' + CAST(contestant_id AS VARCHAR), 3);

PRINT 'Step 3 completed: Data migrated to new format.'

-- Step 4: Drop old columns and rename temp columns
PRINT 'Step 4: Replacing old columns with new ones...'

-- Drop old primary key constraint from Persons
ALTER TABLE Persons DROP CONSTRAINT PK_Persons;

-- Drop old person_id column and rename temp column in Persons
ALTER TABLE Persons DROP COLUMN person_id;
EXEC sp_rename 'Persons.person_id_temp', 'person_id', 'COLUMN';

-- Add primary key back on Persons
ALTER TABLE Persons ADD CONSTRAINT PK_Persons PRIMARY KEY (person_id);

-- Update Voters table
ALTER TABLE Voters DROP COLUMN person_id;
EXEC sp_rename 'Voters.person_id_temp', 'person_id', 'COLUMN';

-- Update Contestants table
ALTER TABLE Contestants DROP COLUMN person_id;
EXEC sp_rename 'Contestants.person_id_temp', 'person_id', 'COLUMN';

-- Update Judges table
ALTER TABLE Judges DROP COLUMN person_id;
EXEC sp_rename 'Judges.person_id_temp', 'person_id', 'COLUMN';

-- Update Admins table
ALTER TABLE Admins DROP COLUMN person_id;
EXEC sp_rename 'Admins.person_id_temp', 'person_id', 'COLUMN';

-- Update ITSupporters table
ALTER TABLE ITSupporters DROP COLUMN person_id;
EXEC sp_rename 'ITSupporters.person_id_temp', 'person_id', 'COLUMN';

-- Update Comments table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'judge_id')
BEGIN
    ALTER TABLE Comments DROP COLUMN judge_id;
    EXEC sp_rename 'Comments.judge_id_temp', 'judge_id', 'COLUMN';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'contestant_id_temp')
BEGIN
    ALTER TABLE Comments DROP COLUMN contestant_id;
    EXEC sp_rename 'Comments.contestant_id_temp', 'contestant_id', 'COLUMN';
END

-- Update Video table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'contestant_id_temp')
BEGIN
    ALTER TABLE Video DROP COLUMN contestant_id;
    EXEC sp_rename 'Video.contestant_id_temp', 'contestant_id', 'COLUMN';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'admin_id_temp')
BEGIN
    ALTER TABLE Video DROP COLUMN admin_id;
    EXEC sp_rename 'Video.admin_id_temp', 'admin_id', 'COLUMN';
END

-- Update Content table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Content' AND COLUMN_NAME = 'user_id_temp')
BEGIN
    ALTER TABLE Content DROP COLUMN user_id;
    EXEC sp_rename 'Content.user_id_temp', 'user_id', 'COLUMN';
END

-- Update RegularVotes table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'voter_id_temp')
BEGIN
    ALTER TABLE RegularVotes DROP COLUMN voter_id;
    EXEC sp_rename 'RegularVotes.voter_id_temp', 'voter_id', 'COLUMN';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'contestant_id_temp')
BEGIN
    ALTER TABLE RegularVotes DROP COLUMN contestant_id;
    EXEC sp_rename 'RegularVotes.contestant_id_temp', 'contestant_id', 'COLUMN';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'judge_id_temp')
BEGIN
    ALTER TABLE RegularVotes DROP COLUMN judge_id;
    EXEC sp_rename 'RegularVotes.judge_id_temp', 'judge_id', 'COLUMN';
END

-- Update golden_votes table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'judge_id_temp')
BEGIN
    ALTER TABLE golden_votes DROP COLUMN judge_id;
    EXEC sp_rename 'golden_votes.judge_id_temp', 'judge_id', 'COLUMN';
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'contestant_id_temp')
BEGIN
    ALTER TABLE golden_votes DROP COLUMN contestant_id;
    EXEC sp_rename 'golden_votes.contestant_id_temp', 'contestant_id', 'COLUMN';
END

PRINT 'Step 4 completed: Old columns replaced with new VARCHAR columns.'

-- Step 5: Recreate foreign key constraints
PRINT 'Step 5: Recreating foreign key constraints...'

-- Recreate FK for Voters
ALTER TABLE Voters 
ADD CONSTRAINT FK_Voters_Persons 
FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE;

-- Recreate FK for Contestants
ALTER TABLE Contestants 
ADD CONSTRAINT FK_Contestants_Persons 
FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE;

-- Recreate FK for Judges
ALTER TABLE Judges 
ADD CONSTRAINT FK_Judges_Persons 
FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE;

-- Recreate FK for Admins
ALTER TABLE Admins 
ADD CONSTRAINT FK_Admins_Persons 
FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE;

-- Recreate FK for ITSupporters
ALTER TABLE ITSupporters 
ADD CONSTRAINT FK_ITSupporters_Persons 
FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE;

-- Recreate FK for Comments table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'judge_id')
    ALTER TABLE Comments 
    ADD CONSTRAINT FK_Comments_Judges 
    FOREIGN KEY (judge_id) REFERENCES Persons(person_id);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE Comments 
    ADD CONSTRAINT FK_Comments_Contestants 
    FOREIGN KEY (contestant_id) REFERENCES Persons(person_id);

-- Recreate FK for Video table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE Video 
    ADD CONSTRAINT FK_Video_Contestants 
    FOREIGN KEY (contestant_id) REFERENCES Persons(person_id);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'admin_id')
    ALTER TABLE Video 
    ADD CONSTRAINT FK_Video_Admins 
    FOREIGN KEY (admin_id) REFERENCES Persons(person_id);

-- Recreate FK for Content table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Content' AND COLUMN_NAME = 'user_id')
    ALTER TABLE Content 
    ADD CONSTRAINT FK_Content_Persons 
    FOREIGN KEY (user_id) REFERENCES Persons(person_id);

-- Recreate FK for RegularVotes table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'voter_id')
    ALTER TABLE RegularVotes 
    ADD CONSTRAINT FK_RegularVotes_Voter 
    FOREIGN KEY (voter_id) REFERENCES Persons(person_id);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE RegularVotes 
    ADD CONSTRAINT FK_RegularVotes_Contestant 
    FOREIGN KEY (contestant_id) REFERENCES Persons(person_id);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'judge_id')
    ALTER TABLE RegularVotes 
    ADD CONSTRAINT FK_RegularVotes_Judge 
    FOREIGN KEY (judge_id) REFERENCES Persons(person_id);

-- Recreate FK for golden_votes table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'judge_id')
    ALTER TABLE golden_votes 
    ADD CONSTRAINT FK_GoldenVotes_Judge 
    FOREIGN KEY (judge_id) REFERENCES Persons(person_id);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE golden_votes 
    ADD CONSTRAINT FK_GoldenVotes_Contestant 
    FOREIGN KEY (contestant_id) REFERENCES Persons(person_id);

PRINT 'Step 5 completed: Foreign key constraints recreated.'

-- Step 6: Verification
PRINT 'Step 6: Verifying migration...'

-- Show sample data from Persons table
PRINT 'Sample data from Persons table:'
SELECT TOP 5 person_id, name, email, role FROM Persons ORDER BY person_id;

-- Show counts
PRINT 'Record counts:'
SELECT 'Persons' AS TableName, COUNT(*) AS RecordCount FROM Persons
UNION ALL
SELECT 'Voters', COUNT(*) FROM Voters
UNION ALL
SELECT 'Contestants', COUNT(*) FROM Contestants
UNION ALL
SELECT 'Judges', COUNT(*) FROM Judges
UNION ALL
SELECT 'Admins', COUNT(*) FROM Admins
UNION ALL
SELECT 'ITSupporters', COUNT(*) FROM ITSupporters;

PRINT '============================================='
PRINT 'Migration completed successfully!'
PRINT 'person_id is now VARCHAR(10) with format P001, P002, etc.'
PRINT '============================================='


