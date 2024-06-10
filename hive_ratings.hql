-- First, map the TSV data in Hive
CREATE EXTERNAL TABLE josemaria_ratings_tsv(
  tconst STRING,
  averageRating FLOAT,
  numVotes INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/josemaria/movies/ratings';

-- Run a test query to make sure the above worked correctly
SELECT tconst, averagerating, numvotes
FROM josemaria_ratings_tsv
LIMIT 5;

-- Check if there are NULLs in ratings (An: there are not any NULLs)
SELECT tconst, averagerating, numvotes
FROM josemaria_ratings_tsv WHERE averagerating IS NULL
LIMIT 5;

-- Check how many rows our dataset has with and without startyear and genres NULLs
SELECT COUNT(*) AS nrows
FROM josemaria_ratings_tsv;
-- There are 1,377,957 (titles) with ratings in total (13% of all titles)

-- Create an ORC table for ontime data (Note "stored as ORC" at the end)
CREATE EXTERNAL TABLE josemaria_ratings(
  tconst STRING,
  averageRating FLOAT,
  numVotes INT)
  STORED AS ORC;

-- Copy the TSV table to the ORC table
INSERT OVERWRITE TABLE josemaria_ratings SELECT *
FROM josemaria_ratings_tsv
WHERE averagerating IS NOT NULL
ORDER BY tconst ASC;

-- Check our dataset was correctly filtered
SELECT COUNT(*) AS nrows
FROM josemaria_ratings;
-- There are 1,377,957 (titles) in total which match the number we got before

SELECT tconst, averagerating, numvotes
FROM josemaria_ratings WHERE averagerating IS NULL
LIMIT 5;
-- There are no rows meaning we created the table correctly withouth NULLs