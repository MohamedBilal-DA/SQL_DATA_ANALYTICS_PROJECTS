<h1 align="center">Apple Retail Sales SQL Project</h1>

<p align="center">
  <img src="https://github.com/user-attachments/assets/36b1a691-b325-455a-ad79-6e968b522021" width="900">
</p>

## Project Overview

This project is designed to showcase advanced SQL querying techniques through the analysis of over 1 million rows of Apple retail sales data. The dataset includes information about products, stores, sales transactions, and warranty claims across various Apple retail locations globally. By tackling a variety of questions, from basic to complex, you'll demonstrate your ability to write sophisticated SQL queries that extract valuable insights from large datasets.

The project is ideal for data analysts looking to enhance their SQL skills by working with a large-scale dataset and solving real-world business questions.

## Database Schema

The project uses five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).



### Medium Level Business Questions

1. Find the number of stores in each country.
2. Calculate the total number of units sold by each store.
3. Identify how many sales occurred in December 2023.
4. Determine how many stores have never had a warranty claim filed.
5. Calculate the percentage of warranty claims marked as "Warranty Void".
6. Identify which store had the highest total units sold in the last year.
7. Count the number of unique products sold in the last year.
8. Find the average price of products in each category.
9. How many warranty claims were filed in 2020?
10. For each store, identify the best-selling day based on highest quantity sold.

###  Hard Level Business Questions

11. Identify the least selling product in each country for each year based on total units sold.
12. Calculate how many warranty claims were filed within 180 days of a product sale.
13. Determine how many warranty claims were filed for products launched in the last two years.
14. List the months in the last three years where sales exceeded 5,000 units in the USA.
15. Identify the product category with the most warranty claims filed in the last two years.

### Complex Level Business Questions

16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
17. Analyze the year-by-year growth ratio for each store.
18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
19. Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.
20. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
21. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.

22. ## Query Performance Optimization Using Indexes

To improve query execution performance, appropriate indexes were created on frequently filtered and joined columns.  
Execution plans were analyzed before and after indexing using `EXPLAIN ANALYZE`, and noticeable improvements were observed in execution time.
### Execution Plan After Indexing

```sql
EXPLAIN ANALYZE
SELECT *
FROM sales
WHERE store_id = 'ST-31';
```
<p align="center"><img width="640" height="754" alt="Screenshot 2025-12-16 192856" src="https://github.com/user-attachments/assets/9df0f8ec-d1c9-4dde-b56c-e1abc4944ad8" /></p> ```


### Creating Index
```sql
CREATE INDEX IND_SALES_ST ON SALES(SALE_ID);
CREATE INDEX IND_SALES_DT ON SALES(SALE_DATE);
```
### Execution Plan After Indexing

```sql
EXPLAIN ANALYZE
SELECT *
FROM sales
WHERE store_id = 'ST-31';
```
<p align="center"> <img src="https://github.com/user-attachments/assets/fcb14af8-8483-4c0e-960d-0fd316371330" alt="Execution Plan After Indexing" width="574" height="673" /> </p> ```

#### 19.Identify the store with the highest percentage of "PENDING" claims relative to total claims filed.
```sql
WITH TOTAL_CLAIMS AS(
SELECT ST.STORE_NAME,COUNT(W.CLAIM_ID)TCNT
FROM STORES ST INNER JOIN SALES SS
ON ST.STORE_ID=SS.STORE_ID
INNER JOIN WARANTY W
ON W.SALE_ID=SS.SALE_ID
GROUP BY ST.STORE_NAME),
PENDING_CLAIMS AS(
SELECT ST.STORE_NAME,COUNT(W.CLAIM_ID)PCNT
FROM STORES ST INNER JOIN SALES SS
ON ST.STORE_ID=SS.STORE_ID
INNER JOIN WARANTY W
ON W.SALE_ID=SS.SALE_ID
WHERE REPAIR_STATUS='Pending'
GROUP BY ST.STORE_NAME
),
RANKING AS(
SELECT PC.STORE_NAME,ROUND(PC.PCNT/TC.TCNT::NUMERIC*100,2)PERC,RANK() OVER(ORDER BY ROUND(PC.PCNT/TC.TCNT::NUMERIC*100,2) DESC)RAN
FROM PENDING_CLAIMS PC INNER JOIN TOTAL_CLAIMS TC
ON TC.STORE_NAME=PC.STORE_NAME)
SELECT STORE_NAME,PERC||'%'
FROM RANKING
WHERE RAN=1
```
#### 21.Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
```sql
WITH SALES AS(
SELECT P.PRODUCT_NAME,P.PRICE,S.QUANTITY,P.LAUNCH_DATE,S.SALE_DATE,
CASE
WHEN SALE_DATE >= LAUNCH_DATE
AND SALE_DATE < LAUNCH_DATE + INTERVAL '6 MONTHS'
THEN 'FIRST_6_MONTHS'
WHEN SALE_DATE >= LAUNCH_DATE + INTERVAL '6 MONTHS'
AND SALE_DATE < LAUNCH_DATE + INTERVAL '12 MONTHS'
THEN 'SIX_TO_12_MONTHS'
WHEN SALE_DATE >= LAUNCH_DATE + INTERVAL '12 MONTHS'
AND SALE_DATE < LAUNCH_DATE + INTERVAL '18 MONTHS'
THEN 'TWELVE_TO_18_MONTHS'
WHEN SALE_DATE >= LAUNCH_DATE + INTERVAL '18 MONTHS'
THEN 'BEYOND_18_MONTHS'
END AS RANGEE
FROM SALES S INNER JOIN PRODUCTS P
ON P.PRODUCT_ID=S.PRODUCT_ID)
SELECT PRODUCT_NAME,RANGEE,SUM(PRICE*QUANTITY)
FROM SALES
WHERE RANGEE IS NOT NULL
GROUP BY PRODUCT_NAME,RANGEE
ORDER BY 1,3 DESC
```



