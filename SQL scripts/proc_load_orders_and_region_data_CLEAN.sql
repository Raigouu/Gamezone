/*
==================================================================================
Stored Procedure: Load clean gamezone dataset
==================================================================================
Script purpose:
	This stored procedure performs the ETL (Extract, Transform, Load) process to
	populate the 'clean' tables from the 'raw' tables.
	Actions performed:
		- Truncates clean tables
		- Inserts transformed and cleansed data from 'raw' to 'clean' tables.

Usage example:
	EXEC load_clean_gamezone
*/

CREATE OR ALTER PROCEDURE load_clean_gamezone AS
BEGIN
	BEGIN TRY
	DECLARE
		@start_time DATETIME,
		@end_time DATETIME,
		@batch_start DATETIME,
		@batch_end DATETIME;

		SET @batch_start = GETDATE();
		PRINT '========================================';
		PRINT '>> Begin Gamezone clean data loading';
		PRINT '========================================';
		PRINT '';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: orders_clean';
		TRUNCATE TABLE orders_clean;
		PRINT '>> Inserting data into: orders_clean';
		INSERT INTO orders_clean (
			user_id,
			order_id,
			purchase_ts_clean,
			ship_ts,
			product_name_clean,
			product_id,
			usd_price_clean,
			purchase_platform,
			marketing_channel_clean,
			account_creation_method_clean,
			country_code_clean
		)
		SELECT
			user_id,
			order_id,
			TRY_CONVERT(DATE, purchase_ts) AS purchase_ts_clean,
			ship_ts,
			CASE
				WHEN product_name LIKE '27%' THEN '27" 4k Gaming Monitor'
				ELSE product_name
			END product_name_clean,
			product_id,
			COALESCE(usd_price, 0) AS usd_price_clean,
			purchase_platform,
			COALESCE(marketing_channel, 'unknown') AS marketing_channel_clean,
			COALESCE(account_creation_method, 'unknown') AS account_creation_method_clean,
			COALESCE(country_code, 'unknown') AS country_code_clean
		FROM orders;
		SET @end_time = GETDATE();
		PRINT '----------------------------------------------';
		PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------';
		PRINT '';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: region_clean';
		TRUNCATE TABLE region_clean;
		PRINT '>> Inserting data into: region_clean';
		INSERT INTO region_clean (
			country_code,
			region_clean
		)
		SELECT
			country_code,
			CASE
				WHEN country_code IN ('IE', 'LB') THEN 'EMEA'
				WHEN country_code IN ('MH', 'PG') THEN 'APAC'
				ELSE region
			END region_clean
		FROM region;
		SET @end_time = GETDATE();
		PRINT '----------------------------------------------';
		PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------';
	END TRY

	BEGIN CATCH
		PRINT '======================================';
		PRINT 'ERROR OCCURED DURING DATA LOADING';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================';
	END CATCH
END

EXEC load_clean_gamezone