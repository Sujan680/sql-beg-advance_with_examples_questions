
-- Stored Procedure in sql
/*
	-Stored procedures are powerful database objects that encapsulate a set of SQL statements for reuse. 
	-They offer several advantages including improved performance, security, and code maintainability.
*/

-- Syntax::
		-- Stored Procedure Definition
		/*
			CREATE PROCEDURE ProcedureName AS
			BEGIN
				---
				---SQL Statement Go here
			END
		*/
		-- Stored Procedure Execution:

		-- EXEC ProcedureName

		--Q. Step 1 Write a QUEry 
		-- FOr US Customers Find the total number of customers and the average score;

		SELECT
			COUNT(*) TotalCustomers,
			AVG(Score) AvgScore
		FROM
			Sales.Customers
		WHERE
			Country = 'USA';

		-- step 2: Turning the Queryinto a Stored Procedure

		CREATE PROCEDURE GetCustomerSummary AS
		BEGIN
			SELECT
			COUNT(*) TotalCustomers,
			AVG(Score) AvgScore
			FROM
				Sales.Customers
			WHERE
				Country = 'USA'
		END;

		-- Step 3: Execute the storeed Procedure

		EXEC GetCustomerSummary;


	-- Parameters in Stored Procedure:
	-- Placeholders used to pass values as input from the caller to the procedure, allowing dynamic data to be processed

	-- For the German Customers Find the total number of Customers and the Average score.

		CREATE PROCEDURE GetCustomerSummaryInfo @Country NVARCHAR(50) AS
			BEGIN
				SELECT
				COUNT(*) TotalCustomers,
				AVG(Score) AvgScore
				FROM
					Sales.Customers
				WHERE
					Country =@Country
			END;

			EXEC GetCustomerSummaryInfo @Country = 'Germany';

			EXEC GetCustomerSummaryInfo	@Country = 'USA';
	
	-- Dropping the Procedure
		DROP PROCEDURE GetCustomerSummary;


		-- Multiple Statement in Stored Procedure

		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM
			Sales.Orders o
		JOIN
			Sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE
			c.Country = 'USA';


		ALTER PROCEDURE GetCustomerSummaryInfo @Country NVARCHAR(50) AS
			BEGIN
				SELECT
					COUNT(*) TotalCustomers,
					AVG(Score) AvgScore
				FROM
					Sales.Customers
				WHERE
					Country =@Country;

			-- Find the total Number of Orders and total Sales
					SELECT
						COUNT(OrderID) TotalOrders,
						SUM(Sales) TotalSales
					FROM
						Sales.Orders o
					JOIN
						Sales.Customers c
					ON o.CustomerID = c.CustomerID
					WHERE
						c.Country = @Country
				END;

				EXEC GetCustomerSummaryInfo @Country = 'USA';


		-- Variables in stored procedure

		ALTER PROCEDURE GetCustomerSummaryInfo @Country NVARCHAR(50) AS
			BEGIN
			-- creating the variables
			DECLARE @TotalCustomers INT, @AvgScore FLOAT;

				SELECT
					@TotalCustomers = COUNT(*) ,
					@AvgScore = AVG(Score) 
				FROM
					Sales.Customers
				WHERE
					Country =@Country;
				-- using the variables
				PRINT 'Total Customers from ' + @Country  +':' + CAST(@TotalCustomers AS NVARCHAR);
				PRINT 'Average Score from ' + @Country  +':' + CAST(@AvgScore AS NVARCHAR);

			-- Find the total Number of Orders and total Sales
					SELECT
						COUNT(OrderID) TotalOrders,
						SUM(Sales) TotalSales
					FROM
						Sales.Orders o
					JOIN
						Sales.Customers c
					ON o.CustomerID = c.CustomerID
					WHERE
						c.Country = @Country
				END;

				EXEC GetCustomerSummaryInfo @Country = 'USA';


		--- COTROL FLOW: NULL must be handled here

		ALTER PROCEDURE GetCustomerSummaryInfo @Country NVARCHAR(50) AS
			BEGIN
			-- creating the variables
			DECLARE @TotalCustomers INT, @AvgScore FLOAT;

			--Prepare & Cleanup Data

			IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
			BEGIN 
				PRINT('Updating NULL scores to 0');
				UPDATE Sales.Customers
				SET Score = 0
				WHERE
					Score IS NULL AND Country = @Country;
			END

			ELSE
			BEGIN
				PRINT('NO NULL Scores FOund');
			END;

			-- Generating reports,
				SELECT
					@TotalCustomers = COUNT(*) ,
					@AvgScore = AVG(Score) 
				FROM
					Sales.Customers
				WHERE
					Country =@Country;
				PRINT 'Total Customers from ' + @Country  +':' + CAST(@TotalCustomers AS NVARCHAR);
				PRINT 'Average Score from ' + @Country  +':' + CAST(@AvgScore AS NVARCHAR);

			-- Find the total Number of Orders and total Sales
					SELECT
						COUNT(OrderID) TotalOrders,
						SUM(Sales) TotalSales
					FROM
						Sales.Orders o
					JOIN
						Sales.Customers c
					ON o.CustomerID = c.CustomerID
					WHERE
						c.Country = @Country
				END;

				EXEC GetCustomerSummaryInfo @Country = 'Germany';
				EXEC GetCustomerSummaryInfo @Country = 'USA';

		-- Error Handling:
		/*
			BEGIN TRY
				-- sql statements
			END TRY

			BEGIN CATCH
				-- sql statements
			END CATCH
		*/

		ALTER PROCEDURE GetCustomerSummaryInfo @Country NVARCHAR(50) AS
			BEGIN
			BEGIN TRY
				-- creating the variables
				DECLARE @TotalCustomers INT, @AvgScore FLOAT;

				--Prepare & Cleanup Data

				IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
				BEGIN 
					PRINT('Updating NULL scores to 0');
					UPDATE Sales.Customers
					SET Score = 0
					WHERE
						Score IS NULL AND Country = @Country;
				END

				ELSE
				BEGIN
					PRINT('NO NULL Scores FOund');
				END;

				-- Generating reports,
					SELECT
						@TotalCustomers = COUNT(*) ,
						@AvgScore = AVG(Score) 
					FROM
						Sales.Customers
					WHERE
						Country =@Country;
					PRINT 'Total Customers from ' + @Country  +':' + CAST(@TotalCustomers AS NVARCHAR);
					PRINT 'Average Score from ' + @Country  +':' + CAST(@AvgScore AS NVARCHAR);

				-- Find the total Number of Orders and total Sales
						SELECT
							COUNT(OrderID) TotalOrders,
							SUM(Sales) TotalSales
						FROM
							Sales.Orders o
						JOIN
							Sales.Customers c
						ON o.CustomerID = c.CustomerID
						WHERE
							c.Country = @Country;

				END TRY
					BEGIN CATCH
						PRINT('An error occured.');
						PRINT('Error message:' + ERROR_MESSAGE());
						PRINT('Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR));
						PRINT('Error Line:' + CAST(ERROR_LINE() AS NVARCHAR));
						PRINT('Error Procedure:' + ERROR_PROCEDURE());
					END CATCH
				END
				GO

				EXEC GetCustomerSummaryInfo @Country = 'Germany';