This directory contains examples from chapter 09: Deploying Applications and
Managing Scheduled Tasks with Aurora.

### aurora-build.sh
This script can be used to build the various components that make up Apache
Aurora, including the scheduler, client, admin client, executor, and observer.
This script allows you to build all of these components on a dedicated build
machine, then copy the resulting binaries / executables to the appropriate
machines in your Mesos cluster for installation.

This script is currently compatible with RHEL / CentOS 7.x and Ubuntu 14.04.

Example usage: `./aurora-build.sh all`

### aurora-scheduler.sh
This is an example shell script that can be used to configure an instance of
the Aurora scheduler. It should be used alongside an operating system's
(or sysadmin's) preferred service manager or supervisor, such as Systemd,
Upstart, or Supervisord.

### clusters.json
An example configuration file for the Aurora client. Place this file at
`/etc/aurora/clusters.json` or `~/.aurora/clusters.json`.

### daily-weather-cron.aurora
Runs the `email-weather-forecast.py` example script in a Docker container.
Create the cron job by running the following command:

    $ aurora cron schedule aurora-cluster/www-data/prod/daily-weather-report daily-weather-cron.aurora

### docker-nginx.aurora
As of Aurora 0.9.0, Docker support is experimental at best, and Aurora doesn't
expose all of the `DockerInfo` fields available in Mesos. This is an example
Aurora job that effectively "shells out" to the `docker run` command present
on the Mesos slave.

You can create the job that launches the Nginx 1.9 Docker container by running
the following command:

    $ aurora job create aurora-cluster/www-data/prod/docker-nginx docker-nginx.aurora

### outputenv.aurora
Run the OutputEnv example application included in this repository on Apache
Aurora. You can create the application by running the following command:

    $ aurora job create aurora-cluster/www-data/prod/outputenv outputenv.aurora

### simple-sleep-cron.aurora
A simple cron job that sleeps for 60 seconds every 5 minutes. To create the
cron job in Aurora, run the following command:

    $ aurora cron schedule aurora-cluster/www-data/prod/simple-sleep simple-sleep-cron.aurora
