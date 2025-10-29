CREATE TABLE spotify (
Artist VARCHAR(255),
Track VARCHAR(255),
Album VARCHAR(255),
Album_type VARCHAR(255),
Danceability FLOAT,
Energy  FLOAT,
Loudness  FLOAT,
Speechiness  FLOAT,
Acousticness  FLOAT,
Instrumentalness  FLOAT,
Liveness  FLOAT,
Valence  FLOAT,
Tempo  FLOAT,
Duration_min  FLOAT,
Title VARCHAR(255),
Channel VARCHAR(255),
Views  FLOAT,
Likes  BIGINT,
Comments  BIGINT,
Licensed BOOLEAN,
official_video BOOLEAN,
Stream BIGINT,
EnergyLiveness FLOAT,
most_playedon VARCHAR(50)
);

select count(*) from spotify;

select  count (distinct artist)  from spotify
select  count (distinct  album)  from spotify

select  MAX(Duration_min) FROM spotify
select  min(Duration_min) FROM spotify
select  * FROM spotify
where Duration_min = 0;

 delete from spotify
 where Duration_min =0
 select  * FROM spotify
where Duration_min = 0;

--------------------------------
---- EASY QUENSTIONS
--------------------------------
--- 1 Retrieve the name of all tracks that have more than 1 billion stream
 select * from spotify
 WHERE Stream > 1000000000;

 --- 2 list all albums along with their respective artist

  select distinct album, artist 
  from spotify
  order by 1 
  
  --- 3 Get the total number of comments for tracks where licensed =true
  
   select   sum(comments )
   from spotify
   WHERE licensed = 'TRUE' 
  
 --- 4 find all tracks that belong to the albume type single
  SELECT * FROM spotify
  WHERE album_type ='single' 
 
----5 count the total number of tracks by each artist
SELECT  artist ,
  count(*) as total_number
  FROM spotify
  group by artist
  order by 2 desc

----------------------------------------
---------- Medium level
---------------------------------------

----1 calculate the average danceability of tracks in each albume 
 select album,
  AVG (danceability) as danceability_avg
  from spotify
  group by album 
  order by  danceability_avg desc;


 ----2 Find the top 5 tracks with the highest energy values
	SELECT  TRACK , 
	ENERGY
	FROM SPOTIFY
	ORDER BY ENERGY DESC    ------------- DIFFERENT OUTPUT  -- DUPLICATED VALUES 
	LIMIT 5

	SELECT  TRACK,
	       MAX(ENERGY)
     FROM SPOTIFY                             ------- DIFFERENT OUTPUT ''
	 GROUP BY 1
	 ORDER BY 2 DESC
	 LIMIT 5
	 
 
--- 3 List all tracks along with their views and likes where the offical_video = TRUE

 SELECT * FROM SPOTIFY;
 
 SELECT track 
 , sum(views) as total_view     ---- no dulicpated
 , sum(likes) as total_like 
 FROM Spotify
 where official_video = 'true '
 group by 1
 order by  2 desc


 select  track , views,likes
 from spotify                              -------------- dulicated values 
 where official_video = 'true '
 order by  views desc

 ---- 4 FOR each  album , calculate the total views  of all associated tracks 
  SELECT  album, 
          track ,
		  sum(views) as total_view 
FROM spotify
GROUP BY 1,2 
order by 3 desc;

---- 5 Retrieve the track names that have been stremed on spotify more than youtube 

SELECT	* FROM 
(SELECT track , 
  COALESCE (sum(case  WHEN most_playedon ='youtube' THEN  stream END),0)  as stream_youtube,
  COALESCE (sum(case  WHEN most_playedon ='spotify' THEN  stream END),0)  as stream_spotify
  from spotify 
  group by 1
) AS t1
where  
stream_spotify > stream_youtube
AND   
stream_youtube <> 0


SELECT * FROM 
(SELECT track,
   COALESCE (SUM(CASE WHEN most_playedon ='youtube' THEN stream END),0) STREAM_ON_YOUTUBE,
   COALESCE (SUM(CASE WHEN most_playedon ='spotify' THEN stream END),0) STREAM_ON_SPOTIFY
   FROM spotify
   GROUP BY 1
   ) as t1
   WHERE  
   STREAM_ON_SPOTIFY > STREAM_ON_YOUTUBE
   AND 
   STREAM_ON_YOUTUBE <>0
------------------------------
---------- high level 
------------------------------
---1 FIND THE TOP 3 MOST VIEWS TRACKS FOR EACH ARTIST USING WINDOWS FUNCTION

SELECT * FROM spotify
WITH ranking_artist
as
(SELECT artist , track , sum(views) as total_views ,
DENSE_RANK () OVER(PARTITION BY artist order by sum(views) desc) as ranks
from spotify
group by artist , track
order by 1,3 DESC
)
SELECT * FROM ranking_artist
 where ranks <=3

--2 WRITE A QUERY TO FIND TRACKS WHERE THE LIVENESS SCORE IS ABOVE THE AVERAGE 

 select  
        artist , track , liveness
 from spotify
 WHERE liveness > (select avg(liveness) from spotify)


 ---3 used a with clause to calculate the differences between 
----- highest and lowest enegry values for tracks in each album 
 with high
 as
 (SELECT  album,
		 max(energy) as highest_energy ,
		 min(energy) as lowest_energy
from spotify
group by 1 
)
select  album ,
    highest_energy - lowest_energy as energy_differencess
FROM high 
order by 2 desc

--------------------------
EXPLAIN ANALYZE                     --------- SPEED  OF EXECUTION
SELECT * FROM spotify
 