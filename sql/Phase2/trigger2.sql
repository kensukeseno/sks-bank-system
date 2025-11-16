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
		INSERT INTO Audit (TableName, ActionType, RecordID, Description)
		SELECT
				'Employee',
				'UPDATE',
				i.EmployeeID,
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





