-- =====================================================
-- Database Migration Script
-- Drop Contestants table and create ContestantManagers table
-- =====================================================
-- IMPORTANT: Backup your database before running this script!
-- =====================================================

PRINT 'Starting Contestant to ContestantManager migration...'

-- Step 1: Drop all foreign key constraints that reference Contestants table
PRINT 'Step 1: Dropping foreign key constraints...'

-- Drop FK from Comments table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Comments_Contestants')
    ALTER TABLE Comments DROP CONSTRAINT FK_Comments_Contestants;

-- Drop FK from Video table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Video_Contestants')
    ALTER TABLE Video DROP CONSTRAINT FK_Video_Contestants;

-- Drop FK from RegularVotes table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RegularVotes_Contestant')
    ALTER TABLE RegularVotes DROP CONSTRAINT FK_RegularVotes_Contestant;

-- Drop FK from golden_votes table if exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_GoldenVotes_Contestant')
    ALTER TABLE golden_votes DROP CONSTRAINT FK_GoldenVotes_Contestant;

PRINT 'Step 1 completed: Foreign key constraints dropped.'

-- Step 2: Create ContestantManagers table
PRINT 'Step 2: Creating ContestantManagers table...'

CREATE TABLE ContestantManagers (
    person_id VARCHAR(10) PRIMARY KEY,
    manager_level VARCHAR(50) DEFAULT 'Standard', -- e.g., Standard, Junior, Senior
    FOREIGN KEY (person_id) REFERENCES Persons(person_id) ON DELETE CASCADE
);

PRINT 'Step 2 completed: ContestantManagers table created.'

-- Step 3: Migrate data from Contestants to ContestantManagers
PRINT 'Step 3: Migrating data from Contestants to ContestantManagers...'

-- Insert data from Contestants table into ContestantManagers
INSERT INTO ContestantManagers (person_id, manager_level)
SELECT 
    person_id,
    'Standard' as manager_level  -- Set default manager level for existing contestants
FROM Contestants;

PRINT 'Step 3 completed: Data migrated to ContestantManagers.'

-- Step 4: Drop the old Contestants table
PRINT 'Step 4: Dropping old Contestants table...'

DROP TABLE Contestants;

PRINT 'Step 4 completed: Contestants table dropped.'

-- Step 5: Recreate foreign key constraints pointing to ContestantManagers
PRINT 'Step 5: Recreating foreign key constraints...'

-- Recreate FK for Comments table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Comments' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE Comments 
    ADD CONSTRAINT FK_Comments_ContestantManagers 
    FOREIGN KEY (contestant_id) REFERENCES ContestantManagers(person_id);

-- Recreate FK for Video table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Video' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE Video 
    ADD CONSTRAINT FK_Video_ContestantManagers 
    FOREIGN KEY (contestant_id) REFERENCES ContestantManagers(person_id);

-- Recreate FK for RegularVotes table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RegularVotes' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE RegularVotes 
    ADD CONSTRAINT FK_RegularVotes_ContestantManager 
    FOREIGN KEY (contestant_id) REFERENCES ContestantManagers(person_id);

-- Recreate FK for golden_votes table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'golden_votes' AND COLUMN_NAME = 'contestant_id')
    ALTER TABLE golden_votes 
    ADD CONSTRAINT FK_GoldenVotes_ContestantManager 
    FOREIGN KEY (contestant_id) REFERENCES ContestantManagers(person_id);

PRINT 'Step 5 completed: Foreign key constraints recreated.'

-- Step 6: Verification
PRINT 'Step 6: Verifying migration...'

-- Show sample data from ContestantManagers table
PRINT 'Sample data from ContestantManagers table:'
SELECT TOP 5 cm.person_id, p.name, p.email, cm.manager_level 
FROM ContestantManagers cm
JOIN Persons p ON cm.person_id = p.person_id
ORDER BY cm.person_id;

-- Show counts
PRINT 'Record counts:'
SELECT 'ContestantManagers' AS TableName, COUNT(*) AS RecordCount FROM ContestantManagers
UNION ALL
SELECT 'Persons with Contestant role', COUNT(*) FROM Persons WHERE role = 'Contestant';

PRINT '============================================='
PRINT 'Migration completed successfully!'
PRINT 'Contestants table has been replaced with ContestantManagers table.'
PRINT '============================================='
