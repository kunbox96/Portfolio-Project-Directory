# 📊 Project Title: Customer Segmentation & Purchase Behavior Analysis (Retail - Python)  
Author: Alvin Nguyễn – Nguyễn Thế Đạt  
Date: 2025-04-10  
Tools Used: Python

---

![Customer Segmentation RFM Python Banner](./image/banner.png)



## 📑 Table of Contents  
1. [📌 Background & Objectives](#-background--objectives)  
2. [📂 Dataset Overview](#-dataset-overview)  
3. [⚒️ Analysis Workflow](#️-analysis-workflow)  
4. [🔎 Key Insights & Business Recommendations](#-key-insights--business-recommendations)



## 📌 Background & Objectives

### 🎯 Objective:
To segment online retail customers based on **recency**, **frequency**, and **monetary** behavior, allowing the business to improve retention and marketing targeting.

### ❓ Business Questions:
- Who are our most valuable customers?  
- Which segments are inactive or at risk?  
- What actions can we take to engage each segment better?

### 👤 Who is this project for?
✔️ CRM & Loyalty Teams  
✔️ Marketing & Retargeting Analysts  
✔️ Business Intelligence & Growth Strategy Teams



## 📂 Dataset Overview

- **Source**: UK Online Retail Transactions (2010–2011)  
- **Volume**: ~300,000 rows across ~20,000 customers  
- **Format**: Excel `.xlsx`  
- **Key Fields**: `InvoiceNo`, `CustomerID`, `Quantity`, `Price`, `Country`, `InvoiceDate`



## ⚒️ Analysis Workflow

1️⃣ **Data Cleaning**  
- Removed canceled invoices and records with missing `CustomerID` or invalid pricing  
- Filtered transactions to include **only UK customers**

2️⃣ **Feature Engineering**  
- Created a `Revenue` column (Quantity × Price)  
- Calculated **Recency**, **Frequency**, and **Monetary** for each customer  
- Used `qcut()` to segment customers into RFM quintiles and assigned scores

3️⃣ **RFM Segmentation**  
- Combined RFM scores into named groups:  
  - *Champions*, *Loyal*, *Potential Loyalist*, *At Risk*, *Lost*, etc.  
- Counted customers and total revenue for each segment

4️⃣ **Data Visualization**  
- Used **histograms**, **bar plots**, and **treemaps** to illustrate:  
  - Distribution of RFM values  
  - Top-performing segments by revenue and transactions



## 🔎 Key Insights & Business Recommendations

### 📌 Key Takeaways:
✔️ *Champions* and *Loyal* customers account for the **highest revenue and frequency**  
✔️ *At Risk* and *Hibernating* segments are large and can be reactivated  
✔️ *Lost Customers* and *About to Sleep* represent churn risk

### ✅ Business Recommendations:
- **Reward loyalty**: Offer exclusive rewards to *Champions* and *Loyal* segments  
- **Reactivation campaigns**: Send "come back" deals to *Hibernating* and *At Risk* customers  
- **Nurture new users**: Provide early discounts to *New* and *Promising* users  
- **Investigate churn**: Run exit surveys for *Lost* customers to improve retention



## 📁 Files Included

- `Python_Segment Customer & Visualize Purchase Behavior.ipynb` – Main Jupyter notebook  
- `ecommerce retail.xlsx` – Raw dataset  
- `requirement.txt` – Library dependencies  
- `README.md` – This file

