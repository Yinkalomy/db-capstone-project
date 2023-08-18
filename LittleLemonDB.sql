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