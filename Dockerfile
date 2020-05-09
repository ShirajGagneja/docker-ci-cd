FROM shiraj07/shirajwebapp-php:1.0

WORKDIR /var/www/html

COPY index.php /var/www/html

COPY upload.php /var/www/html

EXPOSE 80

#CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
