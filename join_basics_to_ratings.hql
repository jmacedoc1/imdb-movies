CREATE TABLE josemaria_basics_ratings (
  tconst STRING,
  year SMALLINT,
  titleType STRING,
  primaryTitle STRING,
  runtimeMinutes SMALLINT,
  genres STRING,
  averageRating FLOAT,
  numvotes INT)
  STORED AS ORC;

INSERT OVERWRITE TABLE josemaria_basics_ratings
SELECT b.tconst AS tconst, b.startyear AS year, b.titletype AS titletype,
b.primarytitle AS primarytitle, b.runtimeMinutes AS runtimeMinutes,
b.genres AS genres, r.averageRating AS averageRating, r.numvotes AS numvotes
FROM josemaria_basics b JOIN josemaria_ratings r
ON b.tconst = r.tconst;

-- Check if tables were joined correctly with a simple query
SELECT year, titleType, primaryTitle, genres, averageRating, numvotes
FROM josemaria_basics_ratings ORDER BY numvotes ASC LIMIT 100;