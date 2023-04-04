FROM --platform=arm64 postgres:15.2

ENV POSTGRES_PASSWORD=secretkey

ENV POSTGRES_USER=blacksnow

EXPOSE 5432