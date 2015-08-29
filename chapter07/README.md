Instructions for deploying the example applications on Marathon.

## OutputEnv
The following command will create *OutputEnv* as a new Marathon application.

```
$ curl -i -H 'Content-Type: application/json' -d @output-env.json marathon-host:8080/v2/apps
```

## Nginx Docker image
The following command will launch the Nginx Docker image as a new Marathon
application.

```
$ curl -i -H 'Content-Type: application/json' -d @docker-nginx.json marathon-host:8080/v2/apps
```

## Keys and Values
The following command will create *Keys and Values* as a new Marathon
application group.

```
$ curl -i -H 'Content-Type: application/json' -d @keys-and-values.json marathon-host:8080/v2/groups
```
