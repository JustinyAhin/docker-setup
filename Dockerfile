FROM oven/bun:1 AS base

WORKDIR /app
COPY package.json bun.lockb* ./

RUN bun install --frozen-lockfile
COPY . .
RUN bun run build

# Production stage
FROM oven/bun:1-slim AS production

WORKDIR /app
COPY package.json bun.lockb* ./

RUN bun install --frozen-lockfile --production

COPY --from=base /app/build ./build
COPY --from=base /app/package.json ./package.json
COPY --from=base /app/static ./static

EXPOSE 3000
ENV NODE_ENV=production
CMD ["bun", "run", "build/index.js"]
