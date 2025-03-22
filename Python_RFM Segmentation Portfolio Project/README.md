# RFM-Analysis

**The project implementation has been divided into 4 parts as follows:**

1.   *Exploratory Data Analysis(EDA)*
2.   *Customer Segmentation using RFM*
3.   *Visualize Data*
4.   *Recommendation*

They have been discussed in detail as shown below.



**Part 1: Exploratory Data Analysis(EDA)**

The first step is to analyse exploratory data (EDA). The EDA is useful for understanding data, discovering patterns, and detecting anomalies or null values in a dataset. The following steps have been taken:

* Examining the dataset's shape, columns, and top 5 head, tail, and sample values for each column.
* The next step was to determine whether or not the dataset contained null and duplicate values. It was discovered that the fields 'Description' and 'CustomerID' contained some null values.
* Then I checked for duplicate values and removed them with the '.dropna()', 'drop_duplicates()'. I also remove the invoiceno cancelled with invoice_no start with "c" character.
* I also explore that the quantity and price columns have abnomally negative, and zero values.
* With quantity column I used function abs() to fix it, meanwhile the abnormal values of price column quite litte 24 / over 300k rows so I dropped it.
* I also filter only country UK because it account for significant data of the dataset

**Part 2: Customer Segmentation using RFM**

Next step is using the clean data set to calculate R-F-M Scores and RFM Segment base on the existing RFM Score and Segment. I have used the *__QUINTILES METHOD__* to calculate the RFM Scores.

* First I created revenue column by multiply 'quantity' and 'price' column
* Then I calculate the R-F-M values and use *__qcut()__* method to calculate the RFM scores.

**Part 3: Visualize Data**

* Finally I detect the distribution of Recency, Frequency, and Monetary value by histplot chart and find out that the Recency of this company is quite good, base on the number of transaction made within 50 days is highest. Meanwhile the F&M chart doesn't show much insight.
* Then I use treemap and barplot to see the contribution by Frequency and Monetary and find out:
>1. __Top 5 Spending by Segment are: Champion, Loyal, At Risk, Promising, and Need Attention__
>2. __Top 5 Number of transactions by Segment are: Hibernating, Champions, Potential Loyalist, Lost customers, and At Risk__

**Part 4: Recommendation**

* In conclusion, company should focus to improve the RFM values with some marketing and promotion campaigns specialize for each segment because each segment have distinct behaviours
>* With *__Champion, Need Attention and Loyal__* segments we should maintain updated product information and current promotional programs. Encourage them to buy more to get more discount, and take a good care for this line of customers.
>* With *__Promising and Potential Loyalist__* segments we should use some special discount code or promotion program encourage them to maintain their good Recency + Frequency values and increase their spending each visit.
>* With *__Hibernating and At Risk__* customers we should remind them by some email or phonecall, or promote special programs like "Come back deal" to inspire them comback to shopping.
>* With *__Lost customers__* we should launch some survey to find out why they don't comeback to findout and improve it.
