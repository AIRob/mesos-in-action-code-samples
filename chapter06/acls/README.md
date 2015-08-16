Access control list (ACL) examples.

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
