# PHP-PM Docker

You can use [PHP-PM](https://github.com/php-pm/php-pm) using Docker. We provide you several images always with PHP-PM and PHP7 pre-installed.

## Images

- [`phppm/nginx`](https://hub.docker.com/r/phppm/nginx/): Contains php-pm and uses NGiNX as static file serving
- [`phppm/standalone`](https://hub.docker.com/r/phppm/standalone/): Contains php-pm and uses php-pm's ability to serve static files (slower)
- [`phppm/ppm`](https://hub.docker.com/r/phppm/ppm/): Just the php-pm binary as entry point

### Examples

```
# change into your project folder first
cd your/symfony-project/

# see what php-pm binary can do for you.
$ docker run -v `pwd`:/var/www/ phppm/ppm --help
$ docker run -v `pwd`:/var/www/ phppm/ppm config --help

# with nginx as static file server
$ docker run -v `pwd`:/var/www -p 80:8080 phppm/nginx

# with php-pm as static file server (dev only)
$ docker run -v `pwd`:/var/www -p 80:8080 phppm/standalone

# use `PPM_CONFIG` environment variable to choose a different ppm config file.
$ docker run  -v `pwd`:/var/www -p 80:8080 phppm/nginx -c ppm-prod.json

# enable file tracking, to automatically restart ppm when php source changed
$ docker run -v `pwd`:/var/www -p 80:8080 phppm/nginx --debug=1 --app-env=dev

# change static file directory. PPM_STATIC relative to mounted /var/www/.
$ docker run -v `pwd`:/var/www -p 80:8080 phppm/nginx --static-directory=web/

# Use 16 threads/workers for PHP-PM.
$ docker run -v `pwd`:/var/www -p 80:8080 phppm/nginx --workers=16
```

Docker compose

```
version: "3.1"

services:
  ppm:
    image: phppm/nginx
    command: --debug=1 --app-env=dev --static-directory=web/
    volumes:
      - ./symfony-app/:/var/www
    ports:
      - "80:8080"
```

### Configuration

You should configure PPM via the ppm.json in the root directory, which is within the container mounted to
`/var/www/`. Alternatively, you can overwrite each option using the regular cli arguments.

```
# change the ppm.json within current directory
docker run -v `pwd`:/var/www phppm/ppm config --help

# not persisting config changes
docker run -v `pwd`:/var/www -p 80:8080 phppm/nginx --help
docker run -v `pwd`:/var/www -p 80:8080 phppm/nginx --workers=1 --debug 1
docker run -v `pwd`:/var/www -p 80:8080 phppm/nginx --c prod-ppm.json
```

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
docker build vendor/my-image -f Dockerfile .
# now use vendor/my-image instead of `phppm/nginx`
```
