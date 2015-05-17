This directory contains example configuration files to be used with both
Mesos and ZooKeeper.

### mesos-master-env.sh
An example Mesos master config file, to be used when Mesos has been compiled
from source. This file should be placed at
`${MESOS_INSTALL}/etc/mesos/mesos-master-env.sh`.

At the very least, you will need to modify the `$MESOS_zk` variable included
in this script.

For a complete list of configuration options for Mesos masters, see the output
of `mesos-master --help`.

### mesos-slave-env.sh
An example Mesos slave config file, to be used when Mesos has been compiled
from source. This file should be placed at
`${MESOS_INSTALL}/etc/mesos/mesos-slave-env.sh`.

At the very least, you will need to modify the `$MESOS_zk` variable included
in this script.

For a complete list of configuration options for Mesos slaves, see the output
of `mesos-slave --help`.

### zoo.cfg
This is a basic config file for ZooKeeper. It should be placed at
`/etc/zookeeper/conf/zoo.cfg`.

At the very least, you will need to modify the list of servers included in this
file to match the hostnames or IP addresses of the servers in your ZooKeeper
ensemble.
