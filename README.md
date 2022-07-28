# A bunch of one-shot scripts for AWS chores

## `aws-ecs-change-service-instance-count`: Want to set instance count for all services to a certain number?

The command `aws-ecs-change-service-instance-count` sets the instance count of all services to a given number. The default
value for `instancecount` is 1.

Useful when you want to stop all tasks in an ECS cluster. Less useful if you want to restore the instance count, especially if
not all services had the same instance count. :-)


```
aws-ecs-change-service-instance-count <clustername>
```

```
aws-ecs-change-service-instance-count <clustername> 0
```

## `aws-restart-all-services`: Perform a forced deployment on all services in a given cluster

```bash
aws-restart-all-services <clustername>
```

## `aws-restart-services`: Perform a forced deployment on a list of services in a given cluster

```bash
aws-restart-services <clustername> <servicename1> [<servicename2> ...]
```

## `aws-get-ses-account-suppression-list.bash`: Retrieve complete SES account suppression list

## `aws-remove-events-rule.bash`: Remove all targets from the rule and the rule itself

## `aws-list-active-images-in-ecs.bash`: Show all active ECS services and all docker images used in each of those services

This command outputs all active ECS services and all docker images used in each of those services for a given cluster.

```bash
$ ./aws-list-active-images-in-ecs.bash myCluster
myService1: myImage1:tag1
myService2: myImage2a:tag2a
myService2: myImage2b:tag2b
myService3: myImage3:tag3
```

## `aws_manage_sg_rule.bash`: Add ingress rule to an SG whose name contains a string

To add an _ingress_ rule to allow traffic on port `1234` originating from `1.2.3.4/32`:

```
./aws_manage_sg_rule.bash my_sg authorize 1234 1.2.3.4/32
```

To remove that rule:

```
./aws_manage_sg_rule.bash my_sg revoke 1234 1.2.3.4/32
```

## `aws_unsubscribe_loggroups.bash`

Remove the subscription from log groups that match a string in a list of string.

## `aws_delete_loggroups_older_than.bash`

Remove CloudWatch log groups with names matching a string and created more than
the given number of seconds (defaults to 1 week) ago.

```
./aws_delete_loggroups_older_than.bash S3LogsTo 3600
```

## `aws_toggle_access_key_state.bash`

Enable or disable all access keys for a user in an AWS account.

```
aws_toggle_access_key_state.bash <username> Inactive
```

```
aws_toggle_access_key_state.bash <username> Active
```

## `aws_create_timeboxed_role`

This script creates a time-boxed IAM role for a given user on a given account.

```bash
$ aws_create_timeboxed_role --help
    Usage: aws_create_timeboxed_role -u username -s nn -e mm
      nn: starting hour of validity of role
      mm: ending hour of validity of role
      nn < mm
```

The above command will create or update a role on the account for which credentials are set
in the shell environment it is running in, for a given user and a given timeframe within the
current day.

The trust policy allows the role to be assumed by users from the bastion account, the only
AWS account in our organization where _real_ users live. The user configuration on the
bastion account only allow users to assume roles on certain AWS accounts, and only the role
that is specifically created for that user.

Finally, the role contains one managed policy, granting the user permission to use AWS SSM
to connect to EC2 instances on that account.

## `aws_update_retentiondays_loggroup.bash`

Update the retention period in days of the log group(s) in an AWS account.

Update `all` log groups to `180` days
```
aws_update_retentiondays_loggroup.bash 180
```

Update a `single` log group to `180` days
```
aws_update_retentiondays_loggroup.bash 180 <loggroup name>
```

## `aws_upload_artifacts_to_codeartifact.bash`

Download the artifacts from S3 and upload them to AWS Codeartifact.

### Requirements:
* `CODEARTIFACT_AUTH_TOKEN` set.
* Create text file named: `S3Download.txt` (same folder)
* `S3_URL` needs to be set to the storage path of the bucket (e.g. `s3://.../home_nexus/sonatype-work/nexus/storage`)
* `CODEARTIFACT_URL` needs to be set to the storage path of the bucket (e.g. `https://<artifact-domain>-<account-id>.d.codeartifact.eu-central-1.amazonaws.com/maven/../`)

#### File structure

```
1: File path inside S3 (from ..k/nexus/storage/) 
2: Folder to copy to  
3: namespace
4: artifact
5: version

e.g.
/ixor-external/com/google/guava/10.0.1.v201203051515/ com.google.guava-10.0.1.v201203051515 com.google guava 10.0.1.v201203051515
```

### Upload all artifacts inside specified folder.

```
./aws_upload_artifacts_to_codeartifact.bash
```
