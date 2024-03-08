# Motomap
The motomap project was started by [markcushman/motomap ](https://github.com/markcushman/motomap). 
This repo forked it to simplify and automatize docker build of builder container and maps. 

## How to use it
You can build the container using `make`
Then you can run it either via `docker-compose`, see example file or via `docker run` as follow : 
```shell
docker run -it -e MAPS_LIST=europe/france/reunion -v /tmp/motomap:/motomap/output/ motomap
```
