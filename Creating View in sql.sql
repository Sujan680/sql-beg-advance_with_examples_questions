
-- VIEW
/*
	- A view in SQL is a virtual table based on the result-set of a SQL query.
	- Views don't store data physically but rather provide a way to simplify complex queries, enhance security, 
	  and present data in a particular way to different users.

	Syntax:
		 CREATE VIEW view_name AS
			SELECT column1, column2, ...
			FROM table_name
			WHERE condition;
*/

-- Find the running total sales for each month
	/*
	WITH CTE_Monthly_Summary AS (
	SELECT
		DATENAME(month,OrderDate) as Months,
		SUM(Sales) TotalSales
	FROM
		Sales.Orders
	GROUP BY DATENAME(month, OrderDate)
	)
	SELECT 
		Months,
		TotalSales,
		SUM(TotalSales) OVER(ORDER BY Months) Running_Total
	FROM
		CTE_Monthly_Summary;
	*/


	--- For the above we create view instead

		CREATE VIEW Sales.V_Monthly_Summary AS 
		(
			SELECT
			DATENAME(month,OrderDate) as Months,
			SUM(Sales) TotalSales,
			COUNT(*) TotalOrders,
			SUM(Quantity) TotalQuantity
			FROM
				Sales.Orders
			GROUP BY DATENAME(month, OrderDate)
		)

	CREATE VIEW Sales.V_Order_Details AS (
	SELECT 
		o.OrderID,
		o.OrderDate,
		o.Sales,
		o.Quantity,
		p.Product,
		p.Category,
		COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') CustomerName,
		c.Country CustomerCountry,
		COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') EmployeeName,
		e.Department,
		e.Salary
	FROM
		Sales.Orders o
	LEFT JOIN
		Sales.Products p
	ON o.ProductID = p.ProductID
	LEFT JOIN
		Sales.Customers c
	ON o.CustomerID = c.CustomerID
	LEFT JOIN
		Sales.Employees e
	ON o.SalesPersonID = e.EmployeeID
)