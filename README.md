# Motomap
The motomap project was started by [markcushman/motomap ](https://github.com/markcushman/motomap). 
This repo forked it to simplify and automatize docker build of builder container and maps. 

## How it works ?
This project build a container including all the needed tools and pre-computed file to generate some garmin map.
The maps to generate will be downloaded at container startup. 

### Build container
Just run `make`.

## How to use it
Then you can run it either via `docker-compose`, see example folder or via `docker run` as follow : 
```shell
docker run -it -e MAPS_LIST=europe/france/reunion -e MAPS_DESIGN=default -v /tmp/motomap:/motomap/output/ motomap:latest
```
### Environment variables
| Name  | Description  | Possible value  | Default value |
|---|---|---|---|
| MAPS_LIST  | List of map to generate according. Can add multiple, semi-colon separated  | See geofabrik.de osm pdf file path | antarctica;europe/andorra;europe/france/guyane  |
| MAPS_DESIGN  | Which style and typ to apply to map  | default, motomap, roue-libre  | default |
| MKGMAP_VERSION  | Version of mkgmap to download and use  | See mkgmap.org.uk | r4918 |
| SPLITTER_VERSION  | Version of splitter to download and use | See mkgmap.org.uk  | r653  |

### Volumes
Artefact are generated inside the container path `/motomap/output/`, so you may want to mount it on your host file system.
