ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.7
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
      git \
      unzip \
      apache2 \
      php8 \
      php8-apache2 \
      php8-curl \
      php8-json \
      php8-mbstring \
      php8-openssl \
      php8-xml

# Install RSS-Bridge:
RUN git clone https://github.com/RSS-Bridge/rss-bridge.git /var/www/localhost/htdocs \
    && chown -R root:root /var/www/localhost/htdocs
