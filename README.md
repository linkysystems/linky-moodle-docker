# Linky moodle

Fast Moodle image build for production enviroments.

## Features:

- Cache storage: Redis or Mongodb
- PHP Opcache on

## Many ENV variables for configuration

See: https://github.com/linkysystems/linky-moodle-docker/blob/master/Dockerfile

## Build commands:

```
docker build -t linky-moodle .
```

## Tag and save in docker registry:

```
docker tag linky-moodle:latest edulinky/linky-moodle:v1.0.4
```

```
docker push edulinky/linky-moodle:v1.0.4
```


## Powered by

- Edulinky: http://edulinky.com

## Created by

- Alberto Souza: https://albertosouza.net


