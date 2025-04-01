-- UNION set operations in sql
-- Returns only the matching rows from tables

use SalesDB;

SELECT *
FROM
	Sales.Customers;

SELECT *
FROM
	Sales.Orders;

SELECT *
FROM
	Sales.Employees;

-- Combine the data from employees and custoemrs into one table

SELECT 
	FirstName,
	LastName
FROM
	Sales.Customers
UNION
SELECT 
	FirstName,
	LastName
FROM
	Sales.Employees;


-- UNION ALL
-- Returns all rows from both queries including duplicates
-- UNION ALL is faster thatn UNION
-- Use to find the duplicates values

SELECT 
	FirstName,
	LastName
FROM
	Sales.Customers
UNION ALL
SELECT 
	FirstName,
	LastName
FROM
	Sales.Employees;


-- EXCEPT
-- Find the employees who are not custoemrs at the same time

SELECT 
	FirstName,
	LastName
FROM
	Sales.Employees
EXCEPT
SELECT 
	FirstName,
	LastName
FROM
	Sales.Customers;


	--- INERSECTION
	-- Retrieves only the common values from rows
	-- FInd the employees, who are also customers

	SELECT 
	FirstName,
	LastName
FROM
	Sales.Customers
INTERSECTION
SELECT 
	FirstName,
	LastName
FROM
	Sales.Employees;

-- Orders data are stored in separate tables (Orders and OrdersArchieve)
-- Combine all orders data into one report wihtout duplicate
SELECT 
	'Orders' AS SourceTable,
	[OrderID],
	  [ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM
	Sales.Orders

	UNION

SELECT 
	'OrdersArchive' AS SourceTable,
	[OrderID],
	[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM
	Sales.OrdersArchive
ORDER BY 
	OrderID;

