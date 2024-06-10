for name in *.gz; do
  destination="/josemaria/movies/${name%.tsv.gz}"
  file_name="${name%.gz}"
  hdfs dfs -mkdir -p $destination
  gzip -d -c "$name" | tail -n +2 | hdfs dfs -put - "${destination}/${file_name}"
done

# Run this only after checking files where correctly moved to HDFS
rm *.gz