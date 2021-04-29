#! /bin/bash

echo "Updating Retention Days Log groups"

if [ -z "$2" ]
then
	aws logs describe-log-groups --query 'logGroups[*]' | jq -r ".[] | select(.retentionInDays != null ) | select(.retentionInDays != $1 ) | .logGroupName" > temp.txt
else
	aws logs describe-log-groups --query 'logGroups[*]' | jq -r ".[] | select(.retentionInDays != null ) | select(.retentionInDays != $1 ) | select(.logGroupName == \"$2\" ) | .logGroupName" > temp.txt
fi

while read line; do

echo "Updating retention days log group: $line"
aws logs put-retention-policy --log-group-name $line --retention-in-days $1

done < temp.txt

rm -f temp.txt
