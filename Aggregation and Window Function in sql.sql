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

