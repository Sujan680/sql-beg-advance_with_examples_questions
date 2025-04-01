
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