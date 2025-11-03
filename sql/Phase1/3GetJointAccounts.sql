
/* ________________________________________________________________________________
Procedure:   GetJointAccounts
Parameters:  
    @BranchID INT = NULL	Optional branch filter (NULL = all branches, or pass a specific OfficeID)
What for:    Returns all accounts that are jointly held (i.e., accounts with more than one customer), including the names of the customers.
For who:     Compliance officers, customer service, and executives who need visibility into shared accounts.
Returns:     One row per joint account, including account details, number of owners, and a concatenated list of customer names.
Sample usage:
    EXEC GetJointAccounts;             -- All branches, all joint accounts
    EXEC GetJointAccounts @BranchID=2; -- Joint accounts for Branch 2
________________________________________________________________________________ */

CREATE OR ALTER PROCEDURE GetJointAccounts
    @BranchID INT = NULL					-- optional : NULL = all office/branches, or pass a specific OfficeID
AS
BEGIN
    SELECT
        a.AccountID,
        at.TypeName AS AccountType,
        o.Name AS BranchName,
        COUNT(ao.CustomerID) AS NumberOfOwners,
        STRING_AGG(c.FirstName + ' ' + c.LastName, ', ') AS CustomerNames
    FROM Account a
    INNER JOIN AccountOwner ao ON a.AccountID = ao.AccountID
    INNER JOIN Customer c ON ao.CustomerID = c.CustomerID
    INNER JOIN AccountType at ON a.AccountTypeID = at.AccountTypeID
    INNER JOIN Office o ON a.OfficeID = o.OfficeID
    WHERE (	@BranchID IS NULL				-- if no BranchID provided = always true, meaning bring it all in
			OR o.OfficeID = @BranchID)		-- if BranchID provided, filter to only that branch
    GROUP BY a.AccountID, at.TypeName, o.Name
    HAVING COUNT(ao.CustomerID) > 1			-- only get accounts with number of owners greater than 1
    ORDER BY o.Name, a.AccountID;
END;

