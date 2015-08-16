This directory contains examples from chapter 06: Mesos In Production.

### acls/
This directory contains access control list (ACL) examples.

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
