CREATE PROCEDURE CreateCustomerWithAccount
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DOB DATE,
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @AccountTypeName NVARCHAR(50), -- 'Chequing' or 'Savings'
    @InitialBalance DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Automatically select a personal banker (random)
        DECLARE @PersonalBankerID INT;
        SELECT TOP 1 @PersonalBankerID = EmployeeID
        FROM Employee
        WHERE EmployeeType = 'PersonalBanker'
        ORDER BY NEWID();

        -- 2. Insert new customer
        INSERT INTO Customer (FirstName, LastName, DOB, Email, Phone, PersonalBankerID)
        VALUES (@FirstName, @LastName, @DOB, @Email, @Phone, @PersonalBankerID);

        DECLARE @NewCustomerID INT = SCOPE_IDENTITY();

        -- 3. Get AccountTypeID from AccountType table
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
        INSERT INTO Account (CustomerID, AccountTypeID, Balance)
        VALUES (@NewCustomerID, @AccountTypeID, @InitialBalance);

        COMMIT TRANSACTION;

        SELECT 
            @NewCustomerID AS CustomerID,
            @PersonalBankerID AS PersonalBankerID,
            @AccountTypeID AS AccountTypeID;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
