ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Show distribution information (optional)
RUN cat /etc/os-release

# Update apt and install required packages: Apache, PHP, dependencies, and git
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-xml \
    git \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# Enable Apache's rewrite module if needed
RUN a2enmod rewrite

# Download FiveFilters Full-Text RSS into Apache's web directory and set proper ownership
RUN git clone https://github.com/fivefilters/full-text-rss.git /var/www/html \
 && chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in the foreground when the container runs
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
