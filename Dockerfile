#syntax=docker/dockerfile:1.4

ARG BASE_IMAGE=shopware/docker-base:8.3-nginx

# pin versions
FROM ${BASE_IMAGE} as base-image
FROM shopware/shopware-cli:latest-php-8.3 as shopware-cli

# build

FROM shopware-cli as build

ADD . /src
WORKDIR /src

RUN /usr/local/bin/entrypoint.sh shopware-cli project ci /src

# build final image

FROM base-image

COPY --from=build --chown=82 --link /src /var/www/html
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
