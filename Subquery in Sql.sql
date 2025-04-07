
-- Subqueries:
-- A query inside another query.

-- Subquery in From Clause: Used as the temporary table for the main query
	/*
		SELECT a.column_name
		FROM (SELECT column_name FROM table_name) AS a;
	*/

--qsn : Find the products that have the price higher than the average price of all products;
	
	SELECT
	*
	FROM (
		SELECT 
			ProductID,
			Price,
			AVG(price) OVER() avg_price
		FROM
			Sales.Products) AS products
	WHERE price > avg_price;


-- qsn: Rank the customers based on their total amount of sales;
		
		SELECT
			*,
			RANK() OVER(ORDER BY Totalsale) RankCustomer
		FROM 
			(SELECT
				CustomerID,
				SUM(Sales) Totalsale
			FROM
				Sales.Orders
			GROUP BY 
				CustomerID)t;

	-- ### Subquery in SELECT Clause:
	/*
	SELECT 
	column_name, 
	(SELECT column_name FROM table_name WHERE condition) AS alias
	FROM table_name;

	!!!!!! IMPORTANT RULE::::
		- The subquery must return a single column and at most one row,
		- A non-correlated SELECT clause subquery can't reference columns from other tables in the same FROM clause,
		- The subquery should produce the same result for the same input values.
	*/

	-- Show the product IDs, names, prices and total number of orders;

	--Main query
	SELECT
		ProductID,
		Product,
		Price,
		--Subquery
		(SELECT COUNT(*) FROM Sales.Orders ) Total_Orders
	FROM	
		Sales.Products;


	-- ## Subquery in JOIN Operation

	-- qsn: Show all customer details and find the total orders for each custoemr.

	SELECT 
		c.*,
		total_orders
	FROM
		Sales.Customers c
	LEFT JOIN (
					SELECT 
						CustomerID,
						COUNT(*) total_orders
					FROM
						Sales.Orders
					GROUP BY 
						CustomerID
			  ) o
		ON c.CustomerID = o.CustomerID;
	
	-- ####### WHERE CLAUSE Subqueries:::USed for complex filtering logic and makes query more flexible and dynamic
	/*
		SELECT column_name
		FROM table_name
		WHERE column_name OPERATOR 
		(SELECT column_name FROM table_name WHERE condition);
	*/

	-- QSN:: Find the products that have a price higher than the average price of all product;

	SELECT
		ProductID,
		Product,
		Price
	FROM
		Sales.Products
	WHERE 
		price > (SELECT 
				AVG(price) 
				FROM Sales.Products);


	--- Subquery in WHERE Clause IN Operator:
	--QSN Show the details of orders made by customers in Germany.

	SELECT
		OrderId,
		ProductID,
		CustomerID,
		OrderDate,
		Sales
	FROM
		Sales.Orders
	WHERE 
		CustomerID IN 
					(SELECT 
					CustomerID 
					FROM Sales.Customers 
					WHERE Country = 'Germany');


		--- ANY / ALL Operator:
		-- ANY Operator: 
		-- Checks if a value matches ANY value wihtin a list.
		-- Used to check if a value is true for AT LEAST one of the values in a list

		/*
			SELECT col1, col2,...
			FROM table 1
			WHERE  column < (SELECT column FROM table 1 WHERE condition)
		*/
		-- QSN : Find the employees whose salaries are greatr 
			  --than the salaries of any male employees

			SELECT
				EmployeeID,
				FirstName,
				Salary
			FROM
				Sales.Employees
			WHERE
				Gender = 'F' AND
				Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

		-- ALL OPERATOR:
		-- Checks if a value matches ALL values wihtin a lsit.

		-- QSN : Find the employees whose salaries are greatr 
			  --than the salaries of any male employees.

			SELECT
				EmployeeID,
				FirstName,
				Salary
			FROM
				Sales.Employees
			WHERE
				Gender = 'F' AND
				Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


	-- NON-CORRELATED SUBQUERY
	-- A Subquerey that can run independently from the Main Query

	-- QSN: Show all customers details and find the total orders for each customer.

	SELECT 
		*,
		(SELECT	
		COUNT(*) TotLOrders
	FROM
		Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
	FROM
		Sales.Customers c;


	-- Correlated Subquery in WHERe Clause EXISTS Operator:
	/*
		The EXISTS operator is a powerful tool in SQL that checks whether a subquery returns any rows. 
		It's commonly used in correlated subqueries to test for the existence of related records.

		SELECT column_names
		FROM table_name
		WHERE EXISTS (subquery);
	*/

	-- Show the details of orders made by customers in Germany,
	 SELECT *
	 FROM
		Sales.Orders o
	WHERE EXISTS (SELECT 1
					FROM
					Sales.Customers c WHERE Country = 'Germany' AND 
					o.CustomerID = c.CustomerID);
