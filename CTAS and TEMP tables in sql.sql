
-- CTAS syntax:
-- creating the CTAS
/*
	In SQL, CTAS stands for "CREATE TABLE AS SELECT", a powerful command used to create a new table based on the 
	results of a SELECT query. It combines table creation and data insertion in a single step.
*/

	SELECT
		DATENAME(month,OrderDate) Orderonth,
		COUNT(OrderID) TotalOrders
	INTO Sales.MonthlyOrders
	FROM
		Sales.Orders
	GROUP BY 
		DATENAME(month, OrderDate);

	SELECT
	 *
	FROM
		Sales.MonthlyOrders;

	DROP TABLE Sales.MonthlyOrders;


	-- Refreshing the CTAS:
	IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
		DROP TABLE Sales.MonthlyOrders;
	GO
		SELECT
		DATENAME(month,OrderDate) Orderonth,
		COUNT(OrderID) TotalOrders
		INTO Sales.MonthlyOrders
		FROM
			Sales.Orders
		GROUP BY 
			DATENAME(month, OrderDate);

		-- USE CASE: Snaping a data

