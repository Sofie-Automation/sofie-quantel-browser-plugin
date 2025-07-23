# syntax=docker/dockerfile:experimental
# BUILD IMAGE
FROM node:18-alpine as build
WORKDIR /opt/quantel-browser-plugin
COPY . .
RUN apk add --no-cache --virtual .build-deps alpine-sdk python3
RUN yarn install --check-files --frozen-lockfile
RUN yarn install --check-files --frozen-lockfile --production --force # purge dev-dependencies
RUN apk del .build-deps

# DEPLOY IMAGE
FROM node:18-alpine
RUN apk add --no-cache tzdata dumb-init
COPY --from=build /opt/quantel-browser-plugin /opt/quantel-browser-plugin

# Run as non-root user
USER 1000
WORKDIR /opt/quantel-browser-plugin
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["yarn", "start"]
