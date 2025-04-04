-- Aggregation and Analytical Functions:

-- 1. Aggreagate Functions:COUNT(), SUM(), AVG(), MAX(), MIN()

-- Find the total numbers, total sales, average sales, highest sales, and minimun sales of customers
SELECT 
	CustomerID,
	COUNT(*) total_nmbr_sales,
	SUM(Sales) total_sales,
	AVG(Sales) avg_sale,
	MAX(Sales) max_sale,
	MIN(Sales) min_sale
FROM
	Sales.Orders
GROUP BY
	CustomerID;

--- Customer table
	SELECT
		SUM(Score) as totalScore,
		AVG(Score)
	FROM
		Sales.Customers;

	--########## Window Functions Basics:  ##########
	-- Both window functions and GROUP BY are used for aggregating data in SQL, 
	--but they serve different purposes and produce different results.

	-- Group by : 
	/*
	-Simple aggregations
	-Groups rows that have the same values into summary rows
	-Collapses multiple rows into a single row per group
	*/
	-- FInd the total sales for each product
	-- (in the below using group by when we need other extra informaton like orderid, order_date we have
	-- to group by all these which will not give correct output),it is suitable for grouping only one value
	SELECT
		ProductID,
		SUM(Sales) as TotalSales
	FROM
		Sales.Orders
	GROUP BY
		ProductID;

	-- Window: Aggregation + Keep details
	/*
	-Performs calculations across a set of table rows related to the current row
	-Doesn't reduce the number of rows in the result set
	*/
	SELECT
		OrderDate,
		OrderID,
		ProductID,
		SUM(Sales) OVER(PARTITION BY ProductID) as total_sales
	FROM
		Sales.Orders
	ORDER BY
		ProductID;

	-- Window Functions:
	/*
	-- Window functions perform calculations across a set of table rows that are somehow related to the 
	--current row, without collapsing rows like GROUP BY does.*/

	-- Syntax
	/*
	SELECT 
		column1,
		column2,
    window_function() OVER (
        [PARTITION BY partition_expression, ...]
        [ORDER BY sort_expression [ASC | DESC], ...]
        [frame_clause]
		)	AS result_column
	FROM table_name;
*/

	/*
	1.	Window Function: The aggregation or ranking function being applied 
		(e.g., SUM(), AVG(), ROW_NUMBER(), etc.)

	2.	OVER(): The clause that defines the window of rows the function operates on

	3.	PARTITION BY (optional):
		-Divides the result set into partitions (groups)
		-The window function is applied to each partition separately
		-Similar to GROUP BY but doesn't reduce rows

	4.	ORDER BY (optional):
		-Determines the logical order of rows within each partition
		-Essential for cumulative/running calculations and ranking functions

	5.	Frame Clause (optional):
		Defines which rows within the partition are included in the window

		Syntax: ROWS | RANGE BETWEEN frame_start AND frame_end

		Common frames:

		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW (default for ORDER BY)

		ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING

		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

	*/

	--- #####  OVER() as OVER(Partition By col)
	-- Find the total sales across all orders
	-- additiionally provides details such as order id, order data

	SELECT
		OrderID,
		OrderDate,
		SUM(Sales) OVER() total_sales
		FROM
			Sales.Orders;

	-- Find the total sales for each product
	-- additiionally provides details such as order id, order data

	SELECT
		OrderID,
		OrderDate,
		ProductID,
		OrderStatus,
		SUM(Sales) OVER(PARTITION BY ProductID) as total_sales_by_product,
		SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) as total_sales_by_product_OrderStatus
		FROM
			Sales.Orders;

	-- Rank each order based on their sales from highest to lowest.
	SELECT
		ProductID,
		OrderID,
		Sales,
		RANK() OVER(ORDER BY Sales DESC) as rank_sales
	FROM
		Sales.Orders;


	-- WINDOW FRAME: Defines a subset of rows within each window that is relevant for the calculation
	SELECT
		
		OrderID,
		OrderDate,
		OrderStatus,
		Sales,
		SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
		ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
	FROM
		Sales.Orders;


--- Rules for Window Functions
--1. Window functions can be used only in SELECT and ORDER BY Clause (Can't be used to filter data)
--2. Nesting Window Function is not allowed
--3. SQL execute Window functions after WHERE Clause.

---E.g., Find the total Sales for each order status, only for two products 101 and 102
	
	SELECT
		OrderID,
		OrderDate,
		OrderStatus,
		Sales,
		SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
	FROM
		Sales.Orders
	WHERE ProductID IN (101,102);

--4. WInodw Functions cab be used together with GROUP BY in the same query, ONLY if the same columns are used
	
	-- Rank the customers based on their total sales.

	SELECT
		CustomerID,
		SUM(Sales) TotalSales,
		RANK() OVER(ORDER BY SUM(Sales) DESC) Rank_customers
	FROM
		Sales.Orders
	GROUP BY 
		CustomerID;


	----##### AGGREGATE WINDOW FUNCTION ?

	SELECT
		OrderID,
		OrderDate,
		OrderStatus,
		Sales,
		COUNT(*) OVER() TotalOrders,
		COUNT(*) OVER(PARTITION BY CustomerID) TotalOrders,
		COUNT(Sales) OVER (PARTITION BY ProductID) TotalSales
	FROM
		Sales.Orders;

	-- FInd the total number of customers
	-- Find the total number of scores for the custoemrs
	-- Additionally provide all custoemrs details

	SELECT
		*,
		COUNT(*) OVER() as total_customers,
		COUNT(Score) OVER() as total_score,
		COUNT(LastName) OVER() as total_lname
	FROM
		Sales.Customers;


	-- Check whether the table 'Orders' contains any duplicate rows
	SELECT
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) check_duplicate
	FROM
		Sales.Orders;

	--2.  idenfiying the duplicate rows to improve data quality
	SELECT
		*
	FROM(
	SELECT 
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) chek_duplicate
	FROM
		Sales.OrdersArchive) t
		WHERE chek_duplicate > 1;


	--- SUM() aggregate window functions

	-- find the total sales for each product
	SELECT
		ProductID,
		Sales,
		SUM(Sales) OVER() TotalSales,
		SUM(Sales) OVER(PARTITION BY ProductID) as total_Sales_by_product
	FROM
		Sales.Orders;


	-- AVG() :
	-- find the average ssales across all orders
	-- find the average for each product
	-- additionally provide details such orderid, orderdate
	SELECT
		ProductID,
		Sales,
		OrderDate,
		AVG(Sales) OVER() AvgSales,
		AVG(Sales) OVER(PARTITION BY ProductID) as avg_sales_by_product
	FROM
		Sales.Orders;

	-- Find the average scores of custoemrs
	-- additionally provide deetails such CustomerID and LastName

	SELECT 
		CustomerID,
		LastName,
		Score,
		COALESCE(Score,0) as new_score,
		AVG(COALESCE(Score,0)) OVER () avg_score
	FROM
		Sales.Customers;

	-- Find all orders where sales are higher than the average sales across all orders
	SELECT
		*
	FROM(
	SELECT
		ProductID,
		OrderDate,
		Sales,
		AVG(Sales) OVER() AvgSales
	FROM
		Sales.Orders
	) t
	WHERE 
		Sales > AvgSales;

	-- note: Helps to evaluate whether a value is above or below the average

	---#### MIN/MAX window functions
	-- Find the highest and the lowest sales of all orders
	-- Find the highest and lowest sales for each product
	SELECT
		ProductID,
		OrderDate,
		Sales,
		MAX(Sales) OVER() Max_sales,
		MAX(Sales) OVER(PARTITION BY ProductID) Max_Sales_by_product,
		MIN(Sales) OVER() Min_sales,
		MIN(Sales) OVER(PARTITION BY ProductID) Min_Sales_by_product
	FROM
		Sales.Orders;

	--NOTE: Group-wise analysis, to understand patterns within different categories

	-- Show the employees with the highest salaries
	SELECT
		*
	FROM (
	SELECT
		FirstName,
		LastName,
		Department,
		Salary,
		MAX(Salary) OVER() highest_salary
	FROM
		Sales.Employees) t
	WHERE
		Salary = highest_salary;


	-- Find the deviation of each sales from the min and max sales amount
	SELECT
		ProductID,
		OrderDate,
		Sales,
		MAX(Sales) OVER() Max_sales,
		MIN(Sales) OVER() Min_sales,
		MAX(Sales) OVER() - Sales DeviationfromMax,
		Sales - MIN(Sales) OVER() DeviationFromMin
	FROM
		Sales.Orders;


	-- Running and Rolling Total 
	-- Tracking current sales with target sales

	-- # RUNNING TOTAL:
	-- Aggeragate all values from the beginning to the current point without droppping off older data.

	-- # ROLLING TOTAL:
	-- Aggeragate all values within a fixed time window (e.g. 30days). As new data is added, the oldest point
	--- will be dropped.

	-- Calculate the running total of sales for each product over time, also the rolling total for each product
		SELECT
			ProductID,
			OrderDate,
			Sales,
			SUM(Sales) OVER(PARTITION BY ProductID) TotalSales,
			SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) RunningTotalSales,
			SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) RollingTotalSales
		FROM
		Sales.Orders;


	-- Calculate the moving average of sales for each product over time
		SELECT
			ProductID,
			OrderDate,
			Sales,
			AVG(Sales) OVER(PARTITION BY ProductID) AvgProduct,
			AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
		FROM
		Sales.Orders;

		-- Calculate the moving average of sales for each product over time
		-- Calculate the moving  average for each product over time , including only next order
		SELECT
			ProductID,
			OrderDate,
			Sales,
			AVG(Sales) OVER(PARTITION BY ProductID) AvgProduct,
			AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
			AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate
			ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) Rolling_Avg
		FROM
		Sales.Orders;


	-- SUMMARY:
		
		SELECT
			ProductID,
			OrderDate,
			Sales,
			SUM(Sales) OVER() OverallTotal,
			SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct,
			SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) RunningTotalSales,
			SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) RollingTotalSales
		FROM
		Sales.Orders;