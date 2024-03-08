.PHONY: help build push all

build:
	docker build -t motomap .

run:
	docker run motomap

debug:
	docker run --rm -it --entrypoint bash motomap