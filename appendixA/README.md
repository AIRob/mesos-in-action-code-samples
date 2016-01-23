# Appendix A
This directory contains examples from Appendix A: Mesosphere DCOS, An Enterprise
Mesos Distribution.

To follow along with the case study presented in the book, the contents of
this directory are best suited to live in their own Git repository, following
the same directory structure that I have here.

## app
A static HTML and CSS example application, based on the [Jumbotron Narrow][0]
example in [Bootstrap][1].

## build-script.sh
An example build script that you can use in a Jenkins job. This script can
be committed alongside your application's code and referred to in the Jenkins
job, or you can copy/paste it into Jenkins itself and not commit it to version
control. Personally, I prefer the first option.

## Dockerfile
This is a simple Dockerfile that begins with the `nginx:1.9` Docker image and
copies the static HTML and CSS files from the `app/` directory to the image.
So when the Docker image is launched, Nginx will start up and host the static
site in the `app/` directory. Commit the Dockerfile alongside your
application's code.

## marathon.json
An example Marathon JSON object defining your application. Modify this to suit
your needs, and commit it alongside your application's code. Note that the
value for the Docker image and tag will be overwritten by the build script
when a new version of the application is deployed to Marathon.

[0]: https://getbootstrap.com
[1]: http://getbootstrap.com/examples/jumbotron-narrow/
