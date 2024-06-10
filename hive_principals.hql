-- First, map the TSV data in Hive
CREATE EXTERNAL TABLE josemaria_principals_tsv(
  tconst STRING,
  ordering BIGINT,
  nconst STRING,
  category STRING,
  job STRING,
  characters STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/josemaria/movies/principals';

-- Run a test query to make sure the above worked correctly
SELECT tconst, ordering, nconst, category, job, characters
FROM josemaria_principals_tsv
LIMIT 5;

-- Check if there are NULLs in person id (nconst) or job category (category)
SELECT tconst, ordering, nconst, category, job, characters
FROM josemaria_principals_tsv WHERE nconst IS NULL OR category IS NULL
LIMIT 5;

-- Check how many rows our dataset has with and without NULLs
SELECT COUNT(*) AS nrows
FROM josemaria_principals_tsv;
-- There are 59,463,445 rows (titles-principals observations) in total (avg of 5.7 principales per title)

-- Create an ORC table for ontime data (Note "stored as ORC" at the end)
CREATE EXTERNAL TABLE josemaria_principals(
  tconst STRING,
  ordering BIGINT,
  nconst STRING,
  category STRING,
  job STRING,
  characters STRING)
  STORED AS ORC;

-- Copy the TSV table to the ORC table
INSERT OVERWRITE TABLE josemaria_principals SELECT *
FROM josemaria_principals_tsv
WHERE nconst IS NOT NULL AND category IS NOT NULL
ORDER BY ordering ASC;

-- Check our dataset was correctly filtered
SELECT COUNT(*) AS nrows
FROM josemaria_principals;
-- Same number of rows as before

SELECT tconst, ordering, nconst, category, job, characters
FROM josemaria_principals WHERE nconst IS NULL OR category IS NULL
LIMIT 5;
-- There are no rows meaning we created the table correctly withouth NULLs

SELECT tconst, ordering, nconst, category, job, characters
FROM josemaria_principals ORDER BY tconst, ordering LIMIT 5;