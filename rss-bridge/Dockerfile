ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

ENV RSSBRIDGE_CONFIG=/etc/rss-bridge/config.ini.php

RUN cat /etc/os-release

RUN apt-get update || (cat /var/log/apt/term.log && false)

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    php \
    php-cli \
    php-common \
    php-curl \
    php-mbstring \
    php-xml \
    git \
    unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install RSS-Bridge
RUN rm -rf /var/www/html && \
    git clone --depth=1 https://github.com/RSS-Bridge/rss-bridge.git /var/www/html && \
    mkdir -p /data/cache && \
    chown -R www-data:www-data /data/cache && \
    chmod -R 775 /data/cache

# Copy run script
COPY rootfs/ /

# Expose port
EXPOSE 80