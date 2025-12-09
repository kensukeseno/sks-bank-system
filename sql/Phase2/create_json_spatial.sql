/**************************************************

	DATA2201:Relational Databases-25SEPMNOS3
	GROUP B
	Andrei Laqui
	Heather Howse
	Ken Seno

****************************************************/

USE SKSNationalBank;

-- Add an error column with JSON data type to the BankTransaction table
ALTER TABLE BankTransaction ADD Error NVARCHAR(MAX);

-- Polulate the error column with sample data

-- Add insufficient funds error to TransactionID 2
UPDATE BankTransaction
SET Error = '{
  "ErrorCode": "TXN-001",
  "Message": "Insufficient funds for withdrawal.",
  "Severity": "ERROR"
}'
WHERE TransactionID = 2;

-- Account frozen
UPDATE BankTransaction
SET Error = '{
  "ErrorCode": "TXN-002",
  "Message": "Transaction rejected: account is frozen.",
  "Severity": "ERROR"
}'
WHERE TransactionID = 9;

-- Daily limit exceeded
UPDATE BankTransaction
SET Error = '{
  "ErrorCode": "TXN-004",
  "Message": "Transaction exceeds daily withdrawal limit.",
  "Severity": "ERROR"
}'
WHERE TransactionID = 27;

-- Invalid type
UPDATE BankTransaction
SET Error = '{
  "ErrorCode": "TXN-003",
  "Message": "Invalid transaction type provided.",
  "Severity": "ERROR"
}'
WHERE TransactionID = 34;

-- Add a location column to the Office table
ALTER TABLE Office ADD GeoLocation GEOGRAPHY;

-- Populate the column with sample data
UPDATE Office
SET GeoLocation = CASE 
    WHEN OfficeID = 1 THEN GEOGRAPHY::Point(43.65107, -79.347015, 4326)  -- Toronto Main Branch
    WHEN OfficeID = 2 THEN GEOGRAPHY::Point(49.2827, -123.1207, 4326)    -- Vancouver Downtown Branch
    WHEN OfficeID = 3 THEN GEOGRAPHY::Point(51.0447, -114.0719, 4326)    -- Calgary City Centre Branch
    WHEN OfficeID = 4 THEN GEOGRAPHY::Point(45.4943, -73.6164, 4326)    -- Montreal West End Branch
    WHEN OfficeID = 5 THEN GEOGRAPHY::Point(45.4345, -75.6133, 4326)    -- Ottawa East End Branch
    WHEN OfficeID = 6 THEN GEOGRAPHY::Point(49.1937, -123.1837, 4326)   -- Head Office Vancouver
    WHEN OfficeID = 8 THEN GEOGRAPHY::Point(51.0737, -114.1250, 4326)   -- Head Office Calgary
    WHEN OfficeID = 9 THEN GEOGRAPHY::Point(45.5017, -73.5673, 4326)    -- Head Office Montreal
    WHEN OfficeID = 10 THEN GEOGRAPHY::Point(45.4215, -75.6972, 4326)   -- Head Office Ottawa
END;
