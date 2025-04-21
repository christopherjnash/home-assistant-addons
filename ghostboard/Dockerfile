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

# 2) Clone Ghostboard server code
RUN git clone https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard

# 3) Copy server files into /app
RUN mkdir -p /app \
 && cp -R /tmp/ghostboard/server/* /app/

WORKDIR /app

# 4) Tell the client it's in Docker
RUN sed -i 's/const IN_DOCKER = false;/const IN_DOCKER = true;/' index.html

# 5) Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# 6) Remove default nginx site configs
RUN rm -f /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# 7) Install Ghostboard’s configs into the system
RUN cp /app/ghostboard.conf /etc/nginx/conf.d/ghostboard.conf \
 && cp /app/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 8) Prepare writable directories and set ownership to www-data
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

# 9) Patch the vhost so nginx never tries to chown /var/lib/nginx and logs to stdout/stderr
RUN sed -i 's/listen 80 default_server;/listen 80;/'              /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/ssl_/d'                                             /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/include \/etc\/nginx\/mime.types;/d'               /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/sub_filter_types text\/html;/d'                    /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/client_body_temp_path/d'                           /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/proxy_pass http:\/\/127.0.0.1:8080;/a\    client_body_temp_path /tmp/nginx-body;' \
                                                                  /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/sub_filter_once on;/a\    proxy_temp_path /tmp/nginx-proxy;' \
                                                                  /etc/nginx/conf.d/ghostboard.conf \
 && sed -i 's|access_log .*|access_log /dev/stdout main;|'      /etc/nginx/conf.d/ghostboard.conf \
 && sed -i 's|error_log .*|error_log /dev/stderr info;|'        /etc/nginx/conf.d/ghostboard.conf

# 10) Expose port 80 for HA →8765 mapping
EXPOSE 80

# 11) Launch Supervisor (specifying its config)
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
