-- First, map the TSV data in Hive
CREATE EXTERNAL TABLE josemaria_basics_tsv(
  tconst STRING,
  titleType STRING,
  primaryTitle STRING,
  originalTitle STRING,
  isAdult TINYINT,
  startYear SMALLINT,
  endYear SMALLINT,
  runtimeMinutes SMALLINT,
  genres STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/josemaria/movies/basics';

-- Run a test query to make sure the above worked correctly
SELECT tconst, titleType, primarytitle, runtimeminutes, isadult, endyear
FROM josemaria_basics_tsv
LIMIT 5;

-- Check if there are NULLs in release year or genres
SELECT tconst, primarytitle, runtimeminutes, isadult, startYear, genres
FROM josemaria_basics_tsv WHERE genres IS NULL
LIMIT 5;

-- Check how many rows our dataset has with and without startyear and genres NULLs
SELECT COUNT(*) AS nrows
FROM josemaria_basics_tsv;
-- There are 10,384,671 rows (titles) in total!

SELECT COUNT(*) AS nrows
FROM josemaria_basics_tsv
WHERE startYear IS NOT NULL AND genres IS NOT NULL;
-- There are 8,614,846 rows (titles) withouth startyear and genres NULLs

-- Create an ORC table for ontime data (Note "stored as ORC" at the end)
CREATE EXTERNAL TABLE josemaria_basics(
  tconst STRING,
  titleType STRING,
  primaryTitle STRING,
  originalTitle STRING,
  isAdult TINYINT,
  startYear SMALLINT,
  endYear SMALLINT,
  runtimeMinutes SMALLINT,
  genres STRING)
  STORED AS ORC;

-- Copy the TSV table to the ORC table
INSERT OVERWRITE TABLE josemaria_basics SELECT *
FROM josemaria_basics_tsv
WHERE startYear IS NOT NULL AND genres IS NOT NULL
ORDER BY tconst ASC;

-- Check our dataset was correctly filtered
SELECT COUNT(*) AS nrows
FROM josemaria_basics;
-- There are 8,614,846 (titles) in total which match the number we got before

SELECT tconst, primarytitle, runtimeminutes, isadult, startYear, genres
FROM josemaria_basics WHERE startYear IS NULL OR genres IS NULL 
LIMIT 5;
-- There are no rows meaning we created the table correctly withouth NULLs