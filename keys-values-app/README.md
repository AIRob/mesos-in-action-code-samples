# Keys and Values App

A simple Ruby web application (implemented using the Sinatra framework) that
stores key/value pairs in a Redis database.

## Prerequisites

Each of the machines running this web app must have the following already
installed:

  - Ruby - tested with versions 1.9.3, 2.0.0, and 2.1.5
  - Bundler - tested with version 1.8.4

## Usage

The listening port for the application will use the environment variable
`$PORT`, as set by Marathon. If the variable isn't set, it will fallback to
8080.

Furthermore, the following environment variables must be set:
  - `REDIS_HOST`
  - `REDIS_PORT`

Install the necessary Ruby gems:

```
$ bundle install
```

Run the app:

```
$ bundle exec ruby app.rb
```

## Deploying the App

There are examples located in the `examples/` directory.

