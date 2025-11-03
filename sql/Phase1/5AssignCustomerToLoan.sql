
/* ________________________________________________________________________________
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
