# Gamezone
Exploratory Data Analysis (EDA) and deep dive analysis of Gamezone's product performance during COVID (2019 - 2020).

## **Project Overview**

This project aims to help Gamezone's product team by analyzing product performance during the COVID period (2019-2020) using Google Sheets as the main analysis tool and Tableau as the visualization tool. SQL is only used to show proficiency in using the tool. 

KPIs such as overall sales, sales by product, AOV by product, Sales by Marketing Channel, Sales by Region, Top Product by Channel, and Top Product by Region are used as measurements to find which product performed best during the period. 

## **Dataset** 


The dataset consists of 2 tables, which are 'orders' with a total row of 21,864 and 'region' with a total row of 193. In the table 'orders', with a grain of 1 row represents an order made by a customer. The table has columns of: 

	- user_id
	- order_id
	- purchase_ts (purchase time stamp)
	- ship_ts (shipping time stamp)
	- product_name
	- product_id
	- usd_price
	- purchase_platform
	- marketing_channel
	- account_creation_method
	- country_code

In the table 'region', with a grain of 1 row represents the country code in a region, the table has columns of:

	- country_code
	- region (divided into 4 main regions, which are NA, EMEA, APAC, and LATAM)

The main table of this dataset is the 'orders' table.

## **Objectives**

The analysis result should be able to aid Gamezone's product team in making a decision on which product should be improved or discontinued due to its own performance. 

## **Data Preparation & Cleaning**

During the cleaning process, below is the list of issues were found:
'order' table

	- order_id:
		Even though it is supposed to be the unique identifier, it has duplicates that can be divided into two categories.
			1. same order_id with the same user_id
			2. same order_id with different user_id
		The total row of this issue is 145 rows, since it only represent 0.66% of the data, and there is no way of retrieving the truth of the data, so it is left as it is in order to not lose any value.
	- purchase_ts:
		There are inconsistencies and one blank value in the field, where most rows are in DATE format, while some are in timestamp format (MM-DD-YYYY HH:MM:SS). Therefore, all data are converted into DATE format (MM/DD/YYYY)
	- ship_ts:
		There are invalid dates in the column. Cases such as shipping time before purchase time. The total issue is 2,001 rows. Since there is no way of retrieving the truth of the data, it is left as is.
	- product_name:
		Naming inconsistencies in one product (27in 4k gaming monitor). All of the inconsistencies are converted into standardized naming, which is 27in 4k gaming monitor.
	- usd_price:
		Found 34 rows of blank values and $0 for the price of some products. So, to not miss or delete any rows, all missing values are converted into $0, and there is no way of retrieving the data.
	- marketing_channel:
		Found 83 blank values in the field, but there are 'unknown' values beforehand. Therefore, all blanks are converted into 'unknown'.
	- account_creation_method:
		Found 83 blank values in the field, but there are 'unknown' values beforehand. Therefore, all blanks are converted into 'unknown'.
	- country_code:
		Found 37 blank values in the field, and they are converted into 'unknown' values.

'region' table:

	- region:
		There are naming inconsistencies, missing values, and invalid values. 
		For example, North America and NA, missing region codes for country codes IE and LB, and invalid values for country code MH and PG.
		Since there is a way to retrieve the truth, these values are corrected into their respective region. IE and LB are included in EMEA, and MH and PG are included in APAC.

After joining the tables, there are 5 more errors in the data with values of EU and AP. Therefore, the values in the country code are left as is, and the values in the region field are corrected into EMEA and APAC, respectively.


## **Key Insights**
			
<img width="1751" height="669" alt="image" src="https://github.com/user-attachments/assets/8ade3557-21cc-4bf5-9024-1e57eb0a2647" />

From the pivot table, it is found that the total sales during the COVID period (2019 - 2020) are $6.1 m, with the best performing product being the gaming monitor (almost $2m in total sales) and the worst performing product is the Razer Pro gaming headset ($800).
Peaks of total sales are similar in 2019 and 2020, with them happened at September and December. These occurrences might happen due to them being the start of school and/or holiday seasons, when promotions might be pushed further. Lastly, there seems to be a pattern where total sales tend to drop at the beginning of every new year; assumptions would be that there are no incentives to purchase products. Thus, resulting in the drop in total sales.

<img width="1379" height="141" alt="image" src="https://github.com/user-attachments/assets/5c4bac95-975b-404e-959e-b82bdb94e63f" />

Focusing on the graphs of each product's performance, it is found that all products doubled in their sales during 2020. Moreover, the trends of every product are similar to one another, with peaks at the end of 2020 and a significant drop after.

### Product Analysis
<img width="1200" height="860" alt="image" src="https://github.com/user-attachments/assets/43f53fd9-6dd8-410c-9b07-b67b0a0e4005" />

Above is a dashboard created by Tableau. This dashboard intends to give an overview of product performance throughout the COVID period (2019 - 2020), with additional data for January and February 2021. Focusing on KPIs for the product team to help them make decisions on which products to focus on or to discontinue investing in. 

<img width="1230" height="615" alt="image" src="https://github.com/user-attachments/assets/8a1aaffe-6014-404d-bdf7-d52c9ccfcf2a" />
This graph shows the sales by product with similar behavior throughout the years, peaking in September and December of each year (2019 - 2020) and then dropping significantly at the end of 2020. The top 3 products are the Gaming Monitor, Nintendo Switch, and the Sony PlayStation 5 Bundle. 

<img width="1230" height="615" alt="image" src="https://github.com/user-attachments/assets/9fe3d224-4d09-4e0e-a93a-1878d62a19be" />
This graph shows the product AOV with a focus on the top 3 products that contributed the most to the total sales. The Gaming Monitor and the Nintendo Switch had stable pricing during the COVID period. On the other hand, the PS 5 bundle has fluctuated throughout the years. In 2019, the peak price was $1.859 in January, down to $1,482 in October. While in 2020, the peak price was $1.732 in January and dropped to $1.510 in May, but steadily rose to $1.710 in November. Most likely due to the high demand and/or promotions.

<img width="1360" height="615" alt="image" src="https://github.com/user-attachments/assets/5621fbbf-2b14-49e1-a8b1-3171b40a09f5" />
This graph shows the top 3 product shares by region, with NA dominating the sales of the top 3 products, followed by EMEA and APAC. Nintendo Switch contributed the most in sales in NA and EMEA, while the PS5 contributed the most in APAC and LATAM.

<img width="1360" height="611" alt="image" src="https://github.com/user-attachments/assets/2979f69f-d864-45a7-bf0b-61a2d07ba0a0" />
Product Share by Marketing Channel







