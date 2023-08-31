FROM alpine3.17

ARG USER_ID

RUN echo "UTC" > /etc/timezone

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

RUN apk add --no-cache zip unzip libzip-dev freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev curl \
    curl ffmpeg \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install bcmath opcache pcntl pdo_mysql mysqli zip gd exif \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.4.4

RUN mkdir -p /var/www/html/bootstrap/cache && chmod -R 777 /var/www/html/bootstrap/cache \
  && mkdir -p /var/www/html/storage/framework/cache && chmod -R 777 /var/www/html/storage/framework/cache \
  && mkdir -p /var/www/html/storage/framework/sessions && chmod -R 777 /var/www/html/storage/framework/sessions \
  && mkdir -p /var/www/html/storage/framework/testing && chmod -R 777 /var/www/html/storage/framework/testing \
  && mkdir -p /var/www/html/storage/framework/views && chmod -R 777 /var/www/html/storage/framework/views

# Change user and group id to 1000 that is equal with general linux default user id.
# It requires to have synced directories and files permissions.
RUN deluser www-data
#RUN adduser -D -H -u $USER_ID -s /bin/bash www-data
RUN adduser -D -H -u 1000 -s /bin/bash www-data

# Use www-data user for entrypoint login
# to be the same user as http-server process run user.
RUN chown -R www-data:www-data /var/www/html

USER www-data
