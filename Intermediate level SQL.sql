
-- Intermediate level SQL

-- 1. Filtering Data(WHERE opertor)
-- 1.1 Comparison operator: (=, <> or !=, >,<,>=,<=)

-- Retrieves all customers from USA;
SELECT *
FROM
	customers
WHERE 
	country = 'USA';

-- Retrieves all customers not from USA
SELECT *
FROM
	customers
WHERE 
	country <> 'USA';

	-- Retrieves all customers with score > 500
SELECT *
FROM
	customers
WHERE 
	score > 500;

-- Retrieves all customers with score >= 500
SELECT *
FROM
	customers
WHERE 
	score >= 500;

-- Retrieves all customers with score <= 500
SELECT *
FROM
	customers
WHERE 
	score <= 500;

-- 1.2 Logical Operator: All conditions must be true

-- Retrieves all customers from USA and score > 500
SELECT *
FROM
	customers
WHERE 
	country = 'USA' AND
	score > 500;

-- Retrieves customers from Germany OR score less than or eqyal to 500
SELECT *
FROM
	customers
WHERE
	country = 'Germany' OR
	score <= 500;

	-- Retrieves all customers not from USA;
SELECT *
FROM
	customers
WHERE
	NOT (country = 'USA');


--1.3 Range operator (BETWEEN)
-- Retrieves all customers whose score falls in the range between 100 and 500;
SELECT *
FROM
	customers
WHERE
	score BETWEEN 100 AND 500;


-- 1.4 Membership opearator:
-- Retrieves all customrs from either Germany or USA;
SELECT *
FROM
	customers
WHERE
	country IN ('Germany', 'USA');


-- Retrieves all customrs NOT from either Germany or USA;
SELECT *
FROM
	customers
WHERE
	country  NOT IN ('Germany', 'USA');

-- 1.5 Search operator (LIKE) -- (%, _)
SELECT *
FROM
	customers
WHERE
	country LIKE 'U%';

-- Retrieves all customers whose first name starts with M
SELECT *
FROM
	customers
WHERE
	first_name LIKE 'M%';


--- 2. Combining Data (Joins, set)
--2.1 Join in sql (INNER JOIN, FULL JOIN, LEFT JOIN, RIGHT JOIN)

SELECT *
FROM customers;

SELECT *
FROM orders;

-- Get all customers along with their orders, but only for customers who placed an order
SELECT 
	c.id,
	c.first_name,
	c.country,
	o.order_id,
	o.order_date, 
	o.sales
FROM	
	customers c
INNER JOIN
	orders o
ON c.id = o.customer_id;


-- LEFT JOIN: Returns all rows from left and only matching rows from right table But NULL for unmatching values
SELECT 
	c.id,
	c.first_name,
	c.country,
	o.order_id,
	o.order_date, 
	o.sales
FROM	
	customers c
LEFT JOIN
	orders o
ON c.id = o.customer_id;

-- RIGHT JOIN: Retrieves all rows from the right table and matching rows value from the left table
-- Retrieves all customers along with their orders ,including orders without matching customers.
SELECT 
	c.id,
	c.first_name,
	c.country,
	o.order_id,
	o.order_date, 
	o.sales
FROM	
	customers c
RIGHT JOIN
	orders o
ON c.id = o.customer_id;

-- FULL JOIN: Returns everythings from combined tables even if there is not match
SELECT 
	c.id,
	c.first_name,
	c.country,
	o.order_id,
	o.order_date, 
	o.sales
FROM	
	customers c
FULL JOIN
	orders o
ON c.id = o.customer_id;


-- SQL Advance :
-- LEFT ANTI JOIN
-- A LEFT ANTI JOIN is a specialized join that returns only rows from the left table that do 
-- not have matching rows in the right table. It's essentially the opposite of an INNER JOIN.

-- Get all customers who haven't placed any orders;
SELECT 
	c.id,
	c.first_name,
	c.country,
	o.order_id,
	o.order_date, 
	o.sales
FROM	
	customers c
LEFT JOIN
	orders o
ON c.id = o.customer_id
WHERE
	o.customer_id IS NULL;


SELECT
	id,
	first_name
FROM
	customers
WHERE 
	id NOT IN ( SELECT customer_id
				FROM orders WHERE
					customer_id IS NOT NULL);

-- RIGHT ANTI JOIN: Returns all the rows from right table that has not match in left table

--- Get all orders without matching customers

SELECT
	order_id,
	sales,
	customer_id
FROM
	orders o
LEFT JOIN
	customers c
ON o.customer_id = c.id
WHERE
	c.id IS NULL;

-- USING THE most optimal solutiions:
SELECT 
    o.order_id,
    o.sales,
	o.customer_id
FROM 
    orders o
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM customers c 
        WHERE c.id = o.customer_id
    );


-- FULL ANTI JOIN: Returns only rows that don't match in either tables

-- FInd the customers without oreders and orders without customers
SELECT *
FROM
	customers 
FULL JOIN
	orders
ON
	customers.id = orders.customer_id
WHERE
	customers.id IS NULL OR orders.customer_id IS NULL;


	-- Get all customers along with their orders, but only for customers who have places order?
-- WIHTOUT using INER JOIN:

-- using LEFT JOIN
SELECT *
FROM	
	customers AS c
LEFT JOIN
	orders AS o
ON c.id = o.customer_id
WHERE
	o.customer_id IS NOT NULL;



SELECT 
	*
FROM
	customers
WHERE id IN (SELECT customer_id
						FROM orders
							WHERE customer_id IS NOT NULL);


-- CROSS JOIN: Combines Every rows from left with every row from right 

-- Generate all possible combinations of customers and orders;

SELECT *
FROM
	customers
CROSS JOIN
	orders;







