.PHONY: build size tags test run

REPO=blacktop
NAME=elasticsearch
BUILD ?= 5.5
LATEST ?= 5.5

all: build size test

build:
	cd $(BUILD); docker build -t $(REPO)/$(NAME):$(BUILD) .

size: build
ifeq "$(BUILD)" "$(LATEST)"
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(REPO)/$(NAME):$(BUILD)| cut -d' ' -f1)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(REPO)/$(NAME):$(BUILD))/' README.md
endif
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(REPO)/$(NAME):$(BUILD))/' README.md

tags:
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(REPO)/$(NAME)

ssh:
	@docker run -it --rm -p 9200:9200 $(REPO)/$(NAME):$(BUILD) bash

run:
	@docker run -d --name elasticsearch -p 9200:9200 $(REPO)/$(NAME):$(BUILD)

test:
	docker run -d --name esatest -p 9200:9200 -e cluster.name=testcluster $(REPO)/$(NAME):$(BUILD); sleep 10;
	docker logs esatest
	http localhost:9200 | jq .cluster_name
	docker rm -f esatest
