CREATE TABLE josemaria_top_10_by_year (
  year SMALLINT,
  primaryTitle STRING,
  genres STRING,
  runtimeMinutes SMALLINT,
  averageRating FLOAT,
  numvotes INT,
  ranking TINYINT);

INSERT OVERWRITE TABLE josemaria_top_10_by_year
SELECT year, primarytitle, genres, runtimeMinutes, averagerating, numvotes, ranking
FROM (
    SELECT year, primarytitle, genres, runtimeMinutes, averagerating, numvotes,
    ROW_NUMBER() OVER (PARTITION BY year ORDER BY averagerating DESC) AS ranking
    FROM josemaria_basics_ratings WHERE numvotes >= 30000 AND titletype = "movie"
) AS ranked_ratings
WHERE ranking <= 10;

-- Check if table was created correctly by querying something simple
SELECT year, primarytitle, averagerating, numvotes, ranking
FROM josemaria_top_10_by_year
WHERE year BETWEEN 2000 AND 2005
ORDER BY year, ranking ASC;