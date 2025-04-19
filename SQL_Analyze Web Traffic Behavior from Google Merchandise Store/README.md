# 📊 Analyze Web Traffic Behavior from Google Merchandise Store

👤 Author: Alvin Nguyễn – Nguyễn Thế Đạt  

🛠️ Tools Used: SQL, BigQuery

📆 Date: April 2025  

---
![Web Analytics SQL Banner](./image/banner.png)

## 📑 Table of Contents
1. [📌 Background & Overview](#-background--overview)  
2. [📂 Dataset Description & Data Structure](#-dataset-description--data-structure)  
3. [🧠 Problem Solving Process](#-problem-solving-process)  
4. [📊 Explore the Dataset & Generate Insights](#-explore-the-dataset--generate-insights)  
5. [🔎 Final Conclusion & Recommendations](#-final-conclusion--recommendations)

---

## 📌 Background & Overview

### 📖 What is this project about?

> This project investigates visitor behaviors on the Google Merchandise Store using SQL and BigQuery. It aims to understand user interaction patterns, traffic sources, engagement levels, and transaction performance.

### 👥 Who is this project for?

- Digital marketing teams looking to understand channel performance.
- Web analysts aiming to optimize conversion funnels.
- Ecommerce product owners who want to increase revenue via user engagement insights.

### ❓ Business Questions:

- Which channels drive the most traffic and conversions?
- What is the average time users spend on the site by traffic source?
- Which devices generate more engaged users or revenue?
- What is the bounce rate across sessions and traffic channels?
- Which landing pages generate the most engagement?
- Which browser generates the highest conversion rate?
- What is the top revenue-generating product?
- Which hour of the day has the highest transaction rate?

### 🎯 Project Outcome:

- Identified the most effective marketing channels based on sessions and transaction values.
- Uncovered the difference in engagement by device category and session duration.
- Analyzed bounce rates and identified traffic channels with weak conversion.
- Identified top-performing landing pages and products.
- Provided actionable insights for better channel allocation and landing page optimization.

---

## 📂 Dataset Description & Data Structure

### 📌 Data Source

- Dataset: [`bigquery-public-data.google_analytics_sample.ga_sessions_20170801`](https://console.cloud.google.com/bigquery?ws=!1m4!1m3!3m2!1sbigquery-public-data!2sgoogle_analytics_sample)
- Platform: Google Analytics sample dataset provided in Google BigQuery.
- Structure: Nested schema typical of Google Analytics exports, including hits, totals, device, trafficSource, and geoNetwork.

<details>
<summary>Table: ga_sessions_20170801</summary>

| Column Name        | Type     | Description                                                                 |
|--------------------|----------|-----------------------------------------------------------------------------|
| fullVisitorId      | STRING   | Unique identifier for each user                                             |
| visitId            | INTEGER  | Identifier for a session                                                    |
| visitNumber        | INTEGER  | Count of sessions for a user                                                |
| visitStartTime     | TIMESTAMP| Session start time (epoch)                                                  |
| date               | STRING   | Date of the session (YYYYMMDD)                                              |
| totals             | RECORD   | Includes session-level metrics (visits, hits, pageviews, bounces, revenue) |
| trafficSource      | RECORD   | Source, medium, campaign, keyword                                           |
| device             | RECORD   | Info about browser, device category, operating system                       |
| geoNetwork         | RECORD   | Geographic information (country, city, metro)                               |
| hits               | RECORD   | List of hit-level records per session (pages, events, e-commerce, etc.)     |

</details>

---

## 🧠 Problem Solving Process

| 1️⃣ Understand Problem | 2️⃣ Break into Smaller Tasks | 3️⃣ Ideate Logic | 4️⃣ Implement and Review |
|----------------------------|-----------------------------|--------------------|----------------------|
| Define scope: engagement, bounce, conversion, traffic, time spent | Identify nested vs top-level columns, decide unnesting | Explore by device, channel, region, bounce flag, revenue | Each query explores a business question & reveals insights |

---

## 📊 Explore the Dataset & Generate Insights

### Query 1️⃣: Top Traffic Sources by Sessions and Transactions
```sql
SELECT
  trafficSource.source AS source,
  COUNT(DISTINCT fullVisitorId) AS total_users,
  COUNT(DISTINCT CONCAT(fullVisitorId, CAST(visitId AS STRING))) AS total_sessions,
  SUM(totals.transactions) AS total_transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY source
ORDER BY total_transactions DESC
LIMIT 10;
```
<details>
<summary>Click to expand query result</summary>

| Row | Source                       | Total Users | Total Sessions | Total Transactions |
|-----|------------------------------|-------------|----------------|---------------------|
| 1   | (direct)                     | 1943        | 2166           | 44                  |
| 2   | mail.google.com              | 2           | 2              | 1                   |
| 3   | analytics.google.com         | 53          | 57             | null                |
| 4   | adwords.google.com           | 2           | 2              | null                |
| 5   | ask                          | 2           | 2              | null                |
| 6   | productforums.google.com     | 1           | 1              | null                |
| 7   | baidu                        | 5           | 5              | null                |

</details><br>

> 🔍 **Insight**: The majority of users and sessions came from direct traffic, which also generated the highest number of transactions (44), while other sources like mail.google.com contributed minimally with very low session and transaction volume.

### Query 2️⃣: Average Time on Site by Device Category
```sql
SELECT
  device.deviceCategory AS device_type,
  ROUND(AVG(totals.timeOnSite), 2) AS avg_time_on_site,
  COUNT(DISTINCT fullVisitorId) AS users
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.timeOnSite IS NOT NULL
GROUP BY device_type
ORDER BY avg_time_on_site DESC;
```
<details>
<summary>Click to expand query result</summary>

| Row | Device Type | Avg Time on Site (sec) | Users |
|-----|-------------|-------------------------|--------|
| 1   | desktop     | 352.45                  | 832    |
| 2   | mobile      | 261.24                  | 315    |
| 3   | tablet      | 194.86                  | 35     |

</details><br>

> 🔍 **Insight**: Desktop users spend more time on site on average compared to tablet and mobile users. This suggests better engagement on larger screen devices.

### Query 3️⃣: Bounce Rate by Traffic Source
```sql
SELECT
  trafficSource.medium AS medium,
  ROUND(100.0 * COUNTIF(totals.bounces = 1) / COUNT(1),2) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY medium
ORDER BY bounce_rate DESC;
```
<details>
<summary>Click to expand query result</summary>

| Row | medium             | bounce_rate |
|-----|--------------------|-------------|
| 1   | referral           | 67.41       |
| 2   | organic            | 60.00       |
| 3   | affiliate          | 57.69       |
| 4   | (none)             | 45.48       |
| 5   | cpm                | 40.00       |

</details><br>

> 🔍 **Insight**: Referral and organic channels exhibit the highest bounce rates, signaling a need to refine landing pages or better align content with user intent.

### Query 4️⃣: Conversion Rate by Device
```sql
SELECT
  device.deviceCategory AS device,
  ROUND(100.0 * SUM(totals.transactions) / COUNT(1), 2) AS conversion_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.visits = 1
GROUP BY device
ORDER BY conversion_rate DESC;
```
<details>
<summary>Click to expand query result</summary>

| Row | device  | conversion_rate |
|-----|---------|-----------------|
| 1   | desktop | 2.47            |
| 2   | mobile  | 0.28            |
| 3   | tablet  | null            |

</details>
<br>

> 🔍 **Insight**: Desktop users had the highest conversion rate (2.47%), while mobile users showed a significantly lower rate (0.28%), and tablets recorded no conversions. This highlights the importance of prioritizing desktop optimization for transactions while investigating mobile UX issues.


### Query 5️⃣: Top Revenue Countries
```sql
SELECT
  geoNetwork.country AS country,
  ROUND(SUM(totals.totalTransactionRevenue)/1e6,2) AS revenue_million
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.totalTransactionRevenue IS NOT NULL
GROUP BY country
ORDER BY revenue_million DESC
LIMIT 5;
```
<details>
<summary>Click to expand query result</summary>

| Row | country       | revenue_million |
|-----|---------------|-----------------|
| 1   | United States | 8884.01         |
| 2   | Finland       | 5.99            |

</details>
<br>

> 🔍 **Insight**: The United States overwhelmingly dominates in revenue generation, contributing over $8.8 billion, while the next country, Finland, generates only $5.99 million. This indicates a strong concentration of high-value customers in the U.S. market.


### Query 6️⃣: Top Landing Pages by Pageviews
```sql
SELECT
  hits.page.pagePath AS landing_page,
  COUNT(hits.page.pagePath) AS views
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`, UNNEST(hits) AS hits
WHERE hits.type = 'PAGE'
GROUP BY landing_page
ORDER BY views DESC
LIMIT 10;
```
<details>
<summary>Click to expand query result</summary>

| Row | landing_page                                              | views |
|-----|-----------------------------------------------------------|-------|
| 1   | /home                                                     | 2212  |
| 2   | /google+redesign/shop+by+brand/google+apparel             | 734   |
| 3   | /basket.html                                              | 721   |
| 4   | /google+redesign/apparel/men/tshirts/google+grey+tee.html | 381   |
| 5   | /signin.html                                              | 333   |
| 6   | /asearch.html                                             | 216   |
| 7   | /store.html                                               | 213   |
| 8   | /google+redesign/electronics                              | 176   |
| 9   | /yourinfo.html                                            | 172   |
| 10  | /store.html/quickview                                     | 170   |

</details><br>

> 🔍 **Insight**: 

- The homepage (/home) is the dominant entry point, accounting for the most pageviews (2,212), followed by major product category and shopping flow pages such as /basket.html, /store.html, and /signin.html.
- This pattern suggests that users often begin at the homepage, explore product categories, and proceed into the cart or account-related flows—highlighting a typical ecommerce funnel.
- Improving UX and loading speed on these top-visited pages could directly impact engagement and conversion efficiency.

### Query 7️⃣: Browser with Highest Conversion Rate
```sql
SELECT
  device.browser,
  ROUND(100.0 * SUM(totals.transactions) / COUNT(DISTINCT CONCAT(fullVisitorId, visitId)), 3) AS conversion_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY device.browser
ORDER BY conversion_rate DESC
LIMIT 5;
```
<details>
<summary>Click to expand query result</summary>

| Row | browser  | conversion_rate |
|-----|----------|-----------------|
| 1   | Chrome   | 2.158           |
| 2   | Firefox  | 0.990           |
| 3   | Safari   | 0.756           |
| 4   | Edge     | null            |
| 5   | Coc Coc  | null            |

</details><br>

> 🔍 **Insight**: 

- Chrome users exhibit the highest conversion rate at 2.16%, significantly outperforming other browsers. Firefox and Safari show moderate performance, while Edge and Coc Coc recorded no measurable conversions.

- This suggests that optimization efforts (UX/UI, compatibility, and speed) should be prioritized for Chrome first—followed by Firefox and Safari—to maximize conversion potential across the most impactful browser platforms.

### Query 8️⃣: Hourly Transaction Trend
```sql
SELECT
  EXTRACT(HOUR FROM TIMESTAMP_SECONDS(visitStartTime)) AS hour,
  COUNT(totals.transactions) AS transaction_count
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE totals.transactions IS NOT NULL
GROUP BY hour
ORDER BY hour;
```
<details>
<summary>Click to expand query result</summary>

| Hour | Transaction Count |
|------|-------------------|
| 2    | 3                 |
| 4    | 2                 |
| 5    | 1                 |
| 13   | 1                 |
| 14   | 5                 |
| 15   | 2                 |
| 16   | 5                 |
| 17   | 6                 |
| 18   | 3                 |
| 19   | 3                 |
| 20   | 3                 |
| 21   | 4                 |
| 22   | 4                 |
| 23   | 1                 |

</details>
<br>


> 🔍 **Insight**: Transaction activity peaks between 14:00 and 17:00, suggesting that late afternoon is the most effective window for driving purchases. Marketing efforts could be focused during these hours to boost conversions.


## 🔎 Final Conclusion & Recommendations

This analysis of Google Merchandise Store user behavior—using SQL queries on BigQuery—highlights valuable trends in traffic sources, devices, landing pages, browsers, and transactional patterns. The insights point toward clear areas of improvement that can enhance engagement and increase conversions.

---

### 📌 Dimension-Based Summary

#### 1️⃣ Traffic Source Effectiveness
- **Direct** traffic generated the most users, sessions, and transactions.
- Referral and organic sources had high bounce rates, indicating poor landing relevance or low user intent.

**→ Recommendation**: Audit the user journey from referral and organic sources; ensure landing pages align with ad/search content.

---

#### 2️⃣ Device Performance
- **Desktop** had the highest engagement and conversion rate.
- Mobile lagged in both time on site and transaction rate.

**→ Recommendation**: Improve mobile checkout UX and optimize speed to reduce drop-offs on smaller screens.

---

#### 3️⃣ Landing Page Optimization
- `/home` was the top entry page, followed by basket and key product category pages.
- High entry volume indicates these pages heavily influence user experience.

**→ Recommendation**: A/B test layout, CTAs, and loading time on top-visited pages to improve user flow and engagement.

---

#### 4️⃣ Browser Compatibility
- **Chrome** users converted more effectively than others.
- Browsers like Edge and Coc Coc had no recorded conversions.

**→ Recommendation**: Prioritize Chrome and Safari UX, while troubleshooting or deprioritizing unsupported browsers.

---

#### 5️⃣ Time-of-Day Behavior
- Peak transactions occurred between **2PM–5PM**, especially at 5PM (hour 17).
- Minimal conversions outside this window.

**→ Recommendation**: Schedule campaigns and discounts to align with afternoon peaks for better response rates.

---

## ✅ Recommended Actions

- 🎯 Refine landing page messaging for referral and organic channels.
- 📱 Invest in mobile-first design and simplify purchase steps for phone users.
- 🧪 Run A/B tests on `/home`, `/basket.html`, and top product pages.
- 🌐 Enhance Chrome and Safari experiences, deprioritize underperforming browsers.
- ⏰ Align promotional campaigns with high-converting time blocks (14h–17h).
- 🛒 Focus content personalization around top-converting paths (from homepage to cart).

