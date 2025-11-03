/* ________________________________________________________________________________
Procedure:   BankPerformanceDashboard
Parameters:
    None

What for:
    Provides a summary of key financial metrics for each branch office, 
    including deposit totals, loan totals, and the loan-to-deposit ratio (LDR).

For who:
    Bank executives, analysts, or performance dashboards that monitor 
    the overall health and activity levels of each branch.

Returns:
    A list of branches showing:
        - TotalAccounts   (number of active accounts)
        - TotalDeposits   (sum of all account balances)
        - TotalLoans      (number of issued loans)
        - TotalLoanAmount (sum of all loan amounts)
        - LDR (%)         (Loan-to-Deposit Ratio, a key performance metric)

Sample usage:
    EXEC BankPerformanceDashboard;
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE BankPerformanceDashboard
AS
BEGIN
    SET NOCOUNT ON;

    /* Aggregate key metrics per branch
          - Counts unique accounts and loans by branch.
          - Calculates total deposits and total loan amounts*/
    SELECT 
        o.OfficeID,
        o.Name AS BranchName,

        COUNT(DISTINCT a.AccountID) AS TotalAccounts,
        SUM(a.Balance) AS TotalDeposits,
        COUNT(DISTINCT l.LoanID) AS TotalLoans,
        SUM(l.LoanAmount) AS TotalLoanAmount,

        /* Loan-to-Deposit Ratio (LDR)
              - A key metric that compares total loans to total deposits.
              - Expressed as a percentage; NULL if no deposits exist*/
        CAST(
            CASE 
                WHEN SUM(a.Balance) = 0 THEN NULL
                ELSE (SUM(l.LoanAmount) / SUM(a.Balance)) * 100
            END AS DECIMAL(10,2)
        ) AS [LDR (%)]  -- Loan-to-deposit ratio as a percentage

    FROM Office o
    LEFT JOIN Account a 
        ON o.OfficeID = a.OfficeID
    LEFT JOIN Loan l 
        ON o.OfficeID = l.OfficeID

    /* Only include offices that are active branches (exclude HQ or admin) */
    WHERE o.IsBranch = 1
    GROUP BY o.OfficeID, o.Name
    ORDER BY o.OfficeID;
END;
GO


