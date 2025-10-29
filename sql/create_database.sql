-- Delete the database if it already exists.
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'SKSNationalBank')
BEGIN
    ALTER DATABASE SKSNationalBank SET OFFLINE WITH ROLLBACK IMMEDIATE;
    ALTER DATABASE SKSNationalBank SET ONLINE;
    DROP DATABASE SKSNationalBank;
END

-- Create the database. 
CREATE DATABASE SKSNationalBank;
GO

USE SKSNationalBank;

-- Create all tables based on your design. 
-- Create the appropriate primary and foreign keys. 
-- Create the appropriate constraints and relationships. 
CREATE TABLE Address
(
	AddressID INT IDENTITY(1, 1) PRIMARY KEY,
	Address1 NVARCHAR(100) NOT NULL,
	Address2 NVARCHAR(100),
	City NVARCHAR(100) NOT NULL,
	Province NVARCHAR(50) NOT NULL,
	PostalCode NVARCHAR(10) NOT NULL,
)

CREATE TABLE AccountType
(
	AccountTypeID INT IDENTITY(1, 1) PRIMARY KEY,
	TypeName VARCHAR(50) NOT NULL
)

CREATE TABLE Office
(
	OfficeID INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL,
	AddressID INT NOT NULL,
	Phone NVARCHAR(20) NOT NULL,
	IsBranch BIT DEFAULT 0,
	FOREIGN KEY (AddressID) REFERENCES Address (AddressID)
)


CREATE TABLE Customer
(
	CustomerID INT IDENTITY(1, 1) PRIMARY KEY,
	FirstName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
	AddressID INT,
	Phone NVARCHAR(20) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	FOREIGN KEY (AddressID) REFERENCES Address (AddressID)
)

CREATE TABLE Employee
(
	EmployeeID INT IDENTITY(1, 1) PRIMARY KEY,
	FirstName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
	EmployeeRole NVARCHAR(20),
	ManagerID INT,
	StartDate DATETIME NOT NULL DEFAULT GETDATE(),
	AddressID INT NOT NULL,
	Phone NVARCHAR(20),
	Email NVARCHAR(100),
	FOREIGN KEY (AddressID) REFERENCES Address (AddressID),
	FOREIGN KEY (ManagerID) REFERENCES Employee (EmployeeID),
)

CREATE TABLE CustomerEmployee
(
	CustomerID INT NOT NULL,
	EmployeeID INT NOT NULL,
	FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
	FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID)
)

CREATE TABLE EmployeeOffice
(
	EmployeeID INT NOT NULL,
	OfficeID INT NOT NULL,
	FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID),
	FOREIGN KEY (OfficeID) REFERENCES Office (OfficeID)
)

CREATE TABLE OfficeManager
(
	ManagerID INT NOT NULL,
	OfficeID INT NOT NULL,
	FOREIGN KEY (ManagerID) REFERENCES Employee (EmployeeID),
	FOREIGN KEY (OfficeID) REFERENCES Office (OfficeID)
)

CREATE TABLE Account
(
	AccountID INT IDENTITY(1, 1) PRIMARY KEY,
	OfficeID INT NOT NULL,
	AccountTypeID INT NOT NULL,
	Balance MONEY DEFAULT 0,
	LastAccessed DATETIME,
	InterestRate DECIMAL(5,2) DEFAULT 0,
	CreationDate DATETIME DEFAULT GETDATE(),
	OverdraftDailyFee MONEY NOT NULL DEFAULT 10 CHECK (OverdraftDailyFee >= 0),
	FOREIGN KEY (OfficeID) REFERENCES Office (OfficeID),
	FOREIGN KEY (AccountTypeID) REFERENCES AccountType (AccountTypeID)
)

CREATE TABLE AccountOwner
(
	AccountID INT NOT NULL,
	CustomerID INT NOT NULL,
	FOREIGN KEY (AccountID) REFERENCES Account (AccountID),
	FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
)

CREATE TABLE BankTransaction
(
	TransactionID INT IDENTITY(1, 1) PRIMARY KEY,
	AccountID  INT NOT NULL,
	Amount MONEY NOT NULL,
	TransactionDate DATETIME DEFAULT GETDATE(),
	TransactionType VARCHAR(20),
	FOREIGN KEY (AccountID) REFERENCES Account (AccountID)
)

		
CREATE TABLE Overdraft
(
	OverdraftID INT IDENTITY(1, 1) PRIMARY KEY,
	TransactionID INT NOT NULL,
	OverdraftAmount MONEY NOT NULL CHECK (OverdraftAmount BETWEEN 0 AND 1000),
	FOREIGN KEY (TransactionID) REFERENCES BankTransaction (TransactionID)
)

CREATE TABLE Loan
(
	LoanID INT IDENTITY(1, 1) PRIMARY KEY,
	OfficeID INT NOT NULL,
	LoanAmount MONEY NOT NULL,
	InterestRate DECIMAL(5,2) NOT NULL,
	CreationDate DATETIME DEFAULT GETDATE(),
	DueDate DATETIME DEFAULT DATEADD(MONTH, 1, GETDATE()),
	FOREIGN KEY (OfficeID) REFERENCES Office (OfficeID)
)
		
CREATE TABLE LoanPayment
(
	LoanPaymentID INT IDENTITY(1, 1) PRIMARY KEY,
	LoanID INT NOT NULL,
	PaymentDate	DATETIME DEFAULT GETDATE(),
	AmountPaid	MONEY NOT NULL CHECK (AmountPaid > 0),
	FOREIGN KEY (LoanID) REFERENCES Loan (LoanID)
)

CREATE TABLE LoanHolder
(
	LoanID INT NOT NULL,
	CustomerID INT NOT NULL,
	FOREIGN KEY (LoanID) REFERENCES Loan (LoanID),
	FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
)