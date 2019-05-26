#! /usr/bin/env bash

for loggroup in $(aws logs  describe-log-groups --query 'logGroups[*].[logGroupName][]' --output text); do
  for substr in S3LogsToCloudwatchLambda ChatWebhook CWLogsSubscription EC2InstallCWAgent LambdaCumulativeReservationMetric AwsLambdaS3LogsToCloudwatch; do
    if [[ ${loggroup} =~ ${substr} ]]; then
      echo "INFO: Unsubscribing ${loggroup}"
      aws logs delete-subscription-filter --log-group-name ${loggroup} --filter-name SubscriptionFilter
    fi
  done
done

