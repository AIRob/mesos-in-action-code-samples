#!/bin/bash
export MESOS_NATIVE_LIBRARY=/usr/local/lib/libmesos.so
export MASTER=mesos://zk://10.132.171.226:2181/mesos
export SPARK_MESOS_COARSE=true
export SPARK_EXECUTOR_EXTRA_LIBRARY_PATH=/usr/lib/hadoop/lib/native
export SPARK_EXECUTOR_EXTRA_JAVA_OPTIONS=-XX:-UseConcMarkSweepGC
export SPARK_LOCAL_IP=10.132.171.226
