-- Create Notifications table for Observer pattern implementation (Fixed Version)
-- This version avoids cascade path conflicts by using NO ACTION constraints

-- First, check if the table already exists and drop it if necessary
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notifications]') AND type in (N'U'))
BEGIN
    DROP TABLE [dbo].[Notifications];
    PRINT 'Existing Notifications table dropped.';
END

-- Create Notifications table with NO ACTION constraints to avoid cascade path conflicts
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    recipient_id VARCHAR(10) NOT NULL,
    sender_id VARCHAR(10) NOT NULL,
    message NVARCHAR(500) NOT NULL,
    type NVARCHAR(50) NOT NULL DEFAULT 'GOLDEN_VOTE',
    created_at DATETIME DEFAULT GETDATE(),
    is_read BIT DEFAULT 0
);

-- Add foreign key constraints with NO ACTION to prevent cascade path conflicts
ALTER TABLE Notifications 
ADD CONSTRAINT FK_Notifications_Recipient 
FOREIGN KEY (recipient_id) REFERENCES Persons(person_id) ON DELETE NO ACTION;

ALTER TABLE Notifications 
ADD CONSTRAINT FK_Notifications_Sender 
FOREIGN KEY (sender_id) REFERENCES Persons(person_id) ON DELETE NO ACTION;

-- Create indexes for better performance
CREATE INDEX IX_Notifications_Recipient ON Notifications(recipient_id);
CREATE INDEX IX_Notifications_Read_Status ON Notifications(is_read);
CREATE INDEX IX_Notifications_Created_At ON Notifications(created_at);

-- Insert some sample data for testing (optional - comment out if not needed)
-- INSERT INTO Notifications (recipient_id, sender_id, message, type) 
-- VALUES ('P001', 'P002', 'Judge John Doe gave you a golden vote! 🏆', 'GOLDEN_VOTE');

PRINT 'Notifications table created successfully with NO ACTION constraints.';
PRINT 'Note: When deleting users, you may need to manually clean up their notifications.';
