select * from LittleLemonDB.Bookings;

select * from LittleLemonDB.Menu;

ALTER TABLE LittleLemonDB.Menu 
 DROP COLUMN Starters, DROP COLUMN Courses, DROP COLUMN Drinks, DROP COLUMN Desserts ;
 
ALTER TABLE LittleLemonDB.Menu
 ADD MenuName VARCHAR(100);
 
CREATE TABLE LittleLemonDB.MenuItems (
 MenuItemsID INT PRIMARY KEY NOT NULL,
 CourseName VARCHAR(100) NOT NULL,
 StarterName VARCHAR(100) NOT NULL, 
 DessertName VARCHAR(100) NOT NULL); 
 
 
ALTER TABLE LittleLemonDB.Menu
 ADD MenuItemsID INT, 
 ADD FOREIGN KEY (MenuItemsID) REFERENCES LittleLemonDB.MenuItems(MenuItemsID);

SELECT * FROM LittleLemonDB.MenuItems;


use LittleLemonDB;

CREATE VIEW OrdersView AS SELECT Orders.OrdersID, Orders.Quantity, Orders.Total_Cost FROM LittleLemonDB.Orders WHERE Orders.Quantity > 2;

ALTER TABLE LittleLemonDB.Orders RENAME COLUMN `Total Cost` TO Total_Cost; 

SELECT * FROM OrdersView;
 
 
SELECT 
a.CustomerID AS CustomerID, 
a.FullName AS FullName, 
b.OrdersID OrderID, 
b.Total_Cost as `Total Cost`, 
c.MenuName as `Menu Name`, 
d.CourseName as `Course Name`,
d.StarterName as `Starter Name`
FROM Customers as a INNER JOIN Orders as b
ON a.CustomerID = b.CustomersID
INNER JOIN Menu as c
ON b.MenuID = c.MenuID
INNER JOIN MenuItems as d
ON c.MenuItemsID = d.MenuItemsID
ORDER BY b.Total_Cost ASC;


SELECT MenuName FROM LittleLemonDB.Menu WHERE MenuID = ANY
 (SELECT MenuID FROM LittleLemonDB.Orders WHERE Quantity > 2);
 
 
CREATE PROCEDURE GetMaxQuantity()
  SELECT Quantity FROM LittleLemonDB.Orders
  ORDER BY Quantity DESC
  LIMIT 1;
  
CALL GetMaxQuantity();

PREPARE GetOrderDetail FROM 'SELECT OrdersID, Quantity, Total_Cost FROM Orders WHERE CustomersID = ?';

SET @id = 1;

EXECUTE GetOrderDetail USING @id;

CREATE PROCEDURE CancelOrder(Order_id INT) 
 DELETE FROM LittleLemonDB.Orders WHERE OrdersID = Order_id;
 
CALL CancelOrder(5);

INSERT INTO LittleLemonDB.Bookings (BookingID, BookingDate, TableNumber, NumberOfGuests, CustomerID)
VALUES ( 1, '2022-10-10', 5, 8, 1), (2, '2022-11-12', 3, 6, 3), (3, '2022-10-11', 2, 3, 2), (4, '2022-10-13', 2, 4, 1);

INSERT INTO LittleLemonDB.Customers (CustomerID, FullName, CustomerPhoneNo, CustomerAddress)
VALUES (1, 'Vanessa McCarthy', '757536378', '23 Road, H close, House 3, Festac Town'),
(2, 'Marcos Romero', '757536379', '225 stillwater, Saskatoon'),
(3, 'Hiroki Yamane', '757536376', '212, Elan road, saskatoon'),
(4, 'Anna Iversen', '757536375', '245, stillwater, Alberta'),
(5, 'Diana Pinto', '757536374', 'telling avenue, toronto');


INSERT INTO LittleLemonDB.Staff (StaffID, StaffName, Role, ContactNumber, Salary) VALUES 
(1,'Seamus Hogan', 'Recruitment', '351478025',50000), 
(2,'Thomas Eriksson', 'Legal', '351475058',75000), 
(3,'Simon Tolo', 'Marketing', '351930582',40000), 
(4,'Francesca Soffia', 'Finance', '351258569',45000), 
(5,'Emily Sierra', 'Customer Service', '351083098',35000), 
(6,'Maria Carter', 'Human Resources', '351022508',55000),
(7,'Rick Griffin', 'Marketing', '351478458',50000);

SELECT * FROM LittleLemonDB.Staff;



select * from LittleLemonDB.Customers;

-- Creating a stored procedure to check booking

Drop procedure CheckBooking;
DELIMITER //
CREATE PROCEDURE CheckBooking(InputBooking_date DATE, Input_tableno INT)
BEGIN
		DECLARE v_cnt INT;
		SELECT count(*)
        INTO v_cnt
        FROM LittleLemonDB.Bookings
        WHERE BookingDate = InputBooking_date AND TableNumber = Input_tableno; 
        
       IF v_cnt = 1 THEN
		SELECT CONCAT('Table ' , Input_tableno, ' is already booked') AS 'Booking status';
	   ELSE
		SELECT CONCAT('Table ' , Input_tableno, ' is available');
		
	END IF;
END //

DELIMITER ;

-- call the procedure 
CALL CheckBooking('2022-11-12', 3);



SELECT * FROM LittleLemonDB.Bookings;

-- changed the datatype of bookings table

ALTER TABLE LittleLemonDB.Bookings
MODIFY COLUMN BookingID INT AUTO_INCREMENT; 

-- Create new procedure

DELIMITER //

CREATE PROCEDURE AddValidBooking(IN p_Bookingdate DATE, IN p_tableno INT)


BEGIN
DECLARE v_cnt INT;

START TRANSACTION; 
INSERT INTO LittleLemonDB.Bookings (BookingDate, TableNumber, NumberOfGuests, CustomerID)
VALUES (p_Bookingdate, p_tableno, 4, 3);

SELECT count(*)
INTO v_cnt
FROM LittleLemonDB.Bookings
WHERE BookingDate = p_Bookingdate AND TableNumber = p_tableno; 
    
IF v_cnt >= 1
	THEN SELECT CONCAT('Table ', p_tableno, ' is already booked - booking cancelled') AS BookingStatus;
	ROLLBACK;
ELSE
	SELECT CONCAT('Table ', p_tableno, ' is available and ready') AS BookingStatus;
	COMMIT;
        
END IF;
    
END //
    
DELIMITER ;
    
    -- call Valid Booking
    
call AddValidBooking("2022-12-17", 6);
    
DROP PROCEDURE AddValidBooking;
-- Stored procedure for adding bookings to table.
DELIMITER //
CREATE PROCEDURE AddBooking(IN p_bookingdate DATE, p_tableno INT, IN p_customerid INT)
BEGIN

	INSERT INTO LittleLemonDB.Bookings (BookingDate, TableNumber, NumberOfGuests, CustomerID)
	VALUES (p_bookingdate, p_tableno, 5, p_customerid);

	SELECT 'New Table added' AS Confirmation;
    
END //

DELIMITER ;

CALL AddBooking("2022-12-30", 4, 3);

-- stored procedure for updating table

DELIMITER //
CREATE PROCEDURE UpdateBooking(IN p_bookingdate DATE)
BEGIN 
	UPDATE LittleLemonDB.Bookings
    SET BookingDate = p_bookingdate
    WHERE BookingID = 6;
    
    SELECT 'Booking 6 updated' as confirmation;
    
END //

DELIMITER ;

-- calling the procedure

-- procedure for cancelling Booking

DELIMITER //
CREATE PROCEDURE CancelBooking(IN p_bookingid INT)
BEGIN 
	DELETE FROM LittleLemonDB.Bookings
    WHERE BookingID = p_bookingid;
    
    SELECT CONCAT( 'Booking ', p_bookingid, ' cancelled') AS Confirmation;
    
END//

DELIMITER ;

CALL CancelBooking(6);

show databases;



    
    




