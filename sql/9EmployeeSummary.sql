/* ________________________________________________________________________________
Procedure:   EmployeeSummary
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
    EXEC EmployeeSummary;               -- All branches
    EXEC EmployeeSummary @BranchID = 2; -- Only branch #2
________________________________________________________________________________*/

CREATE OR ALTER PROCEDURE EmployeeSummary
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

