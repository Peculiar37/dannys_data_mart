-- 1. Data Cleansing Steps --
select *
 from weekly_sales;
 
CREATE TABLE clean_weekly_sales AS
SELECT  
    STR_TO_DATE(week_date, '%d/%m/%y') AS week_date,
    WEEK(STR_TO_DATE(week_date, '%d/%m/%y')) AS week_number,
    MONTH(STR_TO_DATE(week_date, '%d/%m/%y')) AS month_number,
    YEAR(STR_TO_DATE(week_date, '%d/%m/%y')) AS calendar_year,
    region,
    platform,
    segment,
    customer_type,
    CASE
        WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
        WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
        WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
        ELSE 'unknown'
    END AS age_band,
    CASE
        WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
        WHEN LEFT(segment, 1) = 'F' THEN 'Families'
        ELSE 'unknown'
    END AS demographic,
    transactions,
    CAST(sales AS SIGNED) AS sales,
    ROUND(CAST(sales AS DECIMAL(18,2))/transactions, 2) AS avg_transaction
FROM weekly_sales;

select *
from clean_weekly_sales;


