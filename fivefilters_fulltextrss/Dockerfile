ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# (Optional) Display OS info for debugging
RUN cat /etc/os-release

# Install base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    php \
    libapache2-mod-php \
    php-xml \
    php-tidy \
    php-mbstring \
    ca-certificates \
    git \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite if needed
RUN a2enmod rewrite

# 1) Clone FiveFilters Full-Text RSS at the pinned commit:
RUN git clone https://bitbucket.org/fivefilters/full-text-rss.git /tmp/full-text-rss && \
    cd /tmp/full-text-rss && \
    git reset --hard 384d52fd83361ffd6e7f28bd39b322970a015a28

# 2) Clone FiveFilters site config from GitHub:
RUN git clone https://github.com/fivefilters/ftr-site-config.git /tmp/ftr-site-config

# 3) Move both into /var/www/html
RUN rm -rf /var/www/html && mkdir -p /var/www/html && \
    cp -R /tmp/full-text-rss/* /var/www/html/ && \
    # Merge site-config files into the 'standard' config folder
    mkdir -p /var/www/html/site_config/standard && \
    cp -R /tmp/ftr-site-config/. /var/www/html/site_config/standard/ || true

# 4) Create + fix permissions on the cache directory
RUN mkdir -p /var/www/html/cache/rss && \
    chmod -R 777 /var/www/html/cache && \
    chmod -R 777 /var/www/html/site_config && \
    chown -R www-data:www-data /var/www/html

# Fix deprecated implode() calls in SimplePie
RUN sed -i "s/implode(array_keys(\\\$this->day), '|')/implode('|', array_keys(\\\$this->day))/" /var/www/html/libraries/simplepie/library/SimplePie/Parse/Date.php && \
    sed -i "s/implode(array_keys(\\\$this->month), '|')/implode('|', array_keys(\\\$this->month))/" /var/www/html/libraries/simplepie/library/SimplePie/Parse/Date.php

# Expose port 80 to match your config.yaml
EXPOSE 80

# Run Apache in the foreground for Home Assistant
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
