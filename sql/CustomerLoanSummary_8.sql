USE [SKSNationalBank]
GO

CREATE OR ALTER PROCEDURE GetCustomerLoanSummary
    @BranchID INT = NULL   -- optional: NULL = all branches
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        o.Name AS BranchName,
        l.LoanID,
        STRING_AGG(c.FirstName + ' ' + c.LastName, ', ') AS LoanHolders,
        CAST(l.LoanAmount AS NUMERIC(12,2)) AS OriginalAmount,
        CAST(ISNULL(SUM(lp.AmountPaid), 0) AS NUMERIC(12,2)) AS TotalPaid,
        CAST(l.LoanAmount - ISNULL(SUM(lp.AmountPaid), 0) AS NUMERIC(12,2)) AS OutstandingBalance,
        CAST(l.InterestRate AS NUMERIC(5,2)) AS InterestRate,
        CAST(l.CreationDate AS DATE) AS StartDate,
        CAST(MAX(lp.PaymentDate) AS DATE) AS LastPaymentDate,
        CAST((
            SELECT TOP 1 lp2.AmountPaid
            FROM LoanPayment lp2
            WHERE lp2.LoanID = l.LoanID
            ORDER BY lp2.PaymentDate DESC
        ) AS NUMERIC(12,2)) AS LastPaymentAmount,
        CASE 
            WHEN (l.LoanAmount - ISNULL(SUM(lp.AmountPaid), 0)) <= 0 THEN 'Paid'
            WHEN MAX(lp.PaymentDate) IS NULL 
                 AND DATEDIFF(DAY, l.CreationDate, GETDATE()) > 30 THEN 'Overdue'
            WHEN MAX(lp.PaymentDate) IS NOT NULL 
                 AND DATEDIFF(DAY, MAX(lp.PaymentDate), GETDATE()) > 30 THEN 'Overdue'
            ELSE 'UpToDate'
        END AS PaymentStatus
    FROM Loan l
    INNER JOIN LoanHolder lh ON l.LoanID = lh.LoanID
    INNER JOIN Customer c ON lh.CustomerID = c.CustomerID
    LEFT JOIN LoanPayment lp ON l.LoanID = lp.LoanID
    LEFT JOIN Office o ON l.OfficeID = o.OfficeID
    WHERE 
        (@BranchID IS NULL OR o.OfficeID = @BranchID)
    GROUP BY 
        o.Name, l.LoanID, l.LoanAmount, l.InterestRate, l.CreationDate
    ORDER BY 
        CASE 
            WHEN (l.LoanAmount - ISNULL(SUM(lp.AmountPaid), 0)) <= 0 THEN 2  -- Paid last
            WHEN MAX(lp.PaymentDate) IS NULL 
                 AND DATEDIFF(DAY, l.CreationDate, GETDATE()) > 30 THEN 0    -- Overdue first
            WHEN MAX(lp.PaymentDate) IS NOT NULL 
                 AND DATEDIFF(DAY, MAX(lp.PaymentDate), GETDATE()) > 30 THEN 0
            ELSE 1  -- UpToDate next
        END,
        o.Name, l.CreationDate;
END;
GO
