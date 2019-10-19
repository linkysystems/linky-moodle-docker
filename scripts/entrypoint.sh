#!/bin/bash

set -e

# 1- Check internet connection:
php /var/www/html/scripts/check-db-connection.php

# 2- Run moodle installer:
CMD_CONFIGURATION="php /var/www/html/admin/cli/install.php \
  --chmod='2777' \
  --lang=${MOODLE_LANGUAGE} \
  --dataroot=${MOODLE_DATA_DIR} \
  --agree-license \
  --adminuser=${MOODLE_USERNAME} \
  --adminpass=${MOODLE_PASSWORD} \
  --dbtype=${DATABASE_TYPE} \
  --dbhost=${MYSQL_HOST} \
  --dbname=${MYSQL_DATABASE} \
  --dbuser=${MYSQL_USER} \
  --dbpass=${MYSQL_PASSWORD} \
  --dbport=${MYSQL_PORT} \
  --prefix=${MYSQL_PREFIX} \
  --fullname=${MOODLE_SITENAME} \
  --shortname=${MOODLE_SITENAME} \
  --summary=${MOODLE_SUMMARY} \
  --adminemail=${MOODLE_EMAIL}"

echo $($CMD_CONFIGURATION)

CMD_INSTALL_DB="php /var/www/html/admin/cli/install_database.php \
  --lang=${MOODLE_LANGUAGE} \
  --agree-license \
  --adminuser=${MOODLE_USERNAME} \
  --adminpass=${MOODLE_PASSWORD} \
  --adminemail=${MOODLE_EMAIL} \
  --fullname=${MOODLE_SITENAME} \
  --shortname=${MOODLE_SITENAME} \
  --summary=${MOODLE_SUMMARY}"

echo $($CMD_INSTALL_DB)

exec "$@"