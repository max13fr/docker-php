FROM php:7.1-fpm

# iconv, mcrypt, gd, mysql, mysqli
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        ssmtp \
        vim \
        less \
        cron \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_pgsql \
    && docker-php-ext-install mbstring

# phpredis extension
pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# mail (redirect to host)
RUN echo "Mailhub=docker-host" > /etc/ssmtp/ssmtp.conf && \
    echo "FromLineOverride=Yes" >> /etc/ssmtp/ssmtp.conf && \
    echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
