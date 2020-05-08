FROM shiraj07/shirajwebapp-php:1.0

WORKDIR /var/www/html

COPY . /var/www/html

EXPOSE 80

#CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
