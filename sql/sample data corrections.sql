--ChatGPT created sample data for reference to make corrections to the populate.sql


-- If AccountBalance or related columns are NULL
UPDATE Account 
SET Balance = 0
WHERE Balance IS NULL;

UPDATE Account 
SET InterestRate = 0
WHERE InterestRate IS NULL;

USE [SKSNationalBank];
GO

-- Add realistic many-to-many relationships between Customers and Employees
-- Some employees assist multiple customers, and some customers are assisted by multiple employees.

INSERT INTO CustomerEmployee (CustomerID, EmployeeID)
VALUES
-- Employee 1 (Alice) assists several customers
(1, 1), (2, 1), (3, 1),

-- Employee 2 (Bob) helps multiple customers including one shared with Alice
(2, 2), (3, 2), (4, 2),

-- Employee 3 (Charlie) works with several, some shared with 1 and 2
(1, 3), (4, 3), (5, 3),

-- Employee 4 (Deborah) has a few exclusive and shared customers
(5, 4), (6, 4), (3, 4),

-- Employee 5 (Ethan) handles some of the same customers as 3 and 4
(4, 5), (5, 5), (7, 5),

-- Some customers connected to multiple employees:
(1, 2),   -- Customer 1 also linked to Employee 2
(2, 3),   -- Customer 2 also linked to Employee 3
(3, 5),   -- Customer 3 also linked to Employee 5
(4, 1),   -- Customer 4 also linked to Employee 1
(5, 2),   -- Customer 5 also linked to Employee 2
(6, 1),   -- Customer 6 also linked to Employee 1
(7, 3);   -- Customer 7 also linked to Employee 3
INSERT INTO CustomerEmployee (CustomerID, EmployeeID)
VALUES
-- Secondary office assignments 
-- Employees who split time between locations
(1, 2),   -- Alice also covers Office 2
(3, 6),   -- Charlie supports Office 6
(5, 10),  -- Ethan assists Office 10 occasionally
(7, 3),   -- George works with Office 3 team
(10, 9),  -- Jack rotates between 10 and 9
(12, 5),  -- Liam supports another region
(14, 2),  -- Owen covers both 4 and 2
(16, 9),  -- Quinn helps at Office 9
(19, 7),  -- Tessa travels to 7
(21, 4),  -- Victor cross-trained at 4
(25, 6),  -- Zane provides coverage at 6
(28, 10), -- Brent splits with Office 10
(30, 8),  -- Drew also supports Office 8
(33, 1),  -- Iris does shifts at 1
(36, 5),  -- Leo rotates between 6 and 5
(38, 9);  -- Mila assists at 9

-- Add accounts to Branch 1
INSERT INTO Account (OfficeID, AccountTypeID, Balance, LastAccessed, InterestRate, CreationDate)
VALUES
(1, 1, 4000.00, DATEADD(DAY, -10, GETDATE()), 1.8, DATEADD(MONTH, -2, GETDATE())),
(1, 2, 5200.00, DATEADD(DAY, -15, GETDATE()), 2.0, DATEADD(MONTH, -1, GETDATE())),
(1, 1, 3100.00, DATEADD(DAY, -20, GETDATE()), 1.9, DATEADD(MONTH, -3, GETDATE()));

-- Add accounts to Branch 2
INSERT INTO Account (OfficeID, AccountTypeID, Balance, LastAccessed, InterestRate, CreationDate)
VALUES
(2, 1, 3500.00, DATEADD(DAY, -12, GETDATE()), 1.7, DATEADD(MONTH, -2, GETDATE())),
(2, 2, 4800.00, DATEADD(DAY, -18, GETDATE()), 2.1, DATEADD(MONTH, -1, GETDATE())),
(2, 1, 2900.00, DATEADD(DAY, -22, GETDATE()), 1.6, DATEADD(MONTH, -3, GETDATE()));

-- Add accounts to Branch 3
INSERT INTO Account (OfficeID, AccountTypeID, Balance, LastAccessed, InterestRate, CreationDate)
VALUES
(3, 1, 3600.00, DATEADD(DAY, -14, GETDATE()), 1.8, DATEADD(MONTH, -2, GETDATE())),
(3, 2, 4700.00, DATEADD(DAY, -16, GETDATE()), 2.2, DATEADD(MONTH, -1, GETDATE())),
(3, 1, 3300.00, DATEADD(DAY, -21, GETDATE()), 1.9, DATEADD(MONTH, -3, GETDATE()));



-- Insert Loan table (valid branches only)
INSERT INTO Loan (OfficeID, LoanAmount, InterestRate, CreationDate, DueDate)
VALUES
-- Branch 1
(1, 50000.00, 5.00, '2025-10-01', DATEADD(MONTH, 1, '2025-10-01')),
(1, 18000.00, 4.50, '2025-07-01', DATEADD(MONTH, 1, '2025-07-01')),
(1, 30000.00, 5.20, '2025-08-01', DATEADD(MONTH, 1, '2025-08-01')),
(1, 21000.00, 4.70, '2025-09-01', DATEADD(MONTH, 1, '2025-09-01')),

-- Branch 2
(2, 20000.00, 4.50, '2025-10-01', DATEADD(MONTH, 1, '2025-10-01')),
(2, 22000.00, 4.70, '2025-08-01', DATEADD(MONTH, 1, '2025-08-01')),
(2, 17000.00, 4.80, '2025-09-01', DATEADD(MONTH, 1, '2025-09-01')),
(2, 24000.00, 5.10, '2025-06-01', DATEADD(MONTH, 1, '2025-06-01')),

-- Branch 3
(3, 30000.00, 4.80, '2025-10-01', DATEADD(MONTH, 1, '2025-10-01')),
(3, 15000.00, 5.10, '2025-09-01', DATEADD(MONTH, 1, '2025-09-01')),
(3, 26000.00, 4.60, '2025-06-01', DATEADD(MONTH, 1, '2025-06-01')),
(3, 12000.00, 4.40, '2025-07-01', DATEADD(MONTH, 1, '2025-07-01')),

-- Branch 4
(4, 25000.00, 4.20, '2025-10-01', DATEADD(MONTH, 1, '2025-10-01')),
(4, 28000.00, 4.30, '2025-06-01', DATEADD(MONTH, 1, '2025-06-01')),
(4, 14000.00, 5.00, '2025-07-01', DATEADD(MONTH, 1, '2025-07-01')),
(4, 27000.00, 4.90, '2025-08-01', DATEADD(MONTH, 1, '2025-08-01')),

-- Branch 5
(5, 10000.00, 5.50, '2025-10-01', DATEADD(MONTH, 1, '2025-10-01')),
(5, 12500.00, 4.90, '2025-07-01', DATEADD(MONTH, 1, '2025-07-01')),
(5, 35000.00, 5.40, '2025-08-01', DATEADD(MONTH, 1, '2025-08-01')),
(5, 31000.00, 5.30, '2025-09-01', DATEADD(MONTH, 1, '2025-09-01'));


USE [SKSNationalBank];
GO

--also need to fix loans assigned to non-branch offices
--should be no NULL loan amounts, balances,  or interest rates by setting to 0
--fix account and loans assigned to non-branch offices so that they are given a conenction to a branchID and not an office taht isnt a branch.
/* ===============================================
    Verify results
   =============================================== */
-- Loan distribution by branch
SELECT OfficeID, COUNT(*) AS LoanCount
FROM Loan
GROUP BY OfficeID
ORDER BY OfficeID;

-- Account distribution by branch
SELECT OfficeID, COUNT(*) AS AccountCount, ISNULL(SUM(Balance),0) AS TotalBalance
FROM Account
GROUP BY OfficeID
ORDER BY OfficeID;
