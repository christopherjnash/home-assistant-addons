# Dockerfile
ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Install base packages + symlink python→python3
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    python3 \
    python3-pip \
    python-is-python3 \
 && rm -rf /var/lib/apt/lists/*

# Grab the Ghostboard server
RUN git clone https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard

# Copy in the server files
RUN mkdir -p /app \
 && cp -R /tmp/ghostboard/server/* /app/

WORKDIR /app

# Tell Ghostboard it’s in Docker
RUN sed -i 's/const IN_DOCKER = false;/const IN_DOCKER = true;/' index.html

# Python deps
RUN pip3 install --no-cache-dir -r requirements.txt

# Drop default nginx configs
RUN rm -f /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# Install Ghostboard’s nginx & supervisord configs
RUN cp /app/ghostboard.conf /etc/nginx/conf.d/ \
 && cp /app/supervisord.conf /etc/supervisor/conf.d/

# ────────── Patch nginx for Home Assistant ──────────
# 1) remove the sub_filter_types line (it defaults to text/html anyway)
# 2) inject a writeable client_body_temp_path
# 3) prepare that temp directory
RUN sed -i 's#sub_filter_types text/html;##g' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/server {/a\    client_body_temp_path /tmp/nginx-body;' \
      /etc/nginx/conf.d/ghostboard.conf \
 && mkdir -p /tmp/nginx-body \
 && chown -R www-data:www-data /tmp/nginx-body

# Expose HTTP port
EXPOSE 80

# Launch both nginx & the Python server under supervisord
CMD ["/usr/bin/supervisord", "-n"]