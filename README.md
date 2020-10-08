# A bunch (not yet but maybe one day) of one-shot scripts for AWS chores

## `aws_unsubscribe_loggroups.bash`

Remove the subscription from loggroups that match a string in a list of string.

## `aws_delete_loggroups_older_than.bash`

Remove CloudWatch loggroups with names matching a string and created more than
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