--CREATING THE SCHEMA
DROP TABLE IF EXISTS BLINKIT_DATA;
CREATE TABLE BLINKIT_DATA(
Item_Fat_Content VARCHAR(20),
Item_Identifier VARCHAR(20),
Item_Type VARCHAR(25),
Outlet_Establishment_Year INTEGER,
Outlet_Identifier VARCHAR(20),
Outlet_Location_Type VARCHAR(20),
Outlet_Size VARCHAR(20),
Outlet_Type VARCHAR(20),
Item_Visibility	FLOAT,
Item_Weight	FLOAT,
Total_Sales	FLOAT,
Rating FLOAT
);

SELECT*
FROM BLINKIT_DATA;

--DATA CLEANING
SELECT DISTINCT ITEM_FAT_CONTENT
FROM BLINKIT_DATA;

UPDATE BLINKIT_DATA SET ITEM_FAT_CONTENT=
CASE
WHEN ITEM_FAT_CONTENT IN('LF','low fat') THEN 'Low Fat'
WHEN ITEM_FAT_CONTENT IN('reg') THEN 'Regular'
ELSE ITEM_FAT_CONTENT
END;

--KPI'S REQUIREMENT

--1.Total Sales: The overall revenue generated from all items sold.

SELECT ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA;

--2.Average Sales: The average revenue per sale.

SELECT ROUND(AVG(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA;

--3.Number of Items: The total count of different items sold.

SELECT COUNT(ITEM_IDENTIFIER)
FROM BLINKIT_DATA;

--4.Average Rating: The average customer rating for items sold. 

SELECT TRUNC(AVG(RATING)::NUMERIC,1) AS AVG_RATING
FROM BLINKIT_DATA;

--GRANULAR REQUIREMENTS

--1.Total Sales by Fat Content
--Objective: Analyze the impact of fat content on total sales.

SELECT ITEM_FAT_CONTENT,ROUND(SUM(TOTAL_SALES))
FROM BLINKIT_DATA
GROUP BY ITEM_FAT_CONTENT
ORDER BY 2 DESC;

--Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

SELECT ITEM_FAT_CONTENT,ROUND(AVG(TOTAL_SALES)) AS AVG_SALES,COUNT(ITEM_IDENTIFIER) AS NO_OF_ITEMS,ROUND(AVG(RATING)::INTEGER,1) AS AVG_RATING
FROM BLINKIT_DATA
GROUP BY ITEM_FAT_CONTENT;

--2.Total Sales by Item Type
--Objective: Identify the performance of different item types in terms of total sales.

SELECT ITEM_TYPE,ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA
GROUP BY ITEM_TYPE
ORDER BY 2 DESC;

--Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

SELECT ITEM_TYPE,ROUND(AVG(TOTAL_SALES)) AS AVG_SALES,COUNT(ITEM_IDENTIFIER) AS NO_OF_ITEMS,ROUND(AVG(RATING)::INTEGER,1) AS AVG_RATING
FROM BLINKIT_DATA
GROUP BY ITEM_TYPE
ORDER BY 2
LIMIT 5;

--3. Fat Content by Outlet for Total Sales
--Objective: Compare total sales across different outlets segmented by fat content.

SELECT OUTLET_TYPE,ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA
WHERE TO_DATE(outlet_establishment_year::TEXT, 'YYYY') >= CURRENT_DATE - INTERVAL '10 YEARS'
GROUP BY OUTLET_TYPE
ORDER BY 2 DESC;

--Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

SELECT OUTLET_TYPE,ROUND(AVG(TOTAL_SALES)) AS AVG_SALES,COUNT(ITEM_IDENTIFIER) AS NO_OF_ITEMS,ROUND(AVG(RATING)::INTEGER,1) AS AVG_RATING
FROM BLINKIT_DATA
GROUP BY OUTLET_TYPE
ORDER BY 2
LIMIT 5;

--4.Total Sales by Outlet Establishment
--Objective: Evaluate how the age or type of outlet establishment influences total sales.

SELECT OUTLET_ESTABLISHMENT_YEAR,ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES
FROM BLINKIT_DATA
GROUP BY OUTLET_ESTABLISHMENT_YEAR
ORDER BY 1 ASC;

--5. Percentage of Sales by Outlet Size:
--Objective: Analyze the correlation between outlet size and total sales.

WITH T_SALE AS
(
SELECT SUM(TOTAL_SALES) AS SUM_SALE
FROM BLINKIT_DATA
)
SELECT OUTLET_SIZE,ROUND(SUM(TOTAL_SALES)::NUMERIC,1)AS TOTAL_SALES,ROUND(SUM(TOTAL_SALES/SUM_SALE)::NUMERIC*100,1)||'%' AS PERCENTAGE_OF_SALES
FROM BLINKIT_DATA CROSS JOIN T_SALE
GROUP BY OUTLET_SIZE

--6. Sales by Outlet Location
--Objective: Assess the geographic distribution of sales across different locations.

SELECT OUTLET_LOCATION_TYPE,ITEM_FAT_CONTENT,ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES,
                       ROUND(AVG(TOTAL_SALES)) AS AVG_SALES,
					   ROUND(AVG(RATING)::NUMERIC,1) AS AVG_RATING
FROM BLINKIT_DATA

GROUP BY OUTLET_LOCATION_TYPE,ITEM_FAT_CONTENT;

--7. All Metrics by Outlet Type:
--Objective: Provide a comprehensive view of all key metrics (Total Sales, Average Sales, Number of 	Items, Average Rating) broken down by different outlet types.

SELECT OUTLET_TYPE,ROUND(SUM(TOTAL_SALES)) AS TOTAL_SALES,
                       ROUND(AVG(TOTAL_SALES)) AS AVG_SALES,
					   ROUND(AVG(RATING)::NUMERIC,1) AS AVG_RATING
FROM BLINKIT_DATA
GROUP BY OUTLET_TYPE;

















