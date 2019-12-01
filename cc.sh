#!/bin/bash
echo "-----------------------------------------------------"
echo "Commoncrawl url searcher by nukedx"
echo "-----------------------------------------------------"
if [[ $# -eq 0 ]]; then
        echo "Error: You didn't enter a target"
        echo "Usage: $0 <target>"
        echo "Example: $0 google.com"
        exit
fi
declare domain=$1
declare -a results
declare outputStyle="output=json&fl=url"
if [[ $# -eq 2 ]]; then
        outputStyle="output=json&fl=url&filter=$2"
        echo "Applying special filter: $2"
fi
echo "Started commoncrawl search for $domain"
echo "Getting database infos"
declare crawldatabases=$(curl -s http://index.commoncrawl.org/collinfo.json)
declare dbamount=$(echo $crawldatabases | jq -c '.[]["cdx-api"]' | wc -w)
echo "$dbamount active databases found"
for (( c=1 ; c<dbamount; c++))
do
        currentData=$(echo $crawldatabases | jq -c '.['$c']')
        currentdatabase=$(echo $currentData | jq -c '.["name"]' | sed 's/\"//g')
        echo "Searching $domain on $currentdatabase"
        targeturl=$(echo $currentData | jq -c '.["cdx-api"]' | sed 's/\"//g')
        fetchedData=$(curl -s "$targeturl?url=*.$domain/*&$outputStyle" | jq -c .url)
        if [[ $fetchedData != "null" ]]; then
                results+="$fetchedData "
        fi
done
echo "-----------------------------------------------------"
echo "Fetched all databases for $domain"
filename="CC-$domain-$(date "+%Y.%m.%d-%H.%M").txt"
echo $results | jq . | sed 's/\"//g' | sort -u > $filename
count=$(wc -l $filename | awk {'print $1'})
echo "Saved output on: $filename"
echo "Total urls found: $count"
echo "-----------------------------------------------------"
