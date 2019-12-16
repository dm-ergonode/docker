#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi
if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ] || [[ "$1" =~ bin/console$ ]]; then
  if [ "$APP_ENV" != 'prod' ]; then
    composer install --prefer-dist --no-progress --no-suggest --no-interaction

    if [ -n "$JWT_PRIVATE_KEY_PATH" ] && [ ! -e  "$JWT_PRIVATE_KEY_PATH"  ] &&  [ -n "$JWT_PUBLIC_KEY_PATH" ] && [ -n "$JWT_PASSPHRASE" ] ; then
       openssl genrsa -out "$JWT_PRIVATE_KEY_PATH" -passout env:JWT_PASSPHRASE -aes256 4096
       openssl rsa -in "$JWT_PRIVATE_KEY_PATH" -passin env:JWT_PASSPHRASE -pubout  -out "$JWT_PUBLIC_KEY_PATH"
    fi

    echo "Waiting for db to be ready..."
    until bin/console doctrine:query:sql "SELECT 1" > /dev/null 2>&1; do
      sleep 1
	  done

    bin/phing build

  	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
  	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var
	fi
fi

exec docker-php-entrypoint "$@"
