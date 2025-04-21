# Dockerfile
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

# 7) Install upstream configs
RUN cp /app/ghostboard.conf /etc/nginx/conf.d/ \
 && cp /app/supervisord.conf /etc/supervisor/conf.d/

# 8) Patch the Ghostboard vhost so HA can run it:
#    • strip the duplicate MIME/type block
#    • remove the old client_body_temp_path
#    • insert a writeable /tmp/nginx-body path
#    • route logs to stdout/stderr
RUN sed -i '/include \/etc\/nginx\/mime.types;/d' /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/types {/,/}/d'                                /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/client_body_temp_path/d'                      /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '/server {/a\    client_body_temp_path /tmp/nginx-body;' \
       /etc/nginx/conf.d/ghostboard.conf \
 && sed -i '1i error_log /dev/stderr warn;\naccess_log /dev/stdout;' \
       /etc/nginx/conf.d/ghostboard.conf \
 && mkdir -p /tmp/nginx-body \
 && chown -R www-data:www-data /tmp/nginx-body

# 9) Expose port 80 (nginx)  
EXPOSE 80

# 10) Launch supervisord → nginx + Python server  
CMD ["/usr/bin/supervisord", "-n"]
