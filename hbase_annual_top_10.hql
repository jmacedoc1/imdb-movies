CREATE EXTERNAL TABLE josemaria_hbase_annual_top_10 (
  year_rank STRING,
  primarytitle STRING,
  genres STRING,
  runtimeminutes SMALLINT,
  averagerating FLOAT,
  numvotes INT)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,
rating:primarytitle,rating:genres,rating:runtimeminutes,rating:averagerating,
rating:numvotes')
TBLPROPERTIES ('hbase.table.name' = 'josemaria_hbase_annual_top_10');

INSERT OVERWRITE TABLE josemaria_hbase_annual_top_10
SELECT CONCAT(year, ranking), primarytitle, genres, runtimeminutes,
averagerating, numvotes
FROM josemaria_top_10_by_year;

SELECT year_rank, primarytitle, genres, averagerating
FROM josemaria_hbase_annual_top_10;