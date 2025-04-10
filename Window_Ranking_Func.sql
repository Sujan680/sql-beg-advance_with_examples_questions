﻿
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
--##################################################################################################
	--1. ROW_NUMBER(): Unique rank
	-- e.g: Assign seat numbers to passengers in order of booking

	SELECT 
		OrderID,
		ProductId,
		Sales,
		ROW_NUMBER() OVER(ORDER BY Sales) SalesRank_Row
	FROM
		Sales.Orders;
--##################################################################################################

	-- 2. RANK(): it handles ties and leaves a gap in ranking
	-- e.g: Olympic medals: two golds (rank=1), next is bronze (rank=3)

		SELECT 
			OrderID,
			ProductId,
			Sales,
			ROW_NUMBER() OVER(ORDER BY Sales) SalesRank_Row,
			RANK() OVER(ORDER BY Sales) SalesRank
		FROM
			Sales.Orders;

--##################################################################################################

	--3. DENSE_RANK(): It also handles ties but doesnot leaves a gap while ranking
	-- e.g:Employee performance tiers: High, High, Medium, Medium, Low
		SELECT 
			OrderID,
			ProductId,
			Sales,
			ROW_NUMBER() OVER(ORDER BY Sales) SalesRank_Row,
			RANK() OVER(ORDER BY Sales) SalesRank,
			DENSE_RANK() OVER(ORDER BY Sales) SalesRankByDense_rank
		FROM
			Sales.Orders;
--##################################################################################################

		-- #### TOP_N Analysis::  ###

		-- FInd the top highest sales for each product
--##################################################################################################
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

--##################################################################################################
		-- ## BOTTOM-N analysis:  ###

	-- Find the lowest 2 customers based on their total sales
--##################################################################################################		
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

--##################################################################################################
	-- Give the unique row numbr to the OrderArchieve tables
	SELECT
		ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
		*
	FROM
		Sales.OrdersArchive;
--#################################################################################################3

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
--##################################################################################################
	-- ROW_NUMBER() USE CASE::
	--1. TOP-N Analysis
	--2. BOTTOM-N Analysis
	--3. Assign Unique IDs
	--4. Quality Checks: IDentify Duplicates
--##################################################################################################

	---### Rank WIndow Function::
	--4. NTILE ----
			-- Divides the rows into a specified number of approximately equal groups.
			-- Bucket size = Number of Rows / Number of Buckes;
--##################################################################################################
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

--##################################################################################################

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
--##################################################################################################

		SELECT
			NTILE(2) OVER(ORDER BY OrderID) Buckest,
			*
		FROM
			Sales.Orders;

--##################################################################################################

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

--##################################################################################################

	------ Window Value Functions: LAG() , LEAD(), FIRST_VALUE(), LAST_VALUE()

		-- LEAD(exp, offset(opti.),default value) OVER(PARTITION BY ProductID ORDER BY OrderDate)
		-- Case Analysis::
		-- Time series analysis:
		-- The Process of analyzing the data to understand patterns, trends and behaviour over time
--##############################################################################################
		--1. Analyze the month-over-month performanace by finding the percentage change in sales
		-- between the current and prev months.
			
			SELECT
				*,
				CurrentMonthSales - PrevMonthSales As Month_Change,
				ROUND(CAST((CurrentMonthSales - PrevMonthSales) AS FLOAT) / PrevMonthSales * 100, 2) MoM_perc
			FROM (
			SELECT 
				MONTH(OrderDate) OrderMonth,
				SUM(Sales) CurrentMonthSales,
				LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PrevMonthSales
			FROM
				Sales.Orders
			GROUP BY
				MONTH(OrderDate) ) t;

--####################################################################################################
	--- Customer Retention Analysis:;
	-- Measure customer's behavior and loyalty to help businesses build strong relationship with customers.

	--#################################################################################
	--qsn: Analyze customer loyalty,
		-- by ranking customers based on the average numbr of days between orders.

		SELECT
			CustomerID,
			AVG(DaysUntilNextOrder) AvgDays,
			RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder), 9999)) Ranking
		FROM (
		SELECT
			OrderID,
			CustomerID,
			OrderDate CurrentOrder,
			LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
			DATEDIFF(day, OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder 
		FROM
			Sales.Orders) t 
		GROUP BY 
			CustomerID;

--#########################################################################################
		--- FIRST_VALUE(): Access a value from the first row within a window
		-- FIRST_VALUE(Sales) OVER(ORDER BY OrderDate ROWS BETWEEN UNBOUND PRECEDING AND CURRENT ROW)

		-- LAST_VALUE(): Access a value from the last row within a window
		--LAST_VALUE(Sales) OVER(ORDER BY OrderDate ROWS BETWEEN  CURRENT ROW AND UNBOUND FOLLOWING)

--##################################################################################################
	-- qsn: FInd the lowest and highest sales for each product::::

	SELECT
		OrderID,
		ProductID,
		Sales,
		FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) lowestSales,
		LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highestSales,
		FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSales,
		MAX(Sales) OVER(Partition By ProductID) as HighestSales,
		MIN(Sales) OVER(Partition By ProductID) as LowestSales
	FROM
		Sales.Orders;

--##################################################################################################