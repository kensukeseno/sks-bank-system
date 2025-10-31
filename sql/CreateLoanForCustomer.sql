
/* ________________________________________________________________________________
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
    SET NOCOUNT ON;

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


