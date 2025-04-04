
-- Window Ranking Functions:
/*
	Window ranking functions are a powerful feature in SQL that allow you to perform calculations across 
	a set of table rows that are somehow related to the current row. These functions are part of the SQL 
	window functions (also called analytic functions).

	1. ROW_NUMBER()
	Assigns a unique sequential integer to rows within a partition of a result set, starting at 1 for the 
	first row in each partition.

	2. RANK():
	Assigns a rank to each row within a partition, with gaps in the ranking values when there are ties.

	3. DENSE_RANK():
	Similar to RANK(), but ranks are consecutive (no gaps) even when there are ties.

	4.NTILE(n):
	Divides rows into a specified number (n) of approximately equal groups.

	5. PERCENT_RANK():
	Calculates the relative rank of a row (percentage) within a result set or partition.
		-Returns values between 0 and 1 (inclusive)
		-Formula: (rank - 1) / (total_rows - 1)
		-First row always has PERCENT_RANK = 0
		-Useful for percentile calculations

	6. CUME_DIST():
	Calculates the cumulative distribution of a value within a group of values.
			-Returns values between 0 and 1 (inclusive)
			-Represents the fraction of rows with values less than or equal to the current row's value
			-Formula: (number of rows ≤ current row) / (total rows)
			-Useful for understanding value distribution
*/

	--1. ROW_NUMBER(): Unique rank

	SELECT 
		OrderID,
		ProductId,
		Sales,
		ROW_NUMBER() OVER(ORDER BY Sales) SalesRank_Row
	FROM
		Sales.Orders;

	-- 2. RANK(): it handles ties and leaves a gap in ranking

		SELECT 
			OrderID,
			ProductId,
			Sales,
			ROW_NUMBER() OVER(ORDER BY Sales) SalesRank_Row,
			RANK() OVER(ORDER BY Sales) SalesRank
		FROM
			Sales.Orders;


	--3. DENSE_RANK(): It also handles ties but doesnot leaves a gap while ranking

		SELECT 
			OrderID,
			ProductId,
			Sales,
			ROW_NUMBER() OVER(ORDER BY Sales) SalesRank_Row,
			RANK() OVER(ORDER BY Sales) SalesRank,
			DENSE_RANK() OVER(ORDER BY Sales) SalesRankByDense_rank
		FROM
			Sales.Orders;

		-- #### TOP_N Analysis::  ###

		-- FInd the top highest sales for each product

		SELECT
		*
		FROM
		(
		SELECT
			OrderID,
			OrderDate,
			ProductID,
			ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales) Rank_By_Product
		FROM	
			Sales.Orders
		) as ranking
		WHERE Rank_By_Product = 1;


		-- ## BOTTOM-N analysis:  ###

	-- Find the lowest 2 customers based on their total sales
		
		SELECT *
		FROM (
		SELECT
			CustomerId,
			SUM(Sales) totalSales,
			ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers
		FROM	
			Sales.Orders
		GROUP BY
			CustomerID
		) lowestSales
		WHERE 
			RankCustomers <= 2;


	-- Give the unique row numbr to the OrderArchieve tables
	SELECT
		ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
		*
	FROM
		Sales.OrdersArchive;

	-- USE CASE: IDentity Duplicates::
	-- Identify the duplicate rows in the table "Orders Archive"
	-- and return a clean result without any duplicates.

		SELECT
			*
		FROM (
			SELECT
				ROW_NUMBER() OVER(Partition By OrderID ORDER BY CreationTime DESC) rn,
				*
			FROM
				Sales.OrdersArchive
			) t
		WHERE 
			rn = 1;

	-- ROW_NUMBER() USE CASE::
	--1. TOP-N Analysis
	--2. BOTTOM-N Analysis
	--3. Assign Unique IDs
	--4. Quality Checks: IDentify Duplicates


	---### Rank WIndow Function::
							--4. NTILE ----
			-- Divides the rows into a specified number of approximately equal groups.
			-- Bucket size = Number of Rows / Number of Buckes;

		SELECT
			OrderID,
			Sales,
			NTILE(1) OVER(ORDER BY Sales DESC) OneBucket,
			NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
			NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket,
			NTILE(4) OVER(ORDER BY Sales DESC) FourBucket,
			NTILE(5) OVER(ORDER BY Sales DESC) FiveBucket
		FROM
			Sales.Orders;

	-- NTILE(n) USE CASE::
	-- Data Segmentation: Divides a dataset into distinct subsets based on certain criteria

	-- Segment all orders into 3 categories: high, medium, and low sales:?
		
		SELECT 
			*,
			CASE
				WHEN Buckets = 1 THEN 'High'
				WHEN Buckets  = 2 THEN 'Medium'
				Else 'Low'
			END Category
		FROM (
		SELECT
			OrderID,
			Sales,
			NTILE(3) OVER(ORDER BY Sales DESC) Buckets
		FROM
			Sales.Orders) t;

		-- In order to export the data, divide the orders into 2 groups.

		SELECT
			NTILE(2) OVER(ORDER BY OrderID) Buckest,
			*
		FROM
			Sales.Orders;

	--- 5. PERCENTAGE-BASED RANKING: CUME_DIST() and PERCENT_RANK()

	--- CUME_DIST = Position Nmbr / Nuber of Rows

	-- PERCENT_RANK = Position Nmbr - 1 / Number of Rows -1

	-- Find the products that fall within the highest 40% of the prices. ?

	SELECT *,
		CONCAT(DistRank * 100, '%') DistRankPert
	FROM (
	SELECT
		Product,
		Price,
		CUME_DIST() OVER(ORDER BY Price DESC) DistRank,
		PERCENT_RANK() OVER(ORDER BY Price DESC) PerctRank
	FROM
		Sales.Products
	 ) t
	 WHERE
		DistRank <= 0.4;

