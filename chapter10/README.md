# Chapter 10
This directory contains examples from Chapter 10: Developing a Mesos Framework.
Both the scheduler and executor are developed using Mesos 0.22.2 and Python 2.7.

## Notes
### Running the examples in a development environment
To run these examples, check out the [Playa Mesos][playa-mesos] Vagrant
environment from Mesosphere. By default, playa-mesos assumes you want to
install the absolute latest version of Mesos. In the case of this book, you'll
actually want Mesos 0.22.2.

After cloning the playa-mesos repository, replace `config.json` with the one
that I've included in this directory _before_ running `vagrant up --provision`.

### Ensuring the Mesos eggs are available to Python
When running the framework, you'll need to be sure that the Mesos eggs are
available on your `$PYTHONPATH`. Assuming that the Mesos eggs are located at
`/usr/local/lib/python2.7/site-packages`, you can do this two different ways.

When invoking the scheduler on the command line:
```bash
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
python2.7 scheduler.py
```

or in the Python file itself:
```python
import site
site.addsitedir('/usr/local/lib/python2.7/site-packages')
...
```

In each of the example files, I've already added the following paths to the
site path for you:

  * `/usr/lib/python2.7/site-packages`
  * `/usr/local/lib/python2.7/site-packages`

## Minimal scheduler and executor
There are two files in this repository that are used in the code listings in
chapter 10: `scheduler-minimal.py` and `executor-minimal.py`. These are the
bare-minimum implementations for a Mesos scheduler and executor.

## Skeletons
There are two files in this repository that can serve as a starting point for
developing your own Mesos framework (scheduler and executor) in Python.

### scheduler-skeleton.py
A basic skeleton for developing a Mesos scheduler. Stubs out all of the methods
available in the `mesos.interface.Scheduler` class, and includes the
docstrings from the bindings in the upstream Mesos project.

### executor-skeleton.py
A basic skeleton for developing a Mesos executor. Stubs out all of the methods
available in the `mesos.interface.Executor` class, and includes the
docstrings from the bindings in the upstream Mesos project.


[playa-mesos]: https://github.com/mesosphere/playa-mesos
