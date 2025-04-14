ARG BUILD_FROM=ghcr.io/home-assistant/{arch}-base-debian:bullseye
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    php \
    php-curl \
    php-json \
    php-mbstring \
    php-openssl \
    php-xml \
    git \
    unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install RSS-Bridge
RUN rm -rf /var/www/html && \
    git clone --depth=1 https://github.com/RSS-Bridge/rss-bridge.git /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Copy run script
COPY run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

# Expose port
EXPOSE 80

# Entrypoint for Home Assistant
CMD ["/usr/local/bin/run"]
