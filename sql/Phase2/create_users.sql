/* Create a login and user named Ågcustomer_group_B*/
-- Create a login
CREATE LOGIN customer_group_B WITH PASSWORD = 'customer',
DEFAULT_DATABASE = SKSNationalBank;

USE SKSNationalBank;
GO

-- Create a user
CREATE USER customer_group_B;

-- Grant permissions
GRANT SELECT ON Customer TO customer_group_B;
GRANT SELECT ON Address TO customer_group_B;
GRANT SELECT ON AccountOwner TO customer_group_B;
GRANT SELECT ON Account TO customer_group_B;
GRANT SELECT ON LoanHolder TO customer_group_B;
GRANT SELECT ON Loan TO customer_group_B;
GRANT SELECT ON LoanPayment TO customer_group_B;

-- Test the enforcement of the privileges
EXECUTE AS USER = 'customer_group_B';

SELECT * FROM Customer;
SELECT * FROM Address;
SELECT * FROM AccountOwner;
SELECT * FROM Account;
SELECT * FROM LoanHolder;
SELECT * FROM Loan;
SELECT * FROM LoanPayment;

-- Go back to the original user
REVERT;
GO

-- accountant_group_B
-- Create a login
CREATE LOGIN accountant_group_B WITH PASSWORD = 'accountant',
DEFAULT_DATABASE = SKSNationalBank;

USE SKSNationalBank;
GO

/* Create a login and user named Ågaccountant_group_[?]Åh */
-- Create a user
CREATE USER accountant_group_B;

-- Grant permissions
-- Grant read operations on all tables
ALTER ROLE db_datareader ADD MEMBER accountant_group_B;
-- Grant write operations on all tables
ALTER ROLE db_datawriter ADD MEMBER accountant_group_B;
-- Remove permissions to update, insert or delete in tables that are related to accounts, payments and loans
DENY UPDATE, INSERT, DELETE
ON Account
TO accountant_group_B;
DENY UPDATE, INSERT, DELETE
ON AccountOwner
TO accountant_group_B;
DENY UPDATE, INSERT, DELETE
ON BankTransaction
TO accountant_group_B;
DENY UPDATE, INSERT, DELETE
ON Overdraft
TO accountant_group_B;
DENY UPDATE, INSERT, DELETE
ON Loan
TO accountant_group_B;
DENY UPDATE, INSERT, DELETE
ON LoanPayment
TO accountant_group_B;

-- Test the enforcement of the privileges
-- Read all the data from all the tables
EXECUTE AS USER = 'accountant_group_B';
SELECT * FROM Customer;
SELECT * FROM CustomerEmployee;
SELECT * FROM Employee;
SELECT * FROM CustomerEmployee;
SELECT * FROM Office;
SELECT * FROM EmployeeOffice;
SELECT * FROM OfficeManager;
SELECT * FROM Address;
SELECT * FROM AccountOwner;
SELECT * FROM Account;
SELECT * FROM AccountType;
SELECT * FROM BankTransaction;
SELECT * FROM Overdraft;
SELECT * FROM LoanHolder;
SELECT * FROM Loan;
SELECT * FROM LoanPayment;

-- Insert Account table
INSERT INTO Account (OfficeID, AccountTypeID, Balance, LastAccessed, InterestRate, CreationDate)
VALUES
(1, 1, 2000.00, '2025-10-10', 2.0, DATEADD(MONTH, -3, GETDATE()));
-- Insert AccountOwner table
INSERT INTO AccountOwner (AccountID, CustomerID)
VALUES
(1, 1);
-- Insert BankTransaction table
INSERT INTO BankTransaction (AccountID, Amount, TransactionDate, TransactionType)
VALUES
(1, 500.00, '2025-10-10', 'Deposit');
-- Insert Overdraft table
INSERT INTO Overdraft (TransactionID, OverdraftAmount)
VALUES
(2, 50.00);
-- Insert Loan table
INSERT INTO Loan (OfficeID, LoanAmount, InterestRate, CreationDate, DueDate)
VALUES
(1, 50000.00, 5.0, GETDATE(), DATEADD(MONTH, 1, GETDATE()));
-- Insert LoanPayment table
INSERT INTO LoanPayment (LoanID, PaymentDate, AmountPaid
VALUES
(1, '2025-10-01', 1000.00);

-- Go back to the original user
REVERT;
GO
