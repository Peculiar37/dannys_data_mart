-- 2. Data Exploration --
select *
from clean_weekly_sales;

-- What day of the week is used for each week_date value?
select week_date,
 dayname(week_date) as date_value 
from  clean_weekly_sales ;

-- What range of week numbers are missing from the dataset?
select week_number
from clean_weekly_sales
group by 1
order by 1 ;

-- How many total transactions were there for each year in the dataset?
select 
year(week_date) as txn_year,
count(*) as total_transactions
from clean_weekly_sales
group by txn_year ;

-- What is the total sales for each region for each month?
select 
region,
month(week_date) as txn_month,
sum(sales) as total_sales
from clean_weekly_sales
group by region, txn_month;

-- What is the total count of transactions for each platform
select
platform,
count(*) as total_transactions 
from clean_weekly_sales
group by platform;

-- What is the percentage of sales for Retail vs Shopify for each month?
select 
date_format(week_date, '%Y-%m') as order_month,
sum(case when platform = 'retail' then sales else 0 end) as retail_sales,
sum(case when platform = 'shopify' then sales else 0 end) as shopify_sales,
sum(sales) as total_sales,
round((sum(case when platform = 'retail' then sales else 0 end)/ sum(sales)) * 100,2) as retail_percentage,
round((sum(case when platform = 'shopify' then sales else 0 end)/sum(sales)) * 100, 2) as shopify_percentage
from clean_weekly_sales
group by date_format(week_date, '%Y-%m')
order by order_month;

-- What is the percentage of sales by demographic for each year in the dataset?
select
demographic,
year(week_date) as txn_year,
sum(sales) as total_sales,
round(sum(sales) /sum(sum(sales)) over (partition by year(week_date)) * 100,2)  as sales_percentage
from clean_weekly_sales
group by year(week_date),demographic
order by txn_year,sales_percentage desc;

-- Which age_band and demographic values contribute the most to Retail sales?
with retails as (
select 
age_band, demographic, 
sum(sales) as retail_sales
from clean_weekly_sales
where platform = 'retail'
and age_band is not null
and demographic is not null
group by age_band, demographic
),
total_sales as (
select 
sum(sales) as all_sales
from clean_weekly_sales
where  platform = 'retail'
)
select age_band,demographic, all_sales,
round((retail_sales/all_sales) * 100,2) as percentage_retail,
rank () over (order by retail_sales desc) as sales_rank
from retails
cross join total_sales
order by retail_sales;

-- Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
-- no. we cant use average to calculate average. rather we do ths
select platform, week_date,
round(sum(sales)/ sum(transactions),1) as correct_avg,
round(avg(avg_transaction)) as wrong_avg
from clean_weekly_sales
group by 1,2
order by 1,2 ;

