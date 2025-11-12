-- create table
DROP TABLE IF EXISTS spotify_DATA;
CREATE TABLE spotify_DATA(
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

--EDA

SELECT*
FROM SPOTIFY_DATA;

SELECT COUNT(*)
FROM SPOTIFY_DATA;

SELECT COUNT(DISTINCT ARTIST)
FROM SPOTIFY_DATA;

SELECT COUNT(DISTINCT ALBUM)
FROM SPOTIFY_DATA;

SELECT DISTINCT ALBUM_TYPE
FROM SPOTIFY_DATA;

SELECT MIN(DURATION_MIN),MAX(DURATION_MIN)
FROM SPOTIFY_DATA;

DELETE
FROM SPOTIFY_DATA
WHERE DURATION_MIN IN(0);

-- -------------------------
-- DATA ANALYSIS EASY CATEGORY
-- -------------------------

--1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT TRACK
FROM SPOTIFY_DATA
WHERE VIEWS >=1000000000;

--2.List all albums along with their respective artists.

SELECT ALBUM,ARTIST
FROM SPOTIFY_DATA;

--3.Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(COMMENTS)
FROM SPOTIFY_DATA
WHERE LICENSED=TRUE;

--4.Find all tracks that belong to the album type single.

SELECT TRACK
FROM SPOTIFY_DATA
WHERE ALBUM_TYPE IN('single');


--5.Count the total number of tracks by each artist.

SELECT ARTIST,COUNT(*)
FROM SPOTIFY_DATA
GROUP BY ARTIST;

-- -------------------------
-- DATA ANALYSIS MEDIUM CATEGORY
-- -------------------------

--6.Calculate the average danceability of tracks in each album.

SELECT ALBUM,AVG(DANCEABILITY)
FROM SPOTIFY_DATA
GROUP BY ALBUM
ORDER BY 2 DESC;

--7.Find the top 5 tracks with the highest energy values.

SELECT TRACK,MAX(ENERGY)
FROM SPOTIFY_DATA
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--8.List all tracks along with their views and likes where official_video = TRUE.

SELECT TRACK,SUM(VIEWS),SUM(LIKES)
FROM SPOTIFY_DATA
WHERE OFFICIAL_VIDEO=TRUE
GROUP BY 1
ORDER BY 3 DESC;

--9.For each album, calculate the total views of all associated tracks.

SELECT ALBUM,TRACK,SUM(VIEWS)AS TOTAL_VIEWS
FROM SPOTIFY_DATA
GROUP BY 1,2;


--10.Retrieve the track names that have been streamed on Spotify more than YouTube.

WITH MOST_STREAM AS
(
SELECT TRACK,
SUM(CASE WHEN MOST_PLAYED_ON='Spotify' THEN STREAM END) AS STREAM_ON_SPOTIFY,
SUM(CASE WHEN MOST_PLAYED_ON='Youtube' THEN STREAM END) AS STREAM_ON_YOUTUBE
FROM SPOTIFY_DATA
GROUP BY 1)
SELECT TRACK
FROM MOST_STREAM
WHERE STREAM_ON_SPOTIFY >STREAM_ON_YOUTUBE
AND STREAM_ON_YOUTUBE<>0;

-- -------------------------
-- ADVANCED PROBLEMS
-- -------------------------

--11.Find the top 3 most-viewed tracks for each artist using window functions.

SELECT ARTIST,TRACK
FROM
(SELECT *,RANK() OVER(PARTITION BY ARTIST ORDER BY VIEWS DESC) AS RN
FROM SPOTIFY_DATA)TOP
WHERE TOP.RN<=3;

--12.Write a query to find tracks where the liveness score is above the average.

SELECT TRACK,LIVENESS
FROM SPOTIFY_DATA
WHERE LIVENESS>(SELECT AVG(LIVENESS)
FROM SPOTIFY_DATA);

--13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH TOP_ENERGY AS
(
SELECT ALBUM,MAX(ENERGY) AS HIGHEST,MIN(ENERGY) AS LOWEST
FROM SPOTIFY_DATA
GROUP BY 1
)
SELECT ALBUM,HIGHEST,LOWEST,HIGHEST-LOWEST AS DIFFERENCE
FROM TOP_ENERGY
ORDER BY 2 DESC;

--QUERY OPTIMIZATION

--BEFORE CREATING INDEX

EXPLAIN ANALYZE --EXECUTION TIME 8.608ms
SELECT ARTIST,TRACK,ALBUM
FROM SPOTIFY_DATA
WHERE ARTIST='Gorillaz'
AND MOST_PLAYED_ON='Youtube'
ORDER BY VIEWS 
LIMIT 300;

CREATE INDEX ARTINDEX ON SPOTIFY_DATA(ARTIST)

--AFTER CREATING INDEX

EXPLAIN ANALYZE --EXECUTION TIME 1.276ms
SELECT ARTIST,TRACK,ALBUM
FROM SPOTIFY_DATA
WHERE ARTIST='Gorillaz'
AND MOST_PLAYED_ON='Youtube'
ORDER BY VIEWS 
LIMIT 300;



