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

# Copy ghostboard nginx config and service scripts
COPY rootfs/ /

# Expose HTTP port
EXPOSE 80