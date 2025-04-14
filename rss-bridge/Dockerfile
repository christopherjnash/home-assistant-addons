ARG BUILD_FROM=arm32v7/ubuntu:20.04
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-curl \
    php-json \
    php-mbstring \
    php-openssl \
    php-xml \
    git unzip

# Install RSS-Bridge
RUN rm -rf /var/www/html && \
    git clone --depth=1 https://github.com/RSS-Bridge/rss-bridge.git /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Start Apache2 service in foreground
CMD ["apachectl", "-D", "FOREGROUND"]