# spark-primes-example
A simple Spark example to find prime numbers within a set.

## Configuration
This example was developed and tested on a cluster running Mesos 0.22.0 and
CDH 5.3.

You'll need to set up `$SPARK_HOME/conf/spark-env.sh` similar to the example
found at `conf/spark-env.sh`, replacing `$MASTER` and `$SPARK_LOCAL_IP` as
appropriate.

You also might want to reduce logging verbosity. You may do so by copying
the example found at `conf/log4j.properties` to
`$SPARK_HOME/conf/log4j.properties`.

## Usage
Clone the repo and package up the example:

```
git clone https://github.com/rji/mesos-in-action-code-samples
cd mesos-in-action-code-samples/chapter02/spark-primes-example
sbt package
```

On your gateway machine, submit the job. By default, the job will run with a
set size of `100000`. You can optionally provide an integer argument. The
example below uses a `setSize` of `100`.

```
/opt/spark/bin/spark-submit --class com.manning.mesosinaction.PrimesExample \
  target/scala-2.10/spark-primes-example_2.10-0.1.0-SNAPSHOT.jar 100
```

## Results
With the example above, we get a data set of integers from 1 to 100, and observe
the following output on the console:

```
I0411 23:19:06.344908 10360 sched.cpp:448] Framework registered with 20150411-201705-3802891274-5050-4398-0007
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
I0411 23:19:12.936801 10305 sched.cpp:1589] Asked to stop the driver
I0411 23:19:12.937367 10363 sched.cpp:831] Stopping framework '20150411-201705-3802891274-5050-4398-0007'
```

