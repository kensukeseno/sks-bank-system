CREATE PROCEDURE CreateCustomerWithAccount
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

        -- 1. Select a random personal banker
        DECLARE @PersonalBankerID INT;
        SELECT TOP 1 @PersonalBankerID = EmployeeID
        FROM Employee
        WHERE EmployeeType = 'PersonalBanker'
        ORDER BY NEWID();

        -- 2. Insert new customer
        INSERT INTO Customer (FirstName, LastName, Email, Phone, PersonalBankerID)
        VALUES (@FirstName, @LastName, @Email, @Phone, @PersonalBankerID);

        DECLARE @NewCustomerID INT = SCOPE_IDENTITY();

        -- 3. Get AccountTypeID
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

        -- 4. Insert new account
        INSERT INTO Account (AccountTypeID, Balance)
        VALUES (@AccountTypeID, @InitialBalance);

        DECLARE @NewAccountID INT = SCOPE_IDENTITY();

        -- 5. Link customer and account
        INSERT INTO AccountOwner (AccountID, CustomerID)
        VALUES (@NewAccountID, @NewCustomerID);

        COMMIT TRANSACTION;

        SELECT 
            @NewCustomerID AS CustomerID,
            @PersonalBankerID AS PersonalBankerID,
            @AccountTypeID AS AccountTypeID,
            @NewAccountID AS AccountID;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
