
-- Date and Time functions:

SELECT
	OrderID,
	CreationTime,
	'2025-04-01' as Hardcoded_date,
	GETDATE() AS Today
FROM
	Sales.Orders;

-- Part extraction:( DAY, MONTH, YEAR, DATEPART, DATENAME, DATETRUNC, EOMONTH)

SELECT
	OrderID,
	CreationTime,
	YEAR(CreationTIme) as Year,
	MONTH(CreationTime) as Month,
	DAY(CreationTime) as Day
FROM
	Sales.Orders;

-- PartDate
-- DATEPART(part, date)
SELECT
	OrderID,
	OrderDate,
	CreationTime,
	DATEPART(day,CreationTime) as day,
	DATEPART(month,CreationTime) as month,
	DATEPART(year,CreationTime) as year,
	DATEPART(hour,CreationTime) as hour_dp,
	DATEPART(MINUTE,CreationTime) as minute_dp,
	DATEPART(second,CreationTime) as sec_dp,
	DATEPART(week,CreationTime) as week_dp,
	DATEPART(weekday,CreationTime) as weekday_dp,
	DATEPART(QUARTER,CreationTime) as quarter
FROM
	Sales.Orders;

-- DATENAME(part, date)
SELECT
	OrderID,
	OrderDate,
	CreationTime,
	DATENAME(day,CreationTime) as day,
	DATENAME(weekday,CreationTime) as weekday,
	DATENAME(month,CreationTime) as month
FROM
	Sales.Orders;

-- DATETRUNC(part, data) function
-- For resetting the specific datepart
SELECT
	OrderID,
	CreationTime,
	DATETRUNC(minute,CreationTime) as min_trunc,
	DATETRUNC(day,CreationTime) as day,
	DATETRUNC(year,CreationTime) as year_dt
FROM
	Sales.Orders;


SELECT
	DATETRUNC(month,CreationTime) as creation,
	COUNT(*) as number_of_orders
FROM
	Sales.Orders
GROUP BY 
	DATETRUNC(month, CreationTime);
	
-- EOMONTH Function:

SELECT
	'2025-04-01',
	EOMONTH('2025-04-01') as end_of_month;

--e.g: to get the end of month we use EOMONTH()
SELECT
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) as End_month
FROM
	Sales.Orders;

-- Case Scenario
-- How many orders were placed each year ?

SELECT
	YEAR(OrderDate),
	COUNT(*) as number_of_orders
FROM
	Sales.Orders
GROUP BY
	Year(OrderDate);

-- How many orders were placed each month ?

SELECT
	DATENAME(month,OrderDate) as month,
	COUNT(*) as number_of_orders
FROM
	Sales.Orders
GROUP BY
	DATENAME(month,OrderDate);

-- SHow all orders that were placed during the month of february

SELECT
	*
FROM
	Sales.Orders
WHERE
	MONTH(OrderDate) = 2;

--- ###Format and Casting:
-- FORMAT(value, format, [,culture])
-- To extract the day by formating 
SELECT
	OrderID,
	CreationTime,
	FORMAT(CreationTime, 'MM-dd-yyyy') as Us_format,
	FORMAT(CreationTime, 'dd') dd,
	FORMAT(CreationTime, 'ddd') ddd,
	FORMAT(CreationTime, 'dddd') dddd
FROM
	Sales.Orders;
-- To format the month
SELECT
	OrderID,
	CreationTime,
	FORMAT(CreationTime, 'MM') month_num,
	FORMAT(CreationTime, 'MMM') half_mon,
	FORMAT(CreationTime, 'MMMM') full_month
FROM
	Sales.Orders;


--- Day Wed Jan Q1 2025 12:34:56 PM
SELECT
	CreationTime,
	'Day ' + Format(CreationTime, 'ddd MMM') +
	 ' Q' + DATENAME(quarter, CreationTime) +
	 FORMAT(CreationTime, ' yyyy hh:mm:ss tt') as Custom_format
FROM
	Sales.Orders;

-- E.g 
SELECT
	FORMAT(OrderDate, 'MMM yy'),
	COUNT(*) as number_of_orders
FROM
	Sales.Orders
GROUP BY
	FORMAT(OrderDate, 'MMM yy');

-- Standarize the date format


-- #####  CONVERT():
-- Converts a date or time value to a different data type and format the value.

-- CONVERT(data_type, value, [,style])

-- CONVERT(int, '123')
-- CONVERT(VARCHAR, OrderDate, '34')


SELECT
	CONVERT(INT, '123') as [String to Int Convert],
	CONVERT(DATE, '2025-04-01') as [String to DATE Convert],
	CreationTime,
	CONVERT(DATE, CreationTime) as [DateTime to Date Convert]
FROM
	Sales.Orders;


--- CAST(value AS data_type) function
-- CAST('123' AS INT)
-- CAST('2023-03-12' AS DATE)

SELECT
	CAST('123' AS INT) as [String to Int],
	CAST(123 AS varchar) as [Int to string],
	CAST('2021-12-3' AS DATE) as [String to Date];

SELECT
	CreationTime,
	CAST(CreationTIme as Date) as Date
FROM	
	Sales.Orders;


-- Date Calculations:
-- DATEADD() and DATEDIFF()

--- DATEADD() : Allow adds or subtracts a specific time interval to/from a date.
-- DATEADD(part, interval, data)
-- DATEADD(year, 3, OrderDate)
-- DATEADD(month, -4, OrderDate)

SELECT
	OrderID,
	OrderDate,
	DATEADD(year, 2, OrderDate) as add_year,
	DATEADD(month, 2, OrderDate) as add_month,
	DATEADD(day, -10, OrderDate) as minus_day
FROM	
	Sales.Orders;


-- DATEDIFF() functions in sql
-- DATEDIFF(part, start_date, end_date)

SELECT
*
FROM
	Sales.Employees;

-- Get the age of the employees
SELECT 
	firstName,
	Department,
	BirthDate,
	DATEDIFF(year,BirthDate,GETDATE()) as age
FROM
	Sales.Employees;

-- Find the average shipping duration in days for each month

SELECT
	MONTH(OrderDate) each_month,
	AVG(DATEDIFF(day,OrderDate, ShipDate)) as ship_days
FROM
	Sales.Orders
GROUP BY
	MONTH(OrderDate);


-- Time Gap Analysis
-- Find the number of days betweeen each orders and the previous order

SELECT
	OrderID,
	OrderDate as CurrentOrderDate,
	LAG(OrderDate) OVER(ORDER BY OrderDate) as PrevOrderDate,
	DATEDIFF(day, LAG(OrderDate) OVER(ORDER BY OrderDate), OrderDate) as number_of_days
FROM
	Sales.Orders;

-- Validations: ISDATE(): Checks if a value is date or not.
-- Returns  1 if the string value is a valid date

SELECT ISDATE('123') as DateCheck;