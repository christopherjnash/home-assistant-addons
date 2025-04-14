ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.7
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Update apk indexes and install dependencies using generic package names
RUN apk update && apk add --no-cache \
    git \
    unzip \
    apache2 \
    php \
    php-apache2 \
    php-curl \
    php-json \
    php-mbstring \
    php-openssl \
    php-xml

# Install RSS-Bridge
RUN git clone https://github.com/RSS-Bridge/rss-bridge.git /var/www/localhost/htdocs \
    && chown -R root:root /var/www/localhost/htdocs
