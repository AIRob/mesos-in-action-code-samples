#!/bin/bash
# Configuration script for an Apache Aurora scheduler.

# Directory that the Aurora scheduler is installed to
AURORA_SCHEDULER_HOME=/usr/local/aurora-scheduler

# Google logging library logging level. "0" represents INFO-level logging.
export GLOG_v=0

# LIBPROCESS_IP and LIBPROCESS_PORT controls the configuration of the
# Mesos scheduler driver.
export LIBPROCESS_IP=10.141.141.10
export LIBPROCESS_PORT=8083

# JVM options: ensure libmesos.so is on java.library.path,
# and set the initial and maximum heap sizes.
export JAVA_OPTS="-Djava.library.path=/usr/lib -Xms2g -Xmx2g"

# An array of Aurora options that will be passed to the executable.
# For a complete list, see `aurora-scheduler --help`
#
# In a number of places, we've substituted in values that are already
# configured for Mesos. This only works if the Aurora instances are
# being deployed on the same machines as the Mesos masters.
AURORA_OPTS=(
    -zk_endpoints=$(cut -d / -f 3 /etc/mesos/zk)
    -mesos_master_address=$(cat /etc/mesos/zk)
    -native_log_quorum_size=$(cat /etc/mesos-master/quorum)
    -cluster_name=aurora-cluster
    -http_port=8081
    -serverset_path=/aurora/scheduler
    -native_log_zk_group_path=/aurora/replicated-log
    -native_log_file_path=/var/db/aurora
    -backup_dir=/var/lib/aurora/backups
    -vlog=INFO
    -logtostderr
    -allowed_container_types=DOCKER,MESOS
    -thermos_executor_path=/usr/local/aurora-executor/thermos.pex
    -thermos_exeuctor_flags="--announcer-enable --announcer-ensemble $(cut –d / -f 3 /etc/mesos/zk)"
)

exec "${AURORA_SCHEDULER_HOME}/bin/aurora-scheduler" "${AURORA_OPTS[@]}"
