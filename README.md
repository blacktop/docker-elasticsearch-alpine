![es-logo](https://raw.githubusercontent.com/blacktop/docker-elasticsearch-alpine/master/es-logo.png)

# docker-elasticsearch-alpine

[![Publish Docker Image](https://github.com/blacktop/docker-elasticsearch-alpine/actions/workflows/docker-image.yml/badge.svg)](https://github.com/blacktop/docker-elasticsearch-alpine/actions/workflows/docker-image.yml) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Image](https://img.shields.io/badge/docker%20image-1.02GB-blue.svg)](https://hub.docker.com/r/blacktop/elasticsearch/)

Alpine Linux based [Elasticsearch](https://www.elastic.co/products/elasticsearch) Docker Image

**Table of Contents**

- [docker-elasticsearch-alpine](#docker-elasticsearch-alpine)
  - [Why?](#why)
  - [Dependencies](#dependencies)
  - [Image Tags](#image-tags)
  - [Getting Started](#getting-started)
  - [Documentation](#documentation)
  - [Known Issues :warning:](#known-issues-warning)
  - [Issues](#issues)
  - [Credits](#credits)
  - [License](#license)

## Why?

Compare Image Sizes:

* official elasticsearch = 791.6 MB
* blacktop/elasticsearch = 447.28 MB

**blacktop version is 518 MB smaller !**

## Dependencies

* [alpine:3.15](https://hub.docker.com/_/alpine/)

## Image Tags

``` bash
REPOSITORY               TAG                 SIZE
blacktop/elasticsearch   latest              1.02GB
blacktop/elasticsearch   8.1                 1.02GB
blacktop/elasticsearch   8.0                 1.02GB
blacktop/elasticsearch   7.17                411MB
blacktop/elasticsearch   7.16                446MB
blacktop/elasticsearch   7.15                447MB
blacktop/elasticsearch   7.10                294MB
blacktop/elasticsearch   7.9                 297MB
blacktop/elasticsearch   7.8                 296MB
blacktop/elasticsearch   7.7                 294MB
blacktop/elasticsearch   7.6                 293MB
blacktop/elasticsearch   7.5                 288MB
blacktop/elasticsearch   7.4                 288MB
blacktop/elasticsearch   7.3                 289MB
blacktop/elasticsearch   7.2                 358MB
blacktop/elasticsearch   7.1                 304MB
blacktop/elasticsearch   7.0                 304MB
blacktop/elasticsearch   6.8                 281MB
blacktop/elasticsearch   6.7                 192MB
blacktop/elasticsearch   6.6                 128MB
blacktop/elasticsearch   6.5                 127MB
blacktop/elasticsearch   6.4                 127MB
blacktop/elasticsearch   6.3                 120MB
blacktop/elasticsearch   6.2                 119MB
blacktop/elasticsearch   6.1                 119MB
blacktop/elasticsearch   6.0                 117MB
blacktop/elasticsearch   5.6                 124MB
blacktop/elasticsearch   5.5                 123MB
blacktop/elasticsearch   5.4                 123MB
blacktop/elasticsearch   5.3                 123MB
blacktop/elasticsearch   x-pack              1.05GB
blacktop/elasticsearch   5.2                 150MB
blacktop/elasticsearch   5.1                 149MB
blacktop/elasticsearch   5.0                 148.4MB
blacktop/elasticsearch   2.4                 116MB
blacktop/elasticsearch   kopf                122MB
blacktop/elasticsearch   2.3                 139.1MB
blacktop/elasticsearch   1.7                 114MB
```

## Getting Started

``` bash
$ docker run -d --name elastic -p 9200:9200 blacktop/elasticsearch
```

## Documentation

* [To create an elasticsearch cluster](docs/create.md)
* [To increase the HEAP_SIZE to 2GB](docs/options.md)
* [To monitor the clusters metrics using dockerbeat](docs/dockerbeat.md)
* [To run in production](docs/production.md)

## Known Issues :warning:

I have noticed when running the new **5.0+** version on a linux host you need to increase the memory map areas with the following command

``` bash
sudo sysctl -w vm.max_map_count=262144
```

## Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-elasticsearch-alpine/issues/new)

## Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/elasticsearch<br> Production docs from https://stefanprodan.com/2016/elasticsearch-cluster-with-docker/

## License

MIT Copyright (c) 2016-2022 **blacktop**