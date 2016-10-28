![es-logo](https://raw.githubusercontent.com/blacktop/docker-elasticsearch-alpine/master/es-logo.png)

docker-elasticsearch-alpine
===========================

[![CircleCI](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine.png?style=shield)](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Image](https://img.shields.io/badge/docker image-141.5 MB-blue.svg)](https://hub.docker.com/r/blacktop/elasticsearch/)

Alpine Linux based Elasticsearch Docker Image

**Table of Contents**

  - [Why?](#why)
  - [Dependencies](#dependencies)
  - [Image Tags](#image-tags)
  - [Getting Started](#getting-started)
  - [Documentation](#documentation)
      - [To create an elasticsearch cluster](docs/create.md)
      - [To increase the ES_HEAP_SIZE to 2GB](docs/options.md)        
      - [To monitor the clusters metrics using dockerbeat](docs/dockerbeat.md)
      - [To run in production](docs/production.md)
  - [Issues](#issues)
  - [Credits](#credits)
  - [CHANGELOG](#changelog)
  - [Contributing](#contributing)
  - [License](#license)

### Why?

Compare Image Sizes:  
 - official elasticsearch = 354.8 MB  
 - blacktop/elasticsearch = 141 MB

**Alpine version is 213 MB smaller !**

### Dependencies

-	[gliderlabs/alpine:3.4](https://index.docker.io/_/gliderlabs/alpine/)

### Image Tags

```bash
REPOSITORY               TAG                 SIZE
blacktop/elasticsearch   latest              141.5 MB
blacktop/elasticsearch   5.0                 151.1 MB
blacktop/elasticsearch   x-pack              151.1 MB
blacktop/elasticsearch   kopf                147.5 MB
blacktop/elasticsearch   2.4                 141.5 MB
blacktop/elasticsearch   2.3                 141.7 MB
blacktop/elasticsearch   1.7                 145.4 MB
```

> **NOTE:** tag **kopf** is the same as tag **latest**, but includes the *kopf* plugin.  

### Getting Started

```bash
$ docker run -d --name elastic -p 9200:9200 blacktop/elasticsearch
```

### Documentation

 * [To create an elasticsearch cluster](docs/create.md)
 * [To increase the ES_HEAP_SIZE to 2GB](docs/options.md)
 * [To monitor the clusters metrics using dockerbeat](docs/dockerbeat.md)
 * [To run in production](docs/production.md)

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-elasticsearch-alpine/issues/new)

### Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/elasticsearch  
Production docs from https://stefanprodan.com/2016/elasticsearch-cluster-with-docker/  

### CHANGELOG

See [`CHANGELOG.md`](https://github.com/blacktop/docker-elasticsearch-alpine/blob/master/CHANGELOG.md)

### Contributing

[See all contributors on GitHub](https://github.com/blacktop/docker-elasticsearch-alpine/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/blacktop/docker-elasticsearch-alpine/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

### License

MIT Copyright (c) 2016 **blacktop**
