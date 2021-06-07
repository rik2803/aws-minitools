#!/bin/bash

echo "Starting copy to AWS Codeartifact"

folder=$1
groupid1=$2
groupid2=$3
artifactid=$4
version=$5


FILES="${folder}/*"
for f in $FILES
do
  filename=$(basename $f)
  echo $filename
  curl --request PUT https://$DOMAIN-$ACCOUNT_ID.d.codeartifact.$REGION.amazonaws.com/maven/$REPOSITORY/$groupid1/$groupid2/$artifactid/$version/$filename --user "aws:$CODEARTIFACT_AUTH_TOKEN" --header "Content-Type: application/octet-stream" --data-binary "@${f}"
done

aws codeartifact update-package-versions-status \
    --domain $DOMAIN \
    --domain-owner $ACCOUNT_ID \
    --repository $REPOSITORY \
    --format maven \
    --namespace $groupid1.$groupid2 \
    --package $artifactid \
    --versions $version \
    --target-status Published &

echo "Copy to AWS Codeartifact finished & artifact published"