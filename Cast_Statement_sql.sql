-- CASE Statement:
-- Evaluates a list of conditions and returns a value when the condition is met

-- Syntax
/*
CASE
	WHEN condition1 THEN result1
	WHEN condition2 THEN result2
	....
	ELSE retult
END
*/

-- Use Case: 
-- Categorizing Data: Group the data into different catefories based on certain categories
-- Main Purpose is Data Transformation
-- Derive new information
-- Creat new column based on existing data

-- SQL TASK:
/*Generate a report showing the total sales for each category:
-high: if the sales higher then 50
- Medium: if the sales between 20 and 50
- Low: if the sales equal or lower than 20
Sort the result from lowest to highest
*/

SELECT 
	Category,
	SUM(Sales) as total_sales
FROM(
SELECT
	OrderID,
	Sales,
	CASE
		WHEN sales > 50 THEN 'High'
		WHEN sales > 20 AND sales <50 THEN 'Medium'
		ELSE 'Low' 
	END Category
FROM
	Sales.Orders
) categorize_sales
GROUP BY
	Category
ORDER BY
	total_sales;

-- ## Case Statement Rules:
-- The data type of the resutls must be matching

-- Mapping 
 
 -- Retrieves employee with details with gender displayed as full text
 SELECT
	EmployeeID,
	FirstName,
	LastName,
	Gender,
	CASE
		WHEN Gender = 'M' THEN 'Male'
		ELSE 'Female'
	END as gender_category
FROM
	Sales.Employees;

-- Retrieves customers details with abbreviated country code
SELECT
	CustomerID,
	FirstName,
	Country,
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'n/a'
	END as country_code
FROM
	Sales.Customers;


-- Case Statement: Quick Form
SELECT
	CustomerID,
	FirstName,
	Country,
	CASE Country
		WHEN  'Germany' THEN 'DE'
		WHEN  'USA' THEN 'US'
		ELSE 'n/a'
	END as country_code
FROM
	Sales.Customers;


-- ### Handling Nulls in Case Statement
-- Find the average scores of customers and treat Null as 0
-- And aditiional provides details such as CustomerID, LastName


SELECT
	CustomerID,
	LastName,
	Score,
	CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END as_score,
	AVG(Score) OVER() Avg_score1,
	AVG(CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END) OVER() avg_score2
FROM
	Sales.Customers;

	-- Congitional aggreagation
-- Count how many times each customer has made an order with sales greater than 30;
SELECT
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END )  TotalOrders
FROM
	Sales.Orders
GROUP BY
	CustomerID;