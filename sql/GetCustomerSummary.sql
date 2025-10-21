
/* ________________________________________________________________________________
Procedure:   GetCustomerSummary
Parameters:  
    @CustomerID INT		Required. The customer to summarize.
What for:    Returns a two-row summary for a specific customer: one for accounts and one for loans, each with a comma-separated list and total amount.
For who:     Executives and customer service reps who need a quick overview of a customer's financial position.
Returns:     Two rows:
             - Row 1: Account summary (AccountList, TotalBalance)
             - Row 2: Loan summary (LoanList, TotalLoanAmount)
Sample usage:
    EXEC GetCustomerFinancialSummary @CustomerID = 11;
________________________________________________________________________________ */

CREATE OR ALTER PROCEDURE GetCustomerSummary
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Row 1: Account summary
    SELECT 
        'Accounts' AS Category,
        STRING_AGG(FORMAT(a.AccountID, '00000000'), ', ') AS IDList, -- STRING_AGG lists values into a string, in thsi case separated by commas
        SUM(a.Balance) AS TotalAmount
    FROM AccountOwner ao
    INNER JOIN Account a ON ao.AccountID = a.AccountID
    WHERE ao.CustomerID = @CustomerID

    UNION ALL -- combine and tell SQL don't bother checking for duplicates (we know there won't be any)

    -- Row 2: Loan summary
    SELECT 
        'Loans' AS Category,
        STRING_AGG(FORMAT(l.LoanID, '00000000'), ', ') AS ItemList,
        SUM(l.LoanAmount) AS TotalAmount
    FROM LoanHolder lh
    INNER JOIN Loan l ON lh.LoanID = l.LoanID
    WHERE lh.CustomerID = @CustomerID;
END;

