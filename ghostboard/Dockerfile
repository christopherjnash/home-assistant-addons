# Dockerfile
ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Install base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    python3 \
    python3-pip \
    git \
 && rm -rf /var/lib/apt/lists/*

# Clone Ghostboard
RUN git clone https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard

# Copy server files into /app
RUN mkdir -p /app \
 && cp -R /tmp/ghostboard/server/* /app/

WORKDIR /app

# Tell the client we're in Docker
RUN sed -i 's/const IN_DOCKER = false;/const IN_DOCKER = true;/' index.html

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Clean up default nginx configs
RUN rm -f /etc/nginx/conf.d/default.conf \
       /etc/nginx/sites-enabled/default

# Install our custom configs
RUN cp /app/ghostboard.conf /etc/nginx/conf.d/ \
 && cp /app/supervisord.conf /etc/supervisor/conf.d/

# Expose HTTP (80) only; nginx will proxy WebSocket (8765) and app (8080)
EXPOSE 80

# Launch supervisord (it starts nginx + the Python server)
CMD ["/usr/bin/supervisord", "-n"]