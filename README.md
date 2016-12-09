![es-logo](https://raw.githubusercontent.com/blacktop/docker-elasticsearch-alpine/master/es-logo.png)

docker-elasticsearch-alpine
===========================

[![CircleCI](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine.png?style=shield)](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/elasticsearch.svg)](https://hub.docker.com/r/blacktop/elasticsearch/) [![Docker Image](https://img.shields.io/badge/docker image--blue.svg)](https://hub.docker.com/r/blacktop/elasticsearch/)

Alpine Linux based [Elasticsearch](https://www.elastic.co/products/elasticsearch) Docker Image

**Table of Contents**

-	[Why?](#why)
-	[Dependencies](#dependencies)
-	[Image Tags](#image-tags)
-	[Getting Started](#getting-started)
-	[Documentation](#documentation)
	-	[To create an elasticsearch cluster](docs/create.md)
	-	[To increase the HEAP_SIZE to 2GB](docs/options.md)  
	-	[To monitor the clusters metrics using dockerbeat](docs/dockerbeat.md)
	-	[To run in production](docs/production.md)
-	[Issues](#issues)
-	[Credits](#credits)
-	[CHANGELOG](#changelog)
-	[Contributing](#contributing)
-	[License](#license)

### Why?

Compare Image Sizes:  
 - official elasticsearch = 350 MB  
 - blacktop/elasticsearch = 149 MB

**Alpine version is 201 MB smaller !**

### Dependencies

-	[gliderlabs/alpine:3.4](https://index.docker.io/_/gliderlabs/alpine/)

### Image Tags

```bash
REPOSITORY               TAG                 SIZE
blacktop/elasticsearch   latest              149.7 MB
blacktop/elasticsearch   5.0                 149.7 MB
blacktop/elasticsearch   geoip               182.7 MB
blacktop/elasticsearch   x-pack              200.0 MB
blacktop/elasticsearch   2.4                 140.1 MB
blacktop/elasticsearch   kopf                147.5 MB
blacktop/elasticsearch   2.3                 141.8 MB
blacktop/elasticsearch   1.7                 145.4 MB
```

> **NOTE:**
 * tag **x-pack** is the same as tag **latest**, but includes the *x-pack*, the *ingest-geoip* and the *ingest-user-agent* plugin.  
 * tag **geoip** is the same as tag **latest**, but includes the *ingest-geoip* and the *ingest-user-agent* plugin.  
 * tag **kopf** is the same as tag **2.4**, but includes the *kopf* plugin.

### Getting Started

```bash
$ docker run -d --name elastic -p 9200:9200 blacktop/elasticsearch
```

### Documentation

-	[To create an elasticsearch cluster](docs/create.md)
-	[To increase the HEAP_SIZE to 2GB](docs/options.md)
-	[To monitor the clusters metrics using dockerbeat](docs/dockerbeat.md)
-	[To run in production](docs/production.md)

### Known Issues :warning:

I have noticed when running the new **5.0** version on a linux host you need to increase the memory map areas with the following command

```bash
sudo sysctl -w vm.max_map_count=262144
```

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
