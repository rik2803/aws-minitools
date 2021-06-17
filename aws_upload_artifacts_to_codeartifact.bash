#!/bin/bash

S3_URL=${S3_URL:-s3://ixortooling-prd-backup-server22/home_nexus/sonatype-work/nexus/storage}
CODEARTIFACT_URL=${CODEARTIFACT_URL:-https://ixorartifacts-678053966837.d.codeartifact.eu-central-1.amazonaws.com/maven/IxorMaven/}

SPLIT=""
NAMESPACE=""
ARTIFACT=""
VERSION=""

filename='S3Download.txt'

while read line; do
  # Downloading artifacts
  SPLIT=($line)
  echo "Downloading artifacts to folder: ${SPLIT[1]} from S3 bucket: ${S3_URL}${SPLIT[0]}"
  aws s3 cp ${S3_URL}${SPLIT[0]} ${SPLIT[1]} --recursive

done < $filename

echo ""
echo "${NAMESPACE//./$'/'}"

FILES="${SPLIT[1]}/*"
for f in $FILES
do
  FILENAME=$(basename $f)
  echo "Filename base "  $FILENAME

  curl --request PUT ${CODEARTIFACT_URL}${SPLIT[2]//./$'/'}/${SPLIT[3]}/${SPLIT[4]}/${FILENAME} --user "aws:$CODEARTIFACT_AUTH_TOKEN" --header "Content-Type: application/octet-stream" --data-binary "@${f}"

done

aws codeartifact update-package-versions-status \
    --domain ixorartifacts \
    --domain-owner 678053966837 \
    --repository IxorMaven \
    --format maven \
    --namespace ${SPLIT[2]} \
    --package ${SPLIT[3]} \
    --versions ${SPLIT[4]} \
    --target-status Published &