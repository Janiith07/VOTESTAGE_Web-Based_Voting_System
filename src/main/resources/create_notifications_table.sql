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
-- VALUES ('P001', 'P002', 'Judge John Doe gave you a golden vote! 🏆', 'GOLDEN_VOTE');

PRINT 'Notifications table created successfully with indexes.';
