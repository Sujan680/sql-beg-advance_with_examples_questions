-- NULL Functions in sql
-- Null means nothing, unknown!
-- Null is not equal to anything!
-- Null is not zero
-- Null is not empty sting
-- null is not blank space

-- ISNULL, COALSCE, NULLIF:
-- Use ISNULL/COALESCE if we want to replace NULL with value
-- Use NULLIF if we want to replace value with NULL

-- ISNULL(value, replacement)
-- ISNULL(ShipppingAddress, 'N/A')
-- ISNULL(ShippingAddress, BillingAddress)


-- COALSESCE(value1,value2,...)
-- COALSESCE(ShippingAddress, BillingAddress)
-- COALSESCE(ShippingAddress, BillingAddress, 'N/A')


-- FInd the average scores of the customers

SELECT
	CustomerID,
	Score,
	AVG(Score) OVER() AvgScores,
	AVG(COALESCE(Score, 0)) OVER() AvgScore2
FROM
	Sales.Customers;


-- Display the full name of custoemrs in a single field
-- by merging their first and last name,
-- and add 10 bonus points to each customers score.

SELECT
	CustomerID,
	FirstName,
	LastName,
	-- CONCAT(FirstName, ' ', COALESCE(LastName, ' ')) as FullName,
	FirstName + ' ' + COALESCE(LastName, ' ') as FullName,
	Score,
	COALESCE(Score,0) + 10 as ScoreBonus
FROM
	Sales.Customers;


--1. Handling the NULL before joining tables
/*
SELECT
	t1.year,
	t1.type,
	t1.orders,
	t2.sales
FROM	
	table1 t1
JOIN
	table2 t2
ON t1.year = t2.year and
	 ISNULL (t1.type, '') = ISNULL (t2.type, '');
	 */
	
--2. Handling the NULL before Sorting:
-- Sort the customers from lowest to highest scores, with NULL appearing last

SELECT
	CustomerID,
	FirstName,
	Score
FROM	
	Sales.Customers
ORDER BY
	CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score;


-- NULLIF functions in sql:
--NULLIF(value1, value2)
-- Compares two expressions, return NULL if same otherwise first value

-- USE case: Preventing the error of dividing by zero

SELECT
	OrderID,
	Sales,
	Quantity,
	Sales / NULLIF(Quantity,0) as price
FROM
	Sales.Orders;

--Identify the customers who have no scores
SELECT
	CustomerID,
	FirstName
FROM
	Sales.Customers
WHERE
	Score IS NULL;

--Identify the customers who have scores
SELECT
	CustomerID,
	FirstName
FROM
	Sales.Customers
WHERE
	Score IS NOT NULL;

-- List all details for customers who have not placed any orders.

Select 
	c.*,
	o.OrderID
FROM
	Sales.Customers c
LEFT JOIN
	Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE 
	o.CustomerID IS NULL;

---#############--- NULL vs Empty vs Space -----
WITH Orders AS (
	SELECT 1 ID, 'A' Category UNION
	SELECT 2, NULL UNION
	SELECT 3, '' UNION
	SELECT 4, '  '
)
SELECT *,
	DATALENGTH(Category) CategoryLen
FROM
	Orders;


-- USE case for the NULL 
--1. Data Policy--Set of rules that defines how data should be handled

-- 1.1 Only use NULLs and empty strings, but avoid blank spaces
	WITH Orders AS (
	SELECT 1 ID, 'A' Category UNION
	SELECT 2, NULL UNION
	SELECT 3, '' UNION
	SELECT 4, '  '
 )
 SELECT *,
	DATALENGTH(Category) CategoryLen,
	TRIM(Category) Policy1,
	DATALENGTH(TRIM(Category)) CategoryLen
 FROM
	Orders;

-- 1.2 Only use NULLs and avoid using empty strings as well as blank spaces
	WITH Orders AS (
	SELECT 1 ID, 'A' Category UNION
	SELECT 2, NULL UNION
	SELECT 3, '' UNION
	SELECT 4, '  '
 )
 SELECT *,
	TRIM(Category) Policy1,
	NULLIF(TRIM(Category), '') Policy2
 FROM
	Orders;

	-- 1.2 Usethe default value 'unknown' and avoid using NULLLs, empty strings and blank spaces
	WITH Orders AS (
	SELECT 1 ID, 'A' Category UNION
	SELECT 2, NULL UNION
	SELECT 3, '' UNION
	SELECT 4, '  '
 )
 SELECT *,
	TRIM(Category) Policy1,
	NULLIF(TRIM(Category), '') Policy2,
	COALESCE(NULLIF(TRIM(Category), ''),'unknown') Policy3
 FROM
	Orders;

--USE CASE For Data Policy 2 is best: Replacing  empty and blank spaces  with NULL
-- Replacing the empty string and blank space with NULL during data preparation before inserting
-- into database to optimize storage and performance.