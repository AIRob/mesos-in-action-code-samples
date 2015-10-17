This directory contains examples from chapter 07: Deploying Applications with
Marathon.

## Deploying the example apps on Marathon

### OutputEnv
The following command will create *OutputEnv* as a new Marathon application.

```
$ curl -H 'Content-Type: application/json' -d @output-env.json marathon-host:8080/v2/apps
```

### Nginx Docker image
The following command will launch the Nginx Docker image as a new Marathon
application.

```
$ curl -H 'Content-Type: application/json' -d @docker-nginx.json marathon-host:8080/v2/apps
```

### Keys and Values
The following command will create *Keys and Values* as a new Marathon
application group.

```
$ curl -H 'Content-Type: application/json' -d @keys-and-values.json marathon-host:8080/v2/groups
```

### Logging
See `marathon-rsyslog.conf` for an example on how to reconfigure Rsyslog to
redirect logging entries from Marathon into their own file. The file should
be placed at `/etc/rsyslog.d/10-marathon.conf`, or something similar.
