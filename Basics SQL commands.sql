
USE MyDatabase;

-- Extracting the table from customers table

SELECT *
FROM
	customers;

-- Selecting the only required columns
SELECT
	first_name,
	country,
	score
FROM
	customers;

-- WHERE -- Filters your data based on a condition
SELECT *
FROM
	customers
WHERE
	score != 0;

-- Retrieves customers from Germany
SELECT	
	first_name,
	country
FROM
	customers
WHERE
	country = 'Germany';


-- Order By -Used to sort column in ascending or descending order
-- Retrieves all customers and sort the results by the highest score first.
SELECT
	*
FROM
	customers
ORDER BY
	score DESC;

-- Retrieves all cusstomers and sort the results by the country and then by the highest score

SELECT *
FROM
	customers
ORDER BY
	country ASC,
	score DESC;

-- GROUP BY - Combines the rows with the same value
-- FInd the total score by each country
SELECT 
	country,
	SUM(score) as total_score
FROM
	customers
GROUP BY 
	country;

-- All columns in the SELECT must be either aggregated or included in GROUP BY clasue
SELECT 
	first_name,
	country,
	SUM(score) as total_score
FROM
	customers
GROUP BY 
	first_name,
	country;

-- Find the total score and total number of customers for each country
SELECT 
	country,
	SUM(score) as total_score,
	COUNT(id) as total_customer
FROM
	customers
GROUP BY 
	country;

-- Having Clause: Filters the data after Aggregation
-- Find the average score for each country considering only customers with score not equal to 0
-- and return only those countries with an average score greater than 430
SELECT 
	country,
	AVG(score) as avg_score
FROM
	customers
WHERE
	score != 0
GROUP BY 
	country
HAVING
	AVG(score) > 430;

-- DISTINCT - Removes duplicates values from table
-- Return unique list of all countries
SELECT
	DISTINCT country AS unique_country
FROM
	customers;

-- TOP(LIMIT) : Restrict the rows to be retrieved
SELECT TOP 3 *
FROM
	customers;

-- Retrievs top 3 customers with the highest scores
SELECT TOP 3 *
FROM
	customers
ORDER BY
	score DESC;

USE MyDatabase;

SELECT *
FROM
	orders;


-- Get the two most recent Orders
SELECT TOP 2 *
FROM
	orders
ORDER BY
	order_date DESC;

-- DDL: Define the structure of you data (Create, ALTER, DROP)
-- Create a new table persons:

DROP TABLE persons;

CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_data DATE,
	phone VARCHAR(20) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)


ALTER TABLE persons 
ADD email VARCHAR(30) NOT NULL;

SELECT *
FROM persons;

ALTER TABLE persons 
DROP COLUMN phone;

SELECT *
FROM persons;

DROP TABLE persons;

-- DML: Modify the data in tables (INSERT, UPDATE, DELETE)

INSERT INTO customers (id, first_name, country, score)
VALUES
(6, 'Anna', 'USA', NULL ),
(7, 'Sam', NULL, 100 );

SELECT *
FROM
	customers;



CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_data DATE,
	phone VARCHAR(20) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)



-- Insert data from customers into persons
INSERT INTO persons (id, person_name, birth_data, phone)
SELECT 
	id,
	first_name,
	NULL,
	'Unknown'
FROM
	customers;

SELECT *
FROM
	persons;

UPDATE customers
SET 
	score = 0
WHERE 
	id = 6;

SELECT *
FROM
	customers;

UPDATE customers
SET
	country = 'UK',
	score = 300
WHERE
	id = 7;


SELECT *
FROM
	customers;


UPDATE customers
SET
	score = 250
WHERE
	score = 0;

SELECT *
FROM
	customers;

INSERT INTO customers(id, first_name)
VALUES (8, 'Sahara');

DELETE FROM customers
WHERE id > 5;

SELECT *
FROM
	customers;


-- Delete all the data from persons

TRUNCATE TABLE perosns;

