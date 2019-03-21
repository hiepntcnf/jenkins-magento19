FROM nginx:latest

ADD ./default.conf /etc/nginx/conf.d/default.conf
#COPY ./php.ini /usr/local/etc/php/

ADD ./* /var/www/html
RUN chown www-data:www-data -R /var/www/html

RUN apt-get update
RUN apt-get install net-tools -y
