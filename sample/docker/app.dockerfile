FROM php:7.4-fpm

WORKDIR /var/www/html
COPY . .

ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# # Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    zlib1g-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libxpm-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    libzip-dev \
    libldb-dev  \
    libldap2-dev \
    zip \
    unzip \
    nodejs \
    npm \
    libsqlite3-dev\
    sqlite3
 ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
# RUN install-php-extensions
# RUN install-php-extensions cli
RUN install-php-extensions json
# RUN install-php-extensions -j$(nproc) common
# RUN install-php-extensions mysql
RUN install-php-extensions zip
RUN install-php-extensions gd
RUN install-php-extensions mbstring
RUN install-php-extensions curl
RUN install-php-extensions xml
RUN install-php-extensions bcmath
RUN install-php-extensions intl
RUN install-php-extensions pgsql
RUN install-php-extensions pdo pdo_pgsql
RUN install-php-extensions pdo_mysql

# Clear cache
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# Extract php source and install missing extensions
# RUN  docker-php-source extract
# RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd
# RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
# RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
# RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-xpm=/usr/include/ --enable-gd-jis-conv
# RUN docker-php-ext-install exif gd mbstring intl xsl zip mysqli pdo_mysql pdo_pgsql pgsql soap bcmath

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Clean up
RUN apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY ./docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./docker/php/conf.d/error_reporting.ini /usr/local/etc/php/conf.d/error_reporting.ini

# xdebug installation
RUN pecl install xdebug-3.1.6 \
   && docker-php-ext-enable xdebug

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

USER $user
