-- =====================================================
-- Password Validation Database Constraint
-- Add CHECK constraint to enforce minimum password length
-- =====================================================
-- IMPORTANT: Backup your database before running this script!
-- =====================================================

-- Add CHECK constraint to Persons table for password length
-- This ensures passwords are at least 8 characters long at database level

PRINT 'Adding password length constraint to Persons table...'

-- Drop existing constraint if it exists
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Persons_PasswordLength')
    ALTER TABLE Persons DROP CONSTRAINT CK_Persons_PasswordLength;

-- Add new constraint
ALTER TABLE Persons 
ADD CONSTRAINT CK_Persons_PasswordLength 
CHECK (LEN(password) >= 8);

PRINT 'Password length constraint added successfully!'
PRINT 'Passwords must now be at least 8 characters long.'

-- Verify the constraint
PRINT 'Verifying constraint...'
SELECT 
    CONSTRAINT_NAME,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS 
WHERE CONSTRAINT_NAME = 'CK_Persons_PasswordLength';

PRINT '============================================='
PRINT 'Password validation constraint completed!'
PRINT '============================================='








