This directory contains examples from chapter 09: Deploying Applications and
Managing Scheduled Tasks with Aurora.

### aurora-scheduler.sh
This is an example shell script that can be used to configure an instance of
the Aurora scheduler. It should be used alongside an operating system's
(or sysadmin's) preferred service manager or supervisor, such as Systemd,
Upstart, or Supervisord.

### outputenv.aurora
Run the OutputEnv example application included in this repository on Apache
Aurora. You can create the application by running the following command:

    $ aurora job create aurora-cluster/www-data/prod/outputenv outputenv.aurora

