
d=docker
name=814ck5n0w
container_name=neo4j
container_alias=neo4j
neo4j_volume = $(HOME)/neo4j/data

build: 
	docker build -t $(name)-$(container_name) . 

start: build
	docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$(neo4j_volume):/data \
    $(name)-$(container_name)
	
clean:
	docker volume prune -f
	docker system prune -f