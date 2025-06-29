ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Install python3 and pip
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip && \
    pip3 install --no-cache-dir freetar==0.14.0 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy rootfs
COPY rootfs/ /
RUN chmod +x /usr/local/bin/freetar_start.py /etc/services.d/freetar/run


EXPOSE 22000

