-- Strings FUnctions
-- 1. Row level Functions
---1.1 Manipulation

-- 1.1.1 CONCAT-- Combines multiple strings in one column

SELECT
	first_name,
	country,
	CONCAT(first_name, ',' , country) as name_country
FROM
	customers;

-- 1.2 UPPER: Converts into upper case 
-- Transfomrs the customer's first_name into lowercase
SELECT 
	first_name,
	lower(first_name) as low_name
FROM
	customers;

-- 1.3 LOWER: Converts into lower case 
-- Transfomrs the customer's first_name into uppercase
SELECT 
	first_name,
	upper(first_name) as upp_name
FROM
	customers;


	--1.4 TRIM functions: Clear spaces from the values
-- Find the customers whose first name contains leading or trailing spaces

	SELECT 
		first_name
	FROM
		customers
	WHERE
		first_name != TRIM(first_name);

-- 1.5 Replace function

SELECT 
	'123-456-789' as phone,
	REPLACE('123-456-789', '-', '') as clean_phone;

	-- Replace file extence from txt to csv

	SELECT
		'report.txt' as old_file,
		REPLACE('report.txt','.txt','.csv') as new_file;


	-- 1.2 CALCULATION : LEN Function

	SELECT
		first_name,
		LEN(first_name) as len_name
	FROM
		customers;

	-- 1.3 String Extraction Function

	-- 1.3.1 LEFT and RIGHT function
	-- Retrievees the first two character of each customers first name
	SELECT
		first_name,
		LEFT(TRIM(first_name),2) as first_two
	FROM
		customers;

-- -- Retrievees the last two character of each customers first name
	
	SELECT
		first_name,
		RIGHT(TRIM(first_name),2) as lst_two
	FROM
		customers;


-- 1.3.2 SUBSTRING(value, start, len): Extract a part of strings at a specified text

	SELECT
		first_name,
		SUBSTRING(TRIM(first_name), 2, LEN(first_name)) as sub_name
	FROM
		customers;

--- Numbers Functions:
-- ROUND:

SELECT
	3.516,
	ROUND(3.516, 2) as round_2,
	ROUND(3.516, 1) as round_1,
	ROUND(3.516, 0) as round_0;

-- ABS:
SELECT
	-10,
	ABS(-10) as abs_val;
	

	