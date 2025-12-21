-- Cleanup script for Notifications table when users are deleted
-- This script should be run before deleting users from the Persons table

-- Create a stored procedure to clean up notifications when a user is deleted
CREATE OR ALTER PROCEDURE CleanupUserNotifications
    @userId VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        -- Delete notifications where the user is either recipient or sender
        DELETE FROM Notifications 
        WHERE recipient_id = @UserId OR sender_id = @UserId;
        
        PRINT 'Cleaned up notifications for user: ' + @UserId;
        RETURN 0;
    END TRY
    BEGIN CATCH
        PRINT 'Error cleaning up notifications for user ' + @UserId + ': ' + ERROR_MESSAGE();
        RETURN 1;
    END CATCH
END;

-- Example usage:
-- EXEC CleanupUserNotifications 'P001';

-- Alternative: Create a trigger to automatically clean up notifications
-- (Uncomment the following if you want automatic cleanup)

/*
CREATE OR ALTER TRIGGER TR_Persons_Delete_CleanupNotifications
ON Persons
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Clean up notifications for deleted users
    DELETE n FROM Notifications n
    INNER JOIN deleted d ON n.recipient_id = d.person_id OR n.sender_id = d.person_id;
    
    PRINT 'Automatically cleaned up notifications for deleted users.';
END;
*/

PRINT 'Notification cleanup procedures created successfully.';
PRINT 'Use: EXEC CleanupUserNotifications ''userId'' to clean up notifications before deleting a user.';
