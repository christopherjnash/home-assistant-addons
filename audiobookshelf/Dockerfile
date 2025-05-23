# ---------- Stage 1: Build Audiobookshelf app -------------

FROM node:20-alpine AS build

WORKDIR /app

# Download and extract Audiobookshelf release source
ADD https://github.com/advplyr/audiobookshelf/archive/refs/tags/v2.9.0.tar.gz .
RUN tar xvf v2.9.0.tar.gz && \
    mv audiobookshelf-2.9.0/* . && \
    rm -rf audiobookshelf-2.9.0 v2.9.0.tar.gz

# Install dependencies (no build step needed for release tarball)
RUN npm ci

# ---------- Stage 2: Minimal runtime for Home Assistant add-on ----------

FROM ghcr.io/hassio-addons/base:14.3.2

# Only ffmpeg is required by Audiobookshelf
RUN apk add --no-cache ffmpeg

ENV NODE_ENV=production

# Copy Home Assistant add-on configs and service scripts, if you have them
COPY rootfs /

# Copy the fully prepared Audiobookshelf app from the builder stage
COPY --from=build /app /app

WORKDIR /app

EXPOSE 8083

# Optional: Uncomment if your add-on needs to launch node directly
# CMD ["node", "index.js"]
