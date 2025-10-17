USE SKSNationalBank;
-- These queries were generated ChatGPT.

-- Insert Address table
INSERT INTO Address (Address1, Address2, City, Province, PostalCode)
VALUES 
('123 Maple St', 'Apt 4B', 'Toronto', 'ON', 'M5A 1B1'),
('456 Oak Rd', 'Unit 7A', 'Vancouver', 'BC', 'V6B 3M9'),
('789 Pine Ave', NULL, 'Calgary', 'AB', 'T2P 2X6'),
('101 Birch Blvd', 'Suite 200', 'Ottawa', 'ON', 'K1N 6K5'),
('202 Cedar Dr', 'Building C', 'Montreal', 'QC', 'H2X 3N5'),
('303 Elm St', 'Apt 2B', 'Edmonton', 'AB', 'T5J 1P3'),
('404 Birch St', 'Floor 3', 'Toronto', 'ON', 'M5B 2M1'),
('505 Maple Ave', 'Apt 1A', 'Vancouver', 'BC', 'V6C 1A2'),
('606 Oak Dr', 'Unit 10', 'Calgary', 'AB', 'T2G 4Y7'),
('707 Pine Blvd', 'Suite 400', 'Ottawa', 'ON', 'K2P 0J6');

-- Insert AccountType table
INSERT INTO AccountType (TypeName)
VALUES 
('Chequing'),
('Savings');

-- Insert Office table (5 branches and 5 non-branches)
INSERT INTO Office (Name, AddressID, Phone, IsBranch)
VALUES
('Toronto Main Branch', 1, '416-123-4567', 1),
('Vancouver Downtown Branch', 2, '604-234-5678', 1),
('Calgary City Centre Branch', 3, '403-345-6789', 1),
('Montreal West End Branch', 4, '514-567-8901', 1),
('Ottawa East End Branch', 5, '613-678-9012', 1),
('Head Office Toronto', 6, '416-123-6789', 0),
('Head Office Vancouver', 7, '604-234-7890', 0),
('Head Office Calgary', 8, '403-345-8901', 0),
('Head Office Montreal', 9, '514-567-9012', 0),
('Head Office Ottawa', 10, '613-678-0123', 0);

-- Insert Customer table
INSERT INTO Customer (FirstName, LastName, AddressID, Phone, Email)
VALUES
('John', 'Doe', 1, '416-555-1234', 'johndoe@email.com'),
('Jane', 'Smith', 2, '604-555-2345', 'janesmith@email.com'),
('Michael', 'Brown', 3, '403-555-3456', 'michaelbrown@email.com'),
('Emily', 'Davis', 4, '613-555-4567', 'emilydavis@email.com'),
('David', 'Wilson', 5, '514-555-5678', 'davidwilson@email.com'),
('Samantha', 'Clark', 6, '780-555-6789', 'samanthaclark@email.com'),
('Oliver', 'Martinez', 7, '416-555-7890', 'olivermartinez@email.com'),
('Ava', 'Rodriguez', 8, '604-555-8901', 'avarodriguez@email.com'),
('Liam', 'Jackson', 9, '403-555-9012', 'liamjackson@email.com'),
('Sophia', 'Lopez', 10, '613-555-0123', 'sophialopez@email.com');

-- Insert Employee table (ManagerID is nullable)
INSERT INTO Employee (FirstName, LastName, ManagerID, StartDate, AddressID, Phone, Email)
VALUES
('Alice', 'Anderson', NULL, '2025-01-10', 1, '416-555-1235', 'aliceanderson@email.com'),
('Bob', 'Taylor', 1, '2025-02-15', 2, '604-555-2346', 'bobtaylor@email.com'),
('Charlie', 'Wilson', NULL, '2025-03-20', 3, '403-555-3457', 'charliewilson@email.com'),
('Deborah', 'Martinez', 1, '2025-04-25', 4, '514-555-4568', 'deborahmartinez@email.com'),
('Ethan', 'Lewis', NULL, '2025-05-30', 5, '613-555-5679', 'ethanlewis@email.com'),
('Fiona', 'Young', 3, '2025-06-10', 6, '780-555-6780', 'fionayoung@email.com'),
('George', 'Walker', 2, '2025-07-15', 7, '416-555-7891', 'georgewalker@email.com'),
('Hannah', 'Scott', 4, '2025-08-20', 8, '604-555-8902', 'hannahscott@email.com'),
('Isla', 'Roberts', NULL, '2025-09-10', 9, '403-555-9013', 'islaroberts@email.com'),
('Jack', 'Adams', 3, '2025-09-25', 10, '613-555-0124', 'jackadams@email.com');

-- Insert CustomerEmployee table (many-to-many relationship)
INSERT INTO CustomerEmployee (CustomerID, EmployeeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), 
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Insert EmployeeOffice table (many-to-many relationship)
INSERT INTO EmployeeOffice (EmployeeID, OfficeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Insert OfficeManager table (each office has one manager)
INSERT INTO OfficeManager (ManagerID, OfficeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Insert Account table
INSERT INTO Account (OfficeID, AccountTypeID, Balance, LastAccessed, InterestRate)
VALUES
(1, 1, 2000.00, '2025-10-10', 2.0),
(2, 1, 3500.00, '2025-10-10', 1.8),
(3, 2, 5000.00, '2025-10-10', 2.2),
(4, 2, 1500.00, '2025-10-10', 1.9),
(5, 1, 3000.00, '2025-10-10', 2.0),
(6, 1, 4000.00, '2025-10-10', 1.7),
(7, 2, 2500.00, '2025-10-10', 2.3),
(8, 2, 4500.00, '2025-10-10', 1.6),
(9, 1, 6000.00, '2025-10-10', 2.5),
(10, 2, 7000.00, '2025-10-10', 1.8);

-- Insert AccountOwner table (many-to-many relationship)
INSERT INTO AccountOwner (AccountID, CustomerID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Insert BankTransaction table
INSERT INTO BankTransaction (AccountID, Amount, TransactionDate, TransactionType)
VALUES
(1, 500.00, '2025-10-10', 'Deposit'),
(2, -200.00, '2025-10-10', 'Withdrawal'),
(3, 150.00, '2025-10-10', 'Deposit'),
(4, -50.00, '2025-10-10', 'Withdrawal'),
(5, 300.00, '2025-10-10', 'Deposit'),
(6, 800.00, '2025-10-10', 'Deposit'),
(7, -100.00, '2025-10-10', 'Withdrawal'),
(8, 500.00, '2025-10-10', 'Deposit'),
(9, -400.00, '2025-10-10', 'Withdrawal'),
(10, 700.00, '2025-10-10', 'Deposit');

-- Insert Overdraft table
INSERT INTO Overdraft (TransactionID, OverdraftAmount)
VALUES
(1, 100.00),
(2, 50.00),
(3, 25.00),
(4, 75.00),
(5, 50.00),
(6, 200.00),
(7, 10.00),
(8, 150.00),
(9, 100.00),
(10, 300.00);

-- Insert Loan table
INSERT INTO Loan (OfficeID, LoanAmount, InterestRate)
VALUES
(1, 50000.00, 5.0),
(2, 20000.00, 4.5),
(3, 30000.00, 4.8),
(4, 25000.00, 4.2),
(5, 10000.00, 5.5),
(6, 15000.00, 5.0),
(7, 22000.00, 4.7),
(8, 27000.00, 4.6),
(9, 28000.00, 5.3),
(10, 35000.00, 4.9);

-- Insert LoanPayment table
INSERT INTO LoanPayment (LoanID, PaymentDate, AmountPaid)
VALUES
(1, '2025-10-01', 1000.00),
(2, '2025-10-01', 800.00),
(3, '2025-10-01', 1200.00),
(4, '2025-10-01', 700.00),
(5, '2025-10-01', 600.00),
(6, '2025-10-01', 1000.00),
(7, '2025-10-01', 1500.00),
(8, '2025-10-01', 1100.00),
(9, '2025-10-01', 1300.00),
(10, '2025-10-01', 1400.00);

-- Insert LoanHolder table
INSERT INTO LoanHolder (LoanID, CustomerID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);