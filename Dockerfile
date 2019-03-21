FROM canifa/php:7.1-fpm
LABEL maintainer hiepnt

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data


RUN chown -Rf www-data:www-data /var/log/php/ /var/www
RUN chmod -Rf g+rw /var/log/php/

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*

COPY . /var/www/html

WORKDIR /var/www/html
