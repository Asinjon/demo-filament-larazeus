FROM php:8.1.13-fpm

ARG USER_ID

RUN echo "UTC" > /etc/timezone

RUN apt-get update && apt-get install -y \
    libicu-dev libpq-dev libzip-dev zip unzip \
    libfreetype6-dev libpng-dev libjpeg62-turbo-dev \
    curl ffmpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl bcmath opcache pcntl pdo_mysql mysqli zip exif \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN mkdir -p /var/www/html/bootstrap/cache && chmod -R 777 /var/www/html/bootstrap/cache \
  && mkdir -p /var/www/html/storage/framework/cache && chmod -R 777 /var/www/html/storage/framework/cache \
  && mkdir -p /var/www/html/storage/framework/sessions && chmod -R 777 /var/www/html/storage/framework/sessions \
  && mkdir -p /var/www/html/storage/framework/testing && chmod -R 777 /var/www/html/storage/framework/testing \
  && mkdir -p /var/www/html/storage/framework/views && chmod -R 777 /var/www/html/storage/framework/views

# Change user and group id to 1000 that is equal with general linux default user id.
# It requires to have synced directories and files permissions.
RUN deluser www-data 2>/dev/null || true
#RUN adduser -D -H -u $USER_ID -s /bin/bash www-data
RUN adduser -D -H -u 1000 -s /bin/bash www-data

# Use www-data user for entrypoint login
# to be the same user as http-server process run user.

RUN groupadd -g 1000 www-data && \
    useradd -u 1000 -ms /bin/bash -g www-data www-data

RUN chown -R www-data:www-data /var/www/html

USER www-data
