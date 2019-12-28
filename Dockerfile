FROM php:7.4.1-alpine

ENV PHP_SWOOLE_VERSION 4.4.14

RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    curl-dev \
    imagemagick-dev \
    libtool \
    libxml2-dev \
    postgresql-dev \
    sqlite-dev

RUN apk add --no-cache \
    bash \
    curl \
    g++ \
    gcc \
    git \
    imagemagick \
    libc-dev \
    libpng-dev \
    make \
    mysql-client \
    nodejs \
    nodejs-npm \
    yarn \
    openssh-client \
    postgresql-libs \
    rsync \
    zlib-dev \
    libzip-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install swoole-$PHP_SWOOLE_VERSION \
    && docker-php-ext-enable swoole \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install calendar \
    && docker-php-ext-install curl \
    && docker-php-ext-install exif \
    && docker-php-ext-install iconv \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install pdo_sqlite \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install tokenizer \
    && docker-php-ext-install xml \
    && docker-php-ext-install zip

# Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && composer config -g repo.packagist composer hppttps://mirrors.aliyun.com/composer/

# Cleanup dev dependencies
RUN apk del -f .build-deps