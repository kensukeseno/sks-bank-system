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

    INSERT INTO Audit (TableName, ActionType, RecordID, ChangedBy, Description)
    SELECT 
        'BankTransaction',
        'INSERT',
        i.TransactionID,
		SYSTEM_USER,
        'Large withdrawal of $' + CAST(i.Amount AS NVARCHAR) + 
        ' from AccountID ' + CAST(i.AccountID AS NVARCHAR)
    FROM Inserted i		--temporary table made by trigger
    WHERE i.TransactionType = 'Withdrawal' AND i.Amount >= @AmtThreshold;
END;
GO

/*
--DISABLE TRIGGER trg_AuditLargeWithdrawal ON BankTransaction;
--ENABLE TRIGGER trg_AuditLargeWithdrawal ON BankTransaction;

Ref: https://www.mssqltips.com/sqlservertip/7429/sql-triggers-for-inserts-updates-and-deletes-on-a-table/
*/





/* ________________________________________________________________________________

	2

Name:		trg_EmpRoleOrMngChange
Table:		Employee
Event:		AFTER UPDATE
What for:	Log employee role changes or manager assignments to ensure accountability, traceability, and auditing in the system.
For who:	Database administrators, HR, managers, compliance officers
Tracks:		EmployeeID, EmployeeRole, ManagerID, and a descriptive summary of the change.
Sample usage:
    UPDATE Employee SET EmployeeRole = 'Loan Officer' WHERE EmployeeID = 6;
	UPDATE Employee SET ManagerID = '1' WHERE EmployeeID = 7;
	UPDATE Employee SET EmployeeRole = 'Loan Officer', ManagerID = '1' WHERE EmployeeID = 8;

	SELECT * FROM Audit;
________________________________________________________________________________*/


CREATE OR ALTER TRIGGER trg_EmpRoleOrMngChange
ON Employee
AFTER UPDATE
AS
BEGIN
	IF UPDATE(EmployeeRole) OR UPDATE(ManagerID)
	BEGIN
		INSERT INTO Audit (TableName, ActionType, RecordID, ChangedBy, Description)
		SELECT
				'Employee',
				'UPDATE',
				i.EmployeeID,
				SYSTEM_USER,
				CASE
					WHEN UPDATE(EmployeeRole) AND UPDATE(ManagerID) THEN 
						'Employee role of employee ID ' + CAST(i.EmployeeID AS NVARCHAR) +  ' was changed from ' + 
						d.EmployeeRole + ' to ' + i.EmployeeRole + ' and ' + 'Manager ID was changed from ' + 
						CAST(d.ManagerID AS NVARCHAR) + ' to ' + CAST(i.ManagerID AS NVARCHAR)
					WHEN UPDATE(EmployeeRole) THEN 
						'Employee role of employee ID ' + CAST(i.EmployeeID AS NVARCHAR) +  ' was changed from ' + 
						d.EmployeeRole + ' to ' + i.EmployeeRole
					ELSE 
						'Manager ID of employee ID ' + CAST(i.EmployeeID AS NVARCHAR) +  ' was changed from ' + 
						CAST(d.ManagerID AS NVARCHAR) + ' to ' + CAST(i.ManagerID AS NVARCHAR)
				END
		FROM Inserted i
		JOIN Deleted d ON i.EmployeeID = d.EmployeeID;
	END
END;
GO





/* ________________________________________________________________________________

    3

Name:       trg_LateLoanPayment
Table:      LoanPayment
Event:      AFTER INSERT
What for:   Logs any late loan payment (PaymentDate later than Loan.DueDate) into the
            Audit table so staff can monitor delinquent loan accounts.
For who:    Database administrators, loan officers, managers, compliance staff.
Tracks:     LoanPaymentID, LoanID, AmountPaid, Days Late, and a descriptive summary
            of the late payment event.
Threshold:  Only triggers when the inserted payment occurs after the loan's DueDate.
Sample usage:
    INSERT INTO LoanPayment (LoanID, PaymentDate, AmountPaid)
    VALUES (30, '2025-09-10', 500.00);   -- Will be logged if past DueDate

    SELECT * FROM Audit;
________________________________________________________________________________*/


CREATE OR ALTER TRIGGER trg_LateLoanPayment
ON LoanPayment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Audit (TableName, ActionType, RecordID, ChangedBy, ChangeTime, Description)
    SELECT
        'LoanPayment',                                              
        'INSERT',                                                     
        i.LoanPaymentID,                                            
        SYSTEM_USER,                                                
        GETDATE(),                                                   
        CONCAT(
            'Late payment detected. LoanID: ', i.LoanID,
            ', LoanPaymentID: ', i.LoanPaymentID,
            ', AmountPaid: $', i.AmountPaid,
            ', Days Late: ', DATEDIFF(DAY, l.DueDate, i.PaymentDate)
        )                                                           
    FROM Inserted i
    INNER JOIN Loan l ON i.LoanID = l.LoanID
    WHERE i.PaymentDate > l.DueDate;     -- Only log late payments
END;
GO