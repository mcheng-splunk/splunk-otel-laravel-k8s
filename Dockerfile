FROM composer:1.6.5 as build

WORKDIR /app
COPY . /app
RUN composer install

FROM php:7.1.8-apache

EXPOSE 80
COPY --from=build /app /app
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
RUN chown -R www-data:www-data /app \
    && a2enmod rewrite

# Install curl and other necessary tools
RUN apt-get install -y curl

RUN curl -LO https://github.com/signalfx/signalfx-php-tracing/releases/latest/download/signalfx-setup.php && \
    php signalfx-setup.php --php-bin=all
