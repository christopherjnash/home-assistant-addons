ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# 1) Install base + git + python→python3
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    nginx \
    supervisor \
    python3 \
    python3-pip \
    python-is-python3 \
 && rm -rf /var/lib/apt/lists/*

# 2) Clone Ghostboard
RUN git clone https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard

# 3) Copy server files into /app
RUN mkdir -p /app \
 && cp -R /tmp/ghostboard/server/* /app/

WORKDIR /app

# 4) Tell the client it's in Docker
RUN sed -i 's/const IN_DOCKER = false;/const IN_DOCKER = true;/' index.html

# 5) Install Python deps
RUN pip3 install --no-cache-dir -r requirements.txt

# 6) Remove default nginx site
RUN rm -f /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# 7) Install Ghostboard’s nginx + Supervisor configs
RUN cp /app/ghostboard.conf /etc/nginx/conf.d/ghostboard.conf \
 && cp /app/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 8) Prepare writable temp dirs for nginx and set ownership to www-data
RUN mkdir -p /tmp/nginx-body /tmp/nginx-proxy \
 && chown -R www-data:www-data /tmp/nginx-body /tmp/nginx-proxy

# 9) Override the **global** temp paths in the main nginx.conf
RUN sed -i 's|client_body_temp_path .*;|client_body_temp_path /tmp/nginx-body;|' /etc/nginx/nginx.conf \
 && sed -i 's|proxy_temp_path .*;|proxy_temp_path /tmp/nginx-proxy;|' /etc/nginx/nginx.conf

# 10) Expose HTTP → maps to HA port 8765
EXPOSE 80

# 11) Launch supervisord (explicit config)
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
