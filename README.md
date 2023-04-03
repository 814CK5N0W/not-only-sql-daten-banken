# not-only-sql-daten-banken

Репозиторий работ по курсу

```sh
docker run -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 --name cassandra -d cassandra-prbd
```

```sh
cqlsh> CREATE KEYSPACE sportevent WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};
cqlsh> desc keyspaces

sportevent  system_auth         system_schema  system_views         
system      system_distributed  system_traces  system_virtual_schema

cqlsh> 
```


```sh
docker build -t neo4j-prbd .
```

```sh
docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --name neo4j-prbd -d neo4j-prbd
```
