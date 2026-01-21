/*
================================================================================
DDL Script: Create clean tables
================================================================================
Script purpose:
	This script creates tables for the clean version, dropping existing tables
	if they already exist.
	Run this script to re-define the DDL structure of 'raw' tables
================================================================================
*/
IF OBJECT_ID('orders_clean', 'U') IS NOT NULL
	DROP TABLE orders_clean;
GO

CREATE TABLE orders_clean (
	user_id VARCHAR(50),
	order_id VARCHAR(50),
	purchase_ts_clean DATE,
	ship_ts DATE,
	product_name_clean VARCHAR(50),
	product_id VARCHAR(50),
	usd_price_clean FLOAT,
	purchase_platform VARCHAR(50),
	marketing_channel_clean VARCHAR(50),
	account_creation_method_clean VARCHAR(50),
	country_code_clean VARCHAR(50)
);
GO

IF OBJECT_ID('region_clean', 'U') IS NOT NULL
	DROP TABLE region_clean;
GO

CREATE TABLE region_clean (
	country_code VARCHAR(50),
	region_clean VARCHAR(50)
);