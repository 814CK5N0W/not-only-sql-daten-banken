```sh
docker build -t cassandra-stock .
```

```sh
docker run -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 --name cassandra-stock -d cassandra-stock
```