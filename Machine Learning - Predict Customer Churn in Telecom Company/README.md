# 📊 Project Title: Python Customer Churn Prediction Model  
Author: Alvin Nguyễn – Nguyễn Thế Đạt  
Date: 2025-04-10  
Tools Used: Python, Pandas, Scikit-learn

---

## 📑 Table of Contents  
1. [📌 Background & Overview](#-background--overview)  
2. [📂 Dataset Description & Structure](#-dataset-description--structure)  
3. [⚒️ Main Process](#️-main-process)  
4. [🔎 Final Conclusion & Recommendations](#-final-conclusion--recommendations)

## 📌 Background & Overview  

### 🎯 Objective:
The goal of this project is to **build a predictive machine learning model to identify customers likely to churn**, allowing the business to proactively implement retention strategies.

### ❓ Business Question:
- What are the key behavioral and service factors that lead to customer churn?
- How can we predict which customers are at risk and reduce attrition rate?

### 👤 Who is this project for?
✔️ Customer Success & Retention Teams  
✔️ Data Analysts at Subscription-based businesses  
✔️ Marketing Teams planning retention campaigns  

## 📂 Dataset Description & Structure  

### 📌 Data Source:
- Source: Public telecom dataset (or company CRM exports)  
- Size: ~6,600 rows × ~20 columns  
- Format: `.csv`

### 📊 Key Variables:
| Column Name       | Data Type | Description                                 |
|------------------|-----------|---------------------------------------------|
| customerID        | Text      | Unique identifier for each customer         |
| tenure            | Integer   | Number of months customer has stayed        |
| MonthlyCharges    | Float     | Monthly payment amount                      |
| DaySinceLastOrder | Integer   | Days since last order                       |
| CashbackAmount    | Float     | Total cashback received                     |
| Churn             | Boolean   | Whether the customer left (1) or stayed (0) |


## ⚒️ Main Process

1️⃣ **Data Cleaning & Preprocessing**  
- Removed duplicates and filled missing values using linear interpolation  
- Applied OneHotEncoding for categorical variables  
- Scaled numerical features for modeling

2️⃣ **Feature Selection**  
- Used a Decision Tree Classifier to evaluate feature importance  
- Identified `DaySinceLastOrder`, `Tenure`, and `CashbackAmount` as key predictors

3️⃣ **Model Building & Evaluation**  
- Trained a Decision Tree model with 70/30 train-test split  
- Achieved ~83% accuracy with reasonable recall/precision trade-off


## 🔎 Final Conclusion & Recommendations

### 📌 Key Takeaways:
✔️ Dataset was well-balanced — no oversampling needed  
✔️ High churn associated with long delay since last order, short tenure, and low cashback  
✔️ Decision Tree modeling provided interpretable insight into churn drivers

### ✅ Business Recommendations:
- **Re-engage customers** with long inactivity using targeted offers  
- **Reward tenure milestones** with loyalty incentives  
- Offer **cashback upgrades** to users with low reward history  
- Monitor churn drivers with periodic dashboards for early detection

---
