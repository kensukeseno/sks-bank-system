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