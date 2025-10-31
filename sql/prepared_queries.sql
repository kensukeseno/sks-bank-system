/**************************************************

	DATA2201:Relational Databases-25SEPMNOS3
	GROUP B
	Andrei Laqui
	Heather Howse
	Ken Seno

****************************************************/


USE SKSNationalBank;
GO

/* ________________________________________________________________________________

	1

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
	EXEC GetBranchTotals @BranchID = 3;						Current month, Branch 9
    EXEC GetBranchTotals @MonthOffset = 1, @BranchID = 5;	Last month, Branch 5
    EXEC GetBranchTotals @MonthOffset = 2;					Two months ago, all branches
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE GetBranchTotals
    @MonthOffset INT = 0,       -- optional: 0 = current month, 1 = previous month, etc.
    @BranchID INT = NULL        -- optional : NULL = all office/branches, or pass a specific OfficeID
AS
BEGIN

	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Office WHERE OfficeID = @BranchID AND IsBranch = 1)
		BEGIN
			THROW 50001, 'Invalid OfficeID or not a branch.', 1;
		END

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
			 AND (o.IsBranch = 1)			--only include branches, not headquarters or admin office
		GROUP BY o.OfficeID, o.Name
		ORDER BY o.Name;
	END TRY

	BEGIN CATCH
		THROW;
    END CATCH

END;
GO


/* ________________________________________________________________________________

	2

Procedure:   GetCustomerSummary
Parameters:  
    @CustomerID INT		Required. The customer to summarize.
What for:    Returns a two-row summary for a specific customer: one for accounts and one for loans, each with a comma-separated list and total amount.
For who:     Executives and customer service reps who need a quick overview of a customer's financial position.
Returns:     Two rows:
             - Row 1: Account summary (AccountList, TotalBalance)
             - Row 2: Loan summary (LoanList, TotalLoanAmount)
Sample usage:
    EXEC GetCustomerSummary @CustomerID = 11;
________________________________________________________________________________ */

CREATE OR ALTER PROCEDURE GetCustomerSummary
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Row 1: Account summary
    SELECT 
        'Accounts' AS Category,
        STRING_AGG(FORMAT(a.AccountID, '00000000'), ', ') AS AccountIDList, -- STRING_AGG lists values into a string, in thsi case separated by commas
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
GO


/* ________________________________________________________________________________

	3

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
GO


/* ________________________________________________________________________________

	4

Procedure:   CreateLoanForCustomer
Parameters:
    @CustomerID   INT             Required. The customer receiving the loan
    @OfficeID     INT             Required. The branch issuing the loan
    @LoanAmount	  MONEY			  Required. The amount of the loan
    @InterestRate DECIMAL(5,2)    Required. Annual interest rate (e.g., 5.25 for 5.25%)
What for:
    Inserts a new loan into the Loan table and links it to a customer using the LoanHolder table.
For who:
    Bank employees or systems responsible for issuing loans to individual customers.
Returns:
    The new LoanID created, or a printed message if validation fails.
Sample usage:
    DECLARE @LoanID INT;
	EXEC CreateLoanForCustomer 
        @CustomerID = 11, 
        @OfficeID = 1, 
        @LoanAmount = 1000.00, 
        @InterestRate = 2.25,
		@NewLoanID = @LoanID OUTPUT;
	SELECT @LoanID as NewLoanID;
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE CreateLoanForCustomer
    @CustomerID INT,
    @OfficeID INT,
    @LoanAmount MONEY,			-- using money on simple Loan Amount is fine
    @InterestRate DECIMAL(5,2),	-- bad idea to use money, keep this as decimal
	@NewLoanID INT OUTPUT		-- newwly created Loan ID as output parameter
AS
BEGIN

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check Office
        IF NOT EXISTS (SELECT 1 FROM Office WHERE OfficeID = @OfficeID AND IsBranch = 1)
        BEGIN
            --PRINT 'Invalid OfficeID or not a branch.';
            --ROLLBACK TRANSACTION;
            --RETURN;
			THROW 50001, 'Invalid OfficeID or not a branch.', 1;
        END

        -- Check Customer
        IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            --PRINT 'Invalid CustomerID.';
            --ROLLBACK TRANSACTION;
            --RETURN;
			THROW 50002, 'Invalid CustomerID.', 2;
        END

        -- Insert Loan
        INSERT INTO Loan (OfficeID, LoanAmount, InterestRate)
        VALUES (@OfficeID, @LoanAmount, @InterestRate);

        SET @NewLoanID = SCOPE_IDENTITY(); --get the latest ID we created by the insert statement above, and keep it in @NewLoanID

        -- Link customer to loan
        INSERT INTO LoanHolder (LoanID, CustomerID)
        VALUES (@NewLoanID, @CustomerID);

        COMMIT TRANSACTION; -- success!

        PRINT 'Loan created successfully.';
    END TRY


    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        --PRINT 'An error occurred during loan creation.';
		THROW;
    END CATCH
END;
GO



/* ________________________________________________________________________________

	5

Procedure:   AssignCustomerToLoan
Parameters:
    @CustomerID INT     Required. The customer to be linked to the loan
    @LoanID     INT     Required. The existing loan to assign the customer to
What for:
    Adds a record to the LoanHolder table to associate an existing customer with an existing loan.
For who:
    Bank employees or systems responsible for managing joint loans or updating borrower records.
Returns:
    A printed message confirming success, or a message if validation fails.
Sample usage:
    EXEC AssignCustomerToLoan 
        @CustomerID = 11, 
        @LoanID = 10;
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE AssignCustomerToLoan
    @CustomerID INT,
    @LoanID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check Loan
        IF NOT EXISTS (SELECT 1 FROM Loan WHERE LoanID = @LoanID)
        BEGIN
            --PRINT 'Invalid LoanID.';
            --ROLLBACK TRANSACTION;
            --RETURN;
			THROW 50001, 'Invalid LoanID.', 1;
        END

        -- Check Customer
        IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            --PRINT 'C';
            --ROLLBACK TRANSACTION;
            --RETURN;
			THROW 50002, 'Invalid CustomerID.', 2;
        END

        -- Check for duplicate entry (same customer, same loan)
        IF EXISTS (
            SELECT 1 FROM LoanHolder 
            WHERE LoanID = @LoanID AND CustomerID = @CustomerID
        )
        BEGIN
            --PRINT 'Sorry, this customer is already assigned to the loan.';
            --ROLLBACK TRANSACTION;
            --RETURN;
			THROW 50003, 'Sorry, this customer is already assigned to the loan.', 3;
        END

        -- Insert into LoanHolder
        INSERT INTO LoanHolder (LoanID, CustomerID)
        VALUES (@LoanID, @CustomerID);

        COMMIT TRANSACTION;
        PRINT 'Customer successfully assigned to loan.';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        --PRINT 'An error occurred while assigning the customer.';
		THROW;
    END CATCH
END;
GO


/* ________________________________________________________________________________

	6

Procedure:   CreateCustomerAndAccount
Parameters:
    @FirstName NVARCHAR(50)       – Customer's first name
    @LastName NVARCHAR(50)        – Customer's last name
    @Email NVARCHAR(100)          – Customer's email address
    @Phone NVARCHAR(20)           – Customer's phone number
    @AccountTypeName NVARCHAR(50) – Account type name ('Chequing' or 'Savings')
    @InitialBalance DECIMAL(18,2) – Starting account balance
    @OfficeID INT                 – Branch office where the account is created (must be a valid branch)

What for:
    Creates a new customer record, automatically assigns them to a personal banker, 
    opens a new bank account at a specific branch, and links both records together.

For who:
    Used by bank staff or onboarding systems when registering new customers 
    and opening their first account.

Returns:
    Single row containing:
        - CustomerID
        - PersonalBankerID
        - AccountTypeID
        - AccountID
        - OfficeID

Sample usage:
    EXEC CreateCustomerAndAccount 
        @FirstName = 'Jane',
        @LastName = 'Doe',
        @Email = 'jane.doe@email.com',
        @Phone = '555-0123',
        @AccountTypeName = 'Chequing',
        @InitialBalance = 500.00,
        @OfficeID = 3;
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE CreateCustomerAndAccount
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @AccountTypeName NVARCHAR(50),
    @InitialBalance DECIMAL(18,2),
    @OfficeID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        /* Validate that the OfficeID belongs to a branch */
        IF NOT EXISTS (SELECT 1 FROM Office WHERE OfficeID = @OfficeID AND IsBranch = 1)
        BEGIN
            RAISERROR('Invalid OfficeID: must correspond to an existing branch.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* Randomly assign a Personal Banker to the new customer */
        DECLARE @PersonalBankerID INT;
        SELECT TOP 1 @PersonalBankerID = EmployeeID
        FROM Employee
        WHERE EmployeeRole = 'Personal Banker'
        ORDER BY NEWID();

        /* Create a new Customer record */
        INSERT INTO Customer (FirstName, LastName, Email, Phone)
        VALUES (@FirstName, @LastName, @Email, @Phone);

        DECLARE @NewCustomerID INT = SCOPE_IDENTITY();

        /* Retrieve the AccountTypeID based on input */
        DECLARE @AccountTypeID INT;
        SELECT @AccountTypeID = AccountTypeID
        FROM AccountType
        WHERE TypeName = @AccountTypeName;

        IF @AccountTypeID IS NULL
        BEGIN
            RAISERROR('Invalid AccountType name: %s', 16, 1, @AccountTypeName);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        /* Create a new Account assigned to the specified branch */
        INSERT INTO Account (AccountTypeID, Balance, OfficeID)
        VALUES (@AccountTypeID, @InitialBalance, @OfficeID);

        DECLARE @NewAccountID INT = SCOPE_IDENTITY();

        /* Link the Customer to the Account */
        INSERT INTO AccountOwner (AccountID, CustomerID)
        VALUES (@NewAccountID, @NewCustomerID);

        /* Commit transaction and return new record identifiers */
        COMMIT TRANSACTION;

        SELECT 
            @NewCustomerID AS CustomerID,
            @PersonalBankerID AS PersonalBankerID,
            @AccountTypeID AS AccountTypeID,
            @NewAccountID AS AccountID,
            @OfficeID AS OfficeID;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO




/* ________________________________________________________________________________

	7

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



/* ________________________________________________________________________________

	8

Procedure:   GetBankPerformanceDashboard
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
    EXEC GetBankPerformanceDashboard;
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE [dbo].[GetBankPerformanceDashboard]
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




/* ________________________________________________________________________________

	9

Procedure:   GetEmployeeSummary
Parameters:
    @BranchID INT = NULL  
        Optional. If NULL, returns results for all branches; 
        if provided, filters employees by a specific branch OfficeID.

What for:
    Summarizes employee activity, showing where they work, how many customers
    they serve, and their employee role.

For who:
    Bank managers or HR staff tracking employee workloads and branch assignments.

Returns:
    A list of employees showing:
        - EmployeeID
        - EmployeeName
        - EmployeeRole
        - BranchesWorkedAt
        - CustomersServed

Sample usage:
    EXEC GetEmployeeSummary;               -- All branches
    EXEC GetEmployeeSummary @BranchID = 2; -- Only branch #2
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE [dbo].[GetEmployeeSummary]
    @BranchID INT = NULL   -- optional: NULL = all branches
AS
BEGIN
    SET NOCOUNT ON;

    /*Main summary
       - Joins Employee, Office, and Customer relationships.
       - Aggregates customers and branches for each employee.*/
    SELECT 
        e.EmployeeID,
        e.LastName + ', ' + e.FirstName AS EmployeeName,
        e.EmployeeRole,
        STRING_AGG(o.Name, ', ') AS BranchesWorkedAt,
        COUNT(DISTINCT ce.CustomerID) AS CustomersServed

    FROM Employee e
    INNER JOIN EmployeeOffice eo ON e.EmployeeID = eo.EmployeeID
    INNER JOIN Office o ON eo.OfficeID = o.OfficeID
    LEFT JOIN CustomerEmployee ce ON e.EmployeeID = ce.EmployeeID

    /* Optional: limit by specific branch if provided */
    WHERE 
        o.IsBranch = 1
        AND (@BranchID IS NULL OR o.OfficeID = @BranchID)

    /* Group employees by ID and name to aggregate branches and customers */
    GROUP BY 
        e.EmployeeID, e.LastName, e.FirstName, e.EmployeeRole

    /* Sort by number of customers served (most active first) */
    ORDER BY 
        CustomersServed DESC, EmployeeName;
END;
GO




/* ________________________________________________________________________________

	10

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

CREATE OR ALTER PROCEDURE dbo.GetCustomerRiskLevel
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