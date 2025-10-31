/* ________________________________________________________________________________
Procedure:   CreateCustomerAndAccount
Parameters:
    @FirstName NVARCHAR(50)       – Customer's first name
    @LastName NVARCHAR(50)        – Customer's last name
    @Email NVARCHAR(100)          – Customer's email address
    @Phone NVARCHAR(20)           – Customer's phone number
    @AccountTypeName NVARCHAR(50) – Account type name ('Chequing' or 'Savings')
    @InitialBalance DECIMAL(18,2) – Starting account balance

What for:
    Creates a new customer record, automatically assigns them to a personal banker, 
    opens a new bank account, and links both records together in the database.

For who:
    Used by bank staff or onboarding systems when registering new customers 
    and opening their first account.

Returns:
    Single row containing:
        - CustomerID
        - PersonalBankerID
        - AccountTypeID
        - AccountID

Sample usage:
    EXEC CreateCustomerWithAccount 
        @FirstName = 'Jane',
        @LastName = 'Doe',
        @Email = 'jane.doe@email.com',
        @Phone = '555-0123',
        @AccountTypeName = 'Chequing',
        @InitialBalance = 500.00;
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE CreateCustomerAndAccount
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @AccountTypeName NVARCHAR(50), -- 'Chequing' or 'Savings'
    @InitialBalance DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        /* Randomly assign a Personal Banker to the new customer*/
        DECLARE @PersonalBankerID INT;
        SELECT TOP 1 @PersonalBankerID = EmployeeID
        FROM Employee
        WHERE EmployeeRole = 'PersonalBanker'
        ORDER BY NEWID();

        /* Create a new Customer record*/
        INSERT INTO Customer (FirstName, LastName, Email, Phone)
        VALUES (@FirstName, @LastName, @Email, @Phone);

        DECLARE @NewCustomerID INT = SCOPE_IDENTITY();

        /*Retrieve the AccountTypeID from input*/
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

        /* Create a new Account for the customer*/
        INSERT INTO Account (AccountTypeID, Balance)
        VALUES (@AccountTypeID, @InitialBalance);

        DECLARE @NewAccountID INT = SCOPE_IDENTITY();

        /* Link the Customer to the Account through AccountOwner*/
        INSERT INTO AccountOwner (AccountID, CustomerID)
        VALUES (@NewAccountID, @NewCustomerID);

        /*Commit the transaction and return created IDs*/
        COMMIT TRANSACTION;

        SELECT 
            @NewCustomerID AS CustomerID,
            @PersonalBankerID AS PersonalBankerID,
            @AccountTypeID AS AccountTypeID,
            @NewAccountID AS AccountID;

    END TRY
    BEGIN CATCH
        /* Roll back and rethrow the error for debugging */
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
