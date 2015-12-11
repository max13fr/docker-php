FROM php:5.4-fpm

# iconv, mcrypt, gd, mysql, mysqli
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysql \
    && docker-php-ext-install mysqli

# php-redis
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-2.2.7 /usr/src/php/ext/redis \
    && docker-php-ext-install redis

# cache-lite
RUN /usr/local/bin/pear install Cache_Lite

# mail (redirect to host)
RUN apt-get install -y ssmtp
RUN echo "Mailhub=172.17.42.1" > /etc/ssmtp/ssmtp.conf && \
    echo "FromLineOverride=Yes" >> /etc/ssmtp/ssmtp.conf && \
    echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini

CMD ["php-fpm"]
