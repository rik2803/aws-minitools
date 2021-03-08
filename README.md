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

## `aws_create_timeboxed_role`

This script creates a timeboxed IAM role for a given user on a given account.

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

