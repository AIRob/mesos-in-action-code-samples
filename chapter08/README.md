# Chapter 08
This directory contains examples from Chapter 08: Managing Scheduled Tasks with
Chronos.

## Simple jobs
The "simple" Chronos examples are located in the `simple-jobs/` directory.

### A simple "sleep" job
The file `simple-sleep.json` contains a single Chronos job that runs on a
schedule. It simple prints the date and time every 3 seconds, and stops after
10 iterations.

Deploy this job using the Chronos REST API:
```
$ curl -H 'Content-Type: application/json' -d @simple-jobs/simple-sleep.json \
http://<chronos-host>:4400/scheduler/iso8601
```

### A simple Docker job: e-mail yourself the latest weather report
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
$ curl -H 'Content-Type: application/json' -d @simple-jobs/simple-docker.json \
http://<chronos-host>:4400/scheduler/iso8601
```

## Complex jobs
An example of a "complex" Chronos job -- that is, one or more schedule-based
jobs, followed by one or more dependency-based jobs -- is located in the
`complex-etl-job/` directory.

### War and Peace Word Count
The three jobs in the `complex-etl-job` directory make up a chain of Chronos
jobs that will download the text of "War and Peace" by Leo Tolstoy from
Project Gutenberg, run a Spark job to count the number of words, and then run
a final job to read the word counts in and display the top 20 words in the
Mesos web UI.

To create these jobs, run the following command:

```
$ complex-etl-job/create-jobs.sh <http://chronos-host:4400>
```

For more information on how this works, see the README file located in
the `../wordcount-example/` directory.

[python-docker-image]: https://hub.docker.com/_/python
