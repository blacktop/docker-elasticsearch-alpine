REPO=blacktop/elasticsearch
ORG=blacktop
NAME=elasticsearch
# build info
BUILD ?=$(shell cat LATEST)
LATEST ?=$(shell cat LATEST)


all: update build size test

BUILDS=$(LATEST) 7.17 7.16 6.8 5.6
.PHONY: update
update:
	$(foreach build,$(BUILDS),NAME=$(NAME) BUILD=$(build) $(MAKE) dockerfile;)

.PHONY: dockerfile
dockerfile: ## Update Dockerfiles
ifneq "$(BUILD)" "x-pack"
	hack/make/dockerfile
endif

.PHONY: build
build: ## Build docker image
	cd $(BUILD); docker build --pull -t $(ORG)/$(NAME):$(BUILD) .

.PHONY: size
size: build ## Get built image size
ifeq "$(BUILD)" "$(LATEST)"
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD)| cut -d' ' -f1)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md
endif
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md

.PHONY: tag
tag:
	ORG=$(ORG) NAME=$(NAME) BUILD=$(BUILD) hack/make/tag

.PHONY: tags
tags:
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(ORG)/$(NAME)

.PHONY: test
test: stop ## Test docker image
	docker run -d --name $(NAME) -p 9200:9200 -e cluster.name=testcluster $(ORG)/$(NAME):$(BUILD)
	@wait-for-es
	@docker logs $(NAME)
	http localhost:9200 | jq .cluster_name
	docker rm -f $(NAME)

.PHONY: tar
tar: ## Export tar of docker image
	docker save $(ORG)/$(NAME):$(BUILD) -o $(NAME).tar

.PHONY: push
push: build ## Push docker image to docker registry
	@echo "===> Pushing $(ORG)/$(NAME):$(BUILD) to docker hub..."
	@docker push $(ORG)/$(NAME):$(BUILD)

.PHONY: run
run: stop ## Run docker container
	docker run --init -it --rm --name $(NAME) -p 9200:9200 -e ELASTIC_PASSWORD=password -e "discovery.type=single-node" $(ORG)/$(NAME):$(BUILD)

.PHONY: ssh
ssh: ## SSH into docker image
	@docker run --init -it --rm -p 9200:9200 --entrypoint=bash $(ORG)/$(NAME):$(BUILD)

.PHONY: stop
stop: ## Kill running docker containers
	@docker rm -f $(NAME) || true

.PHONY: circle
circle: ci-size ## Get docker image size from CircleCI
	@sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell cat .circleci/SIZE)-blue/' README.md
	@echo "===> Image size is: $(shell cat .circleci/SIZE)"

ci-build:
	@echo "===> Getting CircleCI build number"
	@http https://circleci.com/api/v1.1/project/github/${REPO} | jq '.[0].build_num' > .circleci/build_num

ci-size: ci-build
	@echo "===> Getting image build size from CircleCI"
	@http "$(shell http https://circleci.com/api/v1.1/project/github/${REPO}/$(shell cat .circleci/build_num)/artifacts circle-token==${CIRCLE_TOKEN} | jq '.[].url')" > .circleci/SIZE

.PHONY: clean
clean: ## Clean docker image and stop all running containers
	docker-clean stop
	docker rmi $(ORG)/$(NAME):$(BUILD) || true

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
