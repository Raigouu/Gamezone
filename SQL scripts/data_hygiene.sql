/*
========================================================================
Data hygiene: orders & region table cleaning
========================================================================
Script purpose:
	This script evaluates each column in the raw version of each table.
========================================================================
*/

-- ORDERS
SELECT * FROM orders;
-- 'order_id' - unique identifier
-- Objective: duplicates
-- Expectations: no duplicates
-- Result: 145 duplicates
SELECT
	order_id,
	count(user_id) user_id
FROM orders
GROUP BY order_id
HAVING COUNT(user_id) > 1;

/* 
This query found that there are 2 cases of duplicated order_id from a sample of 7 order_id
Cases:
	1. Different user_id, but same order_id
	2. Same user_id and same order_id
Conclusion:
	Since there are only 145 rows out of 21,864 (0.66%), they will be left as is.
*/
SELECT
	user_id,
	order_id,
	purchase_ts,
	product_name,
	usd_price,
	purchase_platform,
	marketing_channel,
	account_creation_method,
	country_code
FROM orders
WHERE order_id IN ('ec21fb7726e6954', 'fc629d3dc5474356', 'ef06b84c1df99474', 'fdbaf08293639583', 'fc848001f4117053', 'f440774b7f746547', 'ea1e3aeee3b9432');

-- 'purchase_ts'
-- Objective: Sanity check
-- Expectations: consistent data format, timeline in the same period (2019-2020)
-- Findings: 1 blank (sql turned it into 1900-01-01), 4 nulls and inconsistent data format (DATE & DATETIME)

SELECT 
	MAX(purchase_ts) AS max_date,
	MIN(purchase_ts) AS min_date
FROM orders;

SELECT
	purchase_ts
FROM orders
where purchase_ts = '';

SELECT DISTINCT
	purchase_ts
FROM orders;

SELECT
	TRY_CONVERT(DATE, purchase_ts) AS purchase_ts_clean
FROM orders
ORDER BY purchase_ts_clean;

/*
Conclusion
	5 data out of 21,864 are invalid and there is no way to retrieve correct data. Therefore, it will be left as is.
*/

-- 'ship_ts'
-- Objective: Sanity check
-- Expectations: consistent data format, timeline in the same period (2019-2020)
-- Result: 98 data is outside the evaluated period (2019-2020). Therefore, another column will be made to check the time to ship

SELECT 
	MAX(ship_ts) AS max_date,
	MIN(ship_ts) AS min_date
FROM orders;

SELECT
	ship_ts
FROM orders
where ship_ts = '';

SELECT DISTINCT
	ship_ts
FROM orders
WHERE ship_ts <= '2019-01-01' or ship_ts >= '2020-12-31'
ORDER BY ship_ts;

-- 'product_name'
-- Objective: Sanity check
-- Expectations: consistent naming standard
-- Result: 1 product(gaming monitor) had a naming inconsistency and has been changed into 27" 4k Gaming Monitor.

SELECT DISTINCT
	product_name
FROM orders;

SELECT DISTINCT
	CASE
		WHEN product_name LIKE '27%' THEN '27" 4k Gaming Monitor'
		ELSE product_name
	END product_name_clean
FROM orders;

-- product_id
-- Objective: Sanity check
-- Expectations: no blanks, consistent naming standard
-- Result: no blanks and consistent naming standard

SELECT DISTINCT
	product_id
FROM orders
ORDER BY product_id;

-- usd_price
-- Objective: Sanity check
-- Expectations: price > 0 and no nulls
-- Result: there are 34 rows that is a mix of $0 and NULLs. Since there are no way of retrieving data, NULLs will be replaced with $0

SELECT
	usd_price
FROM orders
WHERE usd_price = 0 OR usd_price IS NULL
ORDER BY usd_price;

SELECT
	usd_price,
	COALESCE(usd_price, 0) AS usd_price_clean
FROM orders
ORDER BY usd_price;

-- purchase platform
-- Objective: Sanity check
-- Expectations: consistent naming standard, no blanks
-- Result: it is as expected

SELECT DISTINCT
	purchase_platform
FROM orders;

-- marketing_channel
-- Objective: Sanity check
-- Expectations: consistent naming standard, no blanks
-- Result: found inconsistency in NULLs, but there is an 'unknown' data. Therefore, all NULLs will be converted into 'unknown'

SELECT DISTINCT
	marketing_channel
FROM orders;

SELECT
	marketing_channel,
	COALESCE(marketing_channel, 'unknown') AS marketing_channel_clean
FROM orders
ORDER BY marketing_channel;

-- account_creation_method
-- Objective: Sanity check
-- Expectations: consistent naming standard, no blanks
-- Result: found inconsistency in NULLs, but there is an 'unknown' data. Therefore, all NULLs will be converted into 'unknown'

SELECT DISTINCT
	account_creation_method
FROM orders;

SELECT
	account_creation_method,
	COALESCE(account_creation_method, 'unknown') AS account_creation_method_clean
FROM orders
ORDER BY account_creation_method;

-- country_code
-- Objective: Sanity check
-- Expectations: consistent naming standard, no blanks
-- Result: found 37 nulls. Therefore, it will be replaced with 'unknown'.

SELECT DISTINCT
	country_code
FROM orders
ORDER BY country_code;

SELECT
	COALESCE(country_code, 'unknown') AS country_code_clean
FROM orders
WHERE country_code IS NULL
ORDER BY country_code;

-- REGION
-- country_code
-- Objective: Sanity check
-- Expectations: no blanks, no NULLs, standaridized naming
-- Result: no blanks, no NULLs, standaridized naming

SELECT DISTINCT
	country_code
FROM region
ORDER BY country_code;

SELECT 
	country_code
FROM region
ORDER BY country_code;

-- region
-- Objective: Sanity check
-- Expectations: no blanks, no NULLs, standardized naming
-- Result: found NULLs and inconsistency. However, since there is a country code for each of the missing and inconsistency, there is a way to find and retrieve data. 
-- IE and LB are included into EMEA, while MH and PG are included into APAC.

SELECT DISTINCT
	region
FROM region
ORDER BY region;

SELECT 
	*
FROM region
WHERE region IS NULL OR region = 'x.X';

SELECT
	country_code,
	CASE
		WHEN country_code IN ('IE', 'LB') THEN 'EMEA'
		WHEN country_code IN ('MH', 'PG') THEN 'APAC'
		ELSE region
	END AS region_clean
FROM region;

-- LEFT JOIN orders.clean with region.clean
-- Findings: after joining, there are new NULLs in region_clean column due to the fact that in country_code_clean there is unassigned region code.
-- the values of country_code are 'EU' and 'AP'. After searching the web, turns out EU and AP are short for Europe and Asia Pacific
-- Therefore, 'EU' is assigned to EMEA and 'AP' to APAC

SELECT
	user_id,
	order_id,
	purchase_ts,
	ship_ts,
	product_name,
	product_id,
	usd_price,
	purchase_platform,
	marketing_channel,
	country_code,
	CASE
		WHEN country_code IN ('IE', 'LB') THEN 'EMEA'
		WHEN country_code IN ('MH', 'PG') THEN 'APAC'
		WHEN country_code = 'EU' AND region IS NULL THEN 'EMEA'
		WHEN country_code = 'AP' AND region IS NULL THEN 'APAC'
		ELSE region
	END region
FROM (
SELECT 
	user_id,
	order_id,
	purchase_ts,
	ship_ts,
	product_name,
	product_id,
	usd_price,
	purchase_platform,
	marketing_channel,
	o.country_code,
	region
FROM orders o
LEFT JOIN region r
ON o.country_code = r.country_code
) t;

-- NEW COLUMN AFTER CLEANING
-- 'time_to_ship'
-- Objective: to find irregularities in purchase_ts_clean and ship_ts
-- Expectations: purchase date < shipping date (positive value)
-- Result: 2002 rows have invalid time_to_ship. Since total rows are 21,864 (+- 10%), they will be left as it is.

SELECT 
	purchase_ts_clean,
	ship_ts,
	DATEDIFF(day, purchase_ts_clean, ship_ts) AS time_to_ship
FROM orders_clean
WHERE DATEDIFF(day, purchase_ts_clean, ship_ts) < 1;