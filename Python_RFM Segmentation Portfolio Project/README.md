# 🧠 Customer Segmentation with RFM Analysis (Python Project)

This project performs **RFM (Recency, Frequency, Monetary)** analysis to segment customers based on their purchase behavior using Python. The data is derived from a UK-based online retail dataset, consisting of over 300,000 transactions.

---

## 🛠 Skills & Tools Used

- **Python**: Core programming language for end-to-end analysis  
- **Pandas**: For data cleaning and transformation  
- **Seaborn & Matplotlib**: For visualizing customer segments and metric distributions  
- **Squarify**: To generate treemap visualizations  
- **Jupyter Notebook**: For organizing and presenting the analysis  
- **EDA & Data Cleaning**: Handled missing values, duplicates, and outliers

---

## 📈 Project Breakdown

### 1. Exploratory Data Analysis (EDA)
- Checked for missing values in 'CustomerID' and 'Description', and dropped/corrected them accordingly.
- Removed canceled invoices (`InvoiceNo` starting with “C”) and negative pricing/quantity values.
- Focused analysis only on **UK customers** as they represent the majority of the data.

### 2. RFM Segmentation (Quintiles Method)
- Created a `Revenue` column by multiplying `Quantity` × `Price`.  
- Calculated `Recency`, `Frequency`, and `Monetary` values.  
- Used **`qcut()`** to assign scores for RFM values and segment customers into groups such as:
  - Champions
  - Loyal Customers
  - At Risk
  - Lost
  - Potential Loyalist, etc.

### 3. Visualization & Insights
- Used **histograms** to explore RFM distributions.  
- **Treemap** and **bar plots** to visualize:
  - Top 5 segments by transaction volume
  - Top 5 segments by revenue contribution

### 4. Business Recommendations
- Tailored marketing actions for each customer segment:
  - **Champions & Loyal**: Encourage more frequent purchases with rewards
  - **Promising & Potential Loyalists**: Use promo codes and offers to convert them
  - **Hibernating & At Risk**: Send re-engagement emails or “Come Back” deals
  - **Lost Customers**: Use surveys to understand churn reasons

---

## 📦 Requirements

Install dependencies using:
```bash
pip install -r requirements.txt
