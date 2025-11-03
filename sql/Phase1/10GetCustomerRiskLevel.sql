/* ________________________________________________________________________________
Procedure:   GetCustomerRiskLevel
Parameters:
	None

What for:
    Analyzes customer financial data to identify high-risk individuals 
    based on outstanding loan balances and overdraft activity.

For who:
    Bank managers, auditors, or automated risk-assessment systems 
    monitoring potentially risky clients.

Returns:
    A ranked list of customers showing:
        - TotalOutstanding (unpaid loan balance)
        - TotalOverdraft   (total overdraft amount)
        - RiskScore        (normalized 0–100)
        - RiskCategory     (Low / Medium / High)

Sample usage:
    EXEC GetCustomerRiskLevel;
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE GetCustomerRiskLevel
AS
BEGIN
    SET NOCOUNT ON;

    /*Calculate average values
          - Used to normalize loan and overdraft amounts for scoring. */

    DECLARE @AvgLoan MONEY = ISNULL((SELECT AVG(LoanAmount) FROM Loan), 1);
    DECLARE @AvgOverdraft MONEY = ISNULL((SELECT AVG(OverdraftAmount) FROM Overdraft), 1);

    /*Calculate total outstanding loan amount per customer
          - Subtracts total payments from each loan to get remaining balance.*/

    ;WITH LoanSummary AS (
        SELECT 
            lh.CustomerID,
            SUM(l.LoanAmount - ISNULL(lp.TotalPaid, 0)) AS TotalOutstanding
        FROM LoanHolder lh
        JOIN Loan l ON lh.LoanID = l.LoanID
        OUTER APPLY (
            SELECT SUM(AmountPaid) AS TotalPaid
            FROM LoanPayment lp
            WHERE lp.LoanID = l.LoanID
        ) lp
        GROUP BY lh.CustomerID
    ),

    /*Calculate total overdraft amount per customer
          - Sums all overdraft transactions linked to the customer's accounts*/
    OverdraftSummary AS (
        SELECT 
            ao.CustomerID,
            SUM(o.OverdraftAmount) AS TotalOverdraft
        FROM AccountOwner ao
        JOIN Account a ON ao.AccountID = a.AccountID
        JOIN BankTransaction t ON t.AccountID = a.AccountID
        JOIN Overdraft o ON o.TransactionID = t.TransactionID
        GROUP BY ao.CustomerID
    )

    /*Compute risk score and category
          - Weighted average of loan and overdraft behavior:
             70% weight = loan performance
             30% weight = overdraft behavior*/
    SELECT 
        c.CustomerID,
        c.FirstName,
        c.LastName,
        ISNULL(ls.TotalOutstanding, 0) AS TotalOutstanding,
        ISNULL(os.TotalOverdraft, 0) AS TotalOverdraft,

         /* RiskScore formula (scaled 0–100) */
        CAST((
            (0.7 * (ISNULL(ls.TotalOutstanding, 0) / @AvgLoan) +
             0.3 * (ISNULL(os.TotalOverdraft, 0) / @AvgOverdraft)) * 100
        ) AS DECIMAL(5,2)) AS RiskScore,

        /* RiskCategory determined by RiskScore */
        CASE 
            WHEN (
                (0.7 * (ISNULL(ls.TotalOutstanding, 0) / @AvgLoan) +
                 0.3 * (ISNULL(os.TotalOverdraft, 0) / @AvgOverdraft)) * 100
            ) < 50 THEN 'Low Risk'
            WHEN (
                (0.7 * (ISNULL(ls.TotalOutstanding, 0) / @AvgLoan) +
                 0.3 * (ISNULL(os.TotalOverdraft, 0) / @AvgOverdraft)) * 100
            ) BETWEEN 50 AND 100 THEN 'Medium Risk'
            ELSE 'High Risk'
        END AS RiskCategory

    FROM Customer c
    LEFT JOIN LoanSummary ls ON c.CustomerID = ls.CustomerID
    LEFT JOIN OverdraftSummary os ON c.CustomerID = os.CustomerID

   -- Only include customers with any active loan or overdraft record
    WHERE ISNULL(ls.TotalOutstanding, 0) > 0 OR ISNULL(os.TotalOverdraft, 0) > 0

    -- Sort by highest-risk first
    ORDER BY RiskScore DESC;
END;
GO

