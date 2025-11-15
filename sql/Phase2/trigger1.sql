CREATE TABLE Audit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100) NOT NULL,
    ActionType NVARCHAR(10) NOT NULL,		-- write if 'INSERT', 'UPDATE', 'DELETE'
    RecordID INT NULL,						-- primary key of the affected row
    ChangedBy NVARCHAR(100) NULL,			-- [optional] username or system process
    ChangeTime DATETIME DEFAULT GETDATE(),	-- when it happened
    Description NVARCHAR(1000) NULL			-- [optional] human-readable brief explanation
);
GO


/* ________________________________________________________________________________

	1

Name:		trg_AuditLargeWithdrawal
Table:		BankTransaction
Event:		AFTER INSERT
What for:	Logs large withdrawal events exceeding $10,000 into the Audit table for compliance and oversight.
For who:	Database administrators and compliance officers monitoring high-risk financial activity.
Tracks:		TransactionID, AccountID, Amount, and a descriptive summary of the withdrawal.
Threshold:	Only triggers when a withdrawal of $10,000 or more is inserted.
Sample usage:
    INSERT INTO BankTransaction (AccountID, Amount, TransactionDate, TransactionType)
    VALUES (30, 12000, GETDATE(), 'Withdrawal');

	SELECT * FROM Audit;
________________________________________________________________________________*/


CREATE OR ALTER TRIGGER trg_AuditLargeWithdrawal
ON BankTransaction
AFTER INSERT			--DML Trigger
AS
BEGIN
	DECLARE @AmtThreshold MONEY;
	SET @AmtThreshold = 10000;

    INSERT INTO Audit (TableName, ActionType, RecordID, Description)
    SELECT 
        'BankTransaction',
        'INSERT',
        i.TransactionID,
        'Large withdrawal of $' + CAST(i.Amount AS NVARCHAR) + 
        ' from AccountID ' + CAST(i.AccountID AS NVARCHAR)
    FROM Inserted i		--temporary table made by trigger
    WHERE i.TransactionType = 'Withdrawal' AND i.Amount >= @AmtThreshold;
END;


/*
--DISABLE TRIGGER trg_AuditLargeWithdrawal ON BankTransaction;
--ENABLE TRIGGER trg_AuditLargeWithdrawal ON BankTransaction;

Ref: https://www.mssqltips.com/sqlservertip/7429/sql-triggers-for-inserts-updates-and-deletes-on-a-table/
*/






