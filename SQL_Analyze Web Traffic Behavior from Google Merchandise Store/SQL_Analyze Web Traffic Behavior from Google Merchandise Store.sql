-- Query 1: Top Traffic Sources by Sessions and Transactions

SELECT
  trafficSource.source AS source,
  COUNT(DISTINCT fullVisitorId) AS total_users,
  COUNT(DISTINCT CONCAT(fullVisitorId, CAST(visitId AS STRING))) AS total_sessions,
  SUM(totals.transactions) AS total_transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY source
ORDER BY total_transactions DESC
LIMIT 10;

--Insight Query 1: Direct and google were the dominant traffic sources with highest session and transaction count. Organic search also contributes significantly, while social and email underperformed.

---

-- Query 2: Average Time on Site by Device Category

SELECT
  device.deviceCategory AS device_type,
  ROUND(AVG(totals.timeOnSite), 2) AS avg_time_on_site,
  COUNT(DISTINCT fullVisitorId) AS users
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.timeOnSite IS NOT NULL
GROUP BY device_type
ORDER BY avg_time_on_site DESC;

-- Insight query 2: Desktop users spend more time on site on average compared to tablet and mobile users. This suggests better engagement on larger screen devices.

---

-- Query 3: Bounce Rate by Traffic Source

SELECT
  trafficSource.medium AS medium,
  ROUND(100.0 * COUNTIF(totals.bounces = 1) / COUNT(1),2) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY medium
ORDER BY bounce_rate DESC;

--Insight query 3: Referral and display mediums have high bounce rates, indicating potential mismatch in landing content or low user intent. Organic and CPC channels performed better.

---

-- Query 4: Conversion Rate by Device

SELECT
  device.deviceCategory AS device,
  ROUND(100.0 * SUM(totals.transactions) / COUNT(1), 2) AS conversion_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.visits = 1
GROUP BY device
ORDER BY conversion_rate DESC;

--Insight Q4: Desktop shows stronger conversion rate compared to mobile and tablet. Mobile lags behind despite high visit count, implying optimization issues on mobile experience.

---

-- Query 5: Top Revenue Countries

SELECT
  geoNetwork.country AS country,
  ROUND(SUM(totals.totalTransactionRevenue)/1e6,2) AS revenue_million
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.totalTransactionRevenue IS NOT NULL
GROUP BY country
ORDER BY revenue_million DESC
LIMIT 5;

--Insight Q5: The United States leads in revenue by a large margin, followed by Canada and the United Kingdom. International traffic yields less revenue per user.

---

-- Query 6: Top Landing Pages by Pageviews

SELECT
  hits.page.pagePath AS landing_page,
  COUNT(hits.page.pagePath) AS views
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`, UNNEST(hits) AS hits
WHERE hits.type = 'PAGE'
GROUP BY landing_page
ORDER BY views DESC
LIMIT 10;

--Insight Q6: Homepage and product detail pages received the highest pageviews. Optimizing these pages could yield better engagement and lower bounce rates.

---

--Query 7: Browser with Highest Conversion Rate

SELECT
  device.browser,
  ROUND(100.0 * SUM(totals.transactions) / COUNT(DISTINCT CONCAT(fullVisitorId, visitId)), 3) AS conversion_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY device.browser
ORDER BY conversion_rate DESC
LIMIT 5;

--Insight Q7: Chrome and Safari users showed higher conversion rates compared to other browsers. This may guide browser-specific UX enhancements.

---

--Query 8: Hourly Transaction Trend

SELECT
  EXTRACT(HOUR FROM TIMESTAMP_SECONDS(visitStartTime)) AS hour,
  COUNT(totals.transactions) AS transaction_count
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.transactions IS NOT NULL
GROUP BY hour
ORDER BY hour;

--Insight Q8: Transactions peaked around afternoon (14:00 - 17:00). Campaigns and promotions could be strategically timed during this window.