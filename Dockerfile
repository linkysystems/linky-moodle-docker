FROM php:7.3.10-apache-stretch
LABEL maintainer "Linky <contato@linkysystems.com>"
# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# Install Moodle dependencies:
RUN apt-get update &&  \
    apt-get install -y \
      libicu-dev \
      openssl \
      libcurl4-openssl-dev \
      libssl-dev \
      libxml2-dev \
      libzip-dev \
      zlib1g-dev \
      libpng-dev \
      zip

RUN docker-php-ext-configure intl && \
  docker-php-ext-install intl

RUN docker-php-ext-configure zip && \
  docker-php-ext-install mysqli && \
  docker-php-ext-install soap && \
  docker-php-ext-install zip && \
  docker-php-ext-install gd && \
  docker-php-ext-install xmlrpc

# Op cache for speed up php processing:
RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache
# MongoDB extension for cache storage:
RUN pecl install mongodb --enable-ssl \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/ext-mongodb.ini
# Redis extension for cache storage:
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    &&  echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

ENV DATABASE_TYPE="mysqli" \
    MYSQL_DATABASE="project" \
    MYSQL_USER="project" \
    MYSQL_PASSWORD="project" \
    MYSQL_HOST="mysqldb" \
    MYSQL_PORT="3306" \
    MYSQL_PREFIX="mdl_" \
    HTTP_HOST="127.0.0.1:80" \
    MOODLE_DATA_DIR="/var/moodledata" \
    MOODLE_THEME_DIR="/var/moodle-themes" \
    MOODLE_EMAIL="user@example.com" \
    MOODLE_LANGUAGE="en" \
    MOODLE_PASSWORD="password" \
    MOODLE_SITENAME="New Site" \
    MOODLE_SKIP_INSTALL="no" \
    MOODLE_USERNAME="user" \
    MOODLE_SUMMARY="" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

COPY configs/php/* $PHP_INI_DIR/conf.d/
COPY configs/apache-sites-avaible/* /etc/apache2/sites-available/

COPY scripts /scripts

RUN chmod +x /scripts/*

ENTRYPOINT ["/scripts/entrypoint.sh"]
