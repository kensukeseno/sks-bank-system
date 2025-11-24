/* ________________________________________________________________________________

    3

Name:       trg_LateLoanPayment
Table:      LoanPayment
Event:      AFTER INSERT
What for:   Logs any late loan payment (PaymentDate later than Loan.DueDate) into the
            Audit table so staff can monitor delinquent loan accounts.
For who:    Database administrators, loan officers, managers, compliance staff.
Tracks:     LoanPaymentID, LoanID, AmountPaid, Days Late, and a descriptive summary
            of the late payment event.
Threshold:  Only triggers when the inserted payment occurs after the loan's DueDate.
Sample usage:
    INSERT INTO LoanPayment (LoanID, PaymentDate, AmountPaid)
    VALUES (30, '2025-09-10', 500.00);   -- Will be logged if past DueDate

    SELECT * FROM Audit;
________________________________________________________________________________*/


CREATE OR ALTER TRIGGER trg_LateLoanPayment
ON LoanPayment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Audit (TableName, ActionType, RecordID, ChangedBy, ChangeTime, Description)
    SELECT
        'LoanPayment',                                              
        'Late',                                                     
        i.LoanPaymentID,                                            
        SYSTEM_USER,                                                
        GETDATE(),                                                   
        CONCAT(
            'Late payment detected. LoanID: ', i.LoanID,
            ', LoanPaymentID: ', i.LoanPaymentID,
            ', AmountPaid: $', i.AmountPaid,
            ', Days Late: ', DATEDIFF(DAY, l.DueDate, i.PaymentDate)
        )                                                           
    FROM Inserted i
    INNER JOIN Loan l ON i.LoanID = l.LoanID
    WHERE i.PaymentDate > l.DueDate;     -- Only log late payments
END;
GO
