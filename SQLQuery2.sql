-- TASK:: Using SalesDB, retrieve a list of all orders, along with the related customer, product,
-- and employee details. For each order, display:
-- order ID, customers name, product name, sales, price, sales persons name

USE SalesDB;

SELECT * FROM Sales.Orders;

SELECT * FROM Sales.Customers;

SELECT * FROM Sales.Employees;

SELECT * FROM Sales.Products;

SELECT
 o.OrderID,
 o.Sales,
 c.FirstName AS customerFirstName,
 c.LastName AS CustomerLastName,
 p.Product as ProductName,
 p.Price,
 e.FirstName as EmployeeFirstName,
 e.LastName as EmployeeLastName
FROM	
	Sales.Orders AS o
LEFT JOIN
	Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN
	Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN
	Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID;