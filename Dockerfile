FROM ubuntu:trusty
MAINTAINER Liang Wei <liang.wei@outlook.com>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php5 pwgen php-apc php5-mcrypt curl libcurl3 libcurl3-dev php5-curl && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf
# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
#ADD server.crt /etc/ssl/certs/
#ADD server.key /etc/ssl/private/
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
#ADD apache_default_ssl /etc/apache2/sites-enabled/000-default-ssl.conf
RUN a2enmod rewrite
#RUN a2enmod ssl
RUN echo "display_errors = Off" >> /etc/php5/apache2/php.ini
# Configure /app folder with sample app
RUN git clone https://github.com/liangwei1988/ip.git /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M
EXPOSE 80
CMD ["/run.sh"]
