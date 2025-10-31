/* ________________________________________________________________________________
Procedure:   GetCustomerLoanSummary
Parameters:
    @BranchID INT = NULL  
        Optional. If NULL, returns results for all branches; otherwise filters 
        by the specified branch OfficeID.

What for:
    Provides a detailed summary of all customer loans, including loan holders, 
    total payments, outstanding balances, and payment status.

For who:
    Bank staff, auditors, or customer service representatives who need to 
    monitor loan repayment activity and identify overdue or paid loans.

Returns:
    A detailed list of loans showing:
        - BranchName          (branch that issued the loan)
        - LoanHolders         (customers attached to the loan)
        - OriginalAmount      (total loaned amount)
        - TotalPaid           (total of all recorded payments)
        - OutstandingBalance  (remaining balance)
        - InterestRate        (loan interest rate)
        - StartDate           (loan creation date)
        - LastPaymentDate     (most recent payment date)
        - LastPaymentAmount   (amount of the latest payment)
        - PaymentStatus       (Paid / UpToDate / Overdue)

Sample usage:
    EXEC GetCustomerLoanSummary;               -- all branches
    EXEC GetCustomerLoanSummary @BranchID = 3; -- only branch #3
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE GetCustomerLoanSummary
    @BranchID INT = NULL   -- optional: NULL = all branches
AS
BEGIN
    SET NOCOUNT ON;

    /* Main query joins loan, customer, and payment data
          - Aggregates payments and combines multiple holders for shared loans*/
    SELECT 
        o.Name AS BranchName,
        l.LoanID,
        
        /* Combine all loan holders on the same loan into a single string */
        STRING_AGG(c.FirstName + ' ' + c.LastName, ', ') AS LoanHolders,
        CAST(l.LoanAmount AS NUMERIC(12,2)) AS OriginalAmount,
        CAST(ISNULL(SUM(lp.AmountPaid), 0) AS NUMERIC(12,2)) AS TotalPaid,
        CAST(l.LoanAmount - ISNULL(SUM(lp.AmountPaid), 0) AS NUMERIC(12,2)) AS OutstandingBalance,
        CAST(l.InterestRate AS NUMERIC(5,2)) AS InterestRate,
        CAST(l.CreationDate AS DATE) AS StartDate,
        CAST(MAX(lp.PaymentDate) AS DATE) AS LastPaymentDate,

        /* Retrieve the most recent payment amount */
        CAST((
            SELECT TOP 1 lp2.AmountPaid
            FROM LoanPayment lp2
            WHERE lp2.LoanID = l.LoanID
            ORDER BY lp2.PaymentDate DESC
        ) AS NUMERIC(12,2)) AS LastPaymentAmount,

        /* Determine payment status:
              - Paid: fully paid off
              - Overdue: no recent payment in >30 days
              - UpToDate: active and within 30-day window
        */
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

    /* Optional filter: limit to a specific branch if provided */
    WHERE 
        (@BranchID IS NULL OR o.OfficeID = @BranchID)

    /* Group by key loan fields to aggregate payments */
    GROUP BY 
        o.Name, l.LoanID, l.LoanAmount, l.InterestRate, l.CreationDate

    /* Sorting
          - Overdue loans appear first, followed by active, then fully paid.*/
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
