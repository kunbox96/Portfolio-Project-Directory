-- Q1:
with
raw AS(
  SELECT 
    parse_date('%Y%m%d', date) date2
    ,sum(totals.visits) AS visits
    ,sum(totals.pageviews) AS pageviews
    ,sum(totals.transactions) AS transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*` 
  WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
  group by 1
  order by 1)

select 
  format_datetime('%Y%m', raw.date2) AS month,
  sum(visits) visits,
  sum(pageviews) pageviews,
  sum(transactions) transactions
from raw
group by 1
order by 1;

-- Cách 2:
-- Q1:
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  SUM(totals.visits) AS visits,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.transactions) AS transactions,
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _TABLE_SUFFIX BETWEEN '0101' AND '0331'
GROUP BY 1
ORDER BY 1;

-- Q2: 
SELECT 
  trafficSource.source,
  sum(totals.visits) AS visits,
  sum(totals.bounces) AS num_bounces,
  round(100.0 * sum(totals.bounces) / sum(totals.visits),2) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*` 
group by 1
order by visits DESC;


-- Q3: 
WITH 
month_revenue AS(
  SELECT 
    'Month' as time_type,
    trafficSource.source,
    format_datetime('%Y%m', parse_date('%Y%m%d', date)) AS time,
    sum(productRevenue)/1000000 as Revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
  UNNEST(hits) hits,
  UNNEST(product) product
  group by 2,3
  having Revenue IS NOT NULL
  order by 4 DESC),

week_revenue AS(
  SELECT 
    'Week' as time_type,
    trafficSource.source,
    format_datetime('%Y%V', parse_date('%Y%m%d', date)) AS time,
    sum(productRevenue)/1000000 as Revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
  UNNEST(hits) hits,
  UNNEST(product) product
  group by 2,3
  having Revenue IS NOT NULL
  order by 4 DESC)

SELECT 
  month_revenue.time_type,
  month_revenue.time,
  month_revenue.source,
  month_revenue.Revenue FROM month_revenue
UNION ALL
SELECT 
  week_revenue.time_type,
  week_revenue.time,
  week_revenue.source,
  week_revenue.Revenue FROM week_revenue
ORDER BY Revenue DESC

with 
month_data as(
  SELECT
    "Month" as time_type,
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    trafficSource.source AS source,
    SUM(p.productRevenue)/1000000 AS revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  WHERE p.productRevenue is not null
  GROUP BY 1,2,3
  order by revenue DESC
),

week_data as(
  SELECT
    "Week" as time_type,
    format_date("%Y%W", parse_date("%Y%m%d", date)) as week,
    trafficSource.source AS source,
    SUM(p.productRevenue)/1000000 AS revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
    unnest(hits) hits,
    unnest(product) p
  WHERE p.productRevenue is not null
  GROUP BY 1,2,3
  order by revenue DESC
)

select * from month_data
union all
select * from week_data;


-- Q4:
-- Cách 1:
WITH
raw AS(
  SELECT 
    format_datetime('%Y%m', parse_date('%Y%m%d', date)) AS month,
    SUM(CASE WHEN totals.transactions IS NOT NULL AND product.productRevenue > 0
      THEN totals.pageviews END) AS sum_pageviews_purchase,
    SUM(CASE WHEN totals.transactions IS NULL AND product.productRevenue IS NULL
      THEN totals.pageviews END) AS sum_pageviews_non_purchase,
    COUNT(DISTINCT CASE WHEN totals.transactions IS NOT NULL
      THEN fullVisitorId END) count_purchase,
    COUNT(DISTINCT CASE WHEN totals.transactions IS NULL
      THEN fullVisitorId END) count_non_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*` ,
  UNNEST(hits) AS hits,
  UNNEST(product) AS product
  WHERE _TABLE_SUFFIX BETWEEN '0601' AND '0731'
  GROUP BY 1)

SELECT 
  raw.month,
  sum_pageviews_purchase / count_purchase AS avg_pageviews_purchase,
  sum_pageviews_non_purchase / count_non_purchase AS avg_pageviews_non_purchase
FROM raw
ORDER BY 1

-- Cách 2:
with 
purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions>=1
  and product.productRevenue is not null
  group by month
),

non_purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions is null
  and product.productRevenue is null
  group by month
)

select
    pd.*,
    avg_pageviews_non_purchase
from purchaser_data pd
full join non_purchaser_data using(month)
order by pd.month;

--câu 4 này lưu ý là mình nên dùng full join, bởi vì trong câu này, phạm vi chỉ từ tháng 6-7, nên chắc chắc sẽ có pur và nonpur của cả 2 tháng
--mình inner join thì vô tình nó sẽ ra đúng. nhưng nếu đề bài là 1 khoảng thời gian dài hơn, 2-3 năm chẳng hạn, nó cũng tháng chỉ có nonpur mà k có pur
--thì khi đó inner join nó sẽ làm mình bị mất data, thay vì hiện số của nonpur và pur thì nó để trống

-- Q5:

select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    sum(totals.transactions)/count(distinct fullvisitorid) as Avg_total_transactions_per_user
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    ,unnest (hits) hits,
    unnest(product) product
where  totals.transactions>=1
and product.productRevenue is not null
group by month;


-- Q6: 

select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    ((sum(product.productRevenue)/sum(totals.visits))/power(10,6)) as avg_revenue_by_user_per_visit
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
  ,unnest(hits) hits
  ,unnest(product) product
where product.productRevenue is not null
group by month;


-- Q7 Cách 1: Dùng DISTINCT

select
    product.v2productname as other_purchased_product,
    sum(product.productQuantity) as quantity
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
where fullvisitorid in (select distinct fullvisitorid
                        from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
                        unnest(hits) as hits,
                        unnest(hits.product) as product
                        where product.v2productname = "YouTube Men's Vintage Henley"
                        and product.productRevenue is not null)
and product.v2productname != "YouTube Men's Vintage Henley"
and product.productRevenue is not null
group by other_purchased_product
order by quantity desc;

--CTE:

with buyer_list as(
    SELECT
        distinct fullVisitorId
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    , UNNEST(hits) AS hits
    , UNNEST(hits.product) as product
    WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
    AND totals.transactions>=1
    AND product.productRevenue is not null
)

SELECT
  product.v2ProductName AS other_purchased_products,
  SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
JOIN buyer_list using(fullVisitorId)
WHERE product.v2ProductName != "YouTube Men's Vintage Henley"
 and product.productRevenue is not null
GROUP BY other_purchased_products
ORDER BY quantity DESC;

-- Q7 Cách 2: Dùng EXISTS + correlated subquery
SELECT 
  product.v2ProductName AS other_purchased_products,  
  SUM(product.productQuantity) quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*` AS a,
UNNEST(hits) hits,
UNNEST(product) product
WHERE EXISTS(
        SELECT 1 FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*` b,
        UNNEST(hits) hits,
        UNNEST(product) product
        WHERE
            a.fullVisitorId = b.fullVisitorId
            AND product.productRevenue IS NOT NULL 
            AND product.v2ProductName LIKE "YouTube Men's Vintage Henley")
    AND product.productRevenue IS NOT NULL
    AND product.v2ProductName NOT LIKE "YouTube Men's Vintage Henley"
GROUP BY 1
ORDER BY 2 DESC


-- Q8: 

--Cách 1:dùng CTE
with
product_view as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_product_view
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '2'
  GROUP BY 1
),

add_to_cart as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_addtocart
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '3'
  GROUP BY 1
),

purchase as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '6'
  and product.productRevenue is not null   --phải thêm điều kiện này để đảm bảo có revenue
  group by 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month;


--Cách 2: dùng count(case when) hoặc sum(case when)

with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CASE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,UNNEST(hits) as hits
,UNNEST (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select
    *,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data;














