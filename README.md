# PHP-PM Docker

You can use [PHP-PM](https://github.com/php-pm/php-pm) using Docker. We provide you several images always with PHP-PM and PHP7 pre-installed.

## Images

- [`phppm/nginx`](https://hub.docker.com/r/phppm/nginx/): Contains php-pm and uses NGiNX as static file serving 
- [`phppm/standalone`](https://hub.docker.com/r/phppm/standalone/): Contains php-pm and uses php-pm's ability to serve static files (slower)
- [`phppm/ppm`](https://hub.docker.com/r/phppm/ppm/): Just the php-pm binary as entry point

### Examples

```
# see what php-pm binary can do for you.
$ docker run -v `pwd`:/var/www/ phppm/ppm --help
$ docker run -v `pwd`:/var/www/ phppm/ppm config --help

# with nginx as static file server
$ docker run -t --rm --name ppm -v `pwd`:/var/www -p 8080:80 phppm/nginx:latest

# with php-pm as static file server (dev only)
$ docker run -t --rm --name ppm -v `pwd`:/var/www -p 8080:80 phppm/nginx:latest

# use `PPM_CONFIG` environment variable to choose a different ppm config file.
$ docker run -t --rm --name ppm -e PPM_CONFIG=ppm-prod.json -v `pwd`:/var/www -p 80:80 phppm/nginx:latest

# enable file tracking, to automatically restart ppm when php source changed
$ docker run -t --rm --name ppm -e PPM_DEBUG=1 -e PPM_APP_ENV=dev -v `pwd`:/var/www -p 80:80 phppm/nginx:latest

# change static file directory. PPM_STATIC relative to mounted /var/www/.
$ docker run -t --rm --name ppm -e PPM_STATIC=./web/ -v `pwd`:/var/www -p 80:80 phppm/nginx:latest

# Use 16 threads/workers for PHP-PM.
$ docker run -t --rm --name ppm -e PPM_WORKER=16 -v `pwd`:/var/www -p 80:80 phppm/nginx:latest
```

Docker compose

```
version: "3.1"

services:
  ppm:
    image: phppm/nginx:latest
    volumes:
      - ./symfony-app/:/var/www
    ports:
      - "80:80"
    environment:
      PPM_DEBUG: 1
      PPM_APP_ENV: dev
      PPM_STATIC: ./web/
```

### Configuration

You should configure PPM via the ppm.json in the root directory, which is withing the container mounted to 
`/var/www/`.

```
docker run phppm/ppm config --help
```

Additional you can use environment variables to change some configuration properties.

| Name          | Default       | Description |
| ------------- | ------------- | -------- |
| PPM_CONFIG    | ppm.json | Which configuration to use |
| PPM_DEBUG    | 0 | Use 1 to activate debugging (automatic reload of workers when source code changes) |
| PPM_APP_ENV    | prod | The application environment |
| PPM_STATIC    |  | Use as root folder for nginx or standalone static file serving |
| PPM_WORKER    | 8 | How many workers should be used to server php application. |

Note, if you don't specify the environment variables above, the values from your ppm.json if present will be used.

## Build image with own tools/dependencies

If your applications requires additional php modules or other tools and libraries in your container, you
can use our image as base. We use lightweight Alpine Linux.

```
# Dockerfile
FROM phppm/nginx:1.0

RUN apk --no-cache add git
RUN apk --no-cache add ca-certificates wget

# whatever you need 
```

```
docker build -t vendor/my-image -f Dockerfile .
# now use vendor/my-image instead of `phppm/nginx`
```