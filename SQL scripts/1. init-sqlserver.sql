/*
=============================================================
Database Creation and Table Setup Script
=============================================================
Script Purpose:
    This script creates a new SQL Server database named 'Gamezone1'. 
    If the database already exists, it is dropped to ensure a clean setup. 
    The script then creates three tables: 'orders' and 'region' 
    with their respective schemas, and populates them with sample data.
    
WARNING:
    Running this script will drop the entire 'Gamezone1' database if it exists, 
    permanently deleting all data within it. Proceed with caution and ensure you 
    have proper backups before executing this script.
*/
USE master;
GO

-- Drop and re-create 'Gamezone1' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Gamezone1')
BEGIN
    ALTER DATABASE Gamezone1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Gamezone1;
END;
GO

-- Create the 'Gamezone1' database
CREATE DATABASE Gamezone1;
GO

USE Gamezone1;
GO

-- ======================================================
-- Table: orders
-- ======================================================
IF OBJECT_ID ('orders', 'U') IS NOT NULL
	DROP TABLE orders;

CREATE TABLE orders(
	user_id VARCHAR(50),
	order_id VARCHAR(50),
	purchase_ts VARCHAR(50),
	ship_ts DATE,
	product_name VARCHAR(50),
	product_id VARCHAR(50),
	usd_price FLOAT,
	purchase_platform VARCHAR(50),
	marketing_channel VARCHAR(50),
	account_creation_method VARCHAR(50),
	country_code VARCHAR(50)
);

-- ======================================================
-- Table: region
-- ======================================================
IF OBJECT_ID ('region', 'U') IS NOT NULL
	DROP TABLE region;

CREATE TABLE region(
	country_code VARCHAR(50),
	region VARCHAR(50)
);