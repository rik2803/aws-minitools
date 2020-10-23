# A bunch (not yet but maybe one day) of one-shot scripts for AWS chores


## `aws_manage_sg_rule.bash`: Add ingress rule to a SG whose name contains a string

To add an _ingress_ rule to allow traffic on poer `1234` originating from `1.2.3.4/32`:

```
./aws_manage_sg_rule.bash my_sg authorize 1234 1.2.3.4/32
```

To remove that rule:

```
./aws_manage_sg_rule.bash my_sg revoke 1234 1.2.3.4/32
```

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
