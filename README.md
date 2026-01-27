# Gamezone
Exploratory Data Analysis (EDA) and deep dive analysis of Gamezone's product performance during COVID (2019 - 2020).

## **Project Overview**

This project aims to help Gamezone's product team by analyzing product performance during the COVID period (2019-2020) using Google Sheets as the main analysis tool and Tableau as the visualization tool. SQL is only used to show proficiency in using the tool. Click the [link](https://github.com/Raigouu/Gamezone/tree/main/SQL%20scripts) to see the SQL data hygiene script.

KPIs such as overall sales, sales by product, AOV by product, Sales by Marketing Channel, Sales by Region, Top Product by Channel, and Top Product by Region are used as measurements to find which product performed best during the period. 

## **Dataset** 


The dataset consists of 2 tables, which are 'orders' and 'region'. The table 'orders' has one row for each order detail made by a customer. On the other hand, the 'region' table has one row that corresponds to a country in a region (focusing on NA, EMEA, APAC, and LATAM). Links to the dataset can be found [here](https://github.com/Raigouu/Gamezone/tree/main/Excel).

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
		Since there is a way to retrieve the truth, these values are corrected in their respective region. IE and LB are included in EMEA, and MH and PG are included in APAC.

After joining the tables, there are 5 more errors in the data with values of EU and AP. Therefore, the values in the country code are left as is, and the values in the region field are corrected into EMEA and APAC, respectively.


## **Key Insights**
### **Overall Performance**
			
<img width="1750" height="670" alt="image" src="https://github.com/user-attachments/assets/8ade3557-21cc-4bf5-9024-1e57eb0a2647" /><br/>
Total sales during the COVID period (2019 - 2020) are $6.1 m, with the best-performing product being the gaming monitor (almost $2m in total sales), and the worst-performing product was the Razer Pro gaming headset ($800).
Peaks of total sales are similar in 2019 and 2020, which happened in September and December, indicating seasonality-driven demand rather than COVID being the main driver of sales. Lastly, there seems to be a pattern where total sales tend to drop at the beginning of every new year; assumptions would be that there were no incentives to purchase products. Thus, resulting in a drop in total sales.<br/>

<img width="1380" height="140" alt="image" src="https://github.com/user-attachments/assets/5c4bac95-975b-404e-959e-b82bdb94e63f" /><br/>
All products doubled in sales during 2020. Moreover, the trends of every product are similar to one another, with peaks at the end of 2020 and a significant drop after.<br/>

### Product Analysis
<img width="1200" height="815" alt="image" src="https://github.com/user-attachments/assets/98d97dd3-00f8-4aff-a775-bb6ce2386715" /><br/>
This dashboard intends to give an overview of product performance throughout the COVID period (2019 - 2020), with additional data for January and February 2021. Focusing on KPIs for the product team to help them make decisions on which products to focus on or to discontinue investing in. The majority of sales are derived from NA compared to other regions.<br/>

<img width="1230" height="615" alt="image" src="https://github.com/user-attachments/assets/8a1aaffe-6014-404d-bdf7-d52c9ccfcf2a" /><br/>
The PlayStation 5 Bundle outperformed the other top products at the end of 2020, but declined much more steeply than the other two. As one of the top sales contributors, this could heavily affect the total revenue. The product and finance team should investigate the next steps, such as pricing strategy and bundling strategy, to maintain revenue over the year. <br/>

<img width="1230" height="615" alt="image" src="https://github.com/user-attachments/assets/9fe3d224-4d09-4e0e-a93a-1878d62a19be" /><br/>
The Gaming Monitor and the Nintendo Switch had stable pricing during the COVID period. On the other hand, the PS 5 bundle has fluctuated throughout the years. In 2019, the peak price was $1.859 in January, down to $1,482 in October. While in 2020, the peak price was $1.732 in January and dropped to $1.510 in May, but steadily rose to $1.710 in November. This instability in pricing could impact consumer and business confidence, such as consumer spending and ineffective investments. However, it can also be caused by inflation during the period, as people are spending less on tertiary needs and spending more on primary needs. Investigation on other drivers that could cause the price fluctuations is recommended.<br/>

<img width="1360" height="615" alt="image" src="https://github.com/user-attachments/assets/5621fbbf-2b14-49e1-a8b1-3171b40a09f5" /><br/>
Nintendo Switch contributed the most in sales in NA and EMEA, while the PS5 contributed the most in APAC and LATAM. Also, more than 50% of sales are derived from NA, which could cause disproportion in the future. Discuss with the respective region marketing teams in enhancing their strategies to increase sales in EMEA, APAC, and LATAM to balance out the sales. <br/>

<img width="1360" height="615" alt="image" src="https://github.com/user-attachments/assets/2979f69f-d864-45a7-bf0b-61a2d07ba0a0" /><br/>
Direct sale is overwhelming other marketing channels (more than 80% of sales come from the direct channel), followed by the rising effect of email and affiliate channels. This should be voiced to the marketing team to improve the email and affiliate channel to help with promoting the company and/or get more exposure to gain more customers that will help generate more sales. Also, proportional marketing channels will help the company not depend on only one marketing channel.

## **Recommendation**
From the insights retrieved below are the recommendations for the product team and marketing team:
Product team:

	- Investigate the main drivers of the significant increase and the steep decline in 2020 sales of PS5 in EMEA
	- Investigate why the Razer Pro Gaming Headset did not perform as expected and decide whether to continue or discontinue investing in it
	- Collaborate with the finance team to stabilize pricing to create consumer and business confidence

Marketing team:
	
	- Focus on improving other marketing channels, such as email and affiliate. As they are showing the probability of growth in reaching potential customers.
	- Might be able to look into the social media marketing channel as an alternative, since people will not be able to go outside as much during COVID.

Finance team:

	- Investigate why the PS5 bundle fluctuated as much throughout the years. 
	- Collaborate with the product team on bundling strategies to attract more customers to spend

Priorities:

	- High Priority		: improve on other marketing channels, such as email and affiliate marketing
	- Medium Priority	: product investment decision
	- Low Priority		: PS 5 pricing strategy  
	
## **Limitations & Assumptions**
The data analyzed does not represent the whole reason why Gamezone's total sales behaved. The current dataset focused more on products and internal factors that may impact product performance. Missing supporting data for the marketing team also made the analysis incomplete. During the period, there could be other drivers that significantly affect Gamezone's sales, such as government policies, psychological behavior, health concerns, and other external factors. Lastly, data regarding pricing strategy could be appreciated to find what is going on with the PS5 fluctuations.


