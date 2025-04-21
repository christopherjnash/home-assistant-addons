ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Install Python, nginx, git, and certificates
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 python3-pip nginx git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone Ghostboard server code and install Python deps
RUN apt-get update && apt-get install -y git python3-pip \
 && mkdir -p /app \
 && git clone --depth=1 https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard \
 && cp -R /tmp/ghostboard/server/* /app/ \
 && rm -rf /tmp/ghostboard \
 && pip3 install --no-cache-dir -r /app/requirements.txt

# Clean default nginx
RUN rm -f /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# Copy service scripts and other overlay files
COPY rootfs/ /

# Ensure run scripts are executable (important on Windows hosts)
RUN chmod +x /etc/services.d/ghostboard/run && \
    chmod +x /etc/services.d/nginx/run

RUN mkdir -p /var/log/nginx && \
    chown -R www-data:www-data /var/log/nginx && \
    chmod -R 755 /var/log/nginx

RUN ls -l /etc/services.d/ghostboard && ls -l /etc/services.d/nginx

# Expose HTTP port
EXPOSE 80