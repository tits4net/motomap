.PHONY: help build push all

build:
	docker build -t motomap:$(shell date +"%Y-%m-%d_%H-%M-%S") -t motomap:latest .

run:
	docker run -it motomap:latest

debug:
	docker run --rm -it --entrypoint bash motomap:latest

build-push:
	$(eval date_tag := $(shell date +"%Y-%m-%d_%H-%M-%S"))
	docker build -t motomap:$(date_tag) -t motomap:latest .
	docker push -a motomap:latest