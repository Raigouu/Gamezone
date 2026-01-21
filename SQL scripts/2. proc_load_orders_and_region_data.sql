/*
==============================================================================
Stored Procedure: Load Gamezone Data (Source -> Database)
==============================================================================
Script Purpose:
	This stored procedure loads data into 'Gamezone1' database
	from external CSV files.
	It performs the following actions:
	- Truncates tables before loading data.
	- Uses the 'BULK INSERT' command to load data from CSV files to tables.

Usage example:
	EXEC load_gamezone
==============================================================================
*/
CREATE OR ALTER PROCEDURE load_gamezone AS
BEGIN
	DECLARE 
		@start_time DATETIME, 
		@end_time DATETIME,
		@batch_start DATETIME,
		@batch_end DATETIME;

	BEGIN TRY
		SET @batch_start = GETDATE();
		PRINT '=================================';
		PRINT 'Begin loading data into tables';
		PRINT '=================================';
		PRINT '';
		PRINT '---------------------------------';
		PRINT 'Begin loading into "orders"'
		PRINT '---------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating table: orders';
		TRUNCATE TABLE orders;
		PRINT '>> Inserting data into: orders';
		BULK INSERT orders
		FROM 'D:\Project datasets\Gamezone1\Gamezone-orders-data.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------';

		PRINT '---------------------------------';
		PRINT 'Begin loading into "region"'
		PRINT '---------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating table: region';
		TRUNCATE TABLE region;
		PRINT '>> Inserting data into: region';
		BULK INSERT region
		FROM 'D:\Project datasets\Gamezone1\Gamezone-region-data.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------';
		SET @batch_end = GETDATE();
		PRINT '=================================';
		PRINT 'Data loading duration: ' + CAST(DATEDIFF(second, @batch_start, @batch_end) AS NVARCHAR) + ' seconds';
		PRINT '=================================';
	END TRY
	BEGIN CATCH
		PRINT '=================================';
		PRINT 'ERROR OCCURED DURING LOADING DATA';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END