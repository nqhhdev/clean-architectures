# syntax=docker/dockerfile:1
# One image for every environment (ADR 0018): the build bakes no configuration, the entrypoint writes it at start.
#   docker build -t web-react web-react
#   docker run --rm -p 8080:8080 -e API_URL=https://api.example.com web-react
# Base images are pinned by digest (tag kept for readers); Dependabot's docker entry bumps both.

FROM node:22-alpine@sha256:0a7108bf6c7bf5de370ffb1a3ed6be93d405b43ff159f681a8d18c0e2bc2e402 AS build
ENV CI=true
WORKDIR /app
RUN corepack enable
# Dependencies first: this layer only changes with the lockfile. `pnpm fetch` fills a BuildKit cache mount, so a cold
# layer still reuses packages downloaded by an earlier build on the same builder.
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,id=web-react-pnpm,target=/pnpm-store \
    pnpm fetch --store-dir /pnpm-store
COPY . .
# Type-checks, generates the API client from openapi/ and builds to dist/ (no mock code, no source maps), then writes a
# .gz next to every text file over 1 KiB so nginx serves it with gzip_static instead of compressing per request.
RUN --mount=type=cache,id=web-react-pnpm,target=/pnpm-store \
    pnpm install --frozen-lockfile --offline --store-dir /pnpm-store \
    && pnpm build \
    && find dist -type f \( -name '*.js' -o -name '*.css' -o -name '*.html' -o -name '*.svg' -o -name '*.json' \) \
       -size +1k -exec gzip -9 -k {} +

FROM nginxinc/nginx-unprivileged:1.31-alpine@sha256:b5047b9b76845eac124358373c6852377c52e4b05834a47647e955dd91cb8f1e
# The script is committed executable (mode 755), so a plain COPY keeps the bit on BuildKit and the legacy builder alike.
COPY docker/entrypoint.sh /docker-entrypoint-web.sh
COPY --from=build /app/dist /usr/share/nginx/html
# Runs as the image's non-root user (uid 101); env.js and the nginx server config are written at start.
USER 101
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
ENTRYPOINT ["/docker-entrypoint-web.sh"]
CMD ["nginx", "-g", "daemon off;"]
