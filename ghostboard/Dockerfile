# Dockerfile
ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# 1) Install base packages + git + python→python3
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    nginx \
    supervisor \
    python3 \
    python3-pip \
    python-is-python3 \
 && rm -rf /var/lib/apt/lists/*

# 2) Clone Ghostboard server
RUN git clone https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard

# 3) Copy into /app
RUN mkdir -p /app \
 && cp -R /tmp/ghostboard/server/* /app/

WORKDIR /app

# 4) Enable Docker mode in the client
RUN sed -i 's/const IN_DOCKER = false;/const IN_DOCKER = true;/' index.html

# 5) Install Python deps
RUN pip3 install --no-cache-dir -r requirements.txt

# 6) Remove default nginx configs
RUN rm -f /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# 7) Install Ghostboard’s nginx & Supervisor configs
COPY ghostboard.conf /etc/nginx/conf.d/ghostboard.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 8) Prepare runtime directories & set ownership for www‑data
RUN mkdir -p \
      /var/lib/nginx/proxy \
      /var/log/nginx \
      /var/cache/nginx \
      /tmp/nginx-body \
      /tmp/nginx-proxy \
 && chown -R www-data:www-data \
      /var/lib/nginx \
      /var/log/nginx \
      /var/cache/nginx \
      /tmp/nginx-body \
      /tmp/nginx-proxy

# 9) Patch Ghostboard vhost for container environment
RUN sed -i 's|listen .*;|listen 80;|' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/ssl_/d' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/include \/etc\/nginx\/mime.types;/d' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/types {/,/}/d' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i 's|error_log .*;|error_log /dev/stderr warn;|' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i 's|access_log .*;|access_log /dev/stdout;|' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i 's|client_body_temp_path .*;|client_body_temp_path /tmp/nginx-body;|' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i 's|proxy_temp_path .*;|proxy_temp_path /tmp/nginx-proxy;|'   /etc/nginx/conf.d/ghostboard.conf

# 10) Expose HTTP
EXPOSE 80

# 11) Launch Supervisor (specifying config file)
CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/conf.d/supervisord.conf"]
