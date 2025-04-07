
-- Common Table Expression (CTE)::
/*
	Temporary, named result set (virtual Table), that can be used multiple times within a query to simplify 
	and organize complex query.
*/

-- CTE Types: 
--1. Non-Recursive (Standalone, Nested) 
--2. Recursive

-- Standalone CTE:
/*
	- Defined and Used independently
	-- Runs independently as it's self-contained and doesn't rely on other CTEs or queries;

	Syntax:
		WITH cte_name AS (
		SELECT column1, column2, ...
		FROM table_name
		WHERE condition
		)
		SELECT * FROM cte_name;
*/

	-- QSN: Find the total Sales Per Customer
		
		WITH CTE_Total_Sales AS (
		SELECT 
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM
			Sales.Orders
		GROUP BY 
			CustomerID
		)
		SELECT
			c.CustomerID,
			c.FirstName,
			c.LastName,
			TotalSales
		FROM 
			Sales.Customers c
		LEFT JOIN
			CTE_Total_Sales cts
		ON c.CustomerID = cts.CustomerID
		ORDER BY
			TotalSales DESC;

						--!!!! You can't use ORDER BY in CTEs !!!!!

	-- Multiple Standalone CTEs
	-- Find the last order date for each customer

		WITH CTE_Total_Sales AS (
		SELECT 
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM
			Sales.Orders
		GROUP BY 
			CustomerID
		),
		CTE_Last_Orders AS (
		SELECT 
		CustomerID,
		MAX(OrderDate) LastOrders
		FROM
			Sales.Orders
		GROUP BY
			CustomerID
		)
		SELECT
			c.CustomerID,
			c.FirstName,
			c.LastName,
			TotalSales,
			LastOrders
		FROM 
			Sales.Customers c
		LEFT JOIN
			CTE_Total_Sales cts
		ON c.CustomerID = cts.CustomerID
		LEFT JOIN
			CTE_Last_Orders clo
		ON c.CustomerID = clo.CustomerID
		ORDER BY
			TotalSales DESC;

	-- Nested CTEs
	-- Rank the Customers based on total sales per customer

		WITH CTE_Total_Sales AS (
		SELECT 
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM
			Sales.Orders
		GROUP BY 
			CustomerID
		),
		CTE_Rank_Customers AS (
		SELECT
			CustomerID,
			TotalSales,
			RANK() OVER(ORDER BY TotalSales) AS RankCustomers
		FROM
			CTE_Total_Sales
		)
		SELECT
			*
		FROM
			CTE_Rank_Customers;

	-- Segment the customers based on their total Sales

		WITH CTE_Total_Sales AS (
		SELECT 
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM
			Sales.Orders
		GROUP BY 
			CustomerID
		),
		CTE_Segment_Customers AS (
		SELECT
			CustomerID,
			TotalSales,
			CASE
				WHEN TotalSales > 100 THEN 'High'
				WHEN TotalSales BETWEEN 50 AND 100 THEN 'Medium'
				ELSE 'Low'
			END AS CustomerSegment
		FROM	
			CTE_Total_Sales
		)
		SELECT
		*
		FROM
			CTE_Segment_Customers;

--- Mixing All Above 4 qsns:
	-- Find total Sales per customer
		WITH CTE_Total_Sales AS (
		SELECT 
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM
			Sales.Orders
		GROUP BY 
			CustomerID
		),
	-- Find the last orders date for each customers
		CTE_Last_Orders AS (
		SELECT 
		CustomerID,
		MAX(OrderDate) LastOrders
		FROM
			Sales.Orders
		GROUP BY
			CustomerID
		),
	-- Rank the customers based on total Sales
		CTE_Rank_Customers AS (
		SELECT
			CustomerID,
			TotalSales,
			RANK() OVER(ORDER BY TotalSales) RankCustomers
		FROM
			CTE_Total_Sales
		),
	-- Segment the custoems based on the total sales
		CTE_Segment_Customers AS (
		SELECT
			CustomerID,
			TotalSales,
			CASE
				WHEN TotalSales > 100 THEN 'High'
				WHEN TotalSales BETWEEN 50 AND 100 THEN 'Medium'
				ELSE 'Low'
			END AS CustomerSegment
		FROM	
			CTE_Total_Sales
		)
		SELECT
			c.CustomerID,
			c.FirstName,
			c.LastName,
			cts.TotalSales,
			LastOrders,
			RankCustomers,
			CustomerSegment
		FROM 
			Sales.Customers c
		LEFT JOIN
			CTE_Total_Sales cts
		ON c.CustomerID = cts.CustomerID
		LEFT JOIN
			CTE_Last_Orders clo
		ON c.CustomerID = clo.CustomerID
		LEFT JOIN
			CTE_Rank_Customers crc
		ON c.CustomerID = crc.CustomerID
		LEFT JOIN 
			CTE_Segment_Customers csc
		ON c.CustomerID = csc.CustomerID
		ORDER BY
			cts.TotalSales DESC;