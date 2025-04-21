ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# 1) Install base + git + python symlink
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    nginx \
    supervisor \
    python3 \
    python3-pip \
    python-is-python3 \
 && rm -rf /var/lib/apt/lists/*

# 2) Fetch Ghostboard server
RUN git clone https://github.com/jon6fingrs/ghostboard.git /tmp/ghostboard

# 3) Copy into /app
RUN mkdir -p /app \
 && cp -R /tmp/ghostboard/server/* /app/

WORKDIR /app

# 4) Enable Docker mode in the client
RUN sed -i "s/const IN_DOCKER = false;/const IN_DOCKER = true;/" index.html

# 5) Python deps
RUN pip3 install --no-cache-dir -r requirements.txt

# 6) Clean out default nginx site
RUN rm -f /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# 7) Install upstream configs (COPY FIRST)
COPY /app/ghostboard.conf /etc/nginx/conf.d/
COPY /app/supervisord.conf /etc/supervisor/conf.d/

# 8) Prepare Nginx runtime directories and modify configuration
#    Create necessary directories and ensure www-data owns them AT BUILD TIME.
#    Focus on /tmp for runtime paths Nginx will write to.
RUN mkdir -p /var/lib/nginx/proxy /var/log/nginx /var/cache/nginx /tmp/nginx-body /tmp/nginx-proxy \
 && chown -R www-data:www-data /var/lib/nginx /var/log/nginx /var/cache/nginx /tmp/nginx-body /tmp/nginx-proxy

#    Modify ghostboard.conf for container environment:
#    - Ensure listen on port 80, disable SSL directives.
#    - Remove potentially problematic MIME type definitions.
#    - Redirect logs robustly to stdout/stderr.
#    - Redirect temporary/proxy paths to /tmp/* owned by www-data.
RUN sed -i 's|listen.*80;|listen 80;|' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i 's|listen.*443 ssl;|#listen 443 ssl;|' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i '/^\s*ssl_certificate/d' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i '/^\s*ssl_certificate_key/d' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i '/include \/etc\/nginx\/mime.types;/d' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i '/types {/,/}/d' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i 's|error_log.*;|error_log /dev/stderr warn;|' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i 's|access_log.*;|access_log /dev/stdout;|' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i 's|client_body_temp_path.*;|client_body_temp_path /tmp/nginx-body;|' /etc/nginx/conf.d/ghostboard.conf && \
    sed -i 's|proxy_temp_path.*;|proxy_temp_path /tmp/nginx-proxy;|' /etc/nginx/conf.d/ghostboard.conf

#    Optional: Uncomment below if default log path errors persist after other changes
# RUN sed -i '/^\s*error_log/ s|/var/log/nginx/error.log|/dev/stderr|' /etc/nginx/nginx.conf && \
#     sed -i '/^\s*access_log/ s|/var/log/nginx/access.log|/dev/stdout|' /etc/nginx/nginx.conf

# 9) Expose port 80 (nginx)
EXPOSE 80

# 10) Launch supervisord, explicitly using the config file
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]