<p align="center">
  <img src="https://assets.entrepreneur.com/content/3x2/2000/1734074212-Photo-2024-12-13T124348531.png?format=pjeg&auto=webp" 
       alt="Blinkit Banner" width="100%">
</p>

<h1 align="center">




# 🟢 Blinkit Data Analysis – SQL Project

## 📘 Project Overview
This project focuses on analyzing **Blinkit’s retail sales data** using **PostgreSQL**.  
It explores business performance metrics such as **total sales**, **average rating**, and **outlet performance** to derive actionable insights for business optimization.

The project includes:
- Data cleaning and standardization  
- KPI calculation using SQL  
- In-depth analysis of outlet performance and sales distribution  

---
## 📊 Excel Dashboard
I have also created an **interactive dashboard in Excel** for this analysis.  
👉 [Click here to check it out](https://github.com/MohamedBilal-DA/Excel_DataAnalytics_Projects/tree/main/Excel_DataAnalytics_Projects/Blinkit_Sales_Analysis)
- --

## 🧹 Data Cleaning

The dataset contained inconsistent text values that required correction before analysis.  
The primary issue was inconsistent entries in the `item_fat_content` column.

### 🔹 Cleaning Query
```sql
--DATA CLEANING
SELECT DISTINCT ITEM_FAT_CONTENT
FROM BLINKIT_DATA;

UPDATE BLINKIT_DATA
SET ITEM_FAT_CONTENT =
CASE
  WHEN ITEM_FAT_CONTENT IN ('LF', 'low fat') THEN 'Low Fat'
  WHEN ITEM_FAT_CONTENT IN ('reg') THEN 'Regular'
  ELSE ITEM_FAT_CONTENT
END;
```

✅ **Fixes applied:**
- Standardized inconsistent text values (`LF`, `low fat`, `reg`)  
- Ensured consistent casing and data formatting  
- Verified numeric columns for accurate data types  

---

## 📊 KPI Queries

### 🔹 1. Total Sales
```sql
--1. Total Sales: The overall revenue generated from all items sold.
SELECT ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA;
```

---

### 🔹 2. Average Sales
```sql
--2. Average Sales: The average revenue per sale.
SELECT ROUND(AVG(TOTAL_SALES)) AS AVG_SALES
FROM BLINKIT_DATA;
```

---

### 🔹 3. Number of Items
```sql
--3. Number of Items: The total count of different items sold.
SELECT COUNT(ITEM_IDENTIFIER) AS TOTAL_ITEMS
FROM BLINKIT_DATA;
```

---

### 🔹 4. Average Rating
```sql
--4. Average Rating: The average customer rating for items sold.
SELECT TRUNC(AVG(RATING)::NUMERIC,1) AS AVG_RATING
FROM BLINKIT_DATA;
```

---

## 🔍 Granular Analysis

### 🔹 Total Sales by Fat Content
```sql
--1. Total Sales by Fat Content
--Objective: Analyze the impact of fat content on total sales.
SELECT ITEM_FAT_CONTENT, ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA
GROUP BY ITEM_FAT_CONTENT
ORDER BY TOTAL_SALES DESC;
```

---

### 🔹 Total Sales by Item Type
```sql
--2. Total Sales by Item Type
--Objective: Identify which item categories generate the highest total sales.
SELECT ITEM_TYPE, ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA
GROUP BY ITEM_TYPE
ORDER BY TOTAL_SALES DESC;
```

---

### 🔹 Fat Content by Outlet for Total Sales
```sql
--3. Fat Content by Outlet for Total Sales
--Objective: Compare total sales across different outlets segmented by fat content.
SELECT OUTLET_TYPE, ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA
WHERE TO_DATE(OUTLET_ESTABLISHMENT_YEAR::TEXT, 'YYYY') >= CURRENT_DATE - INTERVAL '10 YEARS'
GROUP BY OUTLET_TYPE
ORDER BY TOTAL_SALES DESC;
```

---

### 🔹 Total Sales by Outlet Establishment Year
```sql
--4. Total Sales by Outlet Establishment
--Objective: Evaluate how the age or type of outlet establishment influences total sales.
SELECT OUTLET_ESTABLISHMENT_YEAR, ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA
GROUP BY OUTLET_ESTABLISHMENT_YEAR
ORDER BY OUTLET_ESTABLISHMENT_YEAR ASC;
```

---

### 🔹 Percentage of Sales by Outlet Size
```sql
--5. Percentage of Sales by Outlet Size:
--Objective: Analyze the correlation between outlet size and total sales.

WITH T_SALE AS
(
  SELECT SUM(TOTAL_SALES) AS SUM_SALE
  FROM BLINKIT_DATA
)
SELECT 
  OUTLET_SIZE,
  ROUND(SUM(TOTAL_SALES)::NUMERIC,1) AS TOTAL_SALES,
  ROUND(SUM(TOTAL_SALES/SUM_SALE)::NUMERIC*100,1) || '%' AS PERCENTAGE_OF_SALES
FROM BLINKIT_DATA 
CROSS JOIN T_SALE
GROUP BY OUTLET_SIZE;
```

✅ **Insight:**  
Medium-sized outlets account for the highest percentage of overall sales, followed by small outlets.

---

## 🧠 Key Insights
- **Regular-fat items** contribute the highest sales volume.  
- **Medium-sized outlets** drive the largest share of total revenue.  
- **Urban outlets** show higher customer ratings and sales consistency.  
- Outlets established after **2015** show steady sales growth compared to older ones.

---

## 🧩 Tools Used
| Tool | Purpose |
|------|----------|
| **PostgreSQL** | Data cleaning, transformation, and analysis |
| **Excel / CSV** | Source data input |


