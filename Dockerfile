FROM --platform=arm64 node:18.14.1-alpine as build

ADD . /app

WORKDIR /app

RUN npm build