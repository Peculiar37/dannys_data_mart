-- 3. Before & After Analysis
-- Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.
-- What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?

WITH base_week AS (
  SELECT WEEK('2020-06-15') AS bw
),
sales_before AS (
  SELECT 
    SUM(sales) AS total_sales_before
  FROM 
    clean_weekly_sales, base_week
  WHERE
    calendar_year = 2020
    AND week_number BETWEEN (bw - 4) AND (bw - 1)
),
sales_after AS (
  SELECT
    SUM(sales) AS total_sales_after
  FROM
    clean_weekly_sales, base_week
  WHERE
    calendar_year = 2020
    AND week_number BETWEEN bw AND (bw + 3)
)
SELECT
  total_sales_before,
  total_sales_after,
  total_sales_after - total_sales_before AS change_in_sales,
  ROUND(
    100 * (total_sales_after - total_sales_before) / total_sales_before,
    2
  ) AS percentage_of_change
FROM
  sales_before,
  sales_after;
  
  -- What about the entire 12 weeks before and after?
WITH base_week AS (
  SELECT WEEK('2020-06-15') AS bw
),
sales_before AS (
  SELECT 
    SUM(sales) AS total_sales_before
  FROM 
    clean_weekly_sales, base_week
  WHERE
    calendar_year = 2020
    AND week_number BETWEEN (bw - 12) AND (bw - 1)
),
sales_after AS (
  SELECT
    SUM(sales) AS total_sales_after
  FROM
    clean_weekly_sales, base_week
  WHERE
    calendar_year = 2020
    AND week_number BETWEEN bw AND (bw + 11)
)
SELECT
  total_sales_before,
  total_sales_after,
  total_sales_after - total_sales_before AS change_in_sales,
  ROUND(
    100 * (total_sales_after - total_sales_before) / total_sales_before,
    2
  ) AS percentage_of_change
FROM
  sales_before,
  sales_after;
  
  -- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
  WITH base_week AS (
  SELECT WEEK('2020-06-15') AS bw
),
sales_before  as (
select calendar_year ,
sum(sales) as total_sales_before 
from clean_weekly_sales,base_week
where  calendar_year = 2020
    AND week_number BETWEEN (bw - 4) AND (bw - 1)
),
sales_after AS (
  SELECT
    SUM(sales) AS total_sales_after
  FROM
    clean_weekly_sales, base_week
  WHERE
    calendar_year = 2020
    AND week_number BETWEEN bw AND (bw + 3)
)
SELECT
calendar_year,
  total_sales_before,
  total_sales_after,
  total_sales_after - total_sales_before AS change_in_sales,
  ROUND(
    100 * (total_sales_after - total_sales_before) / total_sales_before,
    2
  ) AS percentage_of_change
FROM
  sales_before,
  sales_after;

