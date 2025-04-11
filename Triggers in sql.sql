
-- Triggers in sql:
/*
-Triggers are special types of stored procedures that automatically execute (or "fire") in response to 
-specific database events, such as INSERT, UPDATE, DELETE, or DDL operations. 
-They are used to enforce business rules, maintain data integrity, log changes, and automate tasks.
*/
	/*
		CREATE TRIGGER trigger_name
		ON table_name
		{BEFORE | AFTER | INSTEAD OF} {INSERT | UPDATE | DELETE}
		AS
		BEGIN
			-- Trigger logic
		END;
	*/

	-- Step 1: Create log Table

	CREATE TABLE Sales.EmployeeLogs (
		LogID INT IDENTITY(1,1) PRIMARY KEY,
		EmployeeID INT,
		LogMessage VARCHAR(255),
		LogDate DATE
	)

	-- Step 2 : Create Triggers On Employees Table
	CREATE TRIGGER trg_AgfterInsertEmployee ON Sales.Employees
	AFTER INSERT
	AS	
	BEGIN
		INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
		SELECT
			EmployeeID,
			'New Employee Added=' + CAST(EmployeeID AS VARCHAR),
			GETDATE()
		FROM
			INSERTED
	END
		
	SELECT *
	FROM
		Sales.EmployeeLogs;

	-- step 3: Insert data into Employee Table

	
	SELECT *
	FROM
		Sales.Employees;

	INSERT INTO Sales.Employees 
	VALUES
	(7, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);
