# Dockerfile
ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Install base packages + symlink 'python' → python3
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    python3 \
    python3-pip \
    python-is-python3 \
 && rm -rf /var/lib/apt/lists/*

# Clone Ghostboard server
RUN git clone https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard

# Copy into /app
RUN mkdir -p /app \
 && cp -R /tmp/ghostboard/server/* /app/

WORKDIR /app

# Tell Ghostboard it’s in Docker
RUN sed -i "s/const IN_DOCKER = false;/const IN_DOCKER = true;/" index.html

# Install Python deps
RUN pip3 install --no-cache-dir -r requirements.txt

# Remove default nginx site
RUN rm -f /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# Install Ghostboard’s nginx & supervisord configs
RUN cp /app/ghostboard.conf /etc/nginx/conf.d/ \
 && cp /app/supervisord.conf /etc/supervisor/conf.d/

# ───── Patches for Home Assistant ─────
# 1) Remove the 'sub_filter_types text/html;' line (it duplicates the built‑in mime type)
# 2) Redirect nginx’s client_body_temp_path globally to a writeable /tmp/nginx-body
# 3) Create & chown that directory, so nginx won’t try to chown /var/lib/nginx/body
RUN sed -i 's#sub_filter_types text/html;##g' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i 's#client_body_temp_path .*#client_body_temp_path /tmp/nginx-body;#' /etc/nginx/nginx.conf \
 && mkdir -p /tmp/nginx-body \
 && chown -R www-data:www-data /tmp/nginx-body

# Expose HTTP
EXPOSE 80

# Start supervisord (which launches nginx + the Python server)
CMD ["/usr/bin/supervisord", "-n"]
