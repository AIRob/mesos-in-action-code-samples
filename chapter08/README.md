This directory contains examples from chapter 08: Managing Scheduled Tasks with
Chronos.

### A simple "sleep" job
The file `simple-sleep.json` contains a single Chronos job that runs on a
schedule. It simple prints the date and time every 3 seconds, and stops after
10 iterations.

Deploy this job using the Chronos REST API:
```
$ curl -H 'Content-Type: application/json' -d @simple-sleep.json \
http://<chronos-host>:4400/scheduler/iso8601
```

## A simple Docker job: e-mail yourself the latest weather report
The file `simple-docker.json` contains a single Chronos job that runs on a
schedule. It downloads the script from this GitHub repository and runs it inside
the [`python:3.4.3`][python-docker-image] Docker image.

To use, modify the following environment variables within `simple-docker.json`.

Required variables:
  * `TO_EMAIL_ADDR` - your e-mail address
  * `ZIP_CODE` - the USPS zip code you'd like the weather for

Optional variables:
  * `FROM_EMAIL_ADDR` - your service's e-mail address. If not specified,
  defaults to `weather@localhost`
  * `MAIL_SERVER` - the hostname and port of your mail server. Defaults to
  `localhost:25`.
  * `MAIL_USERNAME` - if authentication is required, the username to use when
  authenticating with your mail server. No default.
  * `MAIL_PASSWORD` - if authentication is required, the password to use when
  authenticating with your mail server. No default.

Deploy this job using the Chronos REST API:

```
$ curl -H 'Content-Type: application/json' -d @simple-docker.json \
http://<chronos-host>:4400/scheduler/iso8601
```

[python-docker-image]: https://hub.docker.com/_/python
