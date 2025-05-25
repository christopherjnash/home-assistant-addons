# --- Build Stage ---
FROM node:22-bookworm-slim AS build
WORKDIR /app

# fetch source
RUN apt-get update && apt-get install -y curl && \
    curl -sSL https://github.com/advplyr/audiobookshelf/archive/refs/tags/v2.23.0.tar.gz \
      | tar xz --strip-components=1 -C /app

# install & build both server + client
RUN npm ci && \
    cd client && npm ci && npm run generate && cd .. && \
    npm prune --production

# --- Final Stage (Node+Debian, glibc-based) ---
FROM node:22-bookworm-slim
RUN apt-get update && apt-get install -y ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app /app

ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=8083

EXPOSE 8083

CMD ["node", "index.js"]