
/* ________________________________________________________________________________
Procedure:   GetBranchTotals
Parameters:
    @MonthOffset INT = 0		Which month to report on (0 = current month, 1 = previous month, 2 = two months ago, etc.)
    @BranchID    INT = NULL		Optional branch filter (NULL = all branches, or pass a specific OfficeID)
What for:
    Returns total deposits from new accounts and total loans from new loans opened for one or all bank branches within a given month.
For who:
    Executives and branch managers who need monthly performance snapshots for decision-making, comparisons, and reporting.
Returns:
	One row per Branch, with name, ID, and  the total deposits and total loans within the month selected
Sample usage:
    EXEC GetBranchTotals 0, 3;								Current month, Branch 3
	EXEC GetBranchTotals @BranchID = 9;						Current month, Branch 9
    EXEC GetBranchTotals @MonthOffset = 1, @BranchID = 5;	Last month, Branch 5
    EXEC GetBranchTotals @MonthOffset = 2;					Two months ago, all branches
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE GetBranchTotals
    @MonthOffset INT = 0,       -- optional: 0 = current month, 1 = previous month, etc.
    @BranchID INT = NULL        -- optional : NULL = all office/branches, or pass a specific OfficeID
AS
BEGIN
    -- Calculate the start and end of the target month
    DECLARE @StartDate DATE, @EndDate DATE;
		-- Start of month = first day of current month minus n months in the past
		SET @StartDate = DATEADD(MONTH, -@MonthOffset, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));
		-- End of month = last day of that month, EOMONTH saves us from guessing 31st, 30th, 28th, 29th !super helpful!
		SET @EndDate = EOMONTH(@StartDate);

	-- from each office, get the accounts and the loans, owner doesn't matter
	-- used sum to add the balance/deposits together, and add loan amounts together
	-- used left join to let offices with no accounts nor loans on that month still appear
    SELECT 
        o.OfficeID,
        o.Name AS BranchName,
        SUM(CASE WHEN a.AccountID IS NOT NULL THEN a.Balance ELSE 0 END) AS TotalDeposits,
        SUM(CASE WHEN l.LoanID IS NOT NULL THEN l.LoanAmount ELSE 0 END) AS TotalLoans
    FROM Office o
    LEFT JOIN Account a 
        ON o.OfficeID = a.OfficeID
        AND a.CreationDate BETWEEN @StartDate AND @EndDate
    LEFT JOIN Loan l 
        ON o.OfficeID = l.OfficeID
        AND l.CreationDate BETWEEN @StartDate AND @EndDate
    WHERE (	@BranchID IS NULL			--if no BranchID provided = always true, meaning bring it all in
			OR o.OfficeID = @BranchID)  --if BranchID provided, filter to only that branch
    GROUP BY o.OfficeID, o.Name
    ORDER BY o.Name;
END;


