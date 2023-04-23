# not-only-sql-daten-banken

Репозиторий работ по курсу


## Сборка контейнера

```sh
docker build -t sportevent-mongo .
```

## Запуск контейнера

```sh
docker run -p 27017:27017 --name sportevent-mongo -d sportevent-mongo
```

