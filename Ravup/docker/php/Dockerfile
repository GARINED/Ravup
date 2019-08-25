FROM php:7.2.6-fpm

RUN apt-get update && apt-get install -y \
    libicu-dev \
    git \
    wget \
    zip \
    curl \
    libcurl4-openssl-dev \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev


# PHP extensions
RUN docker-php-ext-install curl intl zip \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd exif \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# intl + opcache
RUN docker-php-ext-enable opcache \
    && docker-php-ext-install intl

# Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

ARG XDEBUG_INI=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "xdebug.default_enable = on" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_enable = on" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_autostart = on" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_connect_back = on" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_port = 9002" >> ${XDEBUG_INI} \
&& echo "xdebug.remote_host = 127.0.0.1" >> ${XDEBUG_INI}

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR "/var/www/"
