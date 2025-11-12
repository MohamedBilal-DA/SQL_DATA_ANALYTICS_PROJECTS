<p align="center">
  <img src="https://github.com/user-attachments/assets/abb47cac-ef9f-486d-83cd-f38f557fc917" alt="Spotify Logo" width="100%">
</p>

# 🎵 Spotify Advanced SQL Project & Query Optimization (P-6)

**Project Level:** Advanced  
**Dataset Source:** [Spotify Dataset on Kaggle](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

---

## 📘 Overview

This project demonstrates **advanced SQL data analysis and optimization techniques** using a real-world Spotify dataset.  
It includes everything from **dataset understanding** to **complex query writing** and **performance tuning** with indexing.

By the end of this project, you will:
- Strengthen your SQL analytical thinking.  
- Learn how to **use CTEs, window functions, and subqueries** effectively.  
- Optimize queries using **indexes** and **query execution plans**.  

---

## 🧱 Database Schema

Below is the schema used to create the main `spotify` table:

```sql
DROP TABLE IF EXISTS spotify;

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```

---

## 🔍 Step 1: Data Exploration

Before performing any analysis, it’s essential to understand the dataset.  
Key attributes include:

- 🎤 **artist** – Performer of the track  
- 🎶 **track** – Song title  
- 💿 **album** – Album to which the track belongs  
- 📀 **album_type** – Indicates if it’s a single or full album  
- ⚡ **metrics** – Attributes such as `danceability`, `energy`, `tempo`, `valence`, etc.

---

## 🧩 Step 2: SQL Querying & Analysis

Queries are divided into three difficulty levels to build SQL mastery progressively.

### 🟢 Easy Level
1. Retrieve the names of all tracks with more than 1 billion streams.  
2. List all albums along with their respective artists.  
3. Get the total number of comments for licensed tracks.  
4. Display all tracks categorized as “single”.  
5. Count how many tracks each artist has produced.

### 🟡 Intermediate Level
1. Calculate the **average danceability** of tracks per album.  
2. Find the **top 5 tracks** with the highest energy scores.  
3. List all **official videos** with their views and likes.  
4. Compute **total views per album**.  
5. Identify tracks with **more Spotify streams than YouTube views**.

### 🔴 Advanced Level
1. Get the **top 3 most-viewed tracks** for each artist using window functions.  
2. Find tracks with **liveness above the overall average**.  
3. Using a CTE, calculate the **difference between highest and lowest energy per album**:

```sql
WITH energy_cte AS (
    SELECT 
        album,
        MAX(energy) AS highest_energy,
        MIN(energy) AS lowest_energy
    FROM spotify
    GROUP BY album
)
SELECT 
    album,
    highest_energy - lowest_energy AS energy_difference
FROM energy_cte
ORDER BY energy_difference DESC;
```

4. Find tracks where **energy-to-liveness ratio > 1.2**.  
5. Calculate the **cumulative sum of likes** based on views using window functions.

---

## ⚙️ Query Optimization

To improve performance, we optimized SQL queries using PostgreSQL tools such as **EXPLAIN** and **INDEXES**.

### 🧾 Step 1: Analyze Query Performance (Before Optimization)

We executed a query filtering data by `artist` and analyzed performance metrics:

- Execution Time: **7 ms**  
- Planning Time: **0.17 ms**  

<img width="893" height="364" alt="spotify_explain_before_index" src="https://github.com/user-attachments/assets/8711ac9d-0ad0-44a7-8d5c-2da0b364158b" />

---

### 🗂️ Step 2: Create Index on `artist` Column

Indexing helps PostgreSQL quickly locate data without scanning the full table.

```sql
CREATE INDEX idx_artist ON spotify(artist);
```

---

### 📊 Step 3: Analyze Query Performance (After Optimization)

Post optimization, the same query showed significant improvements:

- Execution Time: **0.153 ms**  
- Planning Time: **0.152 ms**  

<img width="1083" height="545" alt="spotify_explain_after_index" src="https://github.com/user-attachments/assets/6902e006-aa8e-4411-9def-8f2f1a072bfc" />

---

### 📈 Performance Comparison

Below is the visual representation of query performance before and after indexing:

<img width="1358" height="276" alt="spotify_graphical view 1" src="https://github.com/user-attachments/assets/d23c4cfa-ce05-447d-8c81-68a106e4c5bd" />
<img width="968" height="278" alt="spotify_graphical view 2" src="https://github.com/user-attachments/assets/8c1fdcb1-aadc-458a-840f-5a410c8ee538" />
<img width="1270" height="361" alt="spotify_graphical view 3" src="https://github.com/user-attachments/assets/9fdf4df7-1da3-432b-8185-e517153908de" />

---

## 📄 SQL Solution File

All SQL scripts used in this project are consolidated in the file **`SOLUTION.sql`**.  
This file contains:

- Table creation and dataset setup  
- Exploratory Data Analysis (EDA) queries  
- Easy, Medium, and Advanced level analytical queries  
- Query optimization steps (before and after index creation)

📂 **Purpose:** To provide a single, executable SQL file that lets anyone reproduce this project end-to-end in PostgreSQL.

You can open it directly in **pgAdmin**, **DBeaver**, or your preferred SQL editor to follow the analysis process line by line.

---

## 🛠️ Technology Stack

- **Database:** PostgreSQL  
- **Query Language:** SQL (DDL, DML, CTEs, Window Functions)  
- **Tools:** pgAdmin 4 / DBeaver / Docker PostgreSQL





