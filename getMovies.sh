mkdir moviesData
cd moviesData

for table in basics ratings principals; do
    url="https://datasets.imdbws.com/title.$table.tsv.gz"
    new_file_name="$table.tsv.gz"
    curl -o "$new_file_name" "$url"
done
