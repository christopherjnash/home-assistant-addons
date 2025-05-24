# --- Build Stage (Use Node 20) ---
FROM node:20-alpine AS build
WORKDIR /app

# fetch source
RUN apk add --no-cache curl && \
    curl -sSL https://github.com/advplyr/audiobookshelf/archive/refs/tags/v2.23.0.tar.gz \
      | tar xz --strip-components=1 -C /app

# install & build both server + client
RUN npm ci && \
    cd client && npm ci && npm run generate && cd .. && \
    npm prune --production

# --- Final Stage (Use Node 20) ---
FROM node:20-alpine
RUN apk add --no-cache ffmpeg

WORKDIR /app
COPY --from=build /app /app

# defaults
ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=8083

EXPOSE 8083

# start the server directly
CMD ["node", "index.js"]
