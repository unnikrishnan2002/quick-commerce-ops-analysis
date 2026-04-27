-- Database Creation 
Create Database quick_commerce;
use quick_commerce;

-- Preparing the table columns
Create Table qc_orders (
	Order_ID TEXT,
    Company TEXT,
    City TEXT,
    Customer_Age TEXT,
    Order_Value TEXT,
    Delivery_Time_Min TEXT,
    Distance_Km TEXT,
    Items_Count TEXT,
    Product_Category TEXT,
    Payment_Method TEXT,
    Customer_Rating TEXT,
    Discount_Applied TEXT,
    Delivery_Partner_Rating TEXT
);

-- Importing the data
Load Data Infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/quick_commerce_data_raw.csv'
Into table qc_orders
Fields Terminated by ','
Enclosed by '"'
Lines Terminated by '\n'
Ignore 1 rows;


-- Sanity checks
Select count(*) from qc_orders;
Select * from qc_orders limit 10;

-- DATA EXPLORATION
Select count(*) as total_rows from qc_orders;

Select 
	SUM(Case when Order_id='' or Order_id IS NULL then 1 else 0 end) as Order_id_blanks,
    SUM(Case when Company='' or Company IS NULL then 1 else 0 end) as Company_blanks,
    SUM(Case when City='' or City IS NULL then 1 else 0 end) as City_blanks,
    SUM(Case when Customer_Age='' or Customer_Age IS NULL then 1 else 0 end) as Customer_Age_blanks,
    SUM(Case when Order_Value='' or Order_Value IS NULL then 1 else 0 end) as Order_Value_blanks,
    SUM(Case when Delivery_Time_Min='' or Delivery_Time_Min IS NULL then 1 else 0 end) as Delivery_Time_Min_blanks,
    SUM(Case when Distance_Km='' or Distance_Km IS NULL then 1 else 0 end) as Distance_Km_blanks,
    SUM(Case when Items_Count='' or Items_Count IS NULL then 1 else 0 end) as Items_Count_blanks,
    SUM(Case when Product_Category='' or Product_Category IS NULL then 1 else 0 end) as Product_Category_blanks,
    SUM(Case when Payment_Method='' or Payment_Method IS NULL then 1 else 0 end) as Payment_Method_blanks,
    SUM(Case when Customer_Rating='' or Customer_Rating IS NULL then 1 else 0 end) as Customer_Rating_blanks,
    SUM(Case when Discount_Applied='' or Discount_Applied IS NULL then 1 else 0 end) as Discount_Applied_blanks,
    SUM(Case when Delivery_Partner_Rating='' or Delivery_Partner_Rating IS NULL then 1 else 0 end) as Delivery_Partner_Rating_blanks
from qc_orders;

SELECT 
    SUM(CASE WHEN ASCII(City) = 13 THEN 1 ELSE 0 END) AS City_cr,
    SUM(CASE WHEN ASCII(Customer_Rating) = 13 THEN 1 ELSE 0 END) AS Rating_cr,
    SUM(CASE WHEN ASCII(Items_Count) = 13 THEN 1 ELSE 0 END) AS Items_cr,
    SUM(CASE WHEN ASCII(Delivery_Partner_Rating) = 13 THEN 1 ELSE 0 END) AS Partner_Rating_cr
FROM qc_orders;

SELECT ASCII(Delivery_Partner_Rating) 
FROM qc_orders
WHERE LENGTH(Delivery_Partner_Rating) = 1
LIMIT 5;

Select Company, Count(*) as order_Count
from qc_orders
group by Company
order by order_count desc;

Select City, Count(*) as order_Count
from qc_orders
group by City
order by order_count desc;

Select Payment_method, Count(*) as order_Count
from qc_orders
group by Payment_method
order by order_count desc;

Select MIN(CAST(Order_Value AS DECIMAL(10,2))), MAX(CAST(Order_Value AS DECIMAL(10,2))), AVG(CAST(Order_Value AS DECIMAL(10,2)))
from qc_orders;

Select MIN(CAST(Customer_age AS DECIMAL(10,2))), MAX(CAST(Customer_age AS DECIMAL(10,2))), AVG(CAST(Customer_age AS DECIMAL(10,2)))
from qc_orders;

Select MIN(CAST(Delivery_Time_Min
 AS DECIMAL(10,2))), MAX(CAST(Delivery_Time_Min
 AS DECIMAL(10,2))), AVG(CAST(Delivery_Time_Min
 AS DECIMAL(10,2)))
from qc_orders;

Select MIN(CAST(Distance_Km
 AS DECIMAL(10,2))), MAX(CAST(Distance_Km
 AS DECIMAL(10,2))), AVG(CAST(Distance_Km
 AS DECIMAL(10,2)))
from qc_orders;

Select MIN(CAST(Customer_rating
 AS DECIMAL(10,2))), MAX(CAST(Customer_rating
 AS DECIMAL(10,2))), AVG(CAST(Customer_rating
 AS DECIMAL(10,2)))
from qc_orders;

SELECT AVG(CAST(Delivery_Partner_Rating AS DECIMAL(10,2)))
FROM qc_orders_cleaned
WHERE ASCII(Delivery_Partner_Rating) != 13;

Select MIN(CAST(items_count
 AS DECIMAL(10,2))), MAX(CAST(items_count
 AS DECIMAL(10,2))), AVG(CAST(items_Count
 AS DECIMAL(10,2)))
from qc_orders;

Select customer_rating
from qc_orders
where CAST(customer_rating
 AS DECIMAL(10,2))=0;


-- DATA CLEANING

CREATE TABLE qc_orders_cleaned AS SELECT * FROM qc_orders;

-- Updating the blank values

SET SQL_SAFE_UPDATES = 0;

Update qc_orders_cleaned
set City="Unknown"
where City='' or City IS NULL;

Update qc_orders_cleaned
set Customer_rating=2.89
where Customer_rating='' or Customer_rating IS NULL;

Update qc_orders_cleaned
set items_count=10
where items_count='' or items_count IS NULL;

Update qc_orders_cleaned
set Delivery_partner_rating=3.74
where ASCII(Delivery_Partner_Rating) = 13 or 
Delivery_partner_rating='' or 
Delivery_partner_rating IS NULL;

-- Checking data again after updation

Select 
	SUM(Case when Order_id='' or Order_id IS NULL then 1 else 0 end) as Order_id_blanks,
    SUM(Case when Company='' or Company IS NULL then 1 else 0 end) as Company_blanks,
    SUM(Case when City='' or City IS NULL then 1 else 0 end) as City_blanks,
    SUM(Case when Customer_Age='' or Customer_Age IS NULL then 1 else 0 end) as Customer_Age_blanks,
    SUM(Case when Order_Value='' or Order_Value IS NULL then 1 else 0 end) as Order_Value_blanks,
    SUM(Case when Delivery_Time_Min='' or Delivery_Time_Min IS NULL then 1 else 0 end) as Delivery_Time_Min_blanks,
    SUM(Case when Distance_Km='' or Distance_Km IS NULL then 1 else 0 end) as Distance_Km_blanks,
    SUM(Case when Items_Count='' or Items_Count IS NULL then 1 else 0 end) as Items_Count_blanks,
    SUM(Case when Product_Category='' or Product_Category IS NULL then 1 else 0 end) as Product_Category_blanks,
    SUM(Case when Payment_Method='' or Payment_Method IS NULL then 1 else 0 end) as Payment_Method_blanks,
    SUM(Case when Customer_Rating='' or Customer_Rating IS NULL then 1 else 0 end) as Customer_Rating_blanks,
    SUM(Case when Discount_Applied='' or Discount_Applied IS NULL then 1 else 0 end) as Discount_Applied_blanks,
    SUM(Case when Delivery_Partner_Rating='' or Delivery_Partner_Rating IS NULL then 1 else 0 end) as Delivery_Partner_Rating_blanks
from qc_orders_cleaned;

SELECT 
    SUM(CASE WHEN ASCII(City) = 13 THEN 1 ELSE 0 END) AS City_cr,
    SUM(CASE WHEN ASCII(Customer_Rating) = 13 THEN 1 ELSE 0 END) AS Rating_cr,
    SUM(CASE WHEN ASCII(Items_Count) = 13 THEN 1 ELSE 0 END) AS Items_cr,
    SUM(CASE WHEN ASCII(Delivery_Partner_Rating) = 13 THEN 1 ELSE 0 END) AS Partner_Rating_cr
FROM qc_orders_cleaned;

Select discount_applied, count(*)
from qc_orders_cleaned
group by discount_applied

-- Applying the correct datatypes to the columns

Alter Table qc_orders_cleaned
Modify Column Order_id VARCHAR(50),
Modify Column Company VARCHAR(50),
Modify Column City VARCHAR(50),
Modify Column Customer_age INT,
Modify Column Order_value DECIMAL(10,2),
Modify Column Delivery_Time_Min DECIMAL(10,2),
Modify Column Distance_Km DECIMAL(10,2),
Modify Column items_count INT,
Modify Column Product_category VARCHAR(100),
Modify Column Payment_method VARCHAR(50),
Modify Column Customer_rating DECIMAL(10,2),
Modify Column Discount_applied BOOLEAN,
Modify Column Delivery_partner_rating DECIMAL(10,2);


-- Sanity check to confirm the changes

SELECT 
    MIN(Order_Value), MAX(Order_Value), AVG(Order_Value),
    MIN(Delivery_Time_Min), MAX(Delivery_Time_Min),
    MIN(Customer_Rating), MAX(Customer_Rating)
FROM qc_orders_cleaned;


-- BUSINESS INSIGHTS

-- BI_1 : Revenue by product category + average order value per category + Averagage value per item
 
 Select Product_category, SUM(Order_value) as Total_Revenue, 
 AVG(Order_value) as AOV, SUM(Order_Value)/SUM(Items_count) as Value_Per_product
 from qc_orders_cleaned
 group by Product_category
 order by Total_revenue desc;
 
 
 -- BI_2 : Average order value by customer age group
 
 -- Checking min max for grouping
 Select MAX(Customer_age), MIN(Customer_age)
 from qc_orders_cleaned;
 
 Select Case
	When Customer_age between 18 and 23 then  '18 - 23'
    When Customer_age between 24 and 29 then  '24 - 29'
    When Customer_age between 30 and 35 then  '30 - 35'
    When Customer_age between 36 and 41 then  '36 - 41'
    When Customer_age between 42 and 47 then  '42 - 47'
    When Customer_age between 48 and 53 then  '48 - 53'
    else '54+'
    end
as Customer_Age_Group, AVG(Order_value) as AOV
from qc_orders_cleaned
group by Customer_Age_Group
order by Customer_Age_group;
    
-- BI_3 : Revenue market share by company

Select Company, SUM(order_value) as Total_Revenue, 
SUM(order_value)/(Select SUM(order_value) from qc_orders_cleaned)*100 as Market_Share_Percentage
from qc_orders_cleaned
group by Company
order by Market_Share_Percentage desc; 

-- BI_4 : Which company has the least average delivery time?

Select Company, AVG(Delivery_time_min) as AVG_Delivery_time
from qc_orders_cleaned
group by Company
order by AVG_Delivery_time;

-- BI_5 : Customer rating by company weighted by order volume

Select Company, AVG(Customer_rating) as AVG_Customer_rating, COUNT(order_id) as No_of_orders
from qc_orders_cleaned
group by Company
order by AVG_Customer_rating desc;

-- BI_6 : Top 10 cities by total order value + dominant company in each city

SELECT t.City, SUM(order_value) as Total_order_value, (
Select Company
from qc_orders_cleaned
where city=t.city
group by Company
order by Count(Company) desc
limit 1
) as Dominant_company
from qc_orders_cleaned t
group by t.city
order by Total_order_value desc
limit 10;

-- BI_7 : Most preferred payment method

Select Payment_method, Count(Payment_method) as Total_count,  
Count(Payment_method)/(Select count(payment_method) from qc_orders_cleaned)*100 as Usage_percentage
from qc_orders_cleaned
group by Payment_method
order by usage_percentage desc;


-- BI_8 : Does discount drive higher order value?

Select Case
	When discount_applied=1 then 'Discount Given'
    else 'Discount not Given' end
as Discount_Status, AVG(Order_value) as AOV
from qc_orders_cleaned
group by Discount_Status
order by Discount_Status;


-- BI_9 : Delivery time vs customer rating — does faster delivery mean better ratings?

Select Case
	When Delivery_time_min between 5 and 10.99 then '5-10 min'
    When Delivery_time_min between 11 and 16.99 then '11-16 min'
    When Delivery_time_min between 17 and 22.99 then '17-22 min'
    When Delivery_time_min between 23 and 28.99 then '23-28 min'
    When Delivery_time_min between 29 and 34.99 then '29-34 min'
    When Delivery_time_min between 35 and 40.99 then '35+ min'
    end
as Delivery_time, AVG(Customer_rating) as Avg_Customer_rating
from qc_orders_cleaned
group by Delivery_time
order by MIN(Delivery_time_min);


-- BI_10 : Does higher item count impact delivery time and delivery partner rating?

Select Case
	When Items_count between 1 and 5 then '1-5 items'
    When Items_count between 6 and 10 then '6-10 items'
    When Items_count between 11 and 15 then '11-15 items'
    When Items_count between 15 and 20 then '15-20 items'
    end
as No_of_items, AVG(delivery_time_min) as Avg_delivery_time, 
AVG(Delivery_partner_rating) as Avg_Delivery_partner_rating
from qc_orders_cleaned
group by No_of_items
order by MIN(Items_count);

-- BI_11 : Which platform gives the most discounts and does it correlate with their customer rating?

Select Company, AVG(Discount_applied)*100 as Avg_discount, AVG(Customer_rating) as Avg_Customer_rating
from qc_orders_cleaned
group by Company
order by Avg_discount, Avg_Customer_rating;


-- BI_12 : city level operational efficiency — AVG delivery time and AVG customer rating per city, ordered by delivery time.

Select City, AVG(Delivery_time_min) as Avg_delivery_time, 
Avg(customer_rating) as Avg_customer_rating
from qc_orders_cleaned
group by City
order by Avg_delivery_time;