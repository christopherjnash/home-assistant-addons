ARG BUILD_FROM
# amd64: alpine:${VERSION}
# i386: i386/alpine:${VERSION}
# aarch64: arm64v8/alpine:${VERSION}
# armv7: arm32v7/alpine:${VERSION}
# armhf: arm32v6/alpine:${VERSION}
FROM ${BUILD_FROM}

# ---------- Stage 1: Build Audiobookshelf app -------------
# This stage builds the Audiobookshelf application from source.
FROM node:24-alpine AS build

# Set the working directory for this build stage.
WORKDIR /app

# Install curl temporarily to download the source, then extract it.
# Using --virtual .build-deps allows for easy cleanup of these temporary packages.
RUN apk add --no-cache --virtual .build-deps curl && \
    echo "Downloading Audiobookshelf source..." && \
    curl -sSL https://github.com/advplyr/audiobookshelf/archive/refs/tags/v2.9.0.tar.gz | tar xz --strip-components=1 -C /app && \
    echo "Download and extraction complete." && \
    apk del .build-deps

# Install npm dependencies.
# Using "npm ci" is recommended for CI/build environments as it uses package-lock.json.
# "--omit=dev" excludes development dependencies, making the copied artifacts smaller.
RUN echo "Installing npm dependencies..." && \
    npm ci --omit=dev && \
    echo "npm dependencies installed."

# ---------- Stage 2: Minimal runtime for Home Assistant add-on ----------
# This stage creates the final addon image.

# Install runtime dependencies required by Audiobookshelf.
# Based on your original Dockerfile, only ffmpeg is needed.
RUN echo "Installing runtime dependencies (ffmpeg)..." && \
    apk add --no-cache ffmpeg && \
    echo "ffmpeg installed."

# Set Node.js environment to production for the runtime.
ENV NODE_ENV=production

# Copy Home Assistant add-on specific files from the local 'rootfs' directory.
# This typically includes s6-overlay service definitions, run scripts, cont-init scripts, etc.
COPY rootfs /

# Ensure all necessary scripts are executable.
# This is crucial for s6-overlay services and other startup scripts.
# It checks for common script locations in Home Assistant addons.
RUN \
    echo "Setting script permissions..." && \
    if [ -d /etc/services.d ]; then \
        find /etc/services.d/ -type f -iname '*.sh' -exec chmod a+x {} + ; \
    fi && \
    if [ -f /run.sh ]; then \
        chmod a+x /run.sh ; \
    fi && \
    if [ -d /etc/cont-init.d ]; then \
        find /etc/cont-init.d/ -type f -iname '*.sh' -exec chmod a+x {} + ; \
    fi && \
    echo "Script permissions set."

# Copy the built Audiobookshelf application from the 'build' stage to the final image.
COPY --from=build /app /app

# Set the working directory for the running application.
WORKDIR /app

# Expose the port Audiobookshelf listens on.
# Note: Actual port mapping for Home Assistant is handled in the add-on's config.yaml/json file.
# This EXPOSE instruction is more for documentation and Docker metadata.
EXPOSE 8083

# The CMD or ENTRYPOINT for the addon will typically be managed by s6-overlay,
# often initiated by a /run.sh script or a service script in /etc/services.d/