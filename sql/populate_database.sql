USE SKSNationalBank;
-- These queries were generated ChatGPT, expanded using Copilot AI.


-- Insert Address table
INSERT INTO Address (Address1, Address2, City, Province, PostalCode)
VALUES 
('123 Maple St', 'Apt 4B', 'Toronto', 'ON', 'M5A 1B1'),
('456 Oak Rd', 'Unit 7A', 'Vancouver', 'BC', 'V6B 3M9'),
('789 Pine Ave', NULL, 'Calgary', 'AB', 'T2P 2X6'),
('101 Birch Blvd', 'Suite 200', 'Ottawa', 'ON', 'K1N 6K5'),
('202 Cedar Dr', 'Building C', 'Montreal', 'QC', 'H2X 3N5'),
('303 Elm St', 'Apt 2B', 'Edmonton', 'AB', 'T5J 1P3'),
('404 Birch St', 'Floor 3', 'Toronto', 'ON', 'M5B 2M1'),
('505 Maple Ave', 'Apt 1A', 'Vancouver', 'BC', 'V6C 1A2'),
('606 Oak Dr', 'Unit 10', 'Calgary', 'AB', 'T2G 4Y7'),
('707 Pine Blvd', 'Suite 400', 'Ottawa', 'ON', 'K2P 0J6'),
('808 Spruce Ct', NULL, 'Halifax', 'NS', 'B3H 1Z1'),
('909 Willow Way', 'Unit 12', 'Winnipeg', 'MB', 'R3C 2E7'),
('111 Aspen Ln', 'Suite 5', 'Regina', 'SK', 'S4P 3X3'),
('222 Sequoia St', NULL, 'Saskatoon', 'SK', 'S7K 4B2'),
('333 Cypress Blvd', 'Apt 9', 'Victoria', 'BC', 'V8W 2Y2'),
('444 Redwood Rd', 'Building A', 'Quebec City', 'QC', 'G1R 5M3'),
('555 Poplar Pl', NULL, 'Hamilton', 'ON', 'L8P 1A1'),
('666 Magnolia Dr', 'Unit 3', 'London', 'ON', 'N6A 4L6'),
('777 Dogwood Ave', 'Suite 10', 'Kitchener', 'ON', 'N2G 3W8'),
('888 Alder Ct', NULL, 'Brampton', 'ON', 'L6Y 1G3'),
('999 Juniper Blvd', 'Apt 2', 'Mississauga', 'ON', 'L5B 2T3'),
('121 Fir St', NULL, 'Surrey', 'BC', 'V3T 1V8'),
('242 Larch Rd', 'Unit 6', 'Burnaby', 'BC', 'V5H 3Z7'),
('363 Chestnut Ave', 'Suite 7', 'Richmond', 'BC', 'V6X 2A9'),
('484 Mapleleaf Ln', 'Floor 2', 'Saint John', 'NB', 'E2L 2B3'),
('515 Beech Dr', NULL, 'Moncton', 'NB', 'E1C 1Y2'),
('646 Pinecrest Ct', 'Unit 11', 'Charlottetown', 'PE', 'C1A 2P3'),
('777 Tamarack Blvd', NULL, 'St. Johns', 'NL', 'A1C 3Y2'),
('888 Hawthorn Rd', 'Apt 8', 'Red Deer', 'AB', 'T4N 1B3'),
('909 Cottonwood Way', 'Unit 2', 'Medicine Hat', 'AB', 'T1A 1S6'),
('1010 Alderwood Pl', NULL, 'Lethbridge', 'AB', 'T1J 2B4'),
('1111 Bayshore Dr', 'Suite 14', 'Kelowna', 'BC', 'V1Y 1J3'),
('1212 Lakeside Ave', 'Unit 4', 'Nanaimo', 'BC', 'V9R 5B6'),
('1313 Riverbend Rd', NULL, 'Thunder Bay', 'ON', 'P7B 2H7'),
('1414 Prairie Ln', 'Apt 3', 'Sarnia', 'ON', 'N7T 2K9'),
('1515 Hillcrest Ct', NULL, 'Sudbury', 'ON', 'P3E 3L1'),
('1616 Meadow Dr', 'Unit 5', 'Guelph', 'ON', 'N1H 4G7'),
('1717 Valley Rd', 'Suite 9', 'Barrie', 'ON', 'L4N 2R6'),
('1818 Summit Ave', NULL, 'Oshawa', 'ON', 'L1H 2K5'),
('1919 Parkview Blvd', 'Apt 2', 'Windsor', 'ON', 'N9A 3S5');

-- Insert AccountType table
INSERT INTO AccountType (TypeName)
VALUES 
('Chequing'),
('Savings');

-- Insert Office table (5 branches and 5 non-branches)
INSERT INTO Office (Name, AddressID, Phone, IsBranch)
VALUES
('Toronto Main Branch', 1, '416-123-4567', 1),
('Vancouver Downtown Branch', 2, '604-234-5678', 1),
('Calgary City Centre Branch', 3, '403-345-6789', 1),
('Montreal West End Branch', 4, '514-567-8901', 1),
('Ottawa East End Branch', 5, '613-678-9012', 1),
('Head Office Toronto', 6, '416-123-6789', 0),
('Head Office Vancouver', 7, '604-234-7890', 0),
('Head Office Calgary', 8, '403-345-8901', 0),
('Head Office Montreal', 9, '514-567-9012', 0),
('Head Office Ottawa', 10, '613-678-0123', 0);

-- Insert Customer table
INSERT INTO Customer (FirstName, LastName, AddressID, Phone, Email)
VALUES
('John', 'Doe', 1, '416-555-1234', 'johndoe@email.com'),
('Jane', 'Smith', 2, '604-555-2345', 'janesmith@email.com'),
('Michael', 'Brown', 3, '403-555-3456', 'michaelbrown@email.com'),
('Emily', 'Davis', 4, '613-555-4567', 'emilydavis@email.com'),
('David', 'Wilson', 5, '514-555-5678', 'davidwilson@email.com'),
('Samantha', 'Clark', 6, '780-555-6789', 'samanthaclark@email.com'),
('Oliver', 'Martinez', 7, '416-555-7890', 'olivermartinez@email.com'),
('Ava', 'Rodriguez', 8, '604-555-8901', 'avarodriguez@email.com'),
('Liam', 'Jackson', 9, '403-555-9012', 'liamjackson@email.com'),
('Sophia', 'Lopez', 10, '613-555-0123', 'sophialopez@email.com'),
('Noah', 'Hughes', 11, '902-555-1100', 'noah.hughes@email.com'),
('Mia', 'Nguyen', 12, '204-555-1200', 'mia.nguyen@email.com'),
('Ethan', 'Patel', 13, '306-555-1300', 'ethan.patel@email.com'),
('Olivia', 'Kim', 14, '306-555-1400', 'olivia.kim@email.com'),
('Aiden', 'Chen', 15, '250-555-1500', 'aiden.chen@email.com'),
('Sophia', 'Bennett', 16, '418-555-1600', 'sophia.bennett@email.com'),
('Lucas', 'Graham', 17, '905-555-1700', 'lucas.graham@email.com'),
('Amelia', 'Singh', 18, '519-555-1800', 'amelia.singh@email.com'),
('James', 'Wright', 19, '403-555-1900', 'james.wright@email.com'),
('Charlotte', 'Perez', 20, '403-555-2000', 'charlotte.perez@email.com'),
('Benjamin', 'Ali', 21, '403-555-2100', 'benjamin.ali@email.com'),
('Harper', 'Khan', 22, '250-555-2200', 'harper.khan@email.com'),
('Alexander', 'Green', 23, '604-555-2300', 'alexander.green@email.com'),
('Ella', 'Ramirez', 24, '604-555-2400', 'ella.ramirez@email.com'),
('Michael', 'Cook', 25, '807-555-2500', 'michael.cook@email.com'),
('Avery', 'Foster', 26, '519-555-2600', 'avery.foster@email.com'),
('Logan', 'Ward', 27, '519-555-2700', 'logan.ward@email.com'),
('Abigail', 'Murphy', 28, '705-555-2800', 'abigail.murphy@email.com'),
('Daniel', 'Rivera', 29, '905-555-2900', 'daniel.rivera@email.com'),
('Grace', 'Bailey', 30, '905-555-3000', 'grace.bailey@email.com'),
('Henry', 'Cooper', 31, '403-555-3100', 'henry.cooper@email.com'),
('Chloe', 'Diaz', 32, '250-555-3200', 'chloe.diaz@email.com'),
('Jackson', 'Reed', 33, '604-555-3300', 'jackson.reed@email.com'),
('Luna', 'James', 34, '604-555-3400', 'luna.james@email.com'),
('Sebastian', 'Brooks', 35, '705-555-3500', 'sebastian.brooks@email.com'),
('Aria', 'Russell', 36, '705-555-3600', 'aria.russell@email.com'),
('Mateo', 'Griffin', 37, '519-555-3700', 'mateo.griffin@email.com'),
('Scarlett', 'Hayes', 38, '905-555-3800', 'scarlett.hayes@email.com'),
('Jack', 'Long', 39, '905-555-3900', 'jack.long@email.com'),
('Victoria', 'Ross', 40, '519-555-4000', 'victoria.ross@email.com');

-- Insert Employee table (ManagerID is nullable)
INSERT INTO Employee (FirstName, LastName, ManagerID, StartDate, AddressID, Phone, Email)
VALUES
('Alice', 'Anderson', NULL, '2025-01-10', 1, '416-555-1235', 'aliceanderson@email.com'),
('Bob', 'Taylor', 1, '2025-02-15', 2, '604-555-2346', 'bobtaylor@email.com'),
('Charlie', 'Wilson', NULL, '2025-03-20', 3, '403-555-3457', 'charliewilson@email.com'),
('Deborah', 'Martinez', 1, '2025-04-25', 4, '514-555-4568', 'deborahmartinez@email.com'),
('Ethan', 'Lewis', NULL, '2025-05-30', 5, '613-555-5679', 'ethanlewis@email.com'),
('Fiona', 'Young', 3, '2025-06-10', 6, '780-555-6780', 'fionayoung@email.com'),
('George', 'Walker', 2, '2025-07-15', 7, '416-555-7891', 'georgewalker@email.com'),
('Hannah', 'Scott', 4, '2025-08-20', 8, '604-555-8902', 'hannahscott@email.com'),
('Isla', 'Roberts', NULL, '2025-09-10', 9, '403-555-9013', 'islaroberts@email.com'),
('Jack', 'Adams', 3, '2025-09-25', 10, '613-555-0124', 'jackadams@email.com'),
('Karen', 'Ng', 1, DATEADD(DAY, -120, GETDATE()), 11, '416-555-2231', 'karen.ng@email.com'),
('Liam', 'Ford', 1, DATEADD(DAY, -115, GETDATE()), 12, '604-555-2232', 'liam.ford@email.com'),
('Nora', 'Chavez', 3, DATEADD(DAY, -110, GETDATE()), 13, '403-555-2233', 'nora.chavez@email.com'),
('Owen', 'Lam', 3, DATEADD(DAY, -105, GETDATE()), 14, '514-555-2234', 'owen.lam@email.com'),
('Piper', 'Singh', NULL, DATEADD(DAY, -100, GETDATE()), 15, '613-555-2235', 'piper.singh@email.com'),
('Quinn', 'Harper', 5, DATEADD(DAY, -95, GETDATE()), 16, '780-555-2236', 'quinn.harper@email.com'),
('Riley', 'Stone', 2, DATEADD(DAY, -90, GETDATE()), 17, '416-555-2237', 'riley.stone@email.com'),
('Seth', 'Powell', 4, DATEADD(DAY, -85, GETDATE()), 18, '604-555-2238', 'seth.powell@email.com'),
('Tessa', 'Ward', 4, DATEADD(DAY, -80, GETDATE()), 19, '403-555-2239', 'tessa.ward@email.com'),
('Uma', 'Kaur', NULL, DATEADD(DAY, -75, GETDATE()), 20, '613-555-2240', 'uma.kaur@email.com'),
('Victor', 'Roy', 6, DATEADD(DAY, -70, GETDATE()), 21, '403-555-2241', 'victor.roy@email.com'),
('Wendy', 'Park', 6, DATEADD(DAY, -65, GETDATE()), 22, '250-555-2242', 'wendy.park@email.com'),
('Xavier', 'Bell', 7, DATEADD(DAY, -60, GETDATE()), 23, '604-555-2243', 'xavier.bell@email.com'),
('Yara', 'Quinn', 7, DATEADD(DAY, -55, GETDATE()), 24, '604-555-2244', 'yara.quinn@email.com'),
('Zane', 'Abbott', NULL, DATEADD(DAY, -50, GETDATE()), 25, '807-555-2245', 'zane.abbott@email.com'),
('Amy', 'Cole', 8, DATEADD(DAY, -45, GETDATE()), 26, '519-555-2246', 'amy.cole@email.com'),
('Brent', 'Fox', 8, DATEADD(DAY, -40, GETDATE()), 27, '519-555-2247', 'brent.fox@email.com'),
('Cara', 'Gates', 9, DATEADD(DAY, -35, GETDATE()), 28, '705-555-2248', 'cara.gates@email.com'),
('Drew', 'Hunt', 9, DATEADD(DAY, -30, GETDATE()), 29, '905-555-2249', 'drew.hunt@email.com'),
('Eve', 'Irwin', NULL, DATEADD(DAY, -25, GETDATE()), 30, '905-555-2250', 'eve.irwin@email.com'),
('Finn', 'Jade', 10, DATEADD(DAY, -22, GETDATE()), 31, '403-555-2251', 'finn.jade@email.com'),
('Gia', 'Keane', 10, DATEADD(DAY, -19, GETDATE()), 32, '250-555-2252', 'gia.keane@email.com'),
('Hugo', 'Lane', 2, DATEADD(DAY, -16, GETDATE()), 33, '604-555-2253', 'hugo.lane@email.com'),
('Iris', 'Moss', 3, DATEADD(DAY, -13, GETDATE()), 34, '604-555-2254', 'iris.moss@email.com'),
('Jules', 'Nolan', 4, DATEADD(DAY, -10, GETDATE()), 35, '705-555-2255', 'jules.nolan@email.com'),
('Kira', 'Ortiz', 5, DATEADD(DAY, -7, GETDATE()), 36, '705-555-2256', 'kira.ortiz@email.com'),
('Leo', 'Price', 6, DATEADD(DAY, -5, GETDATE()), 37, '519-555-2257', 'leo.price@email.com'),
('Mila', 'Queen', 7, DATEADD(DAY, -3, GETDATE()), 38, '905-555-2258', 'mila.queen@email.com'),
('Nate', 'Reese', 8, GETDATE(), 39, '905-555-2259', 'nate.reese@email.com'),
('Opal', 'Shaw', 9, GETDATE(), 40, '519-555-2260', 'opal.shaw@email.com');

-- Insert CustomerEmployee table (many-to-many relationship)
INSERT INTO CustomerEmployee (CustomerID, EmployeeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), 
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15),
(16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25),
(26, 26), (27, 27), (28, 28), (29, 29), (30, 30),
(31, 31), (32, 32), (33, 33), (34, 34), (35, 35),
(36, 36), (37, 37), (38, 38), (39, 39), (40, 40);

-- Insert EmployeeOffice table (many-to-many relationship)
INSERT INTO EmployeeOffice (EmployeeID, OfficeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 1), (12, 2), (13, 3), (14, 4), (15, 5),
(16, 6), (17, 7), (18, 8), (19, 9), (20, 10),
(21, 1), (22, 2), (23, 3), (24, 4), (25, 5),
(26, 6), (27, 7), (28, 8), (29, 9), (30, 10),
(31, 1), (32, 2), (33, 3), (34, 4), (35, 5),
(36, 6), (37, 7), (38, 8), (39, 9), (40, 10);

-- Insert OfficeManager table (each office has one manager)
INSERT INTO OfficeManager (ManagerID, OfficeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 1), (12, 2), (13, 3), (14, 4), (15, 5),
(16, 6), (17, 7), (18, 8), (19, 9), (20, 10);

-- Insert Account table
INSERT INTO Account (OfficeID, AccountTypeID, Balance, LastAccessed, InterestRate, CreationDate)
VALUES
(1, 1, 2000.00, '2025-10-10', 2.0, DATEADD(MONTH, -3, GETDATE())),
(2, 1, 3500.00, '2025-10-10', 1.8, DATEADD(MONTH, -1, GETDATE())),
(3, 2, 5000.00, '2025-10-10', 2.2, DATEADD(MONTH, -2, GETDATE())),
(4, 2, 1500.00, '2025-10-10', 1.9, DATEADD(MONTH, -3, GETDATE())),
(5, 1, 3000.00, '2025-10-10', 2.0, DATEADD(MONTH, -1, GETDATE())),
(6, 1, 4000.00, '2025-10-10', 1.7, DATEADD(MONTH, -3, GETDATE())),
(7, 2, 2500.00, '2025-10-10', 2.3, DATEADD(MONTH, -4, GETDATE())),
(8, 2, 4500.00, '2025-10-10', 1.6, DATEADD(MONTH, -1, GETDATE())),
(9, 1, 6000.00, '2025-10-10', 2.5, GETDATE()),
(10, 2, 7000.00, '2025-10-10', 1.8, GETDATE()),
(1, 1, 1800.00, DATEADD(DAY, -3, GETDATE()), 1.50, DATEADD(MONTH, -3, GETDATE())),
(1, 2, 5200.00, DATEADD(DAY, -5, GETDATE()), 2.10, DATEADD(MONTH, -2, GETDATE())),
(2, 1, 2300.00, DATEADD(DAY, -7, GETDATE()), 1.70, DATEADD(MONTH, -1, GETDATE())),
(2, 2, 4100.00, DATEADD(DAY, -9, GETDATE()), 2.30, DATEADD(MONTH, -4, GETDATE())),
(3, 1, 1250.00, DATEADD(DAY, -11, GETDATE()), 1.60, DATEADD(MONTH, -3, GETDATE())),
(3, 2, 6800.00, DATEADD(DAY, -13, GETDATE()), 2.40, DATEADD(MONTH, -2, GETDATE())),
(4, 1, 2950.00, DATEADD(DAY, -15, GETDATE()), 1.80, DATEADD(MONTH, -1, GETDATE())),
(4, 2, 3700.00, DATEADD(DAY, -17, GETDATE()), 2.20, DATEADD(MONTH, -4, GETDATE())),
(5, 1, 4550.00, DATEADD(DAY, -19, GETDATE()), 1.90, DATEADD(MONTH, -3, GETDATE())),
(5, 2, 2150.00, DATEADD(DAY, -21, GETDATE()), 2.00, DATEADD(MONTH, -2, GETDATE())),
(1, 1, 3400.00, DATEADD(DAY, -23, GETDATE()), 1.70, DATEADD(MONTH, -1, GETDATE())),
(2, 2, 7200.00, DATEADD(DAY, -25, GETDATE()), 2.50, DATEADD(MONTH, -4, GETDATE())),
(3, 1, 900.00,  DATEADD(DAY, -27, GETDATE()), 1.40, DATEADD(MONTH, -3, GETDATE())),
(4, 2, 5600.00, DATEADD(DAY, -29, GETDATE()), 2.10, DATEADD(MONTH, -2, GETDATE())),
(5, 1, 3100.00, DATEADD(DAY, -31, GETDATE()), 1.80, DATEADD(MONTH, -1, GETDATE())),
(1, 2, 2600.00, DATEADD(DAY, -33, GETDATE()), 2.20, DATEADD(MONTH, -4, GETDATE())),
(2, 1, 1700.00, DATEADD(DAY, -35, GETDATE()), 1.50, DATEADD(MONTH, -3, GETDATE())),
(3, 2, 6400.00, DATEADD(DAY, -37, GETDATE()), 2.30, DATEADD(MONTH, -2, GETDATE())),
(4, 1, 1200.00, DATEADD(DAY, -39, GETDATE()), 1.60, DATEADD(MONTH, -1, GETDATE())),
(5, 2, 4800.00, DATEADD(DAY, -41, GETDATE()), 2.40, DATEADD(MONTH, -4, GETDATE())),
(1, 1, 2000.00, DATEADD(DAY, -43, GETDATE()), 1.70, DATEADD(MONTH, -3, GETDATE())),
(2, 2, 3300.00, DATEADD(DAY, -45, GETDATE()), 2.10, DATEADD(MONTH, -2, GETDATE())),
(3, 1, 1500.00, DATEADD(DAY, -47, GETDATE()), 1.80, DATEADD(MONTH, -1, GETDATE())),
(4, 2, 7000.00, DATEADD(DAY, -49, GETDATE()), 2.50, DATEADD(MONTH, -4, GETDATE())),
(5, 1, 2400.00, DATEADD(DAY, -51, GETDATE()), 1.90, DATEADD(MONTH, -3, GETDATE())),
(1, 2, 5300.00, DATEADD(DAY, -53, GETDATE()), 2.30, DATEADD(MONTH, -2, GETDATE())),
(2, 1, 1100.00, DATEADD(DAY, -55, GETDATE()), 1.40, DATEADD(MONTH, -1, GETDATE())),
(3, 2, 6200.00, DATEADD(DAY, -57, GETDATE()), 2.20, DATEADD(MONTH, -4, GETDATE())),
(4, 1, 1800.00, DATEADD(DAY, -59, GETDATE()), 1.60, DATEADD(MONTH, -3, GETDATE()));

-- Insert AccountOwner table (many-to-many relationship)
INSERT INTO AccountOwner (AccountID, CustomerID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15),
(16, 16), (17, 17), (18, 18), (19, 19), (20, 20);

-- Joint owners (2 owners)
INSERT INTO AccountOwner (AccountID, CustomerID)
VALUES
(21, 21), (21, 22),
(22, 23), (22, 24),
(23, 25), (23, 26),
(24, 27), (24, 28),
(25, 29), (25, 30),
(26, 31), (26, 32),
(27, 33), (27, 34),
(28, 35), (28, 36),
(29, 37), (29, 38),
(30, 39), (30, 40);

-- Some triple owners for variety
INSERT INTO AccountOwner (AccountID, CustomerID)
VALUES
(31, 11), (31, 12), (31, 13),
(32, 14), (32, 15), (32, 16),
(33, 17), (33, 18), (33, 19),
(34, 20), (34, 21), (34, 22),
(35, 23), (35, 24), (35, 25);


-- Insert Loan table
INSERT INTO Loan (OfficeID, LoanAmount, InterestRate, CreationDate)
VALUES
(1, 50000.00, 5.0, GETDATE()),
(2, 20000.00, 4.5, GETDATE()),
(3, 30000.00, 4.8, GETDATE()),
(4, 25000.00, 4.2, GETDATE()),
(5, 10000.00, 5.5, GETDATE()),
(6, 15000.00, 5.0, GETDATE()),
(7, 22000.00, 4.7, GETDATE()),
(8, 27000.00, 4.6, GETDATE()),
(9, 28000.00, 5.3, GETDATE()),
(10, 35000.00, 4.9, GETDATE()),
(1, 18000.00, 4.50, DATEADD(MONTH, -3, GETDATE())),
(2, 22000.00, 4.70, DATEADD(MONTH, -2, GETDATE())),
(3, 15000.00, 5.10, DATEADD(MONTH, -1, GETDATE())),
(4, 28000.00, 4.30, DATEADD(MONTH, -4, GETDATE())),
(5, 12500.00, 4.90, DATEADD(MONTH, -3, GETDATE())),
(1, 30000.00, 5.20, DATEADD(MONTH, -2, GETDATE())),
(2, 17000.00, 4.80, DATEADD(MONTH, -1, GETDATE())),
(3, 26000.00, 4.60, DATEADD(MONTH, -4, GETDATE())),
(4, 14000.00, 5.00, DATEADD(MONTH, -3, GETDATE())),
(5, 35000.00, 5.40, DATEADD(MONTH, -2, GETDATE())),
(1, 21000.00, 4.70, DATEADD(MONTH, -1, GETDATE())),
(2, 24000.00, 5.10, DATEADD(MONTH, -4, GETDATE())),
(3, 12000.00, 4.40, DATEADD(MONTH, -3, GETDATE())),
(4, 27000.00, 4.90, DATEADD(MONTH, -2, GETDATE())),
(5, 31000.00, 5.30, DATEADD(MONTH, -1, GETDATE())),
(1, 16000.00, 4.20, DATEADD(MONTH, -4, GETDATE())),
(2, 19500.00, 4.55, DATEADD(MONTH, -3, GETDATE())),
(3, 22000.00, 4.75, DATEADD(MONTH, -2, GETDATE())),
(4, 24500.00, 5.05, DATEADD(MONTH, -1, GETDATE())),
(5, 33000.00, 5.25, DATEADD(MONTH, -4, GETDATE())),
(1, 28500.00, 4.65, DATEADD(MONTH, -3, GETDATE())),
(2, 15500.00, 4.85, DATEADD(MONTH, -2, GETDATE())),
(3, 27500.00, 5.15, DATEADD(MONTH, -1, GETDATE())),
(4, 13500.00, 4.35, DATEADD(MONTH, -4, GETDATE())),
(5, 20000.00, 4.95, DATEADD(MONTH, -3, GETDATE())),
(1, 32000.00, 5.35, DATEADD(MONTH, -2, GETDATE())),
(2, 14500.00, 4.45, DATEADD(MONTH, -1, GETDATE())),
(3, 18500.00, 4.65, DATEADD(MONTH, -4, GETDATE())),
(4, 29500.00, 4.85, DATEADD(MONTH, -3, GETDATE())),
(5, 25000.00, 5.05, DATEADD(MONTH, -2, GETDATE()));

-- Insert LoanHolder table
INSERT INTO LoanHolder (LoanID, CustomerID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15),
(16, 16), (17, 17), (18, 18), (19, 19), (20, 20);

-- Joint holders (2 customers)
INSERT INTO LoanHolder (LoanID, CustomerID)
VALUES
(21, 21), (21, 22),
(22, 23), (22, 24),
(23, 25), (23, 26),
(24, 27), (24, 28),
(25, 29), (25, 30),
(26, 31), (26, 32),
(27, 33), (27, 34),
(28, 35), (28, 36),
(29, 37), (29, 38),
(30, 39), (30, 40);

-- Triple holders for richness
INSERT INTO LoanHolder (LoanID, CustomerID)
VALUES
(31, 11), (31, 12), (31, 13),
(32, 14), (32, 15), (32, 16),
(33, 17), (33, 18), (33, 19),
(34, 20), (34, 21), (34, 22),
(35, 23), (35, 24), (35, 25);

-- Insert BankTransaction table
INSERT INTO BankTransaction (AccountID, Amount, TransactionDate, TransactionType)
VALUES
(1, 500.00, '2025-10-10', 'Deposit'),
(2, -200.00, '2025-10-10', 'Withdrawal'),
(3, 150.00, '2025-10-10', 'Deposit'),
(4, -50.00, '2025-10-10', 'Withdrawal'),
(5, 300.00, '2025-10-10', 'Deposit'),
(6, 800.00, '2025-10-10', 'Deposit'),
(7, -100.00, '2025-10-10', 'Withdrawal'),
(8, 500.00, '2025-10-10', 'Deposit'),
(9, -400.00, '2025-10-10', 'Withdrawal'),
(10, 700.00, '2025-10-10', 'Deposit'),
(11, 300.00, DATEADD(DAY, -2, GETDATE()), 'Deposit'),
(12, -150.00, DATEADD(DAY, -3, GETDATE()), 'Withdrawal'),
(13, 200.00, DATEADD(DAY, -5, GETDATE()), 'Deposit'),
(14, -80.00, DATEADD(DAY, -7, GETDATE()), 'Withdrawal'),
(15, 450.00, DATEADD(DAY, -9, GETDATE()), 'Deposit'),
(16, 500.00, DATEADD(DAY, -12, GETDATE()), 'Deposit'),
(17, -120.00, DATEADD(DAY, -14, GETDATE()), 'Withdrawal'),
(18, 600.00, DATEADD(DAY, -16, GETDATE()), 'Deposit'),
(19, -90.00, DATEADD(DAY, -18, GETDATE()), 'Withdrawal'),
(20, 700.00, DATEADD(DAY, -20, GETDATE()), 'Deposit'),
(21, 250.00, DATEADD(DAY, -22, GETDATE()), 'Deposit'),
(22, -200.00, DATEADD(DAY, -24, GETDATE()), 'Withdrawal'),
(23, 350.00, DATEADD(DAY, -26, GETDATE()), 'Deposit'),
(24, -60.00, DATEADD(DAY, -28, GETDATE()), 'Withdrawal'),
(25, 500.00, DATEADD(DAY, -30, GETDATE()), 'Deposit'),
(26, 400.00, DATEADD(DAY, -33, GETDATE()), 'Deposit'),
(27, -150.00, DATEADD(DAY, -35, GETDATE()), 'Withdrawal'),
(28, 550.00, DATEADD(DAY, -37, GETDATE()), 'Deposit'),
(29, -70.00, DATEADD(DAY, -39, GETDATE()), 'Withdrawal'),
(30, 800.00, DATEADD(DAY, -41, GETDATE()), 'Deposit'),
(31, 600.00, DATEADD(DAY, -43, GETDATE()), 'Deposit'),
(32, -300.00, DATEADD(DAY, -45, GETDATE()), 'Withdrawal'),
(33, 450.00, DATEADD(DAY, -47, GETDATE()), 'Deposit'),
(34, -120.00, DATEADD(DAY, -49, GETDATE()), 'Withdrawal'),
(35, 700.00, DATEADD(DAY, -51, GETDATE()), 'Deposit'),
(36, 200.00, DATEADD(DAY, -53, GETDATE()), 'Deposit'),
(37, -100.00, DATEADD(DAY, -55, GETDATE()), 'Withdrawal'),
(38, 300.00, DATEADD(DAY, -57, GETDATE()), 'Deposit'),
(39, -90.00, DATEADD(DAY, -59, GETDATE()), 'Withdrawal');

-- Add a second wave to increase volume for reports
INSERT INTO BankTransaction (AccountID, Amount, TransactionDate, TransactionType)
VALUES
(11, -50.00, DATEADD(DAY, -28, GETDATE()), 'Withdrawal'),
(12, 320.00, DATEADD(DAY, -27, GETDATE()), 'Deposit'),
(13, -200.00, DATEADD(DAY, -26, GETDATE()), 'Withdrawal'),
(14, 150.00, DATEADD(DAY, -25, GETDATE()), 'Deposit'),
(15, -100.00, DATEADD(DAY, -24, GETDATE()), 'Withdrawal'),
(16, 450.00, DATEADD(DAY, -23, GETDATE()), 'Deposit'),
(17, 300.00, DATEADD(DAY, -22, GETDATE()), 'Deposit'),
(18, -120.00, DATEADD(DAY, -21, GETDATE()), 'Withdrawal'),
(19, 500.00, DATEADD(DAY, -20, GETDATE()), 'Deposit'),
(20, -200.00, DATEADD(DAY, -19, GETDATE()), 'Withdrawal'),
(21, 220.00, DATEADD(DAY, -18, GETDATE()), 'Deposit'),
(22, 150.00, DATEADD(DAY, -17, GETDATE()), 'Deposit'),
(23, -75.00, DATEADD(DAY, -16, GETDATE()), 'Withdrawal'),
(24, 600.00, DATEADD(DAY, -15, GETDATE()), 'Deposit'),
(25, -90.00, DATEADD(DAY, -14, GETDATE()), 'Withdrawal'),
(26, 310.00, DATEADD(DAY, -13, GETDATE()), 'Deposit'),
(27, 180.00, DATEADD(DAY, -12, GETDATE()), 'Deposit'),
(28, -110.00, DATEADD(DAY, -11, GETDATE()), 'Withdrawal'),
(29, 230.00, DATEADD(DAY, -10, GETDATE()), 'Deposit'),
(30, -160.00, DATEADD(DAY, -9, GETDATE()), 'Withdrawal'),
(31, 420.00, DATEADD(DAY, -8, GETDATE()), 'Deposit'),
(32, 210.00, DATEADD(DAY, -7, GETDATE()), 'Deposit'),
(33, -90.00, DATEADD(DAY, -6, GETDATE()), 'Withdrawal'),
(34, 185.00, DATEADD(DAY, -5, GETDATE()), 'Deposit'),
(35, -140.00, DATEADD(DAY, -4, GETDATE()), 'Withdrawal'),
(36, 500.00, DATEADD(DAY, -3, GETDATE()), 'Deposit'),
(37, 275.00, DATEADD(DAY, -2, GETDATE()), 'Deposit'),
(38, -120.00, DATEADD(DAY, -1, GETDATE()), 'Withdrawal'),
(39, 310.00, GETDATE(), 'Deposit');

-- Insert Overdraft table
INSERT INTO Overdraft (TransactionID, OverdraftAmount)
VALUES
(1, 100.00),
(2, 50.00),
(3, 25.00),
(4, 75.00),
(5, 50.00),
(6, 200.00),
(7, 10.00),
(8, 150.00),
(9, 100.00),
(10, 300.00),
(11, 40.00), (12, 25.00), (14, 60.00), (17, 30.00), (20, 80.00),
(22, 50.00), (24, 35.00), (27, 20.00), (32, 45.00), (36, 70.00),
(41, 55.00), (44, 25.00), (46, 65.00), (50, 40.00), (54, 30.00);


-- Insert LoanPayment table
INSERT INTO LoanPayment (LoanID, PaymentDate, AmountPaid)
VALUES
(1, '2025-10-01', 1000.00),
(2, '2025-10-01', 800.00),
(3, '2025-10-01', 1200.00),
(4, '2025-10-01', 700.00),
(5, '2025-10-01', 600.00),
(6, '2025-10-01', 1000.00),
(7, '2025-10-01', 1500.00),
(8, '2025-10-01', 1100.00),
(9, '2025-10-01', 1300.00),
(10, '2025-10-01', 1400.00),
(11, DATEADD(DAY, -85, GETDATE()), 900.00),
(12, DATEADD(DAY, -70, GETDATE()), 800.00),
(13, DATEADD(DAY, -60, GETDATE()), 950.00),
(14, DATEADD(DAY, -50, GETDATE()), 700.00),
(15, DATEADD(DAY, -40, GETDATE()), 650.00),
(16, DATEADD(DAY, -30, GETDATE()), 1000.00),
(17, DATEADD(DAY, -25, GETDATE()), 850.00),
(18, DATEADD(DAY, -20, GETDATE()), 1200.00),
(19, DATEADD(DAY, -15, GETDATE()), 1100.00),
(20, DATEADD(DAY, -10, GETDATE()), 1300.00),
(21, DATEADD(DAY, -5, GETDATE()), 1400.00),
(22, DATEADD(DAY, -3, GETDATE()), 850.00),
(23, DATEADD(DAY, -2, GETDATE()), 900.00),
(24, DATEADD(DAY, -1, GETDATE()), 700.00),
(25, GETDATE(), 600.00),
(26, DATEADD(DAY, -45, GETDATE()), 1500.00),
(27, DATEADD(DAY, -35, GETDATE()), 1100.00),
(28, DATEADD(DAY, -25, GETDATE()), 1200.00),
(29, DATEADD(DAY, -15, GETDATE()), 1300.00),
(30, DATEADD(DAY, -5, GETDATE()), 1400.00),
(31, DATEADD(DAY, -85, GETDATE()), 900.00),
(32, DATEADD(DAY, -70, GETDATE()), 800.00),
(33, DATEADD(DAY, -60, GETDATE()), 950.00),
(34, DATEADD(DAY, -50, GETDATE()), 700.00),
(35, DATEADD(DAY, -40, GETDATE()), 650.00);
