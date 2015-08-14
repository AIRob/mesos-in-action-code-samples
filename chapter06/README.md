This directory contains examples from chapter 06: Mesos In Production.

### haproxy.cfg
This is an example [HAProxy](http://www.haproxy.org/) configuration file that
forwards all requests to the leading Mesos master.

### credentials-file.json
An example Mesos credentials file containing a list of principals (users) and
secrets (passwords) to be used with the `--credentials` configuration option
on the Mesos masters.

### slave-credentials
An example Mesos slave credentials file, containing a principal and a secret
separated by whitespace, to be used with the `--credential` configuration
option. Note: this file should not have a trailing newline.

### ex01-run_tasks-as-user.json
An example Mesos ACL. Permits the "jenkins" principal to run tasks on Mesos
slaves as the Linux user "jenkins".

### ex02-run_tasks-non-root-user.json
An example Mesos ACL. Prevents all principals from running tasks on Mesos slaves
as the Linux user "root".

### ex03-register_frameworks-whitelist-role.json
An example Mesos ACL. Only allow the principal "marathon" to register with the
"prod" role.

### ex04-register_frameworks-whitelist-role-restrictive.json
An example Mesos ACL. Only permit the principal "chronos" to register with the
"batch" role. No other frameworks are allowed to register with any roles.
