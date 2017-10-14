.PHONY: build size tags test tar push run ssh stop circle

REPO=blacktop/elasticsearch
ORG=blacktop
NAME=elasticsearch
# build info
BUILD ?=$(shell cat LATEST)
LATEST ?=$(shell cat LATEST)
VERSION=$(shell cat "$(BUILD)/Dockerfile" | grep '^ENV VERSION' | cut -d" " -f3)
# tarball info
DOWNLOAD_URL=https://artifacts.elastic.co/downloads/$(NAME)
SHA_URL=$(DOWNLOAD_URL)/$(NAME)-$(VERSION).tar.gz.sha512
TARBALL_SHA=$(shell curl -s "$(SHA_URL)")


all: build size test

dockerfile: ## Update Dockerfiles
ifneq "$(BUILD)" "x-pack"
	@echo "===> Getting $(NAME) tarball sha1 for version: $(VERSION)"
	@echo " * TARBALL_SHA=$(TARBALL_SHA)"
	sed -i.bu 's/TARBALL_SHA "[0-9a-f.]\{128\}"/TARBALL_SHA "$(TARBALL_SHA)"/' $(BUILD)/Dockerfile
endif

build: dockerfile ## Build docker image
	cd $(BUILD); docker build -t $(ORG)/$(NAME):$(BUILD) .

size: build ## Get built image size
ifeq "$(BUILD)" "$(LATEST)"
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD)| cut -d' ' -f1)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md
endif
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md

tags:
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(ORG)/$(NAME)

test: stop ## Test docker image
	docker run -d --name $(NAME) -p 9200:9200 -e cluster.name=testcluster $(ORG)/$(NAME):$(BUILD); sleep 20;
	docker logs $(NAME)
	http localhost:9200 | jq .cluster_name
	docker rm -f $(NAME)

tar: ## Export tar of docker image
	docker save $(ORG)/$(NAME):$(BUILD) -o $(NAME).tar

push: build ## Push docker image to docker registry
	@echo "===> Pushing $(ORG)/$(NAME):$(BUILD) to docker hub..."
	@docker push $(ORG)/$(NAME):$(BUILD)

run: stop ## Run docker container
	@docker run --init -d --name $(NAME) -p 9200:9200 $(ORG)/$(NAME):$(BUILD)

ssh: ## SSH into docker image
	@docker run --init -it --rm --entrypoint=bash $(ORG)/$(NAME):$(BUILD)

stop: ## Kill running docker containers
	@docker rm -f $(NAME) || true

circle: ci-size ## Get docker image size from CircleCI
	@sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell cat .circleci/SIZE)-blue/' README.md
	@echo "===> Image size is: $(shell cat .circleci/SIZE)"

ci-build:
	@echo "===> Getting CircleCI build number"
	@http https://circleci.com/api/v1.1/project/github/${REPO} | jq '.[0].build_num' > .circleci/build_num

ci-size: ci-build
	@echo "===> Getting image build size from CircleCI"
	@http "$(shell http https://circleci.com/api/v1.1/project/github/${REPO}/$(shell cat .circleci/build_num)/artifacts circle-token==${CIRCLE_TOKEN} | jq '.[].url')" > .circleci/SIZE

clean: ## Clean docker image and stop all running containers
	docker-clean stop
	docker rmi $(ORG)/$(NAME):$(BUILD) || true

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
