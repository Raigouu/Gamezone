/*
==========================================================================
DDL Script: Create orders_final view
==========================================================================
Script purpose:
	This script creates views for the the final version of orders table.
	The orders_final represents the final dimension and fact tables.

	This view performs transformations and combines data from the clean
	version to produce a clean, enriched, and business-ready dataset.

Usage:
	- This view can be queried directly for analytics and reporting.	
=========================================================================
*/

IF OBJECT_ID('orders_final', 'V') IS NOT NULL
	DROP VIEW orders_final;
GO

CREATE VIEW orders_final AS
	SELECT
		user_id,
		order_id,
		purchase_ts_clean,
		ship_ts,
		time_to_ship,
		product_name_clean,
		product_id,
		usd_price_clean,
		purchase_platform,
		marketing_channel_clean,
		country_code_clean,
		CASE
			WHEN country_code_clean = 'EU' AND region_clean IS NULL THEN 'EMEA'
			WHEN country_code_clean = 'AP' AND region_clean IS NULL THEN 'APAC'
			ELSE region_clean
		END region_clean
	FROM (
	SELECT 
		user_id,
		order_id,
		purchase_ts_clean,
		ship_ts,
		product_name_clean,
		DATEDIFF(day, purchase_ts_clean, ship_ts) AS time_to_ship,
		product_id,
		usd_price_clean,
		purchase_platform,
		marketing_channel_clean,
		country_code_clean,
		region_clean
	FROM orders_clean o
	LEFT JOIN region_clean r
	ON o.country_code_clean = r.country_code
	) t;