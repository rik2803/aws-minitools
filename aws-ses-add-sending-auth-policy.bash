#!/bin/bash

set -e
set -o pipefail

dirname=$(dirname ${0})
. ${dirname}/./lib.bash

[[ -z ${1} ]] && fail "Usage: ${0} sesIdentity srcAccountId dstAccountId"
[[ -z ${2} ]] && fail "Usage: ${0} sesIdentity srcAccountId dstAccountId"
[[ -z ${3} ]] && fail "Usage: ${0} sesIdentity srcAccountId dstAccountId"

sesIdentity="${1}"
srcAccountId="${2}"
dstAccountId="${3}"

cat > ./policy-${$}.json << EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AccountId${srcAccountId}",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${srcAccountId}:root"
            },
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "arn:aws:ses:eu-west-1:${dstAccountId}:identity/${sesIdentity}"
        }
    ]
}
EOF

aws ses put-identity-policy --identity "${sesIdentity}" --policy-name "pol-${srcAccountId}" --policy "file://./policy-${$}.json" --region "${awsRegion:-eu-west-1}"

