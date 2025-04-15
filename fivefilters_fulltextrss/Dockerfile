ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Optional: Display OS information for debugging.
RUN cat /etc/os-release

# Update apt and install required packages: Apache, PHP, dependencies, and Git (with ca-certificates for HTTPS)
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-xml \
    git \
    ca-certificates \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# Enable Apache's rewrite module if needed
RUN a2enmod rewrite

# Clone the new repository containing Full-Text RSS and set proper ownership
RUN rm -rf /var/www/html && \
    git clone https://github.com/heussd/fivefilters-full-text-rss-docker.git /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in the foreground when the container runs
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]