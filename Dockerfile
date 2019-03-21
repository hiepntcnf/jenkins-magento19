FROM php:7.1-fpm
LABEL maintainer hiepnt

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \ 
    libicu-dev \ 
    libjpeg62-turbo-dev \ 
    libmcrypt-dev \ 
    libpng-dev \ 
    libxslt1-dev \ 
    sendmail-bin \ 
    sendmail \ 
    sudo
# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions

RUN docker-php-ext-install \
  dom \ 
  bcmath \
    gd \
    mbstring \
    mysqli \
    mcrypt \
    pdo_mysql \
    soap \
    zip \
    intl \
    xsl \
    pcntl

# Configure PHP
COPY php.ini /usr/local/etc/php/php.ini
COPY php-fpm.conf /usr/local/etc/
COPY ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini.disabled
RUN mkdir -p /var/log/php/ \
    && touch /var/log/php/xdebug.log \
    && touch /var/log/php/error.log \
    && touch /var/log/php/access.log

RUN chown -Rf www-data:www-data /var/log/php/ /var/www
RUN chmod -Rf g+rw /var/log/php/

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*

COPY . /var/www/html

WORKDIR /var/www/html
